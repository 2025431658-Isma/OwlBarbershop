<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Service"%>
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

    // Extracting collection records populated by the Servlet context scope
    @SuppressWarnings("unchecked")
    List<Service> servicesList = (List<Service>) request.getAttribute("servicesList");
    Integer totalServicesCount = (Integer) request.getAttribute("totalServices");

    // Fallback security configurations preventing unexpected NullPointerExceptions
    if (servicesList == null) {
        servicesList = new ArrayList<Service>();
    }
    if (totalServicesCount == null) totalServicesCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Service Management - Admin Dashboard</title>
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

/* SIDEBAR LIGHT BLUE GRADIENT STYLE */
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

.btn-actions-container {
	display: flex;
	gap: 10px;
}

.btn-add-new {
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

.btn-add-new:hover {
	background-color: var(--secondary-color);
	box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
}

.btn-refresh {
	background-color: #e2e8f0;
	color: #4a5568;
	padding: 10px 15px;
	border-radius: var(--border-radius);
	border: none;
	cursor: pointer;
	transition: var(--transition);
}

.btn-refresh:hover {
	background-color: #cbd5e1;
}

/* Stats Cards Section */
.stats-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
	gap: 20px;
	margin-bottom: 30px;
}

.stat-card {
	background-color: var(--card-bg);
	padding: 20px 25px;
	border-radius: var(--border-radius);
	box-shadow: var(--shadow);
	display: flex;
	align-items: center;
	justify-content: space-between;
	border: 1px solid var(--border-color);
}

.stat-info h3 {
	font-size: 24px;
	font-weight: 700;
}

.stat-info p {
	color: var(--text-muted);
	font-size: 14px;
}

/* SQUARE CORNER CORRECTION APPLIED HERE */
.stat-icon {
	width: 50px;
	height: 50px;
	border-radius: var(--border-radius); /* Rounded Square layout */
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 22px;
}

.stat-icon.total { background-color: rgba(67, 97, 238, 0.1); color: var(--primary-color); }

/* Table Section Styles */
.user-table-container {
	background-color: white;
	border-radius: var(--border-radius);
	padding: 25px;
	box-shadow: var(--shadow);
	margin-bottom: 40px;
	border: 1px solid var(--border-color);
	overflow-x: auto;
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
	font-size: 14px;
}

th {
	font-weight: 600;
	color: #555;
	text-transform: uppercase;
	font-size: 12px;
	letter-spacing: 0.5px;
}

.action-buttons-cell {
	display: flex;
	gap: 10px;
}

.btn-action {
	width: 35px;
	height: 35px;
	border-radius: var(--border-radius); /* Square matching style */
	display: flex;
	align-items: center;
	justify-content: center;
	border: none;
	cursor: pointer;
	transition: var(--transition);
	text-decoration: none;
}

