class FieldValidator {
  static String validateEmail(String value) {
    print("validateEmail : $value ");

    if (value.isEmpty) return "Please Enter your email";

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return "Email address is not valid";
    }

    return null;
  }

  /// Password matching expression. Password must be at least 4 characters,
  /// no more than 8 characters, and must include at least one upper case letter,
  /// one lower case letter, and one numeric digit.
  static String validatePassword(String value) {
    print("validatepassword : $value ");

    if (value.isEmpty) return "Enter your password";
    if (value.length < 8) {
      return "Password must be more than 8 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatePhone(String value) {
    print("validatepassword : $value ");

    if (value.isEmpty) return "Enter your phone number";
    if (value.length < 10) {
      return "Phone number must be more than 10 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateuser(String value) {
    print("validatepassword : $value ");

    if (value.isEmpty) return "Enter your Username";
    if (value.length <= 6) {
      return "Username must be more than 8 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatename(String value) {
    if (value.isEmpty) return " Please Enter your Name";
    if (value.length <= 2) {
      return "Atleast 2 characters!";
    }
    if (value.length >= 50) {
      return "Below 50 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatCompanyename(String value) {
    if (value.isEmpty) return " Please Enter Company Name";
    if (value.length <= 2) {
      return "Atleast 2 characters!";
    }
    if (value.length >= 50) {
      return "Below 50 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatCountryename(String value) {
    if (value.isEmpty) return " Please Enter Country Name";
    if (value.length <= 2) {
      return "Atleast 2 characters!";
    }
    if (value.length >= 50) {
      return "Below 50 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatZipCode(String value) {
    if (value.isEmpty) return "Enter Zip Code";
    if (value.length < 0) {
      return "Zip Code";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateBlank(String value) {
    // print("validateName : $value ");

    if (value.isEmpty) return "Field is required";
    // if (value.length <= 1) {
    //   return "Address Name is too short";
    // }
    // if (value.length >= 20) {
    //   return "letters should be less than 20";
    // }
    // Pattern pattern = r'^(?=.*?[a-z])(?!.*?[!@#\$&*~+/.,():N]).{3,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "only letters, number and underscore";
    // }
    // if (!RegExp(r"^[A-Za-z-]{2,25}$").hasMatch(value)) {
    //   return 'Invalid Name';
    // }

    return null;
  }

  static String validatCityename(String value) {
    if (value.isEmpty) return " Please Enter City Name";
    if (value.length <= 2) {
      return "Atleast 2 characters!";
    }
    if (value.length >= 50) {
      return "Below 50 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatStateename(String value) {
    if (value.isEmpty) return " Please Enter State Name";
    if (value.length <= 2) {
      return "Atleast 2 characters!";
    }
    if (value.length >= 50) {
      return "Below 50 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatStreetname(String value) {
    if (value.isEmpty) return " Please Enter Street Name";
    if (value.length <= 2) {
      return "Atleast 2 characters!";
    }
    if (value.length >= 50) {
      return "Below 50 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateaddress(String value) {
    if (value.isEmpty) return "Please Enter your Address";
    if (value.length <= 5) {
      return "Atleast 5 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateAccountNumber(String value) {
    if (value.isEmpty) return "Please Enter your Account Number";
    return null;
  }

  static String validateAccountName(String value) {
    if (value.isEmpty) return "Please Enter your Account Name";
    return null;
  }

  static String validateabout(String value) {
    if (value.isEmpty) return "Please Enter your About!";
    if (value.length <= 5) {
      return "Atleast 5 characters!";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatecard(String value) {
    if (value.isEmpty) return "Enter your Card Number";
    if (value.length < 12) {
      return "Card Number must be 12 Digits";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatemonth(String value) {
    if (value.isEmpty) return "Enter your Month";
    if (value.length < 2) {
      return "Month must be 2 Digit";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateyear(String value) {
    if (value.isEmpty) return "Enter your Year";
    if (value.length < 2) {
      return "Year must be 2 Digit";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validatecvv(String value) {
    if (value.isEmpty) return "Enter your CVV";
    if (value.length < 4 && value.length < 3) {
      return "CVV must be 3 or 4 Digit";
    }

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateholder(String value) {
    if (value.isEmpty) return "Enter Card Holder Name";

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "include one capital letter, number and symbol";
    // }
    return null;
  }

  static String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,15}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
