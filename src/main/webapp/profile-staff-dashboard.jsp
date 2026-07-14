<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String userName = (String) session.getAttribute("userName");
if (userName == null) {
	response.sendRedirect("login.jsp");
	return;
}
String firstLetter = "S";
if (userName != null && !userName.trim().isEmpty()) {
	firstLetter = userName.trim().substring(0, 1).toUpperCase();
}
%>
<%@ page import="model.Staff"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Staff Dashboard - Profile Settings</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
	--primary-color: #4361ee;
	--secondary-color: #3f37c9;
	--success-color: #4cc9f0;
	--warning-color: #ff9e00;
	--danger-color: #e63946;
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
	font-family: 'Segoe UI', sans-serif;
}

body {
	background-color: #f5f7fb;
	color: var(--dark-color);
	display: flex;
	min-height: 100vh;
}

.sidebar {
	width: var(--sidebar-width);
	background: linear-gradient(180deg, var(--primary-color),
		var(--secondary-color));
	color: white;
	position: fixed;
	height: 100vh;
	padding: 20px 0;
	z-index: 1000;
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

.sidebar-menu {
	list-style: none;
	padding: 20px 0;
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

.main-content {
	flex: 1;
	margin-left: var(--sidebar-width);
}

header {
	height: var(--header-height);
	background: white;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0 30px;
	box-shadow: var(--shadow);
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

.card {
	background: white;
	border-radius: var(--border-radius);
	padding: 25px;
	box-shadow: var(--shadow);
	margin-bottom: 30px;
}

.profile-container {
	max-width: 800px;
	margin: 0 auto;
}

.profile-header-card {
	display: flex;
	align-items: center;
	gap: 30px;
	padding: 20px;
	border-bottom: 1px solid #eee;
	margin-bottom: 30px;
}

.big-avatar {
	width: 90px;
	height: 90px;
	border-radius: 50%;
	background: linear-gradient(135deg, var(--primary-color),
		var(--secondary-color));
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	font-size: 2.5rem;
	font-weight: bold;
	box-shadow: var(--shadow);
}

.grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #555;
	font-size: 0.95rem;
}

.form-control {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: var(--border-radius);
	outline: none;
	transition: var(--transition);
	background-color: #fafafa;
	font-size: 1rem;
}

.form-control:focus {
	border-color: var(--primary-color);
	background-color: white;
	box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
}

.form-control[readonly] {
	background-color: #f1f3f7;
	color: #666;
	cursor: not-allowed;
	border-color: #e2e8f0;
}

.btn-container {
	display: flex;
	justify-content: flex-end;
	gap: 15px;
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid #eee;
}

.btn {
	padding: 12px 25px;
	border-radius: var(--border-radius);
	border: none;
	font-weight: 600;
	cursor: pointer;
	display: inline-flex;
	align-items: center;
	gap: 10px;
	font-size: 1rem;
	transition: var(--transition);
}

.btn-edit {
	background-color: var(--primary-color);
	color: white;
}

.btn-edit:hover {
	background-color: var(--secondary-color);
}

.btn-save {
	background-color: #2ec4b6;
	color: white;
	display: none;
}

.btn-save:hover {
	background-color: #20a396;
}

.toast-notification {
	position: fixed;
	bottom: 30px;
	right: 30px;
	background-color: #2ec4b6;
	color: white;
	padding: 15px 30px;
	border-radius: var(--border-radius);
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
	display: none;
	z-index: 3000;
	animation: slideIn 0.5s ease;
	font-weight: 600;
}

@
keyframes slideIn {from { transform:translateY(100px);
	opacity: 0;
}

to {
	transform: translateY(0);
	opacity: 1;
}
}
</style>
</head>
<body>

	<aside class="sidebar">
		<div class="sidebar-header">
			<h2>
				<i class="fas fa-cut"></i> Owl Barber
			</h2>
		</div>
		<ul class="sidebar-menu">
			<li><a href="StaffDashboardServlet"><i
					class="fas fa-dashboard"></i> Dashboard</a></li>
			<li><a href="StaffListServlet"><i class="fas fa-users"></i>
					Staffs</a></li>
			<li><a href="StaffBookingServlet"><i
					class="fas fa-shopping-cart"></i> Booking</a></li>
			<li><a href="StaffSettingServlet" class="active"><i
					class="fas fa-cog"></i> Profile</a></li>
			<li><a href="login.jsp" style="color: #ff4d4d;"
				onclick="return confirm('Are you sure you want to log out?');">
					<i class="fas fa-sign-out-alt"></i> Logout
			</a></li>
		</ul>
	</aside>

	<main class="main-content">
		<header>
			<div></div>
			<div class="header-right">
				<div class="user-profile">
					<div class="user-avatar"><%=firstLetter%></div>
					<div class="user-info">
						<h4><%=userName.split(" ")[0]%></h4>
						<p>Staff</p>
					</div>
				</div>
			</div>
		</header>

		<div class="content-wrapper">
			<div class="card profile-container">
				<%
				Staff currentStaff = (Staff) request.getAttribute("currentStaff");
				if (currentStaff != null) {
				%>
				<div class="profile-header-card">
					<div class="big-avatar"><%=firstLetter%></div>
					<div>
						<h3><%=currentStaff.getStaffName()%></h3>
						<p style="color: #777; margin-top: 5px;">
							<i class="fas fa-briefcase"></i> Professional Barber
						</p>
					</div>
				</div>

				<form action="StaffSettingServlet" method="POST">
					<input type="hidden" name="staffId"
						value="<%=currentStaff.getStaffId()%>">

					<div class="grid-2">
						<div class="form-group">
							<label>Full Name</label> <input type="text" name="staffName"
								id="profileFullName" class="form-control"
								value="<%=currentStaff.getStaffName()%>" readonly required>
						</div>
						<div class="form-group">
							<label>Username</label> <input type="text" name="staffUsername"
								id="profileUsername" class="form-control"
								value="<%=currentStaff.getStaffUsername()%>" readonly required>
						</div>
					</div>

					<div class="grid-2">
						<div class="form-group">
							<label>Email Address</label> <input type="email"
								name="staffEmail" id="profileEmail" class="form-control"
								value="<%=currentStaff.getStaffEmail()%>" readonly required>
						</div>
						<div class="form-group">
							<label>Phone Number</label> <input type="text"
								name="staffPhoneNum" id="profilePhone" class="form-control"
								value="<%=currentStaff.getStaffPhoneNum()%>" readonly required>
						</div>
					</div>

					<div class="grid-2">
						<div class="form-group">
							<label>Specialty</label> <input type="text" name="staffSpecialty"
								id="profileSpecialty" class="form-control"
								value="<%=currentStaff.getStaffSpecialty() != null ? currentStaff.getStaffSpecialty() : ""%>"
								readonly>
						</div>
						<div class="form-group">
							<label>Experience (Years)</label> <input type="number"
								name="staffExperience" id="profileExperience"
								class="form-control"
								value="<%=currentStaff.getStaffExperience()%>" readonly>
						</div>
					</div>

					<div class="form-group">
						<label>Account Password</label> <input type="password"
							name="staffPassword" id="profilePassword" class="form-control"
							value="<%=currentStaff.getStaffPassword()%>" readonly required>
					</div>

					<div class="btn-container">
						<button type="button" class="btn btn-edit" id="editProfileBtn">
							<i class="fas fa-edit"></i> Edit Profile
						</button>
						<button type="submit" class="btn btn-save" id="saveProfileBtn">
							<i class="fas fa-save"></i> Save Changes
						</button>
					</div>
				</form>
				<%
				} else {
				%>
				<div style="text-align: center; color: #777; padding: 20px;">
					<i class="fas fa-exclamation-triangle fa-2x"
						style="color: var(--warning-color); margin-bottom: 10px;"></i>
					<p>Profile data not found. Please access this page using the
						sidebar navigation menu.</p>
				</div>
				<%
				}
				%>
			</div>

			<div class="toast-notification" id="toast">Profile updated
				successfully!</div>
		</div>
	</main>

	<script>
        const editBtn = document.getElementById('editProfileBtn');
        const saveBtn = document.getElementById('saveProfileBtn');
        const inputs = [
            'profileFullName',
            'profileUsername',
            'profileEmail',
            'profilePhone',
            'profilePassword',
            'profileSpecialty',
            'profileExperience'
        ];

        if (editBtn) {
            editBtn.addEventListener('click', () => {
                inputs.forEach(id => {
                    const el = document.getElementById(id);
                    if (el) el.removeAttribute('readonly');
                });
                editBtn.style.display = 'none';
                saveBtn.style.display = 'inline-flex';
            });
        }

        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('status') === 'success') {
                const toast = document.getElementById('toast');
                if (toast) {
                    toast.style.display = 'block';
                    setTimeout(() => {
                        toast.style.display = 'none';
                        // Bersihkan parameter status dari URL bar secara senyap
                        window.history.replaceState({}, document.title, window.location.pathname);
                    }, 3000);
                }
            }
        });
    </script>
</body>
</html>