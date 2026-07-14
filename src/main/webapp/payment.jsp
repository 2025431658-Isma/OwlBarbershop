<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Payment Portal - Owl Barbershop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-color: #2c3e50; --secondary-color: #3498db;
            --light-gray: #f8f9fa; --success-color: #2ecc71;
            --border-radius: 8px; --box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        body { font-family: 'Roboto', sans-serif; background-color: var(--light-gray); color: #333; }
        .payment-container { max-width: 600px; margin: 60px auto; padding: 0 20px; }
        .payment-card { background: #fff; border-radius: var(--border-radius); padding: 40px; box-shadow: var(--box-shadow); text-align: center; }
        .header-icon { font-size: 50px; color: var(--secondary-color); margin-bottom: 20px; }
        .invoice-box { background: #fdfdfd; border: 1px dashed #ddd; border-radius: 6px; padding: 20px; margin: 25px 0; text-align: left; }
        .invoice-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px; }
        .invoice-row:last-child { margin-bottom: 0; padding-top: 12px; border-top: 2px solid #eee; font-weight: 700; font-size: 18px; color: var(--secondary-color); }
        .payment-methods { display: flex; gap: 15px; margin: 25px 0; }
        .method-box { flex: 1; border: 2px solid #eee; border-radius: var(--border-radius); padding: 15px; cursor: pointer; transition: all 0.2s; }
        .method-box.active { border-color: var(--success-color); background: rgba(46, 204, 113, 0.05); }
        .method-box i { font-size: 24px; margin-bottom: 8px; display: block; color: #555; }
        .method-box.active i { color: var(--success-color); }
        
        .btn-pay, .btn-download, .btn-nav { display: block; width: 100%; color: #fff; border: none; padding: 14px; font-size: 16px; font-weight: 600; border-radius: var(--border-radius); cursor: pointer; transition: background 0.2s; margin-bottom: 12px; text-decoration: none; }
        .btn-pay { background: var(--success-color); }
        .btn-pay:hover { background: #27ae60; }
        .btn-download { background: #3498db; }
        .btn-download:hover { background: #2980b9; }
        .btn-nav { background: #7f8c8d; text-align: center; }
        .btn-nav:hover { background: #95a5a6; }

        /* Screen-view styles for the live receipt */
        .receipt-modal { background: #fff; padding: 30px; border-radius: 8px; max-width: 100%; margin: 20px auto; border: 1px solid #e8e8e8; font-family: 'Poppins', sans-serif; color: #2c3e50; position: relative; }
        .receipt-header { text-align: center; border-bottom: 2px dashed #bdc3c7; padding-bottom: 15px; margin-bottom: 20px; }
        .receipt-logo { font-size: 24px; font-weight: 700; color: #2c3e50; text-transform: uppercase; letter-spacing: 1px; }
        .receipt-subtitle { font-size: 11px; color: #7f8c8d; margin-top: 3px; }
        .receipt-title { font-size: 18px; font-weight: 600; color: var(--success-color); margin-top: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        .receipt-body { margin-bottom: 20px; position: relative; z-index: 1; }
        .receipt-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; color: #34495e; }
        .receipt-row.total-row { border-top: 2px solid #2c3e50; padding-top: 10px; font-weight: 700; font-size: 18px; color: #2c3e50; margin-top: 12px; }
        .receipt-footer { text-align: center; border-top: 1px solid #eee; padding-top: 15px; font-size: 11px; color: #95a5a6; position: relative; z-index: 1; }
        .receipt-watermark { font-size: 60px; color: rgba(46, 204, 113, 0.08); font-weight: 800; transform: rotate(-12deg); position: absolute; top: 40%; left: 35%; z-index: 0; pointer-events: none; text-transform: uppercase; letter-spacing: 2px; }
    </style>
</head>
<body>

    <div class="payment-container">
        
        <div class="payment-card" id="checkout-view">
            <div class="header-icon"><i class="fas fa-shield-alt"></i></div>
            <h2>Secure Checkout Gateway</h2>
            <p style="color: #777; margin-top: 5px;">Please verify your service billing rows before executing authorization</p>
            
            <div class="invoice-box">
                <div class="invoice-row"><span>Booking Reference ID:</span><span id="invId">#0</span></div>
                <div class="invoice-row"><span>Reserved Grooming Service:</span><span id="invService">-</span></div>
                <div class="invoice-row"><span>Payment Status Matrix:</span><span style="color: #f39c12; font-weight: 500;">Unpaid (Pending Processing)</span></div>
                <div class="invoice-row"><span>Grand Aggregate Total:</span><span id="invAmount">RM 0.00</span></div>
            </div>

            <h3 style="text-align: left; margin-bottom: 15px; font-family: 'Poppins';">Select Payment Channel</h3>
            <div class="payment-methods">
                <div class="method-box active" onclick="selectMethod(this)">
                    <i class="fas fa-credit-card"></i>
                    <span>Card / Visa / MC</span>
                </div>
                <div class="method-box" onclick="selectMethod(this)">
                    <i class="fas fa-university"></i>
                    <span>FPX Online Banking</span>
                </div>
                <div class="method-box" onclick="selectMethod(this)">
                    <i class="wallet-icon fas fa-wallet"></i>
                    <span>E-Wallet App</span>
                </div>
            </div>

            <button class="btn-pay" onclick="executePaymentMock()">Authorize & Process Payment</button>
        </div>

        <div class="payment-card" id="success-view" style="display: none;">
            <div class="header-icon" style="color: var(--success-color);"><i class="fas fa-check-circle"></i></div>
            <h2>Payment Successful!</h2>
            <p style="color: #777; margin-top: 5px; margin-bottom: 10px;">Your transaction has been confirmed and logged by our processing core matrix.</p>
            
            <div id="receipt-print-area" class="receipt-modal" style="text-align: left;">
                <div class="receipt-watermark">PAID</div>
                <div class="receipt-header">
                    <div class="receipt-logo"><i class="fas fa-cut"></i> Owl Barbershop</div>
                    <div class="receipt-subtitle">Premium Men's Grooming Excellence</div>
                    <div class="receipt-title">Official Digital Receipt</div>
                </div>
                <div class="receipt-body">
                    <div class="receipt-row"><span>Transaction Status:</span><span style="color: var(--success-color); font-weight: 600;">SUCCESSFUL / PAID</span></div>
                    <div class="receipt-row"><span>Date & Time:</span><span id="rcptDate">-</span></div>
                    <div class="receipt-row"><span>Receipt Serial No:</span><span id="rcptRef">-</span></div>
                    <div class="receipt-row"><span>Booking ID Code:</span><span id="rcptBookingId">-</span></div>
                    <div class="receipt-row"><span>Allocated Service:</span><span id="rcptService">-</span></div>
                    <div class="receipt-row"><span>Payment Type:</span><span id="rcptMethod">-</span></div>
                    <div class="receipt-row total-row"><span>Total Paid:</span><span id="rcptAmount">RM 0.00</span></div>
                </div>
                <div class="receipt-footer">
                    <p>Thank you for choosing Owl Barbershop!</p>
                    <p style="margin-top: 4px; font-size: 10px; color: #bdc3c7;">This is a system-validated digital statement proof.</p>
                </div>
            </div>

            <button class="btn-download" onclick="downloadReceiptPDF()"><i class="fas fa-file-pdf"></i> Download PDF Receipt</button>
            <a href="${pageContext.request.contextPath}/MyBookingsServlet" class="btn-nav">Return to My Bookings</a>
        </div>

    </div>

    <script>
        let trackingBookingId = "N/A";
        let trackingAmountFormatted = "0.00";
        let trackingServiceName = "Grooming Selection Unit";

        document.addEventListener("DOMContentLoaded", function() {
            trackingBookingId = sessionStorage.getItem("payment_booking_id") || "N/A";
            let rawAmount = sessionStorage.getItem("payment_amount") || "0";
            trackingServiceName = sessionStorage.getItem("payment_service_name") || "Grooming Selection Unit";

            trackingAmountFormatted = parseFloat(rawAmount).toFixed(2);
            document.getElementById("invId").innerText = "#" + trackingBookingId;
            document.getElementById("invService").innerText = trackingServiceName;
            document.getElementById("invAmount").innerText = "RM " + trackingAmountFormatted;
        });

        function selectMethod(element) {
            document.querySelectorAll(".method-box").forEach(box => box.classList.remove("active"));
            element.classList.add("active");
        }

        function executePaymentMock() {
            if (!trackingBookingId || trackingBookingId === "N/A") {
                alert("❌ Active booking checkout session context was lost.");
                return;
            }

            let chosenChannelName = document.querySelector(".method-box.active span").innerText;
            let params = new URLSearchParams();
            params.append("bookingId", trackingBookingId);

            const payButton = document.querySelector(".btn-pay");
            payButton.disabled = true;
            payButton.innerText = "Processing Transaction Authorization...";

            fetch("${pageContext.request.contextPath}/ProcessPaymentServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === "success") {
                    let systemDate = new Date();
                    let computedTimestamp = systemDate.toLocaleDateString('en-MY', { year: 'numeric', month: 'long', day: 'numeric' }) + ' ' + systemDate.toLocaleTimeString('en-MY');
                    let randomSerial = "OWL-" + Math.floor(100000 + Math.random() * 900000);

                    document.getElementById("rcptDate").innerText = computedTimestamp;
                    document.getElementById("rcptRef").innerText = randomSerial;
                    document.getElementById("rcptBookingId").innerText = "#" + trackingBookingId;
                    document.getElementById("rcptService").innerText = trackingServiceName;
                    document.getElementById("rcptMethod").innerText = chosenChannelName;
                    document.getElementById("rcptAmount").innerText = "RM " + trackingAmountFormatted;

                    sessionStorage.removeItem("payment_booking_id");
                    sessionStorage.removeItem("payment_amount");
                    sessionStorage.removeItem("payment_service_name");

                    document.getElementById("checkout-view").style.display = "none";
                    document.getElementById("success-view").style.display = "block";
                } else {
                    alert("⚠️ Transaction authorization declined by server: " + data.message);
                    payButton.disabled = false;
                    payButton.innerText = "Authorize & Process Payment";
                }
            })
            .catch(err => {
                console.error(err);
                alert("Critical data link communication loss occurred during transaction execution.");
                payButton.disabled = false;
                payButton.innerText = "Authorize & Process Payment";
            });
        }

        function downloadReceiptPDF() {
            // 1. Fetch live text content securely from your page elements
            const rcptDate = document.getElementById("rcptDate")?.innerText || "-";
            const rcptRef = document.getElementById("rcptRef")?.innerText || "-";
            const rcptBookingId = document.getElementById("rcptBookingId")?.innerText || "-";
            const rcptService = document.getElementById("rcptService")?.innerText || "-";
            const rcptMethod = document.getElementById("rcptMethod")?.innerText || "-";
            const rcptAmount = document.getElementById("rcptAmount")?.innerText || "RM 0.00";

            let cleanFilenameId = rcptBookingId.replace("#", "").trim();
            if (!cleanFilenameId || cleanFilenameId === "-") {
                cleanFilenameId = "Compiled";
            }

            // 2. Build a high-end corporate invoice HTML template explicitly for A4 sizing
            const invoiceTemplateHtml = `
                <div style="font-family: 'Poppins', 'Helvetica Neue', Arial, sans-serif; padding: 40px; color: #2c3e50; max-width: 600px; margin: 0 auto; background: #ffffff;">
                    
                    <div style="text-align: center; border-bottom: 2px dashed #bdc3c7; padding-bottom: 20px; margin-bottom: 25px; position: relative;">
                        <div style="font-size: 28px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #2c3e50; margin-bottom: 4px;">
                            Owl Barbershop
                        </div>
                        <div style="font-size: 12px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 0.5px;">
                            Premium Men's Grooming Excellence
                        </div>
                        <div style="font-size: 18px; font-weight: 600; color: #2ecc71; margin-top: 15px; letter-spacing: 0.5px; text-transform: uppercase;">
                            Official Digital Receipt
                        </div>
                    </div>

                    <div style="text-align: center; margin: 15px 0; position: relative;">
                        <div style="font-size: 75px; color: rgba(46, 204, 113, 0.06); font-weight: 900; letter-spacing: 6px; text-transform: uppercase; transform: rotate(-10deg); margin: 10px 0;">
                            PAID
                        </div>
                    </div>

                    <div style="margin-bottom: 30px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px solid #f5f6f7; padding-bottom: 6px;">
                            <span style="color: #7f8c8d;">Transaction Status:</span>
                            <span style="color: #2ecc71; font-weight: 600;">SUCCESSFUL / PAID</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px solid #f5f6f7; padding-bottom: 6px;">
                            <span style="color: #7f8c8d;">Date & Time:</span>
                            <span style="color: #34495e; font-weight: 500;">\${rcptDate}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px solid #f5f6f7; padding-bottom: 6px;">
                            <span style="color: #7f8c8d;">Receipt Serial No:</span>
                            <span style="color: #34495e; font-weight: 500; font-family: monospace;">\${rcptRef}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px solid #f5f6f7; padding-bottom: 6px;">
                            <span style="color: #7f8c8d;">Booking ID Code:</span>
                            <span style="color: #34495e; font-weight: 600;">\${rcptBookingId}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px solid #f5f6f7; padding-bottom: 6px;">
                            <span style="color: #7f8c8d;">Allocated Service:</span>
                            <span style="color: #34495e; font-weight: 500;">\${rcptService}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; border-bottom: 1px solid #f5f6f7; padding-bottom: 6px;">
                            <span style="color: #7f8c8d;">Payment Type:</span>
                            <span style="color: #34495e; font-weight: 500;">\${rcptMethod}</span>
                        </div>
                        
                        <div style="display: flex; justify-content: space-between; border-top: 2px solid #2c3e50; padding-top: 14px; margin-top: 20px;">
                            <span style="font-size: 18px; font-weight: 700; color: #2c3e50;">Total Paid:</span>
                            <span style="font-size: 20px; font-weight: 700; color: #2c3e50;">\${rcptAmount}</span>
                        </div>
                    </div>

                    <div style="text-align: center; border-top: 1px solid #eef2f3; padding-top: 20px; font-size: 12px; color: #95a5a6; line-height: 1.6;">
                        <p style="font-weight: 600; color: #7f8c8d; margin-bottom: 4px;">Thank you for choosing Owl Barbershop!</p>
                        <p style="font-size: 10px; color: #bdc3c7;">This is a system-validated digital statement proof.</p>
                    </div>
                </div>
            `;

            // 3. Configure robust print parameters 
            const configurationOptions = {
                margin:       [15, 15, 15, 15],
                filename:     'Receipt_Booking_' + cleanFilenameId + '.pdf',
                image:        { type: 'jpeg', quality: 1.0 },
                html2canvas:  { 
                    scale: 3, // High definition image output
                    useCORS: true, 
                    letterRendering: true,
                    scrollY: 0,
                    scrollX: 0
                },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            // 4. Generate the PDF flawlessly directly from the source code string context
            html2pdf().set(configurationOptions).from(invoiceTemplateHtml).save();
        }
    </script>
</body>
</html>