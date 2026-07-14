<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - Owl Barbershop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-color: #2c3e50; --secondary-color: #764ba2; --success-color: #2ecc71;
            --warning-color: #f39c12; --danger-color: #e74c3c; --gray-color: #95a5a6;
            --light-gray: #f8f9fa; --border-radius: 8px; --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        body { font-family: 'Roboto', sans-serif; line-height: 1.6; color: #333; background-color: #fff; }
        h1, h2, h3, h4 { font-family: 'Poppins', sans-serif; font-weight: 600; }
        .container { width: 100%; max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .btn { display: inline-block; padding: 10px 20px; border-radius: var(--border-radius); text-decoration: none; font-weight: 500; cursor: pointer; border: none; transition: var(--transition); font-size: 16px; text-align: center; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { opacity: 0.9; transform: translateY(-2px); }
        
        .navbar { background-color: white; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); position: sticky; top: 0; z-index: 1000; padding: 15px 0; }
        .navbar .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { display: flex; align-items: center; text-decoration: none; color: var(--primary-color); font-size: 24px; font-weight: 700; }
        .logo i { margin-right: 10px; font-size: 28px; color: var(--secondary-color); }
        .nav-links {
		    display: flex;
		    align-items: center;
		    gap: 25px; /* Keeps the links neatly grouped together alongside the dropdown */
		}
        .nav-links a { text-decoration: none; color: var(--primary-color); font-weight: 500; padding: 8px 12px; border-radius: var(--border-radius); transition: var(--transition); }
        .nav-links a:hover, .nav-links a.active { color: var(--secondary-color); background-color: rgba(118, 75, 162, 0.1); }
        .user-btn { display: flex; align-items: center; gap: 8px; background: none; border: none; padding: 8px 15px; border-radius: var(--border-radius); cursor: pointer; font-weight: 500; color: var(--primary-color); }
        
        .page-header { padding: 60px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-align: center; }
        .page-header h1 { font-size: 48px; margin-bottom: 15px; color: white; }
        .dashboard-section { padding: 60px 0; background-color: var(--light-gray); min-height: 70vh; }
        .dashboard-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .stat-card { background-color: white; border-radius: var(--border-radius); padding: 25px; box-shadow: var(--box-shadow); text-align: center; }
        .stat-number { font-size: 32px; font-weight: 700; margin-bottom: 10px; color: #764ba2; }
        
        .bookings-container { background-color: white; border-radius: var(--border-radius); box-shadow: var(--box-shadow); overflow: hidden; margin-bottom: 40px; }
        .table-header { padding: 25px 30px; border-bottom: 1px solid #eee; }
        .bookings-table { width: 100%; border-collapse: collapse; }
        .bookings-table th { background-color: #f8f9fa; padding: 15px 20px; text-align: left; font-weight: 600; border-bottom: 2px solid #eee; }
        .bookings-table td { padding: 15px 20px; border-bottom: 1px solid #eee; }
        
        .row-cancelled { background-color: #fdf2f2; color: #7f8c8d; }
        .row-cancelled td strong, .row-cancelled td span { color: #95a5a6; }
        .row-cancelled .text-decoration-target { text-decoration: line-through; }

        .badge { display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        
        /* FIXED CSS SUPPORT FOR ALL CONFIRMED STATES */
        .badge-Confirmed, .badge-Confirmed_Cash { background-color: rgba(46, 204, 113, 0.1); color: var(--success-color); }
        .badge-Pending { background-color: rgba(243, 156, 18, 0.1); color: var(--warning-color); }
        .badge-Cancelled { background-color: rgba(231, 76, 60, 0.2); color: var(--danger-color); }
        
        .action-buttons { display: flex; gap: 6px; align-items: center; }
        .btn-icon { width: 32px; height: 32px; border-radius: var(--border-radius); display: flex; align-items: center; justify-content: center; border: none; cursor: pointer; font-size: 14px; transition: var(--transition); }
        .btn-view { background-color: rgba(118, 75, 162, 0.1); color: var(--secondary-color); }
        .btn-edit-action { background-color: rgba(243, 156, 18, 0.1); color: var(--warning-color); }
        .btn-cancel { background-color: rgba(231, 76, 60, 0.1); color: var(--danger-color); }
        .btn-icon:hover { transform: scale(1.1); }
        .btn-icon:disabled { background-color: #e0e0e0; color: #a0a0a0; cursor: not-allowed; transform: none; }
        
        /* Direct Action Button Styling */
        .btn-pay-now { background-color: var(--success-color); color: white; border: none; padding: 6px 12px; border-radius: var(--border-radius); font-weight: 600; cursor: pointer; font-size: 12px; transition: var(--transition); }
        .btn-pay-now:hover { opacity: 0.9; }
        .btn-pay-cash { background-color: #3498db; color: white; border: none; padding: 6px 12px; border-radius: var(--border-radius); font-weight: 600; cursor: pointer; font-size: 12px; transition: var(--transition); }
        .btn-pay-cash:hover { opacity: 0.9; }
        
        /* Countdown styling badge metrics elements */
        .timer-badge { display: block; margin-top: 4px; font-size: 11px; color: var(--danger-color); font-weight: 700; background: rgba(231, 76, 60, 0.1); padding: 2px 6px; border-radius: 4px; text-align: center; }
        
        .no-bookings { text-align: center; padding: 60px 20px; color: var(--gray-color); }
        .footer { background-color: #1a252f; color: white; padding: 40px 0 20px; text-align: center; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 2000; }
        .modal-content { background-color: white; margin: 100px auto; width: 90%; max-width: 550px; border-radius: var(--border-radius); box-shadow: var(--box-shadow); overflow: hidden; animation: fadeIn 0.3s ease; }
        .modal-header { padding: 20px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; background: #2c3e50; color: white; }
        .modal-body { padding: 25px; line-height: 1.8; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 8px; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: var(--border-radius); font-size: 15px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

        /* ===== RESTORED USER DROPDOWN ACTION MECHANICS ===== */
        .user-menu {
            position: relative;
            display: inline-block;
        }
        .user-dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;             /* RESTORED: Align with the left edge of the profile trigger */
            right: auto;          /* RESTORED: Reset right snapping alignment constraint */
            background-color: white;
            min-width: 220px;    
            box-shadow: var(--box-shadow);
            border-radius: var(--border-radius);
            padding: 10px 0;
            z-index: 1000;
        }
        .user-dropdown:hover .dropdown-content {
            display: block !important;
        }
        .dropdown-content a {
            display: block;
            padding: 10px 20px;
            text-decoration: none;
            color: var(--primary-color);
            transition: var(--transition);
            text-align: left;
            font-size: 14px;
        }
        .dropdown-content a:hover {
            background-color: rgba(118, 75, 162, 0.1);
            color: var(--secondary-color);
        }
        .dropdown-content .divider {
            height: 1px;
            background-color: #eee;
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="container">
            <a href="index.jsp" class="logo"><i class="fas fa-cut"></i> <span>Owl Barbershop</span></a>
            <div class="nav-links">
                <a href="index.jsp">Home</a> 
                <a href="bookings.jsp">Book Now</a>
                <a href="${pageContext.request.contextPath}/MyBookingsServlet" class="active">My Bookings</a>

                <c:choose>
                    <c:when test="${empty sessionScope.username}">
                        <div class="auth-buttons" id="authButtons">
                            <a href="login.jsp" class="btn btn-outline"><i class="fas fa-sign-in-alt"></i> Login</a> 
                            <a href="register.jsp" class="btn btn-primary"><i class="fas fa-user-plus"></i> Register</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="user-menu" id="userMenu" style="display: block;">
                            <div class="user-dropdown">
                                <button class="user-btn" type="button">
                                    <i class="fas fa-user-circle"></i> 
                                    <span id="userName"><c:out value="${sessionScope.fullName}" /></span> 
                                    <i class="fas fa-chevron-down" style="font-size: 12px; margin-left: 3px;"></i>
                                </button>
                                <div class="dropdown-content">
                                    <a href="index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>

                                    <c:if test="${not empty sessionScope.userRole}">
                                        <c:choose>
                                            <c:when test="${sessionScope.userRole eq 'admin'}">
                                                <div id="adminLinks">
                                                    <div class="divider"></div>
                                                    <a href="admin-dashboard.jsp"><i class="fas fa-cog"></i> Admin Panel</a> 
                                                    <a href="admin-dashboard.jsp"><i class="fas fa-chart-bar"></i> Reports</a> 
                                                    <a href="admin-dashboard.jsp"><i class="fas fa-users-cog"></i> User Management</a>
                                                </div>
                                            </c:when>
                                            <c:when test="${sessionScope.userRole eq 'staff'}">
                                                <div id="staffLinks">
                                                    <div class="divider"></div>
                                                    <a href="booking-staff-dashboard.jsp"><i class="fas fa-calendar-day"></i> Schedule</a> 
                                                    <a href="booking-staff-dashboard.jsp"><i class="fas fa-users"></i> Customers</a>
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </c:if>

                                    <div class="divider"></div>
                                    <a href="${pageContext.request.contextPath}/LogoutServlet"
                                       class="btn-logout"
                                       style="color: #e74c3c; padding: 10px 20px; display: block; text-decoration: none;">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

	<section class="page-header">
        <div class="container">
            <h1>My Bookings</h1>
            <p>Manage and settle payments for your appointments in real time</p>
        </div>
    </section>

    <section class="dashboard-section">
        <div class="container">
            <div class="dashboard-header">
                <h2>Booking History</h2>
                <a href="bookings.jsp" class="btn btn-primary"><i class="fas fa-calendar-plus"></i> Book New Appointment</a>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><c:out value="${not empty statTotal ? statTotal : 0}"/></div>
                    <div>Total Bookings</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><c:out value="${not empty statUpcoming ? statUpcoming : 0}"/></div>
                    <div>Confirmed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><c:out value="${not empty statPending ? statPending : 0}"/></div>
                    <div>Pending Hold</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><c:out value="${not empty statCancelled ? statCancelled : 0}"/></div>
                    <div>Cancelled</div>
                </div>
            </div>

            <div class="bookings-container">
                <div class="table-header"><h3>Your Appointments</h3></div>
                
                <c:choose>
                    <c:when test="${empty bookings}">
                        <div class="no-bookings">
                            <i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 20px;"></i>
                            <h3>No Bookings Found</h3>
                            <p>You don't have any appointments listed under this account profile.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="bookings-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Service</th>
                                    <th>Date & Time</th>
                                    <th>Barber</th>
                                    <th>Status</th>
                                    <th>Amount</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <tr class="${b.status eq 'Cancelled' ? 'row-cancelled' : ''}">
                                        <td><strong>#${b.id}</strong></td>
                                        <td class="text-decoration-target"><c:out value="${b.serviceName}"/></td>
                                        <td>
                                            <div class="text-decoration-target"><c:out value="${b.date}"/></div>
                                            <small><c:out value="${b.time}"/></small>
                                        </td>
                                        <td><c:out value="${b.barberName}"/></td>
                                        <td>
                                            <c:set var="statusClass" value="${b.status.replace(' ', '_').replace('(', '').replace(')', '')}" />
                                            <span class="badge badge-${statusClass}"><c:out value="${b.status}"/></span>
                                            
                                            <c:if test="${b.status eq 'Pending' && b.millisLeft > 0}">
                                                <span class="timer-badge" id="timer_${b.id}" data-ms="${b.millisLeft}">Hold: Calculating...</span>
                                            </c:if>
                                        </td>
                                        <td><strong>RM <fmt:formatNumber value="${b.price}" pattern="0.00"/></strong></td>
                                        <td>
                                            <div class="action-buttons">
                                                <c:if test="${b.status eq 'Pending'}">
                                                    <button class="btn-pay-now" onclick="processPaymentGateway('${b.id}', 'PAY_CARD', '${b.price}', '<c:out value="${b.serviceName}"/>')" title="Pay securely with Online Card Engine"><i class="fas fa-credit-card"></i> Card</button>
                                               
                                                </c:if>

                                                <button class="btn-icon btn-view" onclick="openDetails('${b.id}', '${b.serviceName}', '${b.date}', '${b.time}', '${b.barberName}', '${b.status}', '${b.price}', '${b.duration}')" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                
                                                <button class="btn-icon btn-edit-action" 
                                                        onclick="openEditModal('${b.id}', '${b.date}', '${b.time}', '${b.barberId}')" 
                                                        title="Reschedule Appointment"
                                                        <c:if test="${b.status eq 'Cancelled'}">disabled</c:if>>
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                
                                                <button class="btn-icon btn-cancel" 
                                                        onclick="executeCancellationPipeline('${b.id}')" 
                                                        title="Cancel Booking"
                                                        <c:if test="${b.status eq 'Cancelled'}">disabled</c:if>>
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <div id="detailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Appointment Details</h3>
                <span style="cursor:pointer; font-size:24px;" onclick="closeDetails()">&times;</span>
            </div>
            <div class="modal-body" id="modalText"></div>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Reschedule Appointment</h3>
                <span style="cursor:pointer; font-size:24px;" onclick="closeEditModal()">&times;</span>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editBookingId">
                <input type="hidden" id="editBarberId">
                <div class="form-group">
                    <label for="editDate">Choose New Date:</label>
                    <input type="date" id="editDate" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="editTime">Choose New Time Slot:</label>
                    <select id="editTime" class="form-control" required>
                        <option value="10:00">10:00 AM</option>
                        <option value="10:30">10:30 AM</option>
                        <option value="11:00">11:00 AM</option>
                        <option value="11:30">11:30 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="12:30">12:30 PM</option>
                        <option value="13:00">13:00 PM</option>
                        <option value="13:30">13:30 PM</option>
                        <option value="14:00">14:00 PM</option>
                        <option value="15:00">15:00 PM</option>
                        <option value="15:30">15:30 PM</option>
                        <option value="16:00">16:00 PM</option>
                        <option value="16:30">16:30 PM</option>
                        <option value="17:00">17:00 PM</option>
                        <option value="17:30">17:30 PM</option>
                        <option value="18:00">18:00 PM</option>
                        <option value="18:30">18:30 PM</option>
                        <option value="19:00">19:00 PM</option>
                        <option value="19:30">19:30 PM</option>
                        <option value="20:00">20:00 PM</option>
                    </select>
                </div>
                <button class="btn btn-primary" style="width:100%; margin-top:10px;" onclick="executeEditPipeline()">Save Changes</button>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Owl Barbershop System. All Rights Reserved.</p>
    </footer>

    <script>
        // LIVE TICKING REFRESH RUNTIME ENGINE
        document.addEventListener("DOMContentLoaded", function() {
            let timers = document.querySelectorAll("[id^='timer_']");
            timers.forEach(function(timer) {
                let msLeft = parseInt(timer.getAttribute("data-ms"));
                
                let interval = setInterval(function() {
                    if (msLeft <= 0) {
                        timer.innerText = "Hold Expired";
                        clearInterval(interval);
                        window.location.reload();
                        return;
                    }
                    
                    msLeft -= 1000;
                    let totalSeconds = Math.floor(msLeft / 1000);
                    let minutes = Math.floor(totalSeconds / 60);
                    let seconds = totalSeconds % 60;
                    
                    timer.innerText = "Expiring in: " + minutes + "m " + (seconds < 10 ? "0" : "") + seconds + "s";
                }, 1000);
            });
        });

        // RECONFIGURED PAYMENT LOGIC ENGINE
        function processPaymentGateway(id, paymentMethodAction, price, serviceName) {
            let confirmationMsg = "Confirm processing online credit/debit transaction statement balance payment row now?";
                
            if(!confirm(confirmationMsg)) return;

            if (paymentMethodAction === 'PAY_CARD') {
                // Populate session data to safely preserve data context on target views
                sessionStorage.setItem("payment_booking_id", id);
                sessionStorage.setItem("payment_amount", price);
                sessionStorage.setItem("payment_service_name", serviceName);

                // Safely route execution trace directly into checkout window layout
                window.location.href = "${pageContext.request.contextPath}/payment.jsp";
            }
        }

        function openDetails(id, service, date, time, barber, status, price, duration) {
            document.getElementById('modalText').innerHTML = 
                "<p><strong>Booking ID:</strong> #" + id + "</p>" +
                "<p><strong>Grooming Package:</strong> " + service + "</p>" +
                "<p><strong>Duration Estimation:</strong> " + duration + "</p>" +
                "<p><strong>Assigned Staff:</strong> " + barber + "</p>" +
                "<p><strong>Scheduled Date:</strong> " + date + "</p>" +
                "<p><strong>Scheduled Time:</strong> " + time + "</p>" +
                "<p><strong>Payment Statement:</strong> RM " + parseFloat(price).toFixed(2) + "</p>" +
                "<p><strong>Tracking Status:</strong> " + status + "</p>";
            document.getElementById('detailsModal').style.display = 'block';
        }
        
        function closeDetails() { document.getElementById('detailsModal').style.display = 'none'; }

        function openEditModal(id, currentDate, currentTime, barberId) {
            document.getElementById('editBookingId').value = id;
            document.getElementById('editBarberId').value = barberId;
            document.getElementById('editDate').value = currentDate;
            document.getElementById('editTime').value = currentTime;
            let today = new Date().toISOString().split('T')[0];
            document.getElementById('editDate').setAttribute('min', today);
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() { document.getElementById('editModal').style.display = 'none'; }

        function executeEditPipeline() {
            let id = document.getElementById('editBookingId').value;
            let date = document.getElementById('editDate').value;
            let time = document.getElementById('editTime').value;
            let barberId = document.getElementById('editBarberId').value;

            if(!date || !time) {
                alert("⚠️ Please specify target date and operational time selections.");
                return;
            }

            let params = new URLSearchParams();
            params.append("action", "UPDATE");
            params.append("bookingId", id);
            params.append("bookingDate", date);
            params.append("bookingTime", time);
            params.append("barberId", barberId);

            fetch("${pageContext.request.contextPath}/ManageBookingServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    alert("✅ Appointment successfully rescheduled!");
                    window.location.reload();
                } else {
                    alert("❌ Reschedule Denied: " + data.message);
                }
            })
            .catch(err => alert("Communication interface trace break exception path."));
        }

        function executeCancellationPipeline(id) {
            if(!confirm("⚠️ Are you sure you want to cancel appointment #" + id + "? (Requires a 24-hour lead threshold time)")) {
                return;
            }

            let params = new URLSearchParams();
            params.append("action", "CANCEL");
            params.append("bookingId", id);

            fetch("${pageContext.request.contextPath}/ManageBookingServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    alert("✅ Booking canceled successfully.");
                    window.location.reload();
                } else {
                    alert("❌ Cancellation Error: " + data.message);
                }
            })
            .catch(err => alert("Communication interface trace failure path."));
        }
    </script>
</body>
</html>