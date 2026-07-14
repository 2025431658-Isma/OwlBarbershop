<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owl Barbershop - Register Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .register-container {
            background: white;
            width: 100%;
            max-width: 500px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 10px; }
        p.subtitle { text-align: center; color: #7f8c8d; margin-bottom: 25px; font-size: 14px; }
        .form-group { margin-bottom: 20px; position: relative; }
        .form-group i { position: absolute; left: 15px; top: 40px; color: #764ba2; }
        label { display: block; margin-bottom: 8px; color: #34495e; font-weight: 500; font-size: 14px; }
        input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        input:focus { border-color: #764ba2; outline: none; box-shadow: 0 0 8px rgba(118,75,162,0.2); }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            box-shadow: 0 4px 10px rgba(118,75,162,0.3);
        }
        .btn-submit:hover { opacity: 0.9; }
        .alert-error {
            background-color: #fce4e4;
            color: #cc0000;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 5px solid #cc0000;
        }
        .login-link { text-align: center; margin-top: 20px; font-size: 14px; color: #7f8c8d; }
        .login-link a { color: #764ba2; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>

    <div class="register-container">
        <h2>Create Account</h2>
        <p class="subtitle">Join Owl Barbershop for easy online bookings</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert-error">
                <i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <form action="RegisterServlet" method="POST">
            <div class="form-group">
                <label>Full Name</label>
                <i class="fas fa-user"></i>
                <input type="text" name="fullName" placeholder="Insert Your Full Name" required>
            </div>
            
            <div class="form-group">
                <label>Phone Number</label>
                <i class="fas fa-phone"></i>
                <input type="tel" name="phoneNum" placeholder="Insert Your Phone Number" required>
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="Insert Your Email" required>
            </div>

            <div class="form-group">
                <label>Username</label>
                <i class="fas fa-user-tag"></i>
                <input type="text" name="username" placeholder="Insert Your Username" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="•••••" required>
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <i class="fas fa-shield-alt"></i>
                <input type="password" name="confirmPassword" placeholder="•••••" required>
            </div>

            <button type="submit" class="btn-submit">Register Account</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>

</body>
</html>