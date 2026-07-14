<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Retrieve the staff user's name from the session set during login 
    String userName = (String) session.getAttribute("userName");
    // Security Check: If the user is not logged in or the session has expired, redirect back to login.jsp 
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve the first letter of the username for the avatar profile badge (e.g., Alex -> A)
    String firstLetter = "S";
    // Default value in case username is empty or null 
    if (userName != null && !userName.trim().isEmpty()) {
        firstLetter = userName.trim().substring(0, 1).toUpperCase();
    }
%>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Booking Management System</title>
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

        .status-confirmed {
            background-color: #e7f7ef;
            color: #1ea97c; 
        }
        
        .status-updater-select {
    padding: 4px 8px;
    border-radius: 6px;
    border: 1px solid #cbd5e1;
    font-size: 0.8rem;
    cursor: pointer;
    background-color: #fff;
}

        .status-pending {
            background-color: #fff5e6;
            color: #ff9800;
        }

        .status-cancelled {
            background-color: #ffe6e6;
            color: #f44336;
        }

        /* Sidebar Styles */
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

        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: var(--transition);
        }

        /* Header Styles */
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

        .notification {
            position: relative;
            cursor: pointer; 
        }

        .notification i {
            font-size: 1.3rem;
            color: #666; 
        }

        .notification-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: var(--danger-color);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
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

        /* Content Area Styles */
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

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .btn-action {
            border: none;
            padding: 6px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-action.view {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--secondary-color);
        }
        
        .btn-action.edit {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .btn-action.delete {
            background-color: #fdecea;
            color: #d32f2f;
        }

        .btn-action:hover {
            opacity: 0.85;
        }

        .action-buttons-cell {
            display: flex;
            gap: 6px;
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

        /* User Table Styles */
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

        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }

        /* Pagination Styles */
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

        /* Footer Styles */
        footer {
            text-align: center;
            padding: 20px;
            color: #777;
            border-top: 1px solid #eee;
            margin-top: 30px;
        }

        /* Responsive Designs */
        @media (max-width: 900px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .menu-toggle {
                display: block;
            }

            .search-box {
                width: 200px;
            }
        }

        @media (max-width: 768px) {
            .search-box {
                display: none;
            }

            .header-right {
                gap: 15px;
            }

            .table-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .table-filters {
                width: 100%;
                flex-wrap: wrap;
            }
        }

        @media (max-width: 576px) {
            .content-wrapper {
                padding: 20px;
            }

            .page-title h1 {
                font-size: 1.5rem;
            }

            .action-buttons {
                flex-direction: column;
                width: 100%;
            }

            .action-buttons .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h2><i class="fas fa-cut"></i> Owl Barber</h2>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="StaffDashboardServlet">
                    <i class="fa fa-dashboard"></i> Dashboard 
                </a>
            </li>
            <li>
                <a href="StaffListServlet" class="nav-link">
                    <i class="fa fa-users"></i> Staffs 
                </a>
            </li>
            <li>
                <a href="StaffBookingServlet" class="active">
                    <i class="fas fa-shopping-cart"></i> Booking 
                </a>
            </li>
            <li>
                <a href="StaffSettingServlet">
                    <i class="fas fa-cog"></i> Profile 
                </a>
            </li>
            <li style="margin-top: auto;">
                <a href="login.jsp" onclick="return confirm('Are you sure you want to log out?');" style="color: #ff4d4d; font-weight: 600;"> 
                    <i class="fas fa-sign-out-alt" style="color: #ff4d4d;"></i> Logout
			    </a>
            </li>
        </ul>
    </aside>

    <main class="main-content" id="mainContent">
        <header>
            <div class="header-left">
                <button class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </button>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchUsers" placeholder="Search bookings...">
                </div>
            </div>
            <div class="user-profile">
                <div class="user-avatar">
                    <%= firstLetter %>
                </div>
                <div class="user-info">
                    <h4><%= userName %></h4>
                    <p>Staff</p>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="page-title">
                <h1>Booking</h1>
                <div class="action-buttons">
                    <button class="btn btn-outline" id="refreshUsersBtn" onclick="window.location.reload();">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                </div>
            </div>

            <div class="user-table-container">
                <div class="table-header">
                    <h3 style="font-size: 28px;">My Appointments</h3>
                    <div class="table-filters">
                        <select class="filter-select" id="filterBookingStatus">
                            <option value="">All Status</option>
                            <option value="completed">Confirmed</option>
                            <option value="pending">Pending</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Service</th>
                            <th>Date and Time</th>
                            <th>Customer</th>
                            <th>Barber</th>
                            <th>Status</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="bookingsTable">
                        <% 
                            // Warning completely cleared by utilizing an isolated local cast assignment 
                            List<Booking> allBookings = null;
                            if (request.getAttribute("allBookings") != null) {
                                @SuppressWarnings("unchecked")
                                List<Booking> tempCastList = (List<Booking>) request.getAttribute("allBookings");
                                allBookings = tempCastList;
                            }

                            if (allBookings != null && !allBookings.isEmpty()) { 
                                for (Booking b : allBookings) { 
                                    String status = (b.getBookingStatus() != null) ? b.getBookingStatus().toLowerCase() : "pending";
                                    String currentBarber = (b.getStaffName() != null) ? b.getStaffName().replace("'", "\\'") : "No Barber Assigned";
                                    String currentCustomer = (b.getCustomerName() != null) ? b.getCustomerName().replace("'", "\\'") : "Unknown";
                        %>
                        <tr>
                            <td>#<%= b.getBookingId() %></td>
                            <td><%= b.getServiceType() %></td>
                            <td><%= b.getBookingDate() %> @ <%= b.getBookingTime() %></td> 
                            <td><%= b.getCustomerName() %></td>
                            <td><%= b.getStaffName() != null ? b.getStaffName() : "No Barber Assigned" %></td>
                            <td>
                                <span class="status-badge status-<%= status %>">
                                    <%= b.getBookingStatus() %> 
                                </span>
                            </td>
                            <td>RM <%= String.format("%.2f", b.getTotalPrice()) %></td> 
                            <td>
                                <div class="action-buttons-cell">
    <button class="btn-action view" title="View" onclick="alert('Booking ID: #<%= b.getBookingId() %>\nCustomer: <%= currentCustomer %>\nBarber: <%= currentBarber %>')"> 
        <i class="fas fa-eye"></i> 
    </button>
    
    <button class="btn-action edit" title="Update Status" onclick="changeStatus('<%= b.getBookingId() %>', '<%= b.getBookingStatus() != null ? b.getBookingStatus().toUpperCase() : "PENDING" %>')">
        <i class="fas fa-edit"></i>
    </button>

    <a href="DeleteBookingController?id=<%= b.getBookingId() %>" class="btn-action delete" title="Delete" onclick="return confirm('Are you sure you want to delete Booking #<%= b.getBookingId() %>?');">
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
                            <td colspan="8" style="text-align: center; padding: 30px; color: #777;">
                                No appointment records found.
                            </td>
                        </tr>
                        <% 
                            } 
                        %>
                    </tbody>
                </table>

                <div class="pagination">
                    <button class="pagination-btn prev" disabled>
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="pagination-btn active">1</button>
                    <button class="pagination-btn next">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>

            <footer>
                <p>Staff Dashboard &copy; 2026. All rights reserved.</p>
            </footer>
        </div>
    </main>

    <div id="statusModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); z-index:1000; align-items:center; justify-content:center;">
        <div style="background:#252538; padding:30px; border-radius:12px; width:350px; border:2px solid #ffb703; box-shadow:0 8px 24px rgba(0,0,0,0.5); text-align:center;">
            <h3 style="color:#ffb703; margin-bottom:15px; font-size:18px;">Update Booking Status</h3>
            <p id="modalText" style="color:#fff; margin-bottom:20px; font-size:14px;"></p>
            
            <form id="modalForm" method="POST" action="UpdateBookingStatusServlet">
                <input type="hidden" id="modalBookingId" name="id">
                <select id="modalStatusSelect" name="status" style="width:100%; padding:10px; background:#1e1e2f; color:#fff; border:1px solid #a0a0b5; border-radius:6px; margin-bottom:20px; font-size:14px;">
                    <option value="PENDING">PENDING</option>
                    <option value="COMPLETED">COMPLETED</option> 
                    <option value="CANCELLED">CANCELLED</option> 
                </select>
                <div style="display:flex; gap:10px; justify-content:center;">
                    <button type="button" onclick="closeModal()" style="padding:8px 16px; background:#4a4e69; color:#fff; border:none; border-radius:6px; cursor:pointer;">Cancel</button>
                    <button type="submit" style="padding:8px 16px; background:#2a9d8f; color:#fff; border:none; border-radius:6px; cursor:pointer; font-weight:bold;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Open the status selection modal
        function changeStatus(bookingId, currentStatus) {
            document.getElementById("modalBookingId").value = bookingId;
            document.getElementById("modalText").innerText = "Choose a new status for Booking #" + bookingId;
            document.getElementById("modalStatusSelect").value = currentStatus.toUpperCase();
            document.getElementById("statusModal").style.display = "flex";
        }

        // Close status selection modal
        function closeModal() {
            document.getElementById("statusModal").style.display = "none";
        }

        // Dynamic Filtering by Booking Status via Dropdown Selector Matrix
        document.addEventListener("DOMContentLoaded", function () {
            const filterSelect = document.getElementById("filterBookingStatus");
            const tableBody = document.getElementById("bookingsTable");
            if (filterSelect && tableBody) {
                filterSelect.addEventListener("change", function () {
                    const selectedStatus = this.value.toLowerCase().trim();
                    const rows = tableBody.getElementsByTagName("tr");

                    for (let i = 0; i < rows.length; i++) {
                        const row = rows[i];
                        const statusCell = row.getElementsByTagName("td")[5]; // Grab active operational Status Column

                        if (statusCell) {
                            const statusText = statusCell.textContent || statusCell.innerText;
                            const statusValue = statusText.toLowerCase().trim();

                            if (selectedStatus === "" || statusValue === selectedStatus) {
                                row.style.display = ""; // Show row
                            } else {
                                row.style.display = "none"; // Hide row
                            }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>