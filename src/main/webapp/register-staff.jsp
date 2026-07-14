<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register New Staff - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --sidebar-width: 250px;
            --header-height: 70px;
            --border-radius: 10px;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --border-color: #cbd5e1;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background-color: #f5f7fb; color: var(--dark-color); display: flex; min-height: 100vh; }

        /* SIDEBAR SYNC MATCHING THEME */
        .sidebar {
            width: var(--sidebar-width); background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white; position: fixed; height: 100vh; padding: 20px 0; z-index: 1000;
        }
        .sidebar-header { padding: 0 20px 30px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); text-align: center; }
        .sidebar-header h2 { font-size: 1.5rem; display: flex; align-items: center; gap: 10px; justify-content: center; }
        .sidebar-menu { list-style: none; padding: 20px 0; }
        .sidebar-menu a { color: white; text-decoration: none; padding: 15px 25px; display: flex; align-items: center; gap: 15px; font-weight: 500; }
        .sidebar-menu a.active { background-color: rgba(255, 255, 255, 0.1); border-left: 4px solid var(--success-color); }

        .main-content { flex: 1; margin-left: var(--sidebar-width); }
        header { height: var(--header-height); background-color: white; display: flex; justify-content: flex-end; align-items: center; padding: 0 30px; box-shadow: var(--shadow); }
        .user-profile { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background-color: var(--primary-color); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; }
        
        .content-wrapper { padding: 40px; max-width: 800px; margin: 0 auto; }
        .form-card { background: white; padding: 30px; border-radius: var(--border-radius); box-shadow: var(--shadow); border: 1px solid #e2e8f0; }
        .form-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 25px; color: #1e293b; display: flex; align-items: center; gap: 10px; }
        
        .input-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .input-block { display: flex; flex-direction: column; gap: 6px; }
        .input-block.full-width { grid-column: span 2; }
        .input-block label { font-weight: 600; font-size: 0.9rem; color: #475569; }
        .input-block input, .input-block select { padding: 12px; border: 1px solid var(--border-color); border-radius: 6px; outline: none; font-size: 0.95rem; }
        .input-block input:focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15); }
        
        .form-buttons { display: flex; justify-content: flex-end; gap: 15px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0; }
        .btn-action { padding: 12px 24px; border-radius: 6px; font-weight: 600; cursor: pointer; border: none; font-size: 0.95rem; text-decoration: none; text-align: center; }
        .btn-action.cancel { background-color: #f1f5f9; color: #475569; }
        .btn-action.save { background-color: var(--primary-color); color: white; }
        .btn-action.save:hover { background-color: var(--secondary-color); }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <h2><i class="fas fa-cut"></i> Owl Barber</h2>
        </div>
        <ul class="sidebar-menu">
            <li><a href="AdminDashboardServlet"><i class="fas fa-users"></i> Dashboard</a></li>
            <li><a href="AdminBookingServlet"><i class="fas fa-calendar-check"></i> Bookings</a></li>
            <li><a href="BarberAdminServlet" class="active"><i class="fas fa-user-tie"></i> Barbers</a></li>
            <li><a href="AdminServiceServlet"><i class="fas fa-scissors"></i> Services</a></li>
            <li><a href="ReportAdminServlet"><i class="fas fa-chart-line"></i> Reports</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header>
            <div class="user-profile">
                <div class="user-avatar"><%= firstLetter %></div>
                <div>
                    <h4><%= (userName != null) ? userName : "Admin User" %></h4>
                    <p style="font-size: 0.75rem; color: #64748b;">Administrator</p>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="form-card">
                <div class="form-title"><i class="fas fa-user-plus" style="color: var(--primary-color);"></i> Register New Barber Crew</div>
                
                <form action="ManageStaffServlet" method="POST">
                    <input type="hidden" name="action" value="ADD">
                    
                    <div class="input-grid">
                        <div class="input-block full-width">
                            <label>Full Name</label>
                            <input type="text" name="staffName" required placeholder="e.g. Ahmad Haiqal">
                        </div>
                        <div class="input-block">
                            <label>Username</label>
                            <input type="text" name="staffUsername" required placeholder="Unique username">
                        </div>
                        <div class="input-block">
                            <label>Account Password</label>
                            <input type="password" name="staffPassword" required placeholder="Enter password secure text">
                        </div>
                        <div class="input-block">
                            <label>Email Address</label>
                            <input type="email" name="staffEmail" required placeholder="name@email.com">
                        </div>
                        <div class="input-block">
                            <label>Contact Number</label>
                            <input type="text" name="staffPhoneNum" required placeholder="e.g. 012-3456789">
                        </div>
                        <div class="input-block">
                            <label>Specialty Profile</label>
                            <select name="staffSpecialty">
                                <option value="Haircut specialty">Haircut specialty</option>
                                <option value="Beard specialty">Beard specialty</option>
                                <option value="Senior Barber">Senior Barber</option>
                                <option value="General Stylist" selected>General Stylist</option>
                            </select>
                        </div>
                        <div class="input-block">
                            <label>Experience Level (Years)</label>
                            <input type="number" name="staffExperience" required min="0" placeholder="e.g. 3">
                        </div>
                        <div class="input-block">
                            <label>Base Rate (RM)</label>
                            <input type="number" step="0.01" name="staffRate" required min="0" placeholder="e.g. 25.00">
                        </div>
                        <div class="input-block">
                            <label>Assign Manager ID (Leave blank if none)</label>
                            <input type="number" name="managerId" placeholder="Optional numeric ID">
                        </div>
                    </div>
                    
                    <div class="form-buttons">
                        <a href="BarberAdminServlet" class="btn-action cancel">Back to List</a>
                        <button type="submit" class="btn-action save">Confirm Registration</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

</body>
</html>