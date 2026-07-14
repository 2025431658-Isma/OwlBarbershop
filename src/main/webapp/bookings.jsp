<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Owl Barbershop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db; --accent-color: #e74c3c;
            --light-color: #ecf0f1; --dark-color: #2c3e50; --success-color: #2ecc71;
            --warning-color: #f39c12; --danger-color: #e74c3c; --gray-color: #95a5a6;
            --light-gray: #f8f9fa; --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        body { font-family: 'Roboto', sans-serif; line-height: 1.6; color: #333; background-color: #fff; }
        h1, h2, h3, h4, h5 { font-family: 'Poppins', sans-serif; font-weight: 600; line-height: 1.3; }
        .container { width: 100%; max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .btn { display: inline-block; padding: 10px 20px; border-radius: var(--border-radius); text-decoration: none; font-weight: 500; cursor: pointer; border: none; transition: var(--transition); font-size: 16px; text-align: center; }
        .btn-primary { background-color: var(--secondary-color); color: white; }
        .btn-primary:hover { background-color: #2980b9; transform: translateY(-2px); }
        .btn-outline { background-color: transparent; border: 2px solid var(--secondary-color); color: var(--secondary-color); }
        .btn-outline:hover { background-color: var(--secondary-color); color: white; transform: translateY(-2px); }
        .btn-success { background-color: var(--success-color); color: white; }
        
        .gateway-box { border: 2px solid #eee; border-radius: var(--border-radius); padding: 20px; cursor: pointer; transition: var(--transition); text-align: center; background: white; flex: 1; }
        .gateway-box:hover { border-color: var(--secondary-color); transform: translateY(-2px); }
        .gateway-box i { font-size: 32px; margin-bottom: 10px; color: var(--gray-color); }
        
        .navbar { background-color: white; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); position: sticky; top: 0; z-index: 1000; padding: 15px 0; }
        .navbar .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { display: flex; align-items: center; text-decoration: none; color: var(--primary-color); font-size: 24px; font-weight: 700; }
        .logo i { margin-right: 10px; font-size: 28px; color: var(--secondary-color); }
        .nav-links { display: flex; align-items: center; gap: 25px; }
        .nav-links a { text-decoration: none; color: var(--dark-color); font-weight: 500; padding: 8px 12px; border-radius: var(--border-radius); transition: var(--transition); }
        .nav-links a:hover, .nav-links a.active { color: var(--secondary-color); background-color: rgba(52, 152, 219, 0.1); }
        
        /* ===== DROPDOWN ORIGINAL ALIGNMENT STYLES ===== */
        .user-menu {
            position: relative;
            display: inline-block;
        }
        .user-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            background: none;
            border: none;
            padding: 8px 15px;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 500;
            color: var(--dark-color);
            transition: var(--transition);
            font-size: 16px;
            font-family: 'Roboto', sans-serif;
        }
        .user-btn:hover {
            background-color: rgba(0, 0, 0, 0.05);
            color: var(--secondary-color);
        }
        .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            right: auto;
            background-color: white;
            min-width: 200px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: var(--border-radius);
            padding: 10px 0;
            z-index: 1000;
        }
        .user-menu:hover .dropdown-content {
            display: block;
        }
        .dropdown-content a {
            display: block;
            padding: 10px 20px;
            text-decoration: none;
            color: var(--dark-color);
            transition: var(--transition);
            text-align: left;
            font-size: 14px;
        }
        .dropdown-content a:hover {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--secondary-color);
        }
        .dropdown-content .divider {
            height: 1px;
            background-color: #eee;
            margin: 8px 0;
        }
        .btn-logout {
            color: #e74c3c !important;
        }
        .btn-logout:hover {
            background-color: rgba(231, 76, 60, 0.1) !important;
        }

        .page-header { padding: 60px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-align: center; }
        .page-header h1 { font-size: 48px; margin-bottom: 15px; color: white; }
        .booking-container { padding: 60px 0; background-color: var(--light-gray); min-height: calc(100vh - 300px); }
        .booking-wrapper { display: grid; grid-template-columns: 1fr 400px; gap: 40px; }
        .booking-steps { margin-bottom: 40px; }
        .steps-indicator { display: flex; justify-content: space-between; position: relative; margin-bottom: 50px; }
        .steps-indicator::before { content: ''; position: absolute; top: 20px; left: 0; right: 0; height: 2px; background-color: #e0e0e0; z-index: 1; }
        .step { position: relative; z-index: 2; text-align: center; flex: 1; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; background-color: #e0e0e0; color: white; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px; font-weight: 700; }
        .step.active .step-circle { background-color: var(--secondary-color); transform: scale(1.1); }
        .step.completed .step-circle { background-color: var(--success-color); }
        .step-label { font-size: 14px; color: var(--gray-color); font-weight: 500; }
        .step.active .step-label { color: var(--secondary-color); font-weight: 600; }
        .step-content { display: none; background-color: white; border-radius: var(--border-radius); padding: 40px; box-shadow: var(--box-shadow); }
        .step-content.active { display: block; }
        .services-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .service-option { border: 2px solid #eee; border-radius: var(--border-radius); padding: 25px; cursor: pointer; transition: var(--transition); background-color: white; position: relative; }
        .service-option.selected { border-color: var(--secondary-color); background-color: rgba(52, 152, 219, 0.05); }
        .service-option .select-indicator { position: absolute; top: 15px; right: 15px; color: var(--gray-color); font-size: 18px; }
        .service-option.selected .select-indicator { color: var(--secondary-color); }
        .service-details { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; }
        .service-price { font-size: 24px; font-weight: 700; color: var(--secondary-color); }
        .time-slots-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 10px; margin-top: 20px; }
        .time-slot { padding: 15px 10px; border: 2px solid #eee; border-radius: var(--border-radius); text-align: center; cursor: pointer; background-color: white; font-weight: 500; }
        .time-slot.selected { background-color: var(--secondary-color); color: white; border-color: var(--secondary-color); }
        .time-slot.booked-slot { background-color: #fce4e4; color: #c0392b; border-color: #f9cbd0; opacity: 0.6; cursor: not-allowed; text-decoration: line-through; }
        .staff-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .staff-option { border: 2px solid #eee; border-radius: var(--border-radius); padding: 20px; cursor: pointer; text-align: center; background-color: white; }
        .staff-option.selected { border-color: #764ba2 !important; background-color: rgba(118, 75, 162, 0.08) !important; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .booking-summary { position: sticky; top: 100px; background-color: white; border-radius: var(--border-radius); padding: 30px; box-shadow: var(--box-shadow); }
        .summary-header { text-align: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #f8f9fa; }
        .summary-item:last-child { border-bottom: none; font-weight: 700; font-size: 18px; border-top: 2px solid #eee; padding-top: 20px; }
        .summary-value { text-align: right; max-width: 60%; word-wrap: break-word; }
        .form-group { margin-bottom: 25px; }
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: var(--border-radius); font-size: 16px; }
        .booking-navigation { display: flex; justify-content: space-between; margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; }
        .confirmation-details { background-color: #f8f9fa; border-radius: var(--border-radius); padding: 30px; margin-bottom: 30px; }
        .detail-row { display: flex; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .detail-label { width: 150px; color: var(--gray-color); }
        .detail-value { flex: 1; font-weight: 500; }
        .footer { background-color: #1a252f; color: white; padding: 40px 0 20px; text-align: center; }
        .alert { padding: 15px 20px; border-radius: var(--border-radius); margin-bottom: 25px; display: none; background-color: #e74c3c; color: white; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="container">
            <a href="index.jsp" class="logo"><i class="fas fa-cut"></i> <span>Owl Barbershop</span></a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="bookings.jsp" class="active">Book Now</a>
                <a href="${pageContext.request.contextPath}/MyBookingsServlet">My Bookings</a>
                
                <!-- Dynamic Hover Dropdown Set at Original Position Layout -->
                <div class="user-menu">
                    <button class="user-btn">
                        <i class="fas fa-user-circle"></i> 
                        <c:out value="${not empty sessionScope.fullName ? sessionScope.fullName : 'Guest'}"/>
                        <i class="fas fa-chevron-down" style="font-size: 12px; margin-left: 3px;"></i>
                    </button>
                    <div class="dropdown-content">
                        <a href="index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                        
                        <c:if test="${not empty sessionScope.userRole}">
                            <c:choose>
                                <c:when test="${sessionScope.userRole eq 'admin'}">
                                    <div class="divider"></div>
                                    <a href="admin-dashboard.jsp"><i class="fas fa-cog"></i> Admin Panel</a> 
                                    <a href="admin-dashboard.jsp"><i class="fas fa-chart-bar"></i> Reports</a> 
                                    <a href="admin-dashboard.jsp"><i class="fas fa-users-cog"></i> User Management</a>
                                </c:when>
                                <c:when test="${sessionScope.userRole eq 'staff'}">
                                    <div class="divider"></div>
                                    <a href="booking-staff-dashboard.jsp"><i class="fas fa-calendar-day"></i> Schedule</a> 
                                    <a href="booking-staff-dashboard.jsp"><i class="fas fa-users"></i> Customers</a>
                                </c:when>
                            </c:choose>
                        </c:if>
                        
                        <div class="divider"></div>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <section class="page-header">
        <div class="container">
            <h1>Book Your Appointment</h1>
            <p>Select your grooming using our real-time availability instantly</p>
        </div>
    </section>

    <section class="booking-container">
        <div class="container">
            <div class="booking-steps">
                <div class="steps-indicator">
                    <div class="step active" id="step1">
                        <div class="step-circle">1</div>
                        <div class="step-label">Select Services</div>
                    </div>
                    <div class="step" id="step2">
                        <div class="step-circle">2</div>
                        <div class="step-label">Choose Barber</div>
                    </div>
                    <div class="step" id="step3">
                        <div class="step-circle">3</div>
                        <div class="step-label">Date & Time</div>
                    </div>
                    <div class="step" id="step4">
                        <div class="step-circle">4</div>
                        <div class="step-label">Confirmation</div>
                    </div>
                </div>
            </div>

            <div class="booking-wrapper">
                <div class="booking-form">
                    <div class="alert" id="bookingAlert"></div>

                    <div class="step-content active" id="stepContent1">
                        <h2 style="margin-bottom:25px;">Select Grooming Services</h2>
                        <div class="services-grid" id="servicesGrid"></div>
                        <div class="booking-navigation" style="justify-content: flex-end;">
                            <button class="btn btn-primary" onclick="goToStep(2)">Next: Choose Barber <i class="fas fa-arrow-right"></i></button>
                        </div>
                    </div>

                    <div class="step-content" id="stepContent2">
                        <h2>Choose Preferred Barber</h2>
                        <div class="staff-selection" style="margin-top:20px;">
                            <div class="staff-grid" id="staffGrid"></div>
                        </div>
                        <div class="booking-navigation">
                            <button class="btn btn-outline" onclick="goToStep(1)"><i class="fas fa-arrow-left"></i> Back</button>
                            <button class="btn btn-primary" onclick="goToStep(3)">Next: Date & Time <i class="fas fa-arrow-right"></i></button>
                        </div>
                    </div>

                    <div class="step-content" id="stepContent3">
                        <h2>Choose Date & Time</h2>
                        <div class="form-group" style="margin-top:20px;">
                            <label>Appointment Date *</label>
                            <input type="date" id="appointmentDate" class="form-control" onchange="fetchBusySlots()">
                        </div>
                        <div class="time-slots-container">
                            <h3>Available Time Slot</h3>
                            <div class="time-slots-grid" id="timeSlotsGrid">
                                <p style="color: var(--gray-color); grid-column: 1/-1; padding: 10px 0;">Please pick a date first to open time slots.</p>
                            </div>
                        </div>
                        
                        <h2 style="margin-top:40px; margin-bottom:15px;">Your Profile Summary</h2>
                        <div>
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" id="customerName" class="form-control" value="<c:out value='${sessionScope.fullName}'/>" readonly>
                            </div>
                            <div class="form-group">
                                <label>Phone Number</label>
                                <input type="text" id="customerPhone" class="form-control" value="<c:out value='${sessionScope.phone}'/>" readonly>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="text" id="customerEmail" class="form-control" value="<c:out value='${sessionScope.email}'/>" readonly>
                            </div>
                            <div class="form-group">
                                <label>Special Requests Notes</label>
                                <textarea id="specialRequests" class="form-control" placeholder="Any specific requirements..."></textarea>
                            </div>
                        </div>
                        
                        <div class="booking-navigation">
                            <button class="btn btn-outline" onclick="goToStep(2)"><i class="fas fa-arrow-left"></i> Back</button>
                            <button class="btn btn-primary" onclick="goToStep(4)">Review Summary <i class="fas fa-arrow-right"></i></button>
                        </div>
                    </div>

                    <div class="step-content" id="stepContent4">
                        <h2>Confirm Appointment</h2>
                        <div class="confirmation-details" style="margin-top:20px;">
                            <div class="detail-row"><div class="detail-label">Services:</div><div class="detail-value" id="confirmService">-</div></div>
                            <div class="detail-row"><div class="detail-label">Date & Time:</div><div class="detail-value" id="confirmDateTime">-</div></div>
                            <div class="detail-row"><div class="detail-label">Barber Name:</div><div class="detail-value" id="confirmBarber">-</div></div>
                            <div class="detail-row"><div class="detail-label">Total Fee:</div><div class="detail-value" id="confirmAmount" style="color:var(--secondary-color); font-weight:700;">RM 0.00</div></div>
                        </div>

                        <div class="form-group" style="margin: 25px 0; display: flex; align-items: flex-start; gap: 10px;">
                            <input type="checkbox" id="agreeTerms" style="width: 20px; height: 20px; cursor: pointer; margin-top: 3px;">
                            <label for="agreeTerms" style="font-size: 14px; color: var(--primary-color); cursor: pointer; user-select: none;">
                                I agree to the <strong>Owl Barbershop Cancellation Policy</strong>. I understand that cancellations has to made before 24 hours from booking appointments and pay later/cash has to be made in 2 hours after making appointments. Failed to follow may incur operational penalties.
                            </label>
                        </div>

                        <div class="booking-navigation">
                            <button class="btn btn-outline" onclick="goToStep(3)"><i class="fas fa-arrow-left"></i> Back</button>
                            <button class="btn btn-success" id="commitBtn" onclick="commitBookingToDB()"><i class="fas fa-check-circle"></i> Commit Booking</button>
                        </div>
                    </div>

                    <div id="successMessageBlock" style="display:none; text-align:center; padding: 40px 10px;">
                        <i class="fas fa-check-circle" style="font-size:72px; color:var(--success-color); margin-bottom:20px;"></i>
                        <h2 style="color:var(--success-color);">Appointment Saved!</h2>
                        <p style="margin:15px 0; color:var(--gray-color);">Your reservation hold has been entered under item number <strong id="outBookingId">#0</strong></p>
                        
                        <h3 style="margin-top: 30px; margin-bottom: 15px;">Choose Payment Method Gateway</h3>
                        <div style="display: flex; gap: 20px; margin-bottom: 30px;">
                            <div class="gateway-box" onclick="processImmediateGateway('CARD')">
                                <i class="fas fa-credit-card" style="color: #2ecc71;"></i>
                                <h4>Online Payment</h4>
                                <p style="font-size: 12px; color: var(--gray-color); margin-top: 5px;">Settle payment via transaction gateway</p>
                            </div>
                            <div class="gateway-box" onclick="processImmediateGateway('CASH')">
                                <i class="fas fa-money-bill-wave" style="color: #3498db;"></i>
                                <h4>Pay Cash / Pay Later</h4>
                                <p style="font-size: 12px; color: var(--gray-color); margin-top: 5px;">Confirm hold time slot for 2 hours</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="booking-summary">
                    <div class="summary-header">
                        <h3><i class="fas fa-receipt"></i> Checklist Summary</h3>
                    </div>
                    <div class="summary-item"><span class="summary-label">Selected Services :</span><span class="summary-value" id="sumService">None Specified</span></div>
                    <div class="summary-item"><span class="summary-label">Selected Barber   :</span><span class="summary-value" id="sumBarber">Not Selected</span></div>
                    <div class="summary-item"><span class="summary-label">Date Chosen:</span><span class="summary-value" id="sumDate">Not Set</span></div>
                    <div class="summary-item"><span class="summary-label">Time Chosen:</span><span class="summary-value" id="sumTime">Not Set</span></div>
                    <div class="summary-item"><span>Total          :</span><span class="summary-value" id="sumTotal" style="color:var(--secondary-color); font-weight:700;">RM 0.00</span></div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer"><p>&copy; 2026 Owl Barbershop System. All Rights Reserved.</p></footer>

    <script>
        let selectedServices = []; 
        let selectedBarber = null;
        let selectedTimeSlot = null;
        let activeSavedBookingId = null; 

        document.addEventListener("DOMContentLoaded", function() {
            let userId = "<c:out value='${sessionScope.userId}'/>";
            if(!userId || userId.trim() === "") {
                document.getElementById("bookingAlert").innerHTML = "🔒 Authentic login state required. Please authenticate into your profile account first.";
                document.getElementById("bookingAlert").style.display = "block";
                document.querySelectorAll(".step-content button").forEach(b => b.disabled = true);
                return;
            }
            
            let today = new Date().toISOString().split('T')[0];
            document.getElementById("appointmentDate").setAttribute('min', today);
            
            loadServicesFromDB();
            loadBarbersFromDB();
        });
        
        function loadServicesFromDB() {
            fetch("GetBookingDataServlet?action=getServices")
                .then(res => res.json())
                .then(data => {
                    let grid = document.getElementById("servicesGrid");
                    grid.innerHTML = "";
                    data.forEach(s => {
                        let safeName = s.name.replace(/'/g, "\\'");
                        let rawDuration = parseInt(s.duration); 
                      
                        // FIXED: Binds s.id (which evaluates to 101, 102) seamlessly into the layout DOM attributes
                        grid.innerHTML += 
                            '<div class="service-option" id="srv_' + s.id + '" onclick="selectService(' + s.id + ', \'' + safeName + '\', ' + s.price + ', ' + rawDuration + ')">' +
                                '<div class="select-indicator"><i class="far fa-square"></i></div>' +
                                '<h4>' + s.name + '</h4>' +
                                '<p>' + s.description + '</p>' +
                                '<div class="service-details">' +
                                    '<span class="service-price">RM ' + s.price.toFixed(2) + '</span>' +
                                    '<span class="service-duration"><i class="fas fa-clock"></i> ' + s.duration + ' mins</span>' +
                                '</div>' +
                            '</div>';
                    });
                })
                .catch(err => console.error("Error loading services:", err));
        }
        
        function loadBarbersFromDB() {
            fetch("GetBookingDataServlet?action=getStaff")
                .then(res => res.json())
                .then(data => {
                    let grid = document.getElementById("staffGrid");
                    grid.innerHTML = "";
                    
                    if (data.length === 0) {
                        grid.innerHTML = "<p style='color: var(--gray-color); padding: 10px;'>No barbers found in database matrix.</p>";
                        return;
                    }

                    data.forEach(st => {
                        let safeName = st.name.replace(/'/g, "\\'");
                        grid.innerHTML += 
                            '<div class="staff-option" id="st_' + st.id + '" onclick="selectBarber(' + st.id + ', \'' + safeName + '\')">' +
                                '<i class="fas fa-user-tie" style="font-size:32px; color:var(--gray-color); margin-bottom:10px;"></i>' +
                                '<h4>' + st.name + '</h4>' +
                                '<p>' + st.role + '</p>' +
                            '</div>';
                    });
                })
                .catch(err => console.error("Error loading barbers:", err));
        }

        function selectService(id, name, price, durationMinutes) {
            let idx = selectedServices.findIndex(s => s.id === id);
            let card = document.getElementById("srv_" + id);
            
            if (idx > -1) {
                selectedServices.splice(idx, 1);
                if(card) {
                    card.classList.remove("selected");
                    card.querySelector(".select-indicator i").className = "far fa-square";
                }
            } else {
                selectedServices.push({ id: id, name: name, price: price, duration: durationMinutes });
                if(card) {
                    card.classList.add("selected");
                    card.querySelector(".select-indicator i").className = "fas fa-check-square";
                }
            }
            
            updateSummaryUI();
            if(document.getElementById("appointmentDate").value && selectedBarber) {
                fetchBusySlots();
            }
        }

        function updateSummaryUI() {
            if (selectedServices.length === 0) {
                document.getElementById("sumService").innerText = "None Specified";
                document.getElementById("sumTotal").innerText = "RM 0.00";
                return;
            }
            
            let names = selectedServices.map(s => s.name).join(", ");
            let totalPrice = selectedServices.reduce((sum, s) => sum + s.price, 0);
            let totalDur = selectedServices.reduce((sum, s) => sum + s.duration, 0);
            document.getElementById("sumService").innerText = names + " (" + totalDur + " mins)";
            document.getElementById("sumTotal").innerText = "RM " + totalPrice.toFixed(2);
        }

        function selectBarber(id, name) {
            selectedBarber = { id: id, name: name };
            document.querySelectorAll(".staff-option").forEach(el => el.classList.remove("selected"));
            
            const targetCard = document.getElementById("st_" + id);
            if (targetCard) targetCard.classList.add("selected");
            
            document.getElementById("sumBarber").innerText = name;
            if(document.getElementById("appointmentDate").value) {
                fetchBusySlots();
            }
        }

        function fetchBusySlots() {
            let chosenDate = document.getElementById("appointmentDate").value;
            document.getElementById("sumDate").innerText = chosenDate || "Not Set";
            
            if (!chosenDate || !selectedBarber || selectedServices.length === 0) {
                return;
            }
            
            let totalDuration = selectedServices.reduce((sum, s) => sum + s.duration, 0);
            fetch("GetBookingDataServlet?action=getBusySlots&barberId=" + selectedBarber.id + "&date=" + chosenDate + "&totalDuration=" + totalDuration)
                .then(res => res.json())
                .then(busySlots => {
                    generateTimeSlots(busySlots);
                })
                .catch(err => {
                    console.error("Error calculating conflicts:", err);
                    generateTimeSlots([]);
                });
        }

        function generateTimeSlots(busySlots) {
            let grid = document.getElementById("timeSlotsGrid");
            grid.innerHTML = "";
            
            let slots = ["10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00"];
            selectedTimeSlot = null;
            document.getElementById("sumTime").innerText = "Not Set";

            slots.forEach(slot => {
                let isBooked = busySlots.includes(slot);
                if (isBooked) {
                    grid.innerHTML += '<div class="time-slot booked-slot" title="Barber does not have enough continuous space from this point.">' + slot + '</div>';
                } else {
                    grid.innerHTML += '<div class="time-slot" id="ts_' + slot.replace(':','') + '" onclick="selectTime(\'' + slot + '\')">' + slot + '</div>';
                }
            });
        }

        function selectTime(slot) {
            selectedTimeSlot = slot;
            document.querySelectorAll(".time-slot").forEach(el => el.classList.remove("selected"));
            document.getElementById("ts_" + slot.replace(':','')).classList.add("selected");
            document.getElementById("sumTime").innerText = slot;
        }

        function goToStep(stepNum) {
            if (stepNum === 2 && selectedServices.length === 0) {
                alert("Please check at least one grooming service package from the menu before proceeding.");
                return;
            }
            if (stepNum === 3 && !selectedBarber) {
                alert("Please select your preferred barber first.");
                return;
            }
            if (stepNum === 4) {
                if (!selectedTimeSlot || !document.getElementById("appointmentDate").value) {
                    alert("Please select a target date and an open starting timing block.");
                    return;
                }
                
                let names = selectedServices.map(s => s.name).join(", ");
                let totalPrice = selectedServices.reduce((sum, s) => sum + s.price, 0);
                let totalDur = selectedServices.reduce((sum, s) => sum + s.duration, 0);
                document.getElementById("confirmService").innerText = names + " (" + totalDur + " mins)";
                document.getElementById("confirmDateTime").innerText = document.getElementById("appointmentDate").value + " @ " + selectedTimeSlot;
                document.getElementById("confirmBarber").innerText = selectedBarber.name;
                document.getElementById("confirmAmount").innerText = "RM " + totalPrice.toFixed(2);
            }

            document.querySelectorAll(".step-content").forEach(el => el.classList.remove("active"));
            document.querySelectorAll(".step").forEach(el => el.classList.remove("active"));
            
            document.getElementById("stepContent" + stepNum).classList.add("active");
            document.getElementById("step" + stepNum).classList.add("active");
        }

        function commitBookingToDB() {
            if (selectedServices.length === 0) { alert("⚠️ Please select at least one grooming service."); return; }
            if (!selectedBarber || !selectedBarber.id) { alert("⚠️ Please select a preferred barber."); return; }
            if (!selectedTimeSlot) { alert("⚠️ Please select an operational time slot."); return; }
            
            let dateInput = document.getElementById("appointmentDate").value;
            if (!dateInput) { alert("⚠️ Please select an appointment date."); return; }

            const agreeTermsCheckbox = document.getElementById("agreeTerms");
            if (!agreeTermsCheckbox || !agreeTermsCheckbox.checked) { alert("⚠️ You must agree to the Cancellation Policy."); return; }

            let serviceIds = selectedServices.map(s => s.id).join(",");
            let totalCombinedPrice = selectedServices.reduce((sum, s) => sum + s.price, 0);

            let params = new URLSearchParams();
            params.append("serviceId", serviceIds);
            params.append("barberId", selectedBarber.id); // FIXED: Uses correct structural variable path
            params.append("bookingDate", dateInput);
            params.append("bookingTime", selectedTimeSlot);
            params.append("totalPrice", totalCombinedPrice); // FIXED: Sends the computed balance directly

            document.getElementById("bookingAlert").style.display = "none";
            
            const commitBtn = document.getElementById("commitBtn");
            commitBtn.disabled = true;
            commitBtn.innerHTML = "<i class='fas fa-spinner fa-spin'></i> Saving Booking Row...";
            
            // FIXED: Pointed to BookingServlet instead of SaveBookingServlet
            fetch("${pageContext.request.contextPath}/BookingServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(res => res.text())
            .then(text => {
                try {
                    let data = JSON.parse(text);
                    if (data.status === "success") {
                        activeSavedBookingId = data.bookingId; 
                        document.getElementById("outBookingId").innerText = "#" + data.bookingId;
                        
                        document.getElementById("stepContent4").style.display = "none";
                        document.querySelector(".booking-summary").style.display = "none";
                        document.getElementById("successMessageBlock").style.display = "block";
                        
                        document.getElementById("step4").classList.remove("active");
                        document.getElementById("step4").classList.add("completed");

                        sessionStorage.setItem("payment_booking_id", data.bookingId);
                        sessionStorage.setItem("payment_amount", totalCombinedPrice);
                        sessionStorage.setItem("payment_service_name", selectedServices.map(s => s.name).join(", "));
                    } else {
                        commitBtn.disabled = false;
                        commitBtn.innerHTML = "<i class='fas fa-check-circle'></i> Commit Booking";
                        document.getElementById("bookingAlert").innerText = "⚠️ Error: " + data.message;
                        document.getElementById("bookingAlert").style.display = "block";
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    }
                } catch (jsonError) {
                    commitBtn.disabled = false;
                    commitBtn.innerHTML = "<i class='fas fa-check-circle'></i> Commit Booking";
                    document.getElementById("bookingAlert").innerText = "❌ Parser Error: Non-JSON data returned.";
                    document.getElementById("bookingAlert").style.display = "block";
                }
            })
            .catch(err => {
                commitBtn.disabled = false;
                commitBtn.innerHTML = "<i class='fas fa-check-circle'></i> Commit Booking";
                document.getElementById("bookingAlert").innerText = "❌ Network connection dropped or endpoint mismatch.";
                document.getElementById("bookingAlert").style.display = "block";
            });
        }

        function processImmediateGateway(targetType) {
            if (!activeSavedBookingId) return;
            if (targetType === 'CARD') {
                window.location.href = "${pageContext.request.contextPath}/payment.jsp";
            } else if (targetType === 'CASH') {
                let params = new URLSearchParams();
                params.append("action", "PAY_CASH");
                params.append("bookingId", activeSavedBookingId);

                fetch("${pageContext.request.contextPath}/ManageBookingServlet", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: params.toString()
                })
                .then(res => res.json())
                .then(data => {
                    if (data.status === "success") {
                        window.location.href = "${pageContext.request.contextPath}/MyBookingsServlet";
                    } else {
                        alert("❌ Gateway Update Failed: " + data.message);
                    }
                })
                .catch(err => alert("Communication interface failure."));
            }
        }
    </script>
</body>
</html>