package helper;

import jakarta.servlet.http.HttpServletResponse;

public class MyBookingsHelper {

    public static void attachCacheControlHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        response.setHeader("Pragma", "no-cache"); 
        response.setDateHeader("Expires", 0);
    }
}