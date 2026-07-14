<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Staff" %>
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

    Staff profile = (Staff) request.getAttribute("adminProfile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Profile - Settings</title>
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

/* 🌟 SIDEBAR GAYA LIGHT BLUE GRADIENT SUCI */
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

/* Main Content Wrapper Box */
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
	text-align: center; 
	}

.page-title h1 {
	font-size: 2rem;
	font-weight: 700;
}

/* Container Profile Card */
.profile-card {
	background-color: white;
	border-radius: var(--border-radius);
	padding: 35px;
	box-shadow: var(--shadow);
	border: 1px solid var(--border-color);
	max-width: 900px;
	margin: 0 auto 40px auto; 
}

.profile-header-block {
	display: flex;
	align-items: center;
	gap: 20px;
	margin-bottom: 35px;
	border-bottom: 1px solid var(--border-color);
	padding-bottom: 25px;
}

.large-avatar-container {
	width: 75px;
	height: 75px;
	background-color: var(--primary-color);
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2rem;
	font-weight: bold;
	box-shadow: 0 4px 10px rgba(67, 97, 238, 0.2);
}

.profile-header-info h2 {
	font-size: 1.5rem;
	color: var(--dark-color);
}

.profile-header-info p {
	color: var(--text-muted);
	font-size: 0.95rem;
	margin-top: 4px;
}

/* Grid Input Form Controls */
.form-grid-layout {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.input-group-row {
	margin-bottom: 5px;
}

.input-group-row.full-span {
	grid-column: span 2;
}

.input-group-row label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #495057;
	font-size: 0.88rem;
}

.input-group-row input {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #ced4da;
	border-radius: var(--border-radius);
	font-size: 0.95rem;
	color: var(--dark-color);
	background-color: white;
	outline: none;
	transition: var(--transition);
}

.input-group-row input:focus {
	border-color: var(--primary-color);
	box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
}

.input-group-row input[readonly], .input-group-row input[disabled] {
	background-color: #f8f9fa;
	color: #6c757d;
	cursor: not-allowed;
	border-color: #e9ecef;
}

.form-actions-bar {
	margin-top: 30px;
	display: flex;
	justify-content: flex-end;
	gap: 15px;
}

.btn-action {
	border: none;
	padding: 12px 28px;
	border-radius: var(--border-radius);
	font-weight: 600;
	cursor: pointer;
	font-size: 0.95rem;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	transition: var(--transition);
}

.btn-edit {
	background-color: var(--primary-color);
	color: white;
}

.btn-edit:hover {
	background-color: var(--secondary-color);
	box-shadow: 0 4px 12px rgba(67, 97, 238, 0.2);
}

.btn-save {
	background-color: #28a745;
	color: white;
	display: none;
}

.btn-save:hover {
	background-color: #218838;
	box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
}

.toast-notification {
	background-color: #e7f7ef;
	color: #1ea97c;
	padding: 14px 20px;
	border-radius: var(--border-radius);
	margin-bottom: 25px;
	border: 1px solid #c3e6cb;
	display: none;
	align-items: center;
	gap: 10px;
	font-weight: 500;
}

footer {
	text-align: center;
	padding: 20px;
	color: #777;
	border-top: 1px solid #eee;
	margin-top: 30px;
}

