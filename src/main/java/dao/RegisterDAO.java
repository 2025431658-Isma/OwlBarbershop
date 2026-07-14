package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.owlbarber.util.DBConnection;
import model.RegisterModel;

public class RegisterDAO {

    public boolean isUsernameTaken(String username) throws SQLException, ClassNotFoundException {
        String query = "SELECT Cust_Username FROM Customer WHERE Cust_Username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int generateNextCustomerId() throws SQLException, ClassNotFoundException {
        String query = "SELECT NVL(MAX(Cust_ID), 0) + 1 FROM Customer";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    public boolean registerCustomer(RegisterModel model) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO Customer (Cust_ID, Cust_Name, Cust_PhoneNum, Cust_Email, Cust_Username, Cust_Password) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, model.getCustId());
            stmt.setString(2, model.getFullName());
            stmt.setString(3, model.getPhoneNum());
            stmt.setString(4, model.getEmail());
            stmt.setString(5, model.getUsername());
            stmt.setString(6, model.getPassword());

            return stmt.executeUpdate() > 0;
        }
    }
}