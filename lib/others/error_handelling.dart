class ErrorHandelling {
  static String getMessageFromErrorCode({required String errorCode}) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "This email address already exists,\nPlease use another email to register.";
      case "email-already-in-use":
        return "This email address already exists.\nPlease use another email to register.";
      case "ERROR_WRONG_PASSWORD":
        return "The password you entered is incorrect.\nPlease try again.";
      case "wrong-password":
        return "The password is incorrect.\nPlease try again.";
      case "ERROR_USER_NOT_FOUND":
        return "No existing account with this email address.";
      case "user-not-found":
        return "No existing account with this email address.";
      case "ERROR_USER_DISABLED":
        return "User has been disabled.";
      case "user-disabled":
        return "User has been disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
        return "Email address is invalid.";
      case "invalid-email":
        return "Email address is invalid.";
      case "location":
        return "Please enable access to your location.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
