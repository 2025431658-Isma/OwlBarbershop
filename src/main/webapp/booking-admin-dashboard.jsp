<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Booking"%>
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard - Bookings Management</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

/* SIDEBAR LIGHT BLUE GRADIENT STYLING */
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

/* Main Workspace Framework Section */
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

/* Filters Component Bar Toolbar */
.filter-bar {
	background-color: white;
	padding: 20px;
	border-radius: var(--border-radius);
	box-shadow: var(--shadow);
	margin-bottom: 30px;
	display: flex;
	gap: 15px;
	flex-wrap: wrap;
	align-items: center;
	border: 1px solid #e9ecef;
}

.filter-group {
	display: flex;
	align-items: center;
	gap: 10px;
}

.filter-group label {
	font-weight: 600;
	font-size: 0.9rem;
	color: #495057;
}

.filter-group select, .filter-group input {
	padding: 8px 12px;
	border: 1px solid #ced4da;
	border-radius: 6px;
	font-size: 0.9rem;
	outline: none;
	transition: var(--transition);
}

.filter-group select:focus, .filter-group input:focus {
	border-color: var(--primary-color);
}

/* Master Relational Grid Layout Data Output Table */
.table-container {
	background-color: white;
	border-radius: var(--border-radius);
	box-shadow: var(--shadow);
	overflow: hidden;
	border: 1px solid #e9ecef;
}

.table-responsive {
	overflow-x: auto;
	width: 100%;
}

table {
	width: 100%;
	border-collapse: collapse;
	text-align: left;
}

th, td {
	padding: 12px 20px;
	border-bottom: 1px solid #e9ecef;
	vertical-align: middle;
	white-space: nowrap;
}

th {
	background-color: #f8f9fa;
	font-weight: 600;
	color: #495057;
	text-transform: uppercase;
	font-size: 0.85rem;
	letter-spacing: 0.5px;
}

tr:hover {
	background-color: #fdfdfd;
}

.cust-name-cell {
	font-weight: 600;
	color: var(--dark-color);
}

/* Status Component Indicators Badge Styles */
.status-badge {
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: 600;
	display: inline-block;
	text-align: center;
	text-transform: uppercase;
}

.status-completed, .status-confirmed {
	background-color: #d1fae5;
	color: #065f46;
}

.status-pending {
	background-color: #fef3c7;
	color: #92400e;
}

.status-cancelled, .status-rejected {
	background-color: #fee2e2;
	color: #991b1b;
}

/* OUTLINED CIRCULAR ICON ACTIONS CELL DESIGN */
.action-buttons-cell {
	display: flex !important;
	gap: 8px !important;
	align-items: center !important;
	justify-content: flex-start !important;
}

.btn-action {
	width: 35px !important;
	height: 35px !important;
	border-radius: 50% !important;
	background-color: #ffffff !important;
	border: 1px solid #cbd5e1 !important;
	display: inline-flex !important;
	align-items: center !important;
	justify-content: center !important;
	cursor: pointer !important;
	text-decoration: none !important;
	font-size: 0.85rem !important;
	transition: all 0.2s ease !important;
	box-sizing: border-box !important;
}

