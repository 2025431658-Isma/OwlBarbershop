<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// 🌟 1. Retrieve the staff member's name from the session set during Login
String staffName = (String) session.getAttribute("staffName");

// 🔒 Security Control: If the session attribute is missing, redirect back to login
if (staffName == null) {
	response.sendRedirect("login.jsp");
	return;
}

// 🌟 2. Extract the first letter of the name to display inside the profile circular avatar (e.g., John -> J)
String firstLetter = "S"; // Default value fallback
if (staffName != null && !staffName.trim().isEmpty()) {
	firstLetter = staffName.trim().substring(0, 1).toUpperCase();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Staff Dashboard - Owl Barbershop</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
	--primary-color: #4361ee;
	--secondary-color: #3f37c9;
	--success-color: #4cc9f0;
	--warning-color: #f72585;
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

/* Sidebar Styles */
.sidebar {
	width: var(--sidebar-width);
	background: linear-gradient(180deg, var(--primary-color),
		var(--secondary-color));
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

/* Main Layout Styles */
.main-content {
	flex: 1;
	margin-left: var(--sidebar-width);
	transition: var(--transition);
}

/* Top Navbar Header Styles */
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

/* Wrapper and Layout Cards */
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
	color: var(--dark-color);
}

.btn {
	padding: 10px 20px;
	border-radius: 5px;
	border: none;
	cursor: pointer;
	font-weight: 500;
	display: flex;
	align-items: center;
	gap: 8px;
	background-color: var(--primary-color);
	color: white;
}

/* Statistic Blocks */
.stats-cards {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
	gap: 25px;
	margin-bottom: 40px;
}

.stat-card {
	background-color: white;
	border-radius: var(--border-radius);
	padding: 25px;
	box-shadow: var(--shadow);
	display: flex;
	align-items: center;
	gap: 20px;
	transition: var(--transition);
}

.stat-card:hover {
	transform: translateY(-5px);
}

.stat-icon {
	width: 60px;
	height: 60px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.8rem;
	color: white;
}

.stat-icon.users {
	background-color: var(--primary-color);
}

.stat-icon.orders {
	background-color: var(--success-color);
}

.stat-icon.products {
	background-color: var(--warning-color);
}

.stat-info h3 {
	font-size: 1.8rem;
	margin-bottom: 5px;
}

.stat-info p {
	color: #666;
	font-size: 0.9rem;
}

/* Data Table Container Card */
.table-card {
	background-color: white;
	border-radius: var(--border-radius);
	padding: 25px;
	box-shadow: var(--shadow);
	margin-bottom: 40px;
}

.table-card h3 {
	margin-bottom: 20px;
	font-size: 1.3rem;
}

table {
	width: 100%;
	border-collapse: collapse;
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

.status {
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 0.85rem;
	font-weight: 500;
}

.status.completed {
	background-color: #e7f7ef;
	color: #1ea97c;
}

.status.pending {
	background-color: #fff5e6;
	color: #ff9800;
}

.btn-view {
	padding: 5px 10px;
	background-color: var(--primary-color);
	color: white;
	border: none;
	border-radius: 3px;
	cursor: pointer;
}

/* Activity Logs List */
.activity-list {
	list-style: none;
}

.activity-item {
	display: flex;
	align-items: center;
	padding: 15px 0;
	border-bottom: 1px solid #eee;
}

.activity-item:last-child {
	border-bottom: none;
}

.activity-icon {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-right: 15px;
	color: white;
}

.activity-icon.user {
	background-color: var(--primary-color);
}

.activity-icon.order {
	background-color: var(--success-color);
}

.activity-content p {
	margin-bottom: 5px;
}

.activity-time {
	color: #999;
	font-size: 0.85rem;
}

footer {
	text-align: center;
	padding: 20px;
	color: #777;
	border-top: 1px solid #eee;
	margin-top: 30px;
}

/* Responsive UI Viewports */
@media ( max-width : 900px) {
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

@media ( max-width : 768px) {
	.stats-cards {
		grid-template-columns: repeat(2, 1fr);
	}
	.search-box {
		display: none;
	}
}

@media ( max-width : 576px) {
	.stats-cards {
		grid-template-columns: 1fr;
	}
	.content-wrapper {
		padding: 20px;
	}
	.page-title h1 {
		font-size: 1.5rem;
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
			<li><a href="StaffDashboardServlet" class="active"> <i
					class="fas fa-dashboard"></i> Dashboard
			</a></li>
			<li><a href="StaffListServlet"> <i class="fas fa-users"></i>
					Barber
			</a></li>
			<li><a href="StaffBookingServlet"> <i
					class="fas fa-calendar-check"></i> Booking
			</a></li>
			<li><a href="StaffSettingServlet"> <i
					class="fas fa-user-cog"></i> Profile
			</a></li>
			<li style="margin-top: auto;"><a href="login.jsp"
				onclick="return confirm('Are you sure you want to log out?');"
				style="color: #ff4d4d; font-weight: 600;"> <i
					class="fas fa-sign-out-alt" style="color: #ff4d4d;"></i> Logout
			</a></li>
		</ul>
	</aside>

	<main class="main-content" id="mainContent">
		<header>
			<div class="header-left">
				<button class="menu-toggle" id="menuToggle">
					<i class="fas fa-bars"></i>
				</button>
				<div class="search-box">
					<i class="fas fa-search"></i> <input type="text"
						placeholder="Search...">
				</div>
			</div>
			<div class="header-right">
				<div class="user-profile">
					<div class="user-avatar"><%=firstLetter%></div>
					<div class="user-info">
						<h4><%=staffName%></h4>
						<p>Staff Member</p>
					</div>
				</div>
			</div>
		</header>

		<div class="content-wrapper">
			<div class="page-title">
				<h1>Dashboard Overview</h1>
				<button class="btn" id="refreshBtn">
					<i class="fas fa-sync-alt"></i> Refresh Data
				</button>
			</div>

			<div class="stats-cards">
				<div class="stat-card">
					<div class="stat-icon users">
						<i class="fas fa-calendar-check"></i>
					</div>
					<div class="stat-info">
						<h3 id="txtTotalBooking">${not empty totalBooking ? totalBooking : 0}</h3>
						<p>Total Bookings</p>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon products">
						<i class="fas fa-clock"></i>
					</div>
					<div class="stat-info">
						<h3 id="txtPendingBooking">${not empty pendingBooking ? pendingBooking : 0}</h3>
						<p>Pending Bookings</p>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon orders">
						<i class="fas fa-check-circle"></i>
					</div>
					<div class="stat-info">
						<h3 id="txtCompletedBooking">${not empty completedBooking ? completedBooking : 0}</h3>
						<p>Completed</p>
					</div>
				</div>
			</div>

			<div class="table-card">
				<h3>Recent Appointments</h3>
				<table>
					<thead>
						<tr>
							<th>Booking ID</th>
							<th>Customer</th>
							<th>Date</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody id="ordersTable">
					</tbody>
				</table>
			</div>

			<div class="table-card">
				<h3>Recent Log Activities</h3>
				<ul class="activity-list" id="activityList">
				</ul>
			</div>

			<footer>
				<p>Owl Barbershop System &copy; 2026. All Rights Reserved.</p>
			</footer>
		</div>
	</main>

	<script>
		// Declare and catch critical DOM node objects for script executions
		const sidebar = document.getElementById('sidebar');
		const mainContent = document.getElementById('mainContent');
		const menuToggle = document.getElementById('menuToggle');
		const refreshBtn = document.getElementById('refreshBtn');
		const ordersTable = document.getElementById('ordersTable');
		const activityList = document.getElementById('activityList');

		// Hardcoded UI Placeholder Objects Mock Array
		const orders = [
			{ id: "BK-1024", customer: "Ahmad Razak", date: "13-07-2026", status: "pending" },
			{ id: "BK-1023", customer: "Chong Wei", date: "13-07-2026", status: "completed" }
		];

		const activities = [
			{ icon: "user", type: "user", text: "New customer registered an account.", time: "10 mins ago" },
			{ icon: "order", type: "order", text: "New haircut appointment booked on Slot #1.", time: "1 hour ago" }
		];

        // Core initializer to start setup configurations on load
        function initDashboard() {
            populateOrdersTable();
            populateActivityList();
            
            // Attach interaction Event Listeners
            menuToggle.addEventListener('click', toggleSidebar);
            refreshBtn.addEventListener('click', refreshDashboard);
        }

        // Toggle visibility state for Responsive Layout Sidebar Drawer
        function toggleSidebar() {
            sidebar.classList.toggle('active');
            if (sidebar.classList.contains('active')) {
                mainContent.style.marginLeft = '0';
            } else {
                mainContent.style.marginLeft = 'var(--sidebar-width)';
            }
        }

        // Loop array data inside DOM structure for appointments table UI grid
        function populateOrdersTable() {
            ordersTable.innerHTML = '';
            orders.forEach(order => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>\${order.id}</td>
                    <td>\${order.customer}</td>
                    <td>\${order.date}</td>
                    <td><span class="status \${order.status}">\${order.status === 'completed' ? 'Completed' : 'Pending'}</span></td>
                    <td><button class="btn-view" data-id="\${order.id}">View</button></td>
                `;
                ordersTable.appendChild(row);
            });

            // Apply viewing modal listeners on dynamically mapped buttons
            document.querySelectorAll('.btn-view').forEach(button => {
                button.addEventListener('click', function() {
                    alert('Displaying booking details for: ' + this.getAttribute('data-id'));
                });
            });
        }

        // Loop array data streams inside Activity List component elements
        function populateActivityList() {
            activityList.innerHTML = '';
            activities.forEach(activity => {
                const item = document.createElement('li');
                item.className = 'activity-item';
                
                // Fixed logic evaluating type attributes cleanly without broken template tags
                const iconClass = activity.type === 'user' ? 'user' : 'shopping-cart';
                
                item.innerHTML = `
                    <div class="activity-icon \${activity.icon}">
                        <i class="fas fa-\ Bang-iconClass \`\${iconClass}\`"></i>
                    </div>
                    <div class="activity-content">
                        <p>\${activity.text}</p>
                        <span class="activity-time">\${activity.time}</span>
                    </div>
                `;
                activityList.appendChild(item);
            });
        }

        // Simulation module processing synchronous refresh visual changes
        function refreshDashboard() {
            refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            refreshBtn.disabled = true;
            
            setTimeout(() => {
                refreshBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Refresh Data';
                refreshBtn.disabled = false;
                showNotification('Dashboard metrics updated successfully!', 'success');
            }, 1200);
        }

        // Inject transient toast overlay box notices on screens
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = `notification-toast \${type}`;
            notification.innerHTML = `
                <div class="notification-content">
            		<i class="fas fa-check-circle"></i> <span>\${message}</span>
                </div>
                <button class="notification-close" style="background:none; border:none; color:#999; cursor:pointer;"><i class="fas fa-times"></i></button>
            `;
            
            const style = document.createElement('style');
            style.textContent = `
                .notification-toast {
                    position: fixed; top: 90px; right: 30px; background-color: white;
                    border-radius: var(--border-radius); padding: 15px 20px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.2); display: flex;
                    align-items: center; justify-content: space-between; min-width: 300px; z-index: 9999;
                    border-left: 4px solid var(--success-color); animation: slideIn 0.3s ease forwards;
                }
                .notification-content { display: flex; align-items: center; gap: 10px; }
                .notification-content i { color: var(--success-color); }
                @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
            `;
            
            document.head.appendChild(style);
            document.body.appendChild(notification);
            
            notification.querySelector('.notification-close').addEventListener('click', () => {
                notification.remove();
                style.remove();
            });
            
            setTimeout(() => { if (notification.parentNode) { notification.remove(); style.remove(); } }, 4000);
        }

        // Execute initializer method when HTML document object model finishes loading
        document.addEventListener('DOMContentLoaded', initDashboard);
	</script>
</body>
</html>