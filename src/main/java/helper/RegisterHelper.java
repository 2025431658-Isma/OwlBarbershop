package helper;

import org.mindrot.jbcrypt.BCrypt;

public class RegisterHelper {

    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static boolean isAnyEmpty(String... fields) {
        for (String field : fields) {
            if (isEmpty(field)) return true;
        }
        return false;
    }

    public static String hashPassword(String clearPassword) {
        return BCrypt.hashpw(clearPassword, BCrypt.gensalt());
    }
}