.btn-action.view { color: #3b82f6 !important; }
.btn-action.view:hover { background-color: #3b82f6 !important; color: #ffffff !important; border-color: #3b82f6 !important; }

.btn-action.edit { color: #10b981 !important; }
.btn-action.edit:hover { background-color: #10b981 !important; color: #ffffff !important; border-color: #10b981 !important; }

.btn-action.delete { color: #ef4444 !important; }
.btn-action.delete:hover { background-color: #ef4444 !important; color: #ffffff !important; border-color: #ef4444 !important; }

td:last-child {
	white-space: nowrap !important;
	width: 1% !important; 
}

/* RADIO BUTTON POPUP MODAL STYLING */
.status-modal {
	display: none;
	position: fixed;
	z-index: 2000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0,0,0,0.4);
	justify-content: center;
	align-items: center;
}

.modal-content {
	background-color: #ffffff;
	padding: 25px;
	border-radius: var(--border-radius);
	width: 350px;
	box-shadow: 0 4px 20px rgba(0,0,0,0.15);
	animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
	from { opacity: 0; transform: scale(0.95); }
	to { opacity: 1; transform: scale(1); }
}

.modal-header {
	font-size: 1.2rem;
	font-weight: 700;
	margin-bottom: 15px;
	color: var(--dark-color);
	border-bottom: 1px solid #e2e8f0;
	padding-bottom: 10px;
}

.radio-group {
	margin: 15px 0;
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.radio-option {
	display: flex;
	align-items: center;
	gap: 10px;
	font-weight: 600;
	font-size: 0.95rem;
	color: #475569;
	cursor: pointer;
	padding: 8px;
	border-radius: 6px;
	transition: background-color 0.2s;
}

.radio-option:hover {
	background-color: #f1f5f9;
}

.radio-option input[type="radio"] {
	width: 18px;
	height: 18px;
	accent-color: var(--primary-color);
	cursor: pointer;
}

.modal-actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 20px;
	border-top: 1px solid #e2e8f0;
	padding-top: 15px;
}

.btn-modal {
	padding: 8px 16px;
	border-radius: 6px;
	font-weight: 600;
	font-size: 0.9rem;
	cursor: pointer;
	border: none;
	transition: var(--transition);
}

.btn-modal.cancel {
	background-color: #e2e8f0;
	color: #475569;
}
.btn-modal.cancel:hover { background-color: #cbd5e1; }

.btn-modal.save {
	background-color: var(--primary-color);
	color: #ffffff;
}
.btn-modal.save:hover { background-color: var(--secondary-color); }

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

	<div id="statusModal" class="status-modal">
		<div class="modal-content">
			<div class="modal-header">Update Booking Status</div>
			<input type="hidden" id="modalBookingId">
			
			<div class="radio-group">
				<label class="radio-option">
					<input type="radio" name="bookingStatusRadio" value="CONFIRMED" id="radioConfirmed">
					<span>CONFIRMED</span>
				</label>
				<label class="radio-option">
					<input type="radio" name="bookingStatusRadio" value="CANCELLED" id="radioCancelled">
					<span>CANCELLED</span>
				</label>
				<label class="radio-option">
					<input type="radio" name="bookingStatusRadio" value="PENDING" id="radioPending">
					<span>PENDING</span>
				</label>
			</div>
			
			<div class="modal-actions">
				<button type="button" class="btn-modal cancel" onclick="closeStatusModal()">Cancel</button>
				<button type="button" class="btn-modal save" onclick="saveStatusModal()">Save Status</button>
			</div>
		</div>
	</div>

	<aside class="sidebar" id="sidebar">
		<div class="sidebar-header">
			<h2><i class="fas fa-cut"></i> Owl Barber 
			</h2>
		</div>
		<ul class="sidebar-menu">
			<li><a href="AdminDashboardServlet"><i class="fas fa-users"></i> Dashboard</a></li>
			<li><a href="AdminBookingServlet" class="active"><i class="fas fa-calendar-check"></i> Bookings</a></li>
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
				<h1>Bookings Management</h1>
			</div>

			<div class="filter-bar">
				<div class="filter-group">
					<label for="filterBookingStatus"><i class="fas fa-filter"></i> Status:</label>
					<select id="filterBookingStatus">
						<option value="">All Bookings</option>
						<option value="pending">Pending</option>
						<option value="completed">Completed / Confirmed</option>
						<option value="cancelled">Cancelled</option>
					</select>
				</div>
			</div>

			<div class="table-container">
				<div class="table-responsive">
					<table>
						<thead>
							<tr>
								<th>ID</th>
								<th>Service</th>
								<th>Date &amp; Time</th>
								<th>Customer Name</th>
								<th>Barber Assigned</th>
								<th>Status</th>
								<th>Total Price</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody id="bookingsTableBody">
						<% 
                            @SuppressWarnings("unchecked")
                            List<Booking> allBookings = (List<Booking>) request.getAttribute("allBookings");
							if (allBookings != null && !allBookings.isEmpty()) {
                                for (Booking b : allBookings) {
                                    String rawStatus = (b.getBookingStatus() != null) ? b.getBookingStatus() : "PENDING";
                                    String status = rawStatus.toLowerCase().trim();
                                    String formattedPrice = String.format("%.2f", b.getTotalPrice());
                                    
                                    String currentCustomer = b.getCustomerName() != null ? b.getCustomerName() : "Unknown";
                                    String currentBarber = b.getStaffName() != null ? b.getStaffName() : "No Barber Assigned";
                        %>
						<tr>
							<td>#<%= b.getBookingId() %></td>
							<td><%= b.getServiceType() %></td>
							<td><%= b.getBookingDate() %> @ <%= b.getBookingTime() %></td>
							<td class="cust-name-cell"><%= currentCustomer %></td>
							<td><%= currentBarber %></td>
							<td><span class="status-badge status-<%= status %>">
									<%= rawStatus %>
							</span></td>
							<td>RM <%= formattedPrice %></td>
							<td>
								<div class="action-buttons-cell">
                                    <button class="btn-action view" title="View" onclick="alert('Booking ID: #<%= b.getBookingId() %>\nCustomer: <%= currentCustomer %>\nBarber: <%= currentBarber %>')"> 
                                        <i class="fas fa-eye"></i> 
                                    </button>
                                    
                                    <button class="btn-action edit" title="Update Status" onclick="openStatusModal('<%= b.getBookingId() %>', '<%= rawStatus.toUpperCase().trim() %>')">
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
								No system appointment records found.
							</td>
						</tr>
						<% } %>
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
		document.addEventListener('DOMContentLoaded', function () {
			const menuToggle = document.getElementById('menuToggle');
			if (menuToggle) {
				menuToggle.addEventListener('click', () => {
					document.getElementById('sidebar').classList.toggle('active');
				});
			}

			const filterSelect = document.getElementById("filterBookingStatus");
			const tableBody = document.getElementById("bookingsTableBody");

			if (filterSelect && tableBody) {
				filterSelect.addEventListener("change", function () {
					const selectedStatus = this.value.toLowerCase().trim();
					const rows = tableBody.getElementsByTagName("tr");

					for (let i = 0; i < rows.length; i++) {
						const row = rows[i];
						const statusCell = row.getElementsByTagName("td")[5];
						if (statusCell) {
							const statusText = statusCell.textContent || statusCell.innerText;
							let statusValue = statusText.toLowerCase().trim();
							
							if (statusValue === "confirmed") statusValue = "completed";

							if (selectedStatus === "" || statusValue === selectedStatus) {
								row.style.display = "";
							} else {
								row.style.display = "none";
							}
						}
					}
				});
			}
		});

		// RADIO SELECTION MODAL CONTROLLER SCRIPTS
		function openStatusModal(bookingId, currentStatus) {
			document.getElementById('modalBookingId').value = bookingId;
			
			// Auto-check the radio button corresponding to current status
			if (currentStatus === "CONFIRMED") {
				document.getElementById('radioConfirmed').checked = true;
			} else if (currentStatus === "CANCELLED") {
				document.getElementById('radioCancelled').checked = true;
			} else {
				document.getElementById('radioPending').checked = true;
			}
			
			// Display the modal popup box flex overlay
			document.getElementById('statusModal').style.display = 'flex';
		}

		function closeStatusModal() {
			document.getElementById('statusModal').style.display = 'none';
		}

		function saveStatusModal() {
			const bookingId = document.getElementById('modalBookingId').value;
			const selectedRadio = document.querySelector('input[name="bookingStatusRadio"]:checked');
			
			if (selectedRadio) {
				const targetStatus = selectedRadio.value;
				// Smooth parameters transfer directly to the backend update servlet controller
				window.location.href = "UpdateBookingStatusServlet?bookingId=" + bookingId + "&status=" + targetStatus;
			} else {
				alert("Please select a status option.");
			}
		}

		// Close modal if user clicks anywhere outside of the popup content window box
		window.onclick = function(event) {
			const modal = document.getElementById('statusModal');
			if (event.target === modal) {
				closeStatusModal();
			}
		}
	</script>
</body>
</html>