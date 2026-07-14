<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Staff" %>
<%
    String role = (String) session.getAttribute("userRole");
    String userName = (String) session.getAttribute("userName");

    if (role == null || !role.equalsIgnoreCase("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String firstLetter = "A";
    if (userName != null && !userName.trim().isEmpty()) {
        firstLetter = userName.trim().substring(0, 1).toUpperCase();
    }

    @SuppressWarnings("unchecked")
    List<Staff> barberList = (List<Staff>) request.getAttribute("barberList");
    if (barberList == null) {
        barberList = new ArrayList<Staff>();
    }
    int totalBarbersCount = barberList.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Barber Management - Admin Dashboard</title>
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
            --border-color: #e9ecef;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #f5f7fb; color: var(--dark-color); display: flex; min-height: 100vh; overflow-x: hidden; }

        /* SIDEBAR STYLING */
        .sidebar {
            width: var(--sidebar-width); background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white; position: fixed; height: 100vh; padding: 20px 0; transition: var(--transition); z-index: 1000; box-shadow: var(--shadow);
        }
        .sidebar-header { padding: 0 20px 30px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); text-align: center; }
        .sidebar-header h2 { font-size: 1.5rem; display: flex; align-items: center; gap: 10px; justify-content: center; }
        .sidebar-menu { list-style: none; padding: 20px 0; }
        .sidebar-menu a { color: white; text-decoration: none; padding: 15px 25px; display: flex; align-items: center; gap: 15px; transition: var(--transition); font-weight: 500; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background-color: rgba(255, 255, 255, 0.1); border-left: 4px solid var(--success-color); }
        .sidebar-menu i { width: 20px; text-align: center; }

        /* WORKSPACE FRAMEWORK */
        .main-content { flex: 1; margin-left: var(--sidebar-width); transition: var(--transition); }
        header { height: var(--header-height); background-color: white; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: var(--shadow); position: sticky; top: 0; z-index: 999; }
        .header-left { display: flex; align-items: center; gap: 15px; }
        .menu-toggle { background: none; border: none; font-size: 1.5rem; color: var(--primary-color); cursor: pointer; display: none; }
        .header-right { display: flex; align-items: center; gap: 25px; }
        .user-profile { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background-color: var(--primary-color); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; }
        .content-wrapper { padding: 30px; }
        .page-title { margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
        .page-title h1 { font-size: 2rem; font-weight: 700; }

        .btn-add-crew {
            background-color: var(--primary-color); color: white; padding: 10px 20px; border-radius: var(--border-radius);
            text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 8px; border: none; cursor: pointer; transition: var(--transition);
        }
        .btn-add-crew:hover { background-color: var(--secondary-color); box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3); }

        /* TRACKER METRIC CARD */
        .metrics-summary-bar { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .metric-card { background: white; padding: 20px 25px; border-radius: var(--border-radius); box-shadow: var(--shadow); display: flex; align-items: center; justify-content: space-between; border: 1px solid var(--border-color); }
        .metric-info h3 { font-size: 28px; font-weight: 700; margin-bottom: 5px; }
        .metric-info p { color: #6c757d; font-size: 14px; }
        .metric-icon { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 22px; background-color: rgba(67, 97, 238, 0.1); color: var(--primary-color); }

        /* DATA TABLE COMPONENTS */
        .table-container { background-color: white; border-radius: var(--border-radius); box-shadow: var(--shadow); overflow: hidden; border: 1px solid var(--border-color); margin-bottom: 30px; }
        .table-responsive { overflow-x: auto; width: 100%; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 15px 20px; border-bottom: 1px solid var(--border-color); }
        th { background-color: #f8f9fa; font-weight: 600; color: #495057; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; }
        tr:hover { background-color: #fdfdfd; }
        .badge-specialty { background-color: #e0e7ff; color: #4361ee; padding: 5px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; display: inline-block; }

        /* RE-DESIGNED ACTION BUTTON THEME MAPPING (SQUARE BLUE & SOFT RED ICON INTERFACES) */
        .actions-flex { display: flex; gap: 8px; align-items: center; }
        .action-box {
            width: 36px; height: 36px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; 
            cursor: pointer; text-decoration: none; font-size: 0.95rem; border: none; transition: background-color 0.2s;
        }
        /* Light Blue theme for Edit configuration */
        .action-box.edit-btn { background-color: #eff6ff; color: #2563eb; }
        .action-box.edit-btn:hover { background-color: #dbeafe; }
        /* Soft Red theme for Delete configuration */
        .action-box.delete-btn { background-color: #fef2f2; color: #ef4444; }
        .action-box.delete-btn:hover { background-color: #fee2e2; }

        /* MODALS FRAMEWORK CONTAINER SPECIFICATIONS */
        .modal-layer { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); justify-content: center; align-items: center; }
        .modal-window { background: white; padding: 25px; border-radius: var(--border-radius); width: 480px; box-shadow: var(--shadow); }
        .modal-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid var(--border-color); }
        .input-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .input-block { margin-bottom: 14px; display: flex; flex-direction: column; gap: 6px; }
        .input-block.full-width { grid-column: span 2; }
        .input-block label { font-weight: 600; font-size: 0.85rem; color: #495057; }
        .input-block input, .input-block select { padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 6px; outline: none; font-size: 0.9rem; }
        .input-block input:focus { border-color: var(--primary-color); }
        .modal-buttons { display: flex; justify-content: flex-end; gap: 12px; margin-top: 20px; padding-top: 15px; border-top: 1px solid var(--border-color); }
        .m-btn { padding: 10px 20px; border-radius: 6px; font-weight: 600; cursor: pointer; border: none; font-size: 0.9rem; }
        .m-btn.c-btn { background-color: #e2e8f0; color: #475569; }
        .m-btn.s-btn { background-color: var(--primary-color); color: white; }

        footer { text-align: center; padding: 20px; color: #777; border-top: 1px solid #eee; margin-top: 30px; }
        @media (max-width: 900px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; }
            .menu-toggle { display: block; }
        }
    </style>
</head>
<body>

    <!-- Combined Form Layer Modal Architecture (Handles Create & Update Functions) -->
    <div id="crewModal" class="modal-layer">
        <div class="modal-window">
            <div class="modal-title" id="titleLabel">Add New Staff</div>
            <form action="ManageStaffServlet" method="POST">
                <input type="hidden" name="action" id="subAction" value="ADD">
                <input type="hidden" name="staffId" id="fieldId">
                
                <div class="input-grid">
                    <div class="input-block full-width">
                        <label>Full Name</label>
                        <input type="text" name="staffName" id="fieldName" required>
                    </div>
                    <div class="input-block">
                        <label>Username</label>
                        <input type="text" name="staffUsername" id="fieldUser" required>
                    </div>
                    <div class="input-block">
                        <label>Password</label>
                        <input type="password" name="staffPassword" id="fieldPass" placeholder="Leave blank to keep same configuration">
                    </div>
                    <div class="input-block">
                        <label>Email Address</label>
                        <input type="email" name="staffEmail" id="fieldEmail" required>
                    </div>
                    <div class="input-block">
                        <label>Contact Number</label>
                        <input type="text" name="staffPhoneNum" id="fieldPhone" required>
                    </div>
                    <div class="input-block">
                        <label>Specialty Profile</label>
                        <select name="staffSpecialty" id="fieldSpec">
                            <option value="Haircut specialty">Haircut specialty</option>
                            <option value="Beard specialty">Beard specialty</option>
                            <option value="Senior Barber">Senior Barber</option>
                            <option value="General Stylist">General Stylist</option>
                        </select>
                    </div>
                    <div class="input-block">
                        <label>Experience Level (Years)</label>
                        <input type="number" name="staffExperience" id="fieldExp" required min="0">
                    </div>
                    <div class="input-block">
                        <label>Base Rate (RM)</label>
                        <input type="number" step="0.01" name="staffRate" id="fieldRate" required min="0">
                    </div>
                    <div class="input-block">
                        <label>Assign Manager ID</label>
                        <input type="number" name="managerId" id="fieldManager" placeholder="Optional">
                    </div>
                </div>
                
                <div class="modal-buttons">
                    <button type="button" class="m-btn c-btn" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="m-btn s-btn">Save Crew Data</button>
                </div>
            </form>
        </div>
    </div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h2><i class="fas fa-cut"></i> Owl Barber</h2>
        </div>
        <ul class="sidebar-menu">
            <li><a href="AdminDashboardServlet"><i class="fas fa-users"></i> Dashboard</a></li>
            <li><a href="AdminBookingServlet"><i class="fas fa-calendar-check"></i> Bookings</a></li>
            <li><a href="BarberAdminServlet" class="active"><i class="fas fa-user-tie"></i> Barbers</a></li>
            <li><a href="AdminServiceServlet"><i class="fas fa-scissors"></i> Services</a></li>
            <li><a href="ReportAdminServlet"><i class="fas fa-chart-line"></i> Reports</a></li>
            <li><a href="AdminProfileServlet"><i class="fas fa-cog"></i> Profile</a></li>
            <li><a href="login.jsp" style="color: #ff4d4d;" onclick="return confirm('Are you sure you want to log out?');">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a></li>
        </ul>
    </aside>

    <main class="main-content" id="mainContent">
        <header>
            <div class="header-left">
                <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
            </div>
            <div class="header-right">
                <div class="user-profile">
                    <div class="user-avatar"><%= firstLetter %></div>
                    <div class="user-info">
                        <h4><%= (userName != null) ? userName : "Admin User" %></h4>
                        <p>Administrator</p>
                    </div>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="page-title">
                <h1>Barber Management</h1>
                <button class="btn-add-crew" onclick="openAdd()">
                    <i class="fas fa-user-plus"></i> Add New Staff
                </button>
            </div>

            <div class="metrics-summary-bar">
                <div class="metric-card">
                    <div class="metric-info">
                        <h3><%= totalBarbersCount %></h3>
                        <p>Total Service Crew Registered</p>
                    </div>
                    <div class="metric-icon"><i class="fas fa-user-tie"></i></div>
                </div>
            </div>

            <div class="table-container">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Staff ID</th>
                                <th>Full Name</th>
                                <th>Username</th>
                                <th>Email Address</th>
                                <th>Contact Number</th>
                                <th>Specialty Profile</th>
                                <th>Experience Level</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (barberList.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" style="text-align: center; color: #777; padding: 30px;">
                                        <i class="fas fa-folder-open" style="font-size: 2rem; margin-bottom: 10px; display: block;"></i>
                                        No active staff records mapped inside data ledger context collections.
                                    </td>
                                </tr>
                            <% } else { 
                                for (Staff barber : barberList) { %>
                                    <tr>
                                        <td><strong>#<%= barber.getStaffId() %></strong></td>
                                        <td><%= barber.getStaffName() %></td>
                                        <td><%= barber.getStaffUsername() %></td>
                                        <td><%= barber.getStaffEmail() %></td>
                                        <td><%= barber.getStaffPhoneNum() %></td>
                                        <td><span class="badge-specialty"><%= barber.getStaffSpecialty() != null ? barber.getStaffSpecialty() : "General Stylist" %></span></td>
                                        <td><%= barber.getStaffExperience() %> Years</td>
                                        <td>
                                            <div class="actions-flex">
                                                <!-- Action Square Form Entry Triggers for Edit functionality -->
                                                <button class="action-box edit-btn" title="Edit Staff Profile"
                                                    onclick="openEdit('<%= barber.getStaffId() %>', '<%= barber.getStaffName().replace("'", "\\'") %>', '<%= barber.getStaffUsername().replace("'", "\\'") %>', '<%= barber.getStaffEmail().replace("'", "\\'") %>', '<%= barber.getStaffPhoneNum() %>', '<%= barber.getStaffSpecialty() %>', '<%= barber.getStaffExperience() %>', '<%= barber.getStaffRate() %>', '<%= barber.getManagerId() != null ? barber.getManagerId() : "" %>')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                
                                                <!-- Action Square API Link Endpoint Triggers for Delete functionality -->
                                                <a href="ManageStaffServlet?action=DELETE&staffId=<%= barber.getStaffId() %>" 
                                                   class="action-box delete-btn" title="Delete Staff Profile"
                                                   onclick="return confirm('Are you sure you want to permanently delete Barber #<%= barber.getStaffId() %> from the system registry?');">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } 
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <footer>
                <p>Admin Dashboard &copy; 2026. All rights reserved.</p>
            </footer>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            const sidebar = document.getElementById('sidebar');
            if (menuToggle && sidebar) {
                menuToggle.addEventListener('click', () => { sidebar.classList.toggle('active'); });
            }

            // Check URL Parameters for notification feedback windows
            const params = new URLSearchParams(window.location.search);
            if (params.has('msg')) {
                alert(params.get('msg'));
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });

        function openAdd() {
            document.getElementById('titleLabel').innerText = "Add New Staff";
            document.getElementById('subAction').value = "ADD";
            document.getElementById('fieldId').value = "";
            document.getElementById('fieldName').value = "";
            document.getElementById('fieldUser').value = "";
            document.getElementById('fieldPass').placeholder = "Enter password credential";
            document.getElementById('fieldPass').required = true;
            document.getElementById('fieldEmail').value = "";
            document.getElementById('fieldPhone').value = "";
            document.getElementById('fieldSpec').value = "General Stylist";
            document.getElementById('fieldExp').value = "";
            document.getElementById('fieldRate').value = "";
            document.getElementById('fieldManager').value = "";
            document.getElementById('crewModal').style.display = 'flex';
        }

        function openEdit(id, name, user, email, phone, spec, exp, rate, managerId) {
            document.getElementById('titleLabel').innerText = "Update Staff Profile";
            document.getElementById('subAction').value = "UPDATE";
            document.getElementById('fieldId').value = id;
            document.getElementById('fieldName').value = name;
            document.getElementById('fieldUser').value = user;
            document.getElementById('fieldPass').placeholder = "Leave blank to keep current configuration";
            document.getElementById('fieldPass').required = false;
            document.getElementById('fieldPass').value = "";
            document.getElementById('fieldEmail').value = email;
            document.getElementById('fieldPhone').value = phone;
            document.getElementById('fieldSpec').value = spec;
            document.getElementById('fieldExp').value = exp;
            document.getElementById('fieldRate').value = rate;
            document.getElementById('fieldManager').value = managerId;
            document.getElementById('crewModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('crewModal').style.display = 'none';
        }
    </script>
</body>
</html>