@media (max-width: 900px) {
	.sidebar { transform: translateX(-100%); }
	.sidebar.active { transform: translateX(0); }
	.main-content { margin-left: 0; width: 100%; }
	.menu-toggle { display: block; }
	.form-grid-layout { grid-template-columns: 1fr; }
	.input-group-row.full-span { grid-column: span 1; }
}
</style>
</head>
<body>

	<!-- Sidebar Navigation Matrix Layout -->
	<aside class="sidebar" id="sidebar">
		<div class="sidebar-header">
			<h2>
			<i class="fas fa-cut"></i> Owl Barber
			</h2>
		</div>
		<ul class="sidebar-menu">
			<li><a href="AdminDashboardServlet"><i class="fas fa-users"></i> Dashboard</a></li>
			<li><a href="AdminBookingServlet"><i class="fas fa-calendar-check"></i> Bookings</a></li>
			<li><a href="BarberAdminServlet"><i class="fas fa-user-tie"></i> Barbers</a></li>
			<li><a href="AdminServiceServlet"><i class="fas fa-scissors"></i> Services</a></li>
			<li><a href="ReportAdminServlet"><i class="fas fa-chart-line"></i> Reports</a></li>
			<li><a href="AdminProfileServlet" class="active"><i class="fas fa-cog"></i> Profile</a></li>
			<li>
				<a href="login.jsp" style="color: #ff4d4d;" onclick="return confirm('Are you sure you want to log out?');">
					<i class="fas fa-sign-out-alt"></i> Logout
				</a>
			</li>
		</ul>
	</aside>

	<!-- Main Core Grid Layout View -->
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
				<h1>Profile Settings</h1>
			</div>

			<div class="profile-card">
				<% if (profile != null) { %>
				<div class="profile-header-block">
					<div class="large-avatar-container"><%= firstLetter %></div>
					<div class="profile-header-info">
						<h2><%= profile.getStaffName() %></h2>
						<p>Role Assignment: <%= profile.getStaffSpecialty() != null ? profile.getStaffSpecialty() : "Manager" %></p>
					</div>
				</div>

				<div class="toast-notification" id="toastMessage">
					<i class="fas fa-check-circle"></i> Profile configuration updated successfully!
				</div>

				<form action="AdminProfileServlet" method="POST">
					<div class="form-grid-layout">
						<div class="input-group-row">
							<label>Staff ID (Immutable)</label>
							<input type="text" value="<%= profile.getStaffId() %>" disabled>
						</div>
						<div class="input-group-row">
							<label>Specialty Designation</label>
							<input type="text" id="profileSpecialty" name="staffSpecialty" value="<%= profile.getStaffSpecialty() != null ? profile.getStaffSpecialty() : "" %>" readonly>
						</div>
						<div class="input-group-row full-span">
							<label>Full Representative Name</label>
							<input type="text" id="profileName" name="staffName" value="<%= profile.getStaffName() %>" readonly required>
						</div>
						<div class="input-group-row">
							<label>System Account Username</label>
							<input type="text" id="profileUsername" name="staffUsername" value="<%= profile.getStaffUsername() %>" readonly required>
						</div>
						<div class="input-group-row">
							<label>Experience Tier (Years)</label>
							<input type="number" id="profileExperience" name="staffExperience" value="<%= profile.getStaffExperience() %>" readonly required>
						</div>
						<div class="input-group-row">
							<label>Email Contact Address</label>
							<input type="email" id="profileEmail" name="staffEmail" value="<%= profile.getStaffEmail() != null ? profile.getStaffEmail() : "" %>" readonly>
						</div>
						<div class="input-group-row">
							<label>Mobile Contact Number</label>
							<input type="text" id="profilePhone" name="staffPhoneNum" value="<%= profile.getStaffPhoneNum() != null ? profile.getStaffPhoneNum() : "" %>" readonly>
						</div>
						<div class="input-group-row full-span">
							<label>Authentication Password</label>
							<input type="password" id="profilePassword" name="staffPassword" value="<%= profile.getStaffPassword() %>" readonly required>
						</div>
					</div>

					<div class="form-actions-bar">
						<button type="button" class="btn-action btn-edit" id="editProfileBtn"><i class="fas fa-edit"></i> Edit Profile</button>
						<button type="submit" class="btn-action btn-save" id="saveProfileBtn"><i class="fas fa-save"></i> Save Changes</button>
					</div>
				</form>
				<% } %>
			</div>

			<footer>
				<p>Admin Dashboard &copy; 2026. All rights reserved.</p>
			</footer>
		</div>
	</main>

	<script>
		document.addEventListener("DOMContentLoaded", function () {
			const menuToggle = document.getElementById('menuToggle');
			const sidebar = document.getElementById('sidebar');
			if (menuToggle && sidebar) {
				menuToggle.addEventListener('click', () => {
					sidebar.classList.toggle('active');
				});
			}

			const editBtn = document.getElementById('editProfileBtn');
			const saveBtn = document.getElementById('saveProfileBtn');
			const fieldIds = ['profileName', 'profileUsername', 'profileSpecialty', 'profileExperience', 'profileEmail', 'profilePhone', 'profilePassword'];

			if (editBtn) {
				editBtn.addEventListener('click', () => {
					fieldIds.forEach(id => {
						const field = document.getElementById(id);
						if (field) field.removeAttribute('readonly');
					});
					editBtn.style.display = 'none';
					if (saveBtn) saveBtn.style.display = 'inline-flex';
				});
			}

			if (new URLSearchParams(window.location.search).get('status') === 'success') {
				const toast = document.getElementById('toastMessage');
				if (toast) toast.style.display = 'flex';
			}
		});
	</script>
</body>
</html>