<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Global Session Protection Block
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

    // Retrieve live attributes passed from ReportAdminServlet
    Double totalRevenueVal = (Double) request.getAttribute("totalRevenue");
    Integer totalBookingsCount = (Integer) request.getAttribute("totalBookings");

    // Fallbacks if data bindings are null
    if (totalRevenueVal == null) totalRevenueVal = 0.0;
    if (totalBookingsCount == null) totalBookingsCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports &amp; Analytics - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            --card-bg: #ffffff;
            --text-muted: #6c757d;
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

        /* Full Window Height Navigation Column Layout with Light Blue Theme Hooks */
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
            justify-content: center;
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

        /* Workspace Main Panel Layout Frame Wrapper */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: var(--transition);
            width: calc(100% - var(--sidebar-width));
        }

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

        .header-right {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
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

        .content-wrapper {
            padding: 30px;
        }

        .page-title {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title h1 {
            font-size: 2rem;
            font-weight: 700;
        }

        .btn-export-pdf {
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-export-pdf:hover {
            background-color: var(--secondary-color);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        /* Compact Horizontal Data Metrics Configuration Layout */
        .metrics-summary-bar {
            display: inline-flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .metric-card {
            background-color: var(--card-bg);
            padding: 20px 25px;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 1px solid var(--border-color);
            min-width: 320px;
            gap: 40px;
        }

        .metric-info h3 {
            font-size: 24px;
            font-weight: 700;
        }

        .metric-info p {
            color: var(--text-muted);
            font-size: 14px;
            margin-top: 4px;
        }

        /* Modern Square Icon Wrapper Theme Component Design */
        .metric-icon {
            width: 50px;
            height: 50px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .metric-icon.revenue { background-color: rgba(67, 97, 238, 0.1); color: var(--primary-color); }
        .metric-icon.bookings { background-color: rgba(76, 201, 240, 0.1); color: var(--success-color); }

        /* Graphical Analytics Layout Cards */
        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .chart-card {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
        }

        .chart-card-header {
            margin-bottom: 20px;
        }

        .chart-card-header h2 {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark-color);
        }

        .chart-container {
            position: relative;
            height: 350px;
            width: 100%;
        }

        /* Integrated Notification Component Styles */
        .toast-notification {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #212529;
            color: white;
            padding: 15px 25px;
            border-radius: var(--border-radius);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 10px;
            transform: translateY(100px);
            opacity: 0;
            visibility: hidden;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55);
            z-index: 3000;
        }

        .toast-notification.show {
            transform: translateY(0);
            opacity: 1;
            visibility: visible;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #777;
            border-top: 1px solid #eee;
            margin-top: 30px;
        }

        @media (max-width: 1024px) {
            .charts-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 900px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; width: 100%; }
            .menu-toggle { display: block; }
            .metrics-summary-bar { display: flex; flex-direction: column; width: 100%; }
            .metric-card { min-width: 100%; }
        }
    </style>
</head>
<body>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h2><i class="fas fa-cut"></i> Owl Barber</h2>
        </div>
        <ul class="sidebar-menu">
            <li><a href="AdminDashboardServlet"><i class="fas fa-users"></i> Dashboard</a></li>
            <li><a href="AdminBookingServlet"><i class="fas fa-calendar-check"></i> Bookings</a></li>
            <li><a href="BarberAdminServlet"><i class="fas fa-user-tie"></i> Barbers</a></li>
            <li><a href="AdminServiceServlet"><i class="fas fa-scissors"></i> Services</a></li>
            <li><a href="ReportAdminServlet" class="active"><i class="fas fa-chart-line"></i> Reports</a></li>
            <li><a href="AdminProfileServlet"><i class="fas fa-cog"></i> Profile</a></li>
            <li>
                <a href="login.jsp" style="color: #ff4d4d;" onclick="return confirm('Are you sure you want to log out?');">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </aside>

    <main class="main-content" id="mainContent">
        <header>
            <div class="header-left">
                <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>
                <div style="font-weight: 500; color: var(--text-muted);">
                    System Analytics Ledger
                </div>
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
                <h1>Reports &amp; Analytics</h1>
                <button class="btn-export-pdf" id="exportPdfBtn">
                    <i class="fas fa-file-pdf"></i> Export Summary Report
                </button>
            </div>

            <div class="metrics-summary-bar">
                <div class="metric-card">
                    <div class="metric-info">
                        <h3>RM <%= String.format("%.2f", totalRevenueVal) %></h3>
                        <p>Total Revenue Managed</p>
                    </div>
                    <div class="metric-icon revenue"><i class="fas fa-wallet"></i></div>
                </div>
                <div class="metric-card">
                    <div class="metric-info">
                        <h3><%= totalBookingsCount %> Records</h3>
                        <p>Total Managed Bookings</p>
                    </div>
                    <div class="metric-icon bookings"><i class="fas fa-calendar-alt"></i></div>
                </div>
            </div>

            <div class="charts-grid">
                <div class="chart-card">
                    <div class="chart-card-header">
                        <h2>Monthly Revenue Stream Trend (RM)</h2>
                    </div>
                    <div class="chart-container">
                        <canvas id="revenueTrendChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-card-header">
                        <h2>Popular Services Share</h2>
                    </div>
                    <div class="chart-container">
                        <canvas id="popularServicesChart"></canvas>
                    </div>
                </div>
            </div>

            <footer>
                <p>Admin Dashboard &copy; 2026. All rights reserved.</p>
            </footer>
        </div>
    </main>

    <div class="toast-notification" id="toastBox">
        <i class="fas fa-info-circle" style="color: var(--success-color);"></i>
        <span id="toastMessage">Processing operation payload...</span>
    </div>

    <script>
        function openToastNotification(messageText) {
            const toast = document.getElementById("toastBox");
            const textSpan = document.getElementById("toastMessage");
            if(toast && textSpan) {
                textSpan.innerText = messageText;
                toast.classList.add("show");
                setTimeout(() => {
                    toast.classList.remove("show");
                }, 3500);
            }
        }

        function initReportDashboard() {
            const menuToggle = document.getElementById('menuToggle');
            if (menuToggle) {
                menuToggle.addEventListener('click', () => {
                    document.getElementById('sidebar').classList.toggle('active');
                });
            }

            // Chart 1 Setup: Line Revenue Trend Configuration Metrics
            const revCanvas = document.getElementById('revenueTrendChart');
            if (revCanvas) {
                const ctx1 = revCanvas.getContext('2d');
                new Chart(ctx1, {
                    type: 'line',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                        datasets: [{
                            label: 'Monthly Revenue (RM)',
                            data: [1200, 1900, 3000, 2500, 4200, 3800, 5000, 4800, 6200, 5500, 7000, 8500],
                            borderColor: '#4361ee',
                            backgroundColor: 'rgba(67, 97, 238, 0.05)',
                            borderWidth: 3,
                            fill: true,
                            tension: 0.3,
                            pointBackgroundColor: '#4361ee'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { grid: { color: '#f0f0f0' }, ticks: { callback: value => 'RM ' + value } },
                            x: { grid: { display: false } }
                        }
                    }
                });
            }

         // Chart 2 Setup: Popular Product Target Shares Doughnut Configuration
            const popCanvas = document.getElementById('popularServicesChart');
            if (popCanvas) {
                const ctx2 = popCanvas.getContext('2d');
                new Chart(ctx2, {
                    type: 'doughnut',
                    data: {
                        labels: ['Classic Haircut', 'Beard Grooming', 'Premium Hair Spa', 'Kids Haircut'],
                        datasets: [{
                            data: [45, 25, 20, 10],
                            backgroundColor: ['#4361ee', '#4cc9f0', '#ff9e00', '#f72585'],
                            borderWidth: 2,
                            borderColor: '#ffffff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, padding: 15 } } }
                    }
                });
            }

            // Event binding execution routines with Confirmation
            const exportBtn = document.getElementById('exportPdfBtn');
            if (exportBtn) {
                exportBtn.addEventListener('click', () => {
                    // Papar kotak dialog pengesahan sebelum download
                    const confirmDownload = confirm("Are you sure you want to export and download the Summary Report PDF?");
                    
                    // Jika user tekan 'OK', baru jalankan function download/toast
                    if (confirmDownload) {
                        openToastNotification("Compiling system analytical data graphs... Summary PDF downloaded successfully.");
                        
                        // Letakkan logik submit form atau window.location untuk generate PDF sebenar di sini jika ada
                    }
                });
            }
        }

        document.addEventListener('DOMContentLoaded', initReportDashboard);
    </script>
</body>
</html>