<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 🌟 1. Retrieve the staff name from the session set during login (Fixed from userName)
    String staffName = (String) session.getAttribute("staffName");

    // 🔒 Security Control: If the user session does not exist, redirect back to login
    if (staffName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 🌟 2. Extract the first letter of the name to display inside the circular profile avatar
    String firstLetter = "S";
    if (staffName != null && !staffName.trim().isEmpty()) {
        firstLetter = staffName.trim().substring(0, 1).toUpperCase();
    }
%>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %> <%-- Changed from com.owl.model.Staff --%> <%-- Ensure 'com.owl.model.Staff' is typed exactly like this --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - User Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --warning-color: #ff9e00;
            --danger-color: #f72585;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --sidebar-width: 250px;
            --header-height: 70px;
            --border-radius: 10px;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fb;
            color: var(--dark-color);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Sidebar Container Style Rules */
        .sidebar {
            width: var(--sidebar-width);
            background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white;
            position: fixed;
            height: 100vh;
            padding: 20px 0;
            transition: var(--transition);
            z-index: 1000;
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 0 20px 30px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
        }

        .sidebar-header h2 {
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-header h2 i {
            font-size: 1.8rem;
        }

        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            color: white;
            text-decoration: none;
            padding: 15px 25px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: var(--transition);
            font-weight: 500;
        }

        .sidebar-menu a:hover, .sidebar-menu a.active {
            background-color: rgba(255, 255, 255, 0.1);
            border-left: 4px solid var(--success-color);
        }

        .sidebar-menu i {
            width: 20px;
            text-align: center;
        }

        /* View Layout Alignment Settings */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: var(--transition);
        }

        /* Navigation Bar Strip */
        header {
            height: var(--header-height);
            background-color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .menu-toggle {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--primary-color);
            cursor: pointer;
            display: none;
        }

        .search-box {
            position: relative;
            width: 300px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border-radius: 30px;
            border: 1px solid #ddd;
            outline: none;
            transition: var(--transition);
        }

        .search-box input:focus {
            border-color: var(--primary-color);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        /* Page Content Wrapping Wrapper */
        .content-wrapper {
            padding: 30px;
        }

        .page-title {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-title h1 {
            font-size: 2rem;
            color: var(--dark-color);
        }

        /* User Statistics Card Blocks Layout */
        .user-stats {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .user-stat-card {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: var(--transition);
        }

        .user-stat-card:hover {
            transform: translateY(-5px);
        }

        .user-stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
        }

        .user-stat-icon.total { background-color: var(--primary-color); }
        .user-stat-icon.active { background-color: var(--success-color); }
        .user-stat-icon.inactive { background-color: #6c757d; }
        .user-stat-icon.new { background-color: var(--warning-color); }

        .user-stat-info h3 {
            font-size: 1.8rem;
            margin-bottom: 5px;
        }

        .user-stat-info p {
            color: #666;
            font-size: 0.9rem;
        }

        /* Action Buttons Base Rules */
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .btn {
            padding: 12px 24px;
            border-radius: var(--border-radius);
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background-color: var(--primary-color);
            color: white;
        }

        /* Main Records Display Data Table Styling */
        .user-table-container {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow);
            margin-bottom: 40px;
            overflow-x: auto;
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .table-header h3 {
            font-size: 1.3rem;
        }

        .table-filters {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .filter-select {
            padding: 8px 15px;
            border-radius: var(--border-radius);
            border: 1px solid #ddd;
            background-color: white;
            outline: none;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        thead {
            background-color: #f8f9fa;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            font-weight: 600;
            color: #555;
        }

        .user-avatar-small {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .user-info-cell {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-name {
            font-weight: 600;
            margin-bottom: 3px;
        }

        .user-email {
            color: #777;
            font-size: 0.9rem;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }

        .status-active { background-color: #e7f7ef; color: #1ea97c; }

        .role-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }

        .role-admin { background-color: #e6f3ff; color: #2196f3; }
        .role-user { background-color: #f0f0f0; color: #666; }

        .action-buttons-cell {
            display: flex;
            gap: 10px;
        }

        .btn-action {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-action.view { background-color: #e6f3ff; color: #2196f3; }
        .btn-action.delete { background-color: #ffe6e6; color: #f44336; }
        .btn-action:hover { transform: scale(1.1); }

        /* Pagination Interface Blocks */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }

        .pagination-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: white;
            border: 1px solid #ddd;
            cursor: pointer;
            transition: var(--transition);
        }

        .pagination-btn:hover, .pagination-btn.active {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .pagination-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #777;
            border-top: 1px solid #eee;
            margin-top: 30px;
        }

        /* Layout Responsiveness Adaptations */
        @media (max-width: 900px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; }
            .menu-toggle { display: block; }
            .search-box { display: none; }
        }
    </style>
</head>
<body>
    
    <!-- ========================================== -->
    <!-- SIDEBAR CONTAINER LINK SCHEME               -->
    <!-- ========================================== -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h2><i class="fas fa-cut"></i> Owl Barber</h2>
        </div>
        <ul class="sidebar-menu">
            <li><a href="StaffDashboardServlet"><i class="fas fa-dashboard"></i> Dashboard</a></li>
            <li><a href="StaffListServlet" class="active"><i class="fas fa-users"></i> Barber</a></li>
            <li><a href="StaffBookingServlet"><i class="fas fa-calendar-check"></i> Booking</a></li>
            <li><a href="StaffSettingServlet"><i class="fas fa-user-cog"></i> Profile</a></li>
            <li> <a href="login.jsp"
				onclick="return confirm('Are you sure you want to log out?');"
				style="color: #ff4d4d; font-weight: 600;"> <i
					class="fas fa-sign-out-alt" style="color: #ff4d4d;"></i> Logout
			</a></li>
        </ul>
    </aside>

    <!-- Main Content Workframe -->
    <main class="main-content" id="mainContent">
        <header>
            <div class="header-left">
                <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchUsers" placeholder="Search staff records...">
                </div>
            </div>
            <div class="header-right">
                <div class="user-profile">
                    <div class="user-avatar"><%=firstLetter%></div>
                    <div class="user-info">
                        <h4><%=staffName%></h4>
                        <p>Staff</p>
                    </div>
               </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="page-title">
                <h1>Staff Management</h1>
                <div class="action-buttons">
                    <button class="btn btn-outline" id="refreshUsersBtn"><i class="fas fa-sync-alt"></i> Refresh</button>
                </div>
            </div>

            <!-- 🌟 INJECTED COMPONENT: Dynamic Metric Cards Grid UI -->
            <div class="user-stats">
                <div class="user-stat-card">
                    <div class="user-stat-icon total"><i class="fas fa-users"></i></div>
                    <div class="user-stat-info">
                        <h3 id="totalUsers">0</h3>
                        <p>Total Staff</p>
                    </div>
                </div>
                <div class="user-stat-card">
                    <div class="user-stat-icon active"><i class="fas fa-user-check"></i></div>
                    <div class="user-stat-info">
                        <h3 id="activeUsers">0</h3>
                        <p>Active Staff</p>
                    </div>
                </div>
                <div class="user-stat-card">
                    <div class="user-stat-icon inactive"><i class="fas fa-user-slash"></i></div>
                    <div class="user-stat-info">
                        <h3 id="inactiveUsers">0</h3>
                        <p>Inactive Staff</p>
                    </div>
                </div>
            </div>

            <!-- Staff Members Data Table View Frame -->
            <div class="user-table-container">
                <div class="table-header">
                    <h3>All Staff Members</h3>
                    <div class="table-filters">
                        <select class="filter-select" id="filterRole">
                            <option value="">All Roles</option>
                            <option value="Manager">Manager</option>
                            <option value="Staff">Staff</option>
                        </select>
                        <select class="filter-select" id="filterStatus">
                            <option value="">All Status</option>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                        <select class="filter-select" id="sortStaffs">
                            <option value="name-asc">Name A-Z</option>
                            <option value="name-desc">Name Z-A</option>
                        </select>
                    </div>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Staff Info</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Phone Number</th>
                            <th>Last Active Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="StaffsTable">
    <%
        // 1. Fetch data array collection passed down from Servlet handling lifecycle
        @SuppressWarnings("unchecked")
        List<Staff> allStaff = (List<Staff>) request.getAttribute("allStaff");
        
        // 2. Render database record items if object exists
        if (allStaff != null && !allStaff.isEmpty()) {
            for (Staff s : allStaff) {
                String initials = "ST";
                if(s.getStaffName() != null && s.getStaffName().length() >= 2) {
                    initials = s.getStaffName().substring(0, 2).toUpperCase();
                }
    %>
                <tr>
                    <td>
                        <div class="user-info-cell">
                            <div class="user-avatar-small <%= (s.getManagerId() == null) ? "role-admin" : "role-user" %>">
                                <%= initials %>
                            </div>
                            <div>
                                <div class="user-name"><%= s.getStaffName() %></div>
                                <div class="user-email"><%= s.getStaffEmail() %></div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="role-badge <%= (s.getManagerId() == null) ? "role-admin" : "role-user" %>">
                            <%= (s.getManagerId() == null) ? "Manager" : "Staff" %>
                        </span>
                    </td>
                    <td><span class="status-badge status-active">Active</span></td>
                    <td><%= s.getStaffPhoneNum() %></td>
                    <td>Online</td>
                    <td>
                        <div class="action-buttons-cell">
                            <button class="btn-action view" title="View Details" onclick="alert('Staff ID: #<%= s.getStaffId() %>\nPhone: <%= s.getStaffPhoneNum() %>')">
                                <i class="fas fa-eye"></i>
                            </button>
                            <a href="DeleteStaffController?id=<%= s.getStaffId() %>" class="btn-action delete" title="Delete Entry" onclick="return confirm('Are you sure you want to delete this staff?');">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
    <%
            } 
        } else {
    %>
        <tr>
            <td colspan="6" style="text-align: center; color: #999; padding: 30px;">
                <i class="fas fa-users-slash fa-2x" style="margin-bottom: 10px; display: block;"></i>
                No records found in database.
            </td>
        </tr>
    <%
        }
    %>
                    </tbody>
                </table>
                
                <div class="pagination">
                    <button class="pagination-btn prev" id="prevPage" disabled><i class="fas fa-chevron-left"></i></button>
                    <button class="pagination-btn active">1</button>
                    <button class="pagination-btn next" id="nextPage" disabled><i class="fas fa-chevron-right"></i></button>
                </div>
            </div>

            <footer>
                <p>Staff Dashboard &copy; 2026. All rights reserved.</p>
            </footer>
        </div>
    </main>

    <!-- JavaScript Controller Logic Script Area -->
    <script>
    // Grab all verified target DOM Node handles
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    const refreshUsersBtn = document.getElementById('refreshUsersBtn');
    const searchUsers = document.getElementById('searchUsers');
    const staffsTable = document.getElementById('StaffsTable'); 
    
    const totalUsers = document.getElementById('totalUsers');
    const activeUsers = document.getElementById('activeUsers');
    const inactiveUsers = document.getElementById('inactiveUsers');
    
    const filterRole = document.getElementById('filterRole');
    const filterStatus = document.getElementById('filterStatus');
    const sortUsers = document.getElementById('sortStaffs');

    // 🌟 INJECTED BUGFIX: Map Server JSP data stream into client-side JS memory object state array
    let staff = [];
    <% 
        if (allStaff != null) {
            for(Staff s : allStaff) {
    %>
    staff.push({
        id: "<%= s.getStaffId() %>",
        firstName: "<%= s.getStaffName() %>",
        lastName: "",
        email: "<%= s.getStaffEmail() %>",
        role: "<%= (s.getManagerId() == null) ? "Manager" : "Staff" %>",
        status: "Active",
        joinDate: "<%= s.getStaffPhoneNum() %>",
        lastActive: "Online",
        avatarColor: "<%= (s.getManagerId() == null) ? "#2196f3" : "#666" %>"
    });
    <% 
            }
        }
    %>

    let filteredStaff = [...staff];

    // Core Dashboard bootstrapping lifecycle process
    function initUserDashboard() {
        populateUsersTable();
        updateUserStats();
        setupEventListeners();
    }

    // Reset control interface parameters completely back to default state
    function refreshData() {
        searchUsers.value = '';
        filterRole.value = '';
        filterStatus.value = '';
        sortUsers.selectedIndex = 0;
        filteredStaff = [...staff];

        populateUsersTable();
        updateUserStats();
    }

    // Build standard tabular dynamic output grid interface blocks
    function populateUsersTable() {
        if (!staffsTable) return;
        staffsTable.innerHTML = '';
        
        if(filteredStaff.length === 0) {
            staffsTable.innerHTML = `<tr><td colspan="6" style="text-align: center; padding: 30px; color:#999;">No matching records matched the criteria.</td></tr>`;
            return;
        }

        filteredStaff.forEach(person => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <div class="user-info-cell">
                        <div class="user-avatar-small" style="background-color: \${person.avatarColor}">
                            \${person.firstName.substring(0,2).toUpperCase()}
                        </div>
                        <div>
                            <div class="user-name">\${person.firstName}</div>
                            <div class="user-email">\${person.email}</div>
                        </div>
                    </div>
                </td>
                <td><span class="role-badge role-\${person.role === 'Manager' ? 'admin' : 'user'}">\${person.role}</span></td>
                <td><span class="status-badge status-active">\${person.status}</span></td>
                <td>\${person.joinDate}</td>
                <td>\${person.lastActive}</td>
                <td>
                    <div class="action-buttons-cell">
                        <button class="btn-action view" title="View details" onclick="alert('Staff ID: #\${person.id}\\nPhone: \${person.joinDate}')"><i class="fas fa-eye"></i></button>
                        <a href="DeleteStaffController?id=\${person.id}" class="btn-action delete" title="Delete account" onclick="return confirm('Are you sure?');"><i class="fas fa-trash"></i></a>
                    </div>
                </td>
            `;
            staffsTable.appendChild(row);
        });
    }

    // Compute metrics counts calculations dynamically (Fixed 'eq' syntax bug)
    function updateUserStats() {
        if(!totalUsers) return;
        totalUsers.innerText = staff.length;
        activeUsers.innerText = staff.filter(s => s.status === 'Active').length;
        inactiveUsers.innerText = staff.filter(s => s.status === 'Inactive').length;
    }

    // Sort, arrange, and manage search string filtering procedures (Fixed 'eq' bugs)
    function applyFiltersAndSort() {
        const searchTerm = searchUsers.value.toLowerCase();
        const roleValue = filterRole.value;
        const statusValue = filterStatus.value;
        const sortValue = sortUsers.value;

        filteredStaff = staff.filter(person => {
            const fullName = person.firstName.toLowerCase();
            const matchesSearch = fullName.includes(searchTerm) || person.email.toLowerCase().includes(searchTerm);
            const matchesRole = roleValue === "" || person.role === roleValue;
            const matchesStatus = statusValue === "" || person.status === statusValue;
            
            return matchesSearch && matchesRole && matchesStatus;
        });

        if (sortValue === 'name-asc') {
            filteredStaff.sort((a, b) => a.firstName.localeCompare(b.firstName));
        } else if (sortValue === 'name-desc') {
            filteredStaff.sort((a, b) => b.firstName.localeCompare(a.firstName));
        }

        populateUsersTable();
    }

    function toggleSidebar() {
        sidebar.classList.toggle('active');
    }

    function setupEventListeners() {
        menuToggle.addEventListener('click', toggleSidebar);
        if (refreshUsersBtn) {
            refreshUsersBtn.addEventListener('click', refreshData);
        }
        searchUsers.addEventListener('input', applyFiltersAndSort);
        filterRole.addEventListener('change', applyFiltersAndSort);
        filterStatus.addEventListener('change', applyFiltersAndSort);
        sortUsers.addEventListener('change', applyFiltersAndSort);
    }

    // Initialize application logic after DOM generation finishes completely
    document.addEventListener('DOMContentLoaded', initUserDashboard);
</script>
</body>
</html>