.btn-action.view { background-color: #e6f3ff; color: #2196f3; }
.btn-action.edit { background-color: #fff4e5; color: #ff9800; }
.btn-action.delete { background-color: #ffe6e6; color: #f44336; }
.btn-action:hover { transform: scale(1.1); }

/* Modal Architecture Setup */
.modal-overlay {
	position: fixed;
	top: 0; left: 0; width: 100%; height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	display: flex; align-items: center; justify-content: center;
	z-index: 2000; opacity: 0; visibility: hidden;
	transition: all 0.3s ease;
}

.modal-overlay.active { opacity: 1; visibility: visible; }

.modal-card {
	background-color: white;
	width: 500px; max-width: 90%;
	border-radius: var(--border-radius);
	padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);
	transform: translateY(-20px);
	transition: all 0.3s ease;
}

.modal-overlay.active .modal-card { transform: translateY(0); }

.modal-header {
	display: flex; justify-content: space-between;
	align-items: center; margin-bottom: 20px;
}

.modal-close {
	background: none; border: none; font-size: 1.2rem; cursor: pointer; color: #aaa;
}

.modal-close:hover { color: #333; }

.form-group { margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 14px; }
.form-control {
	width: 100%; padding: 10px; border: 1px solid #ddd;
	border-radius: 6px; outline: none; font-size: 14px;
}

.modal-footer {
	display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;
}

.btn-secondary {
	background-color: #e0e0e0; color: #333;
	padding: 10px 20px;
	border-radius: 6px; border: none; cursor: pointer; font-weight: 500;
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
			<li><a href="AdminDashboardServlet"><i class="fas fa-users"></i> Dashboard</a></li>
			<li><a href="AdminBookingServlet"><i class="fas fa-calendar-check"></i> Bookings</a></li>
			<li><a href="BarberAdminServlet"><i class="fas fa-user-tie"></i> Barbers</a></li>
			<li><a href="AdminServiceServlet" class="active"><i class="fas fa-scissors"></i> Services</a></li>
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
				<div class="search-box">
					<i class="fas fa-search"></i>
					<input type="text" id="searchService" placeholder="Search catalog services...">
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

		<div class="content-wrapper">
			<div class="page-title">
				<h1>Service Management</h1>
				<div class="btn-actions-container">
					<button class="btn-refresh" id="refreshBtn" title="Re-sync catalog data"><i class="fas fa-sync-alt"></i></button>
					<button class="btn-add-new" id="addServiceBtn"><i class="fas fa-plus"></i> Add New Service</button>
				</div>
			</div>

			<%
				String msg = request.getParameter("msg");
				if (msg != null && !msg.trim().isEmpty()) {
			%>
				<div style="background-color: #e6fdf4; color: #10b981; border: 1px solid #10b981; padding: 15px; margin-bottom: 30px; border-radius: var(--border-radius); font-weight: 600;">
					<i class="fas fa-check-circle"></i> <%= msg %>
				</div>
			<%
				}
			%>

			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-info">
						<h3><%= totalServicesCount %></h3>
						<p>Total Registered Services</p>
					</div>
					<div class="stat-icon total"><i class="fas fa-layer-group"></i></div>
				</div>
			</div>

			<div class="user-table-container">
				<table>
					<thead>
						<tr>
							<th>Service Id</th>
							<th>Service Name</th>
							<th>Description</th>
							<th>Price</th>
							<th>Duration (Mins)</th>
							<th>Assigned Staff ID</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody id="servicesTableBody">
						<% 
							if (!servicesList.isEmpty()) {
								for (Service s : servicesList) {
									String formattedPrice = String.format("%.2f", s.getServicePrice());
									String cleanDescription = s.getServiceDesc() != null ? s.getServiceDesc().replace("'", "\\'") : "";
									String cleanName = s.getServiceName() != null ? s.getServiceName().replace("'", "\\'") : "";
									int assignedStaff = s.getStaffId();
						%>
						<tr>
							<td>#<%= s.getServiceId() %></td>
							<td class="service-name-cell" style="font-weight: 600;"><%= s.getServiceName() %></td>
							<td><%= s.getServiceDesc() != null ? s.getServiceDesc() : "No details provided" %></td>
							<td style="font-weight: 600; color: var(--primary-color);">RM <%= formattedPrice %></td>
							<td><%= s.getServiceDuration() %> Mins</td>
							<td>
								<%= (assignedStaff > 0) ? assignedStaff : "<span style='color: #ef4444; font-weight: 600;'>Unassigned</span>" %>
							</td>
							<td>
								<div class="action-buttons-cell">
									<button class="btn-action view" title="View Detail View" 
											onclick="alert('Service ID: <%= s.getServiceId() %>\nName: <%= cleanName %>\nPrice: RM <%= formattedPrice %>\nDuration: <%= s.getServiceDuration() %> mins\nAssigned Staff: <%= (assignedStaff > 0) ? "Staff" + assignedStaff : "None" %>')">
										<i class="fas fa-eye"></i>
									</button>
									<button class="btn-action edit" title="Edit Catalog Entry" 
											onclick="openEditServiceModal('<%= s.getServiceId() %>', '<%= cleanName %>', '<%= cleanDescription %>', '<%= s.getServicePrice() %>', '<%= s.getServiceDuration() %>', '<%= assignedStaff %>')">
										<i class="fas fa-edit"></i>
									</button>
									<a href="DeleteServiceController?id=<%= s.getServiceId() %>" class="btn-action delete" title="Purge Record" 
									   onclick="return confirm('Are you sure you want to permanently delete service entry #<%= s.getServiceId() %>?');"
									   style="text-align:center; line-height:35px;">
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
							<td colspan="7" style="text-align: center; padding: 30px; color: #777;">
								No services catalog configuration found in database ledger.
							</td>
						</tr>
						<% } %>
					</tbody>
				</table>
			</div>

			<footer>
				<p>Admin Dashboard &copy; 2026. All rights reserved.</p>
			</footer>
		</div>
	</main>

	<div class="modal-overlay" id="serviceModal">
		<div class="modal-card">
			<div class="modal-header">
				<h2 id="modalTitle">Add New Service</h2>
				<button class="modal-close" id="closeModal">&times;</button>
			</div>
			<form id="serviceForm" action="AddServiceController" method="POST">
				<input type="hidden" id="serviceId" name="serviceId">
				
				<div class="form-group">
					<label for="serviceName">Service Name</label>
					<input type="text" id="serviceName" name="serviceName" class="form-control" required placeholder="e.g. Premium Haircut & Wash">
				</div>
				<div class="form-group">
					<label for="serviceDesc">Service Description</label>
					<input type="text" id="serviceDesc" name="serviceDesc" class="form-control" placeholder="Brief outline of specific features included">
				</div>
				<div class="form-group">
					<label for="servicePrice">Price (RM)</label>
					<input type="number" id="servicePrice" name="servicePrice" step="0.01" class="form-control" required placeholder="0.00">
				</div>
				<div class="form-group">
					<label for="serviceDuration">Duration (Minutes)</label>
					<input type="number" id="serviceDuration" name="serviceDuration" class="form-control" required placeholder="e.g. 30">
				</div>
				<div class="form-group">
					<label for="staffId">Assign Staff ID</label>
					<input type="number" id="staffId" name="staffId" class="form-control" placeholder="Enter Staff ID (Optional)">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn-secondary" id="cancelBtn">Cancel Action</button>
					<button type="submit" class="btn-add-new" id="submitModalBtn">Commit Changes</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		// Modal Interceptor Routing Utilities
		function openAddServiceModal() {
			const form = document.getElementById('serviceForm');
			if (form) {
				form.action = 'AddServiceController';
				document.getElementById('serviceId').value = '';
				document.getElementById('serviceName').value = '';
				document.getElementById('serviceDesc').value = '';
				document.getElementById('servicePrice').value = '';
				document.getElementById('serviceDuration').value = '';
				document.getElementById('staffId').value = '';
				document.getElementById('modalTitle').innerText = 'Add New Catalog Service';
				document.getElementById('submitModalBtn').innerText = 'Save Service';
				document.getElementById('serviceModal').classList.add('active');
			}
		}

		function openEditServiceModal(id, name, desc, price, duration, staffId) {
			const form = document.getElementById('serviceForm');
			if (form) {
				form.action = 'UpdateServiceController';
				document.getElementById('serviceId').value = id;
				document.getElementById('serviceName').value = name;
				document.getElementById('serviceDesc').value = desc;
				document.getElementById('servicePrice').value = price;
				document.getElementById('serviceDuration').value = duration;
				document.getElementById('staffId').value = (staffId && staffId !== '0') ? staffId : '';
				document.getElementById('modalTitle').innerText = 'Update Catalog Service #' + id;
				document.getElementById('submitModalBtn').innerText = 'Apply Updates';
				document.getElementById('serviceModal').classList.add('active');
			}
		}

		function closeServiceModal() {
			const modal = document.getElementById('serviceModal');
			if (modal) modal.classList.remove('active');
		}

		function initServiceDashboard() {
			// Sidebar Toggle Engine
			const menuToggle = document.getElementById('menuToggle');
			if (menuToggle) {
				menuToggle.addEventListener('click', () => {
					document.getElementById('sidebar').classList.toggle('active');
				});
			}
			
			// Dynamic client-side live structural search box configuration filtering values matching strings
			const searchInput = document.getElementById("searchService");
			if (searchInput) {
				searchInput.addEventListener("keyup", function () {
					const filterValue = this.value.toLowerCase().trim();
					const rows = document.querySelectorAll("#servicesTableBody tr");

					rows.forEach(row => {
						const nameCell = row.querySelector(".service-name-cell");
						if (nameCell) {
							const nameText = nameCell.textContent.toLowerCase();
							row.style.display = nameText.includes(filterValue) ? "" : "none";
						}
					});
				});
			}

			const addServiceBtn = document.getElementById('addServiceBtn');
			if (addServiceBtn) addServiceBtn.addEventListener('click', openAddServiceModal);
			
			const refreshBtn = document.getElementById('refreshBtn');
			if (refreshBtn) {
				refreshBtn.addEventListener('click', () => {
					window.location.href = "AdminServiceServlet";
				});
			}
			
			const closeModalBtn = document.getElementById('closeModal');
			const cancelBtn = document.getElementById('cancelBtn');
			if (closeModalBtn) closeModalBtn.addEventListener('click', closeServiceModal);
			if (cancelBtn) cancelBtn.addEventListener('click', closeServiceModal);
			
			const serviceModal = document.getElementById('serviceModal');
			if (serviceModal) {
				serviceModal.addEventListener('click', function(e) {
					if (e.target === serviceModal) closeServiceModal();
				});
			}
		}
		
		document.addEventListener('DOMContentLoaded', initServiceDashboard);
	</script>
</body>
</html>