<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Owl Barbershop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #764ba2; 
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --gray-color: #95a5a6;
            --light-gray: #f8f9fa;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-container {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            width: 100%;
            max-width: 450px;
            overflow: hidden;
            animation: fadeIn 0.5s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .login-header {
            background-color: var(--primary-color);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }
        .login-header h2 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }
        .login-header p {
            color: #bdc3c7;
            font-size: 0.9rem;
        }
        .login-header .logo-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #667eea;
        }
        .login-body {
            padding: 40px 30px;
        }
        .input-group {
            margin-bottom: 25px;
            position: relative;
        }
        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--primary-color);
            font-weight: 500;
            font-size: 0.9rem;
        }
        .input-wrapper {
            position: relative;
        }
        .input-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-color);
            transition: var(--transition);
        }
        .input-wrapper input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #dcdde1;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
            outline: none;
        }
        .input-wrapper input:focus {
            border-color: var(--secondary-color);
        }
        .input-wrapper input:focus + i {
            color: var(--secondary-color);
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: var(--secondary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 10px;
        }
        .btn-login:hover {
            background-color: #5b3a8c;
        }
        .login-footer {
            text-align: center;
            margin-top: 25px;
            font-size: 0.9rem;
            color: #7f8c8d;
        }
        .login-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }
        .alert {
            padding: 12px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            font-size: 0.9rem;
        }
        .alert-danger {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(231, 76, 60, 0.2);
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-header">
            <div class="logo-icon">
                <i class="fas fa-cut"></i>
            </div>
            <h2>Owl Barbershop</h2>
            <p>Sign in to manage your appointments</p>
        </div>
         
        <div class="login-body">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}"/>
                </div>
            </c:if>

            <form id="loginForm" action="LoginServlet" method="POST">
                <div class="input-group">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" name="username" required placeholder="Enter your username">
                        <i class="fas fa-user"></i>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" required placeholder="Enter your password">
                        <i class="fas fa-lock"></i>
                    </div>
                </div>

                <button type="submit" class="btn-login">Login</button>
            </form>

            <div class="login-footer">
                <p>Don't have an account? <a href="register.jsp">Register here</a></p>
                <p style="margin-top: 10px;"><a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a></p>
            </div>
        </div>
    </div>

</body>
</html>