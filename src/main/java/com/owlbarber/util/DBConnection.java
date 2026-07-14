package com.owlbarber.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Corrected thin driver URL mapping explicitly to your local Oracle Service Name: freepdb1
    private static final String URL = "jdbc:postgresql://hostname:5432/database"; 
    
    // Using your assignment credentials
    private static final String USERNAME = "CSC584"; 
    private static final String PASSWORD = "CSC584";
    private static final String DRIVER = "org.postgresql.Driver";

    /**
     * Establishes and returns a live database connection.
     * Throws exceptions so the calling Servlets can catch database issues gracefully.
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Register the ojdbc driver class explicitly
        Class.forName(DRIVER);
        
        // Establish the live handshake and return it
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}