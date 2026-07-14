package model;

/**
 * Model class representing a Service entry in the Owl Barbershop system.
 */
public class Service {
    private int serviceId;
    private String serviceName;
    private String serviceDesc;
    private double servicePrice;
    private int serviceDuration;
    private String serviceStatus;
    private int staffId;
    private String serviceDescription;

    public String getServiceDescription() {
		return serviceDescription;
	}

	public void setServiceDescription(String serviceDescription) {
		this.serviceDescription = serviceDescription;
	}

	public int getStaffId() {
		return staffId;
	}

	public void setStaffId(int staffId) {
		this.staffId = staffId;
	}

	// Default Constructor
    public Service() {
    }

	public int getServiceId() {
		return serviceId;
	}

	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getServiceDesc() {
		return serviceDesc;
	}

	public void setServiceDesc(String serviceDesc) {
		this.serviceDesc = serviceDesc;
	}

	public double getServicePrice() {
		return servicePrice;
	}

	public void setServicePrice(double servicePrice) {
		this.servicePrice = servicePrice;
	}

	public int getServiceDuration() {
		return serviceDuration;
	}

	public void setServiceDuration(int serviceDuration) {
		this.serviceDuration = serviceDuration;
	}

	public String getServiceStatus() {
		return serviceStatus;
	}

	public void setServiceStatus(String serviceStatus) {
		this.serviceStatus = serviceStatus;
	}}