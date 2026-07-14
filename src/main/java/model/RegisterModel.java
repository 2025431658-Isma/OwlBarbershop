package model;

import java.io.Serializable;

public class RegisterModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private int custId;
    private String fullName;
    private String phoneNum;
    private String email;
    private String username;
    private String password;

    public RegisterModel() {}

    public int getCustId() { return custId; }
    public void setCustId(int custId) { this.custId = custId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhoneNum() { return phoneNum; }
    public void setPhoneNum(String phoneNum) { this.phoneNum = phoneNum; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}