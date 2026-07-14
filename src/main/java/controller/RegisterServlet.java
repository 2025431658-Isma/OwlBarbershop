package controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.RegisterDAO;
import model.RegisterModel;
import helper.RegisterHelper;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisterDAO registerDAOInstance;

    @Override
    public void init() throws ServletException {
        this.registerDAOInstance = new RegisterDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String phoneNum = request.getParameter("phoneNum");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Structural parameter form validations
        if (RegisterHelper.isAnyEmpty(fullName, phoneNum, email, username, password, confirmPassword)) {
            request.setAttribute("errorMessage", "All form fields are mandatory!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            // 2. Evaluate username unique constraint rules
            if (registerDAOInstance.isUsernameTaken(username.trim())) {
                request.setAttribute("errorMessage", "Username is already registered!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 3. Assemble populated database model
            int nextId = registerDAOInstance.generateNextCustomerId();
            String secureHashedPassword = RegisterHelper.hashPassword(password);

            RegisterModel newUser = new RegisterModel();
            newUser.setCustId(nextId);
            newUser.setFullName(fullName.trim());
            newUser.setPhoneNum(phoneNum.trim());
            newUser.setEmail(email.trim());
            newUser.setUsername(username.trim());
            newUser.setPassword(secureHashedPassword);

            // 4. Submit payload into persistence layers
            boolean registrationSuccess = registerDAOInstance.registerCustomer(newUser);

            if (registrationSuccess) {
                request.setAttribute("successMessage", "Registration successful! Log in below.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error encountered: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}