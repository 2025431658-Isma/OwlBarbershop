package model;

/**
 * Model class representing a Staff member in the Owl Barbershop system.
 */
public class Staff {
	private int staffId;
	private String staffName;
	private String staffUsername;
	private String staffPassword;
	private String staffEmail;
	private String staffPhoneNum;
	private Integer managerId; // Using Integer object instead of int to safely allow null values (for
								// Managers)
	private String staffSpecialty;
	private int staffExperience;
	private double staffRate;

	public double getStaffRate() {
		return staffRate;
	}

	public void setStaffRate(double staffRate) {
		this.staffRate = staffRate;
	}

	// Default Constructor
	public Staff() {
	}

	// Parameterized Constructor
	public Staff(int staffId, String staffName, String staffUsername, String staffPassword, String staffEmail,
			String staffPhoneNum, Integer managerId, String staffSpecialty, int staffExperience) {
		this.staffId = staffId;
		this.staffName = staffName;
		this.staffUsername = staffUsername;
		this.staffPassword = staffPassword;
		this.staffEmail = staffEmail;
		this.staffPhoneNum = staffPhoneNum;
		this.managerId = managerId;
		this.staffSpecialty = staffSpecialty;
		this.staffExperience = staffExperience;
	}

	// ==========================================
	// GETTERS AND SETTERS
	// ==========================================

	public int getStaffId() {
		return staffId;
	}

	public void setStaffId(int staffId) {
		this.staffId = staffId;
	}

	public String getStaffName() {
		return staffName;
	}

	public void setStaffName(String staffName) {
		this.staffName = staffName;
	}

	public String getStaffUsername() {
		return staffUsername;
	}

	public void setStaffUsername(String staffUsername) {
		this.staffUsername = staffUsername;
	}

	public String getStaffPassword() {
		return staffPassword;
	}

	public void setStaffPassword(String staffPassword) {
		this.staffPassword = staffPassword;
	}

	public String getStaffEmail() {
		return staffEmail;
	}

	public void setStaffEmail(String staffEmail) {
		this.staffEmail = staffEmail;
	}

	public String getStaffPhoneNum() {
		return staffPhoneNum;
	}

	public void setStaffPhoneNum(String staffPhoneNum) {
		this.staffPhoneNum = staffPhoneNum;
	}

	public Integer getManagerId() {
		return managerId;
	}

	public void setManagerId(Integer managerId) {
		this.managerId = managerId;
	}

	public String getStaffSpecialty() {
		return staffSpecialty;
	}

	public void setStaffSpecialty(String staffSpecialty) {
		this.staffSpecialty = staffSpecialty;
	}

	public int getStaffExperience() {
		return staffExperience;
	}

	public void setStaffExperience(int staffExperience) {
		this.staffExperience = staffExperience;
	}
}