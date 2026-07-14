<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
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
<title>Admin Dashboard - Barbershop Management System</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
	--primary-color: #4361ee;
	--secondary-color: #3f37c9;
	--success-color: #4cc9f0;
	--danger-color: #f72585;
	--warning-color: #ff9e00;
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

/* 🌟 DILANDASKAN SEBIJI DARI GAYA STAFF SIDEBAR (LIGHT BLUE GRADIENT) */
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

/* MAIN CONTENT SECTION */
.main-content {
	flex: 1;
	margin-left: var(--sidebar-width);
	padding: 40px;
	transition: var(--transition);
	width: calc(100% - var(--sidebar-width));
}

header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 32px;
	background: none;
	box-shadow: none;
	padding: 0;
}

.header-left {
	display: flex;
	align-items: center;
	gap: 15px;
}

.menu-toggle {
	background: white;
	border: 1px solid var(--border-color);
	font-size: 1.2rem;
	color: var(--dark-color);
	cursor: pointer;
	display: none;
	width: 40px;
	height: 40px;
	border-radius: 8px;
	align-items: center;
	justify-content: center;
	box-shadow: var(--shadow);
}

.welcome-msg h1 {
	font-size: 28px;
	font-weight: 700;
	color: #111;
	margin-bottom: 4px;
}

.welcome-msg p {
	color: var(--text-muted);
}

.header-right {
	display: flex;
	align-items: center;
	gap: 20px;
}

.user-profile {
	display: flex;
	align-items: center;
	gap: 12px;
	background: white;
	padding: 8px 16px;
	border-radius: 30px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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

.user-info h4 {
	font-size: 14px;
	font-weight: 600;
}

.user-info p {
	font-size: 12px;
	color: var(--text-muted);
}

/* STATS CARDS BLOCK */
.stats-cards {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 24px;
	margin-bottom: 40px;
}

.stat-card {
	background-color: var(--card-bg);
	padding: 24px;
	border-radius: var(--border-radius);
	box-shadow: var(--shadow);
	display: flex;
	justify-content: space-between;
	align-items: center;
	border: 1px solid var(--border-color);
	transition: var(--transition);
}

.stat-card:hover {
	transform: translateY(-5px);
}

.stat-info h3 {
	font-size: 28px;
	font-weight: 700;
	margin-bottom: 4px;
}

.stat-info p {
	color: var(--text-muted);
	font-size: 14px;
	font-weight: 500;
}

.stat-icon {
	width: 48px;
	height: 48px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 20px;
	color: white;
}

.stat-icon.users {
	background-color: rgba(67, 97, 238, 0.15);
	color: var(--primary-color);
}

.stat-icon.orders {
	background-color: rgba(76, 201, 240, 0.15);
	color: #0096c7;
}

.stat-icon.revenue {
	background-color: rgba(255, 183, 3, 0.15);
	color: #e65c00;
}

.stat-icon.products {
	background-color: rgba(247, 37, 133, 0.15);
	color: var(--danger-color);
}

/* DATA TABLE CARD */
.table-card {
	background-color: white;
	border-radius: var(--border-radius);
	padding: 0;
	box-shadow: var(--shadow);
	margin-bottom: 40px;
	border: 1px solid var(--border-color);
	overflow: hidden;
}

.table-title-area {
	padding: 24px;
	border-bottom: 1px solid var(--border-color);
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.table-title-area h3 {
	font-size: 1.8rem;
	font-weight: 700;
}

.btn-refresh {
	background-color: white;
	border: 1px solid var(--border-color);
	padding: 8px 16px;
	border-radius: 8px;
	cursor: pointer;
	font-weight: 500;
	display: flex;
	align-items: center;
	gap: 8px;
	transition: var(--transition);
}

.btn-refresh:hover {
	background-color: #f5f5f5;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	background-color: #fafafa;
	padding: 16px 24px;
	color: var(--text-muted);
	font-weight: 600;
	font-size: 12px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	border-bottom: 1px solid var(--border-color);
}

td {
	padding: 18px 24px;
	border-bottom: 1px solid var(--border-color);
	font-size: 14px;
}

tr:last-child td {
	border-bottom: none;
}

.status {
	padding: 6px 12px;
	border-radius: 30px;
	font-size: 12px;
	font-weight: 600;
	display: inline-block;
}

.status.completed, .status.confirmed {
	background-color: #d4edda;
	color: #155724;
}

.status.pending {
	background-color: #fff3cd;
	color: #856404;
}

.status.cancelled {
	background-color: #f8d7da;
	color: #721c24;
}

.btn-view {
	background: none;
	border: 1px solid var(--primary-color);
	color: var(--primary-color);
	padding: 6px 12px;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 500;
	transition: var(--transition);
}

.btn-view:hover {
	background-color: var(--primary-color);
	color: white;
}

footer {
	text-align: center;
	padding: 24px;
	color: var(--text-muted);
	font-size: 14px;
}

@media (max-width: 900px) {
	.sidebar {
		transform: translateX(-100%);
	}
	.sidebar.active {
		transform: translateX(0);
	}
	.main-content {
		margin-left: 0;
		width: 100%;
		padding: 20px;
	}
	.menu-toggle {
		display: flex;
	}
}
</style>
</head>
<body>

	<aside class="sidebar" id="sidebar">
		<div class="sidebar-header">
			<h2>
				<i class="fas fa-cut"></i> Owl Barber
			</h2>
		</div>
		<ul class="sidebar-menu">
			<li><a href="AdminDashboardServlet" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
			<li><a href="AdminBookingServlet"><i class="fas fa-calendar-check"></i> Bookings</a></li>
			<li><a href="BarberAdminServlet"><i class="fas fa-user-tie"></i> Barbers</a></li>
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
				<button class="menu-toggle" id="menuToggle">
					<i class="fas fa-bars"></i>
				</button>
				<div class="welcome-msg">
					<h1>Admin Panel</h1>
					<p>Overview of your barbershop operations today.</p>
				</div>
			</div>
			<div class="header-right">
				<div class="user-profile">
					<div class="user-avatar"><%=firstLetter%></div>
					<div class="user-info">
						<h4><%=(userName != null) ? userName : "Admin User"%></h4>
						<p>Administrator</p>
					</div>
				</div>
			</div>
		</header>

		<div class="stats-cards">
			<div class="stat-card">
				<div class="stat-info">
					<h3 id="userCount"><%=request.getAttribute("totalCustomers") != null ? request.getAttribute("totalCustomers") : "0"%></h3>
					<p>Total Customers</p>
				</div>
				<div class="stat-icon users"><i class="fas fa-smile"></i></div>
			</div>

			<div class="stat-card">
				<div class="stat-info">
					<h3 id="orderCount"><%=request.getAttribute("totalBookings") != null ? request.getAttribute("totalBookings") : "0"%></h3>
					<p>Total Bookings</p>
				</div>
				<div class="stat-icon orders"><i class="fas fa-calendar-alt"></i></div>
			</div>

			<div class="stat-card">
				<div class="stat-info">
					<h3 id="revenueCount">RM <%=request.getAttribute("totalRevenue") != null ? String.format("%.2f", (Double) request.getAttribute("totalRevenue")) : "0.00"%></h3>
					<p>Total Revenue</p>
				</div>
				<div class="stat-icon revenue"><i class="fas fa-wallet"></i></div>
			</div>

			<div class="stat-card">
				<div class="stat-info">
					<h3 id="productCount"><%=request.getAttribute("barberCount") != null ? request.getAttribute("barberCount") : "0"%></h3>
					<p>Total Barbers</p>
				</div>
				<div class="stat-icon products"><i class="fas fa-user-tie"></i></div>
			</div>
		</div>

		<div class="table-card">
			<div class="table-header table-title-area">
				<h3>Recent Bookings</h3>
				<button class="btn-refresh" id="refreshBtn" onclick="window.location.reload();">
					<i class="fas fa-sync-alt"></i> Refresh Data
				</button>
			</div>
			<table>
				<thead>
					<tr>
						<th>Order ID</th>
						<th>Customer</th>
						<th>Date</th>
						<th>Amount</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody id="ordersTable">
					<%
					@SuppressWarnings("unchecked")
					List<Map<String, String>> recentBookings = (List<Map<String, String>>) request.getAttribute("recentBookings");
					if (recentBookings != null && !recentBookings.isEmpty()) {
						for (Map<String, String> o : recentBookings) {
					%>
					<tr>
						<td><%=o.get("id")%></td>
						<td><%=o.get("customer")%></td>
						<td><%=o.get("date")%></td>
						<td><%=o.get("amount")%></td>
						<td><span class="status <%=o.get("status").toLowerCase()%>"><%=o.get("status")%></span></td>
						<td><button class="btn-view" onclick="alert('Viewing Booking details for <%=o.get("id")%>')">View</button></td>
					</tr>
					<%
						}
					} else {
					%>
					<tr>
						<td colspan="6" style="text-align: center; color: #999; padding: 30px;">
						    No active appointment records loaded.
						</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>

		<footer>
			<p>The Owl Barber System &copy; 2026. All rights reserved.</p>
		</footer>
	</main>

	<script>
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');

        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
            });
        }
    </script>
</body>
</html>