class University {
  final String university;
  final String sector;
  final String mainCampus;
  final String address;
  final String phone;
  final String email;
  final String url;
  final String campuses;

  University({
    required this.university,
    required this.sector,
    required this.mainCampus,
    required this.address,
    required this.phone,
    required this.email,
    required this.url,
    required this.campuses,
  });

  // Factory constructor to create University object from Firestore
  factory University.fromFirestore(Map<String, dynamic> json) {
    // Logging the incoming json to debug
    print("Firestore data: $json");

    return University(
      university: _parseString(json['university']),
      sector: _parseString(json['sector']),
      mainCampus: _parseString(json['main_campus']),
      address: _parseString(json['address']),
      phone: _parsePhone(json['phone']),
      email: _parseString(json['email']),
      url: _parseString(json['url']),
      campuses: _parseString(json['campuses']),
    );
  }

  // Helper function to handle String fields (to handle null or non-string types)
  static String _parseString(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is double || value is int) {
      return value.toString();
    } else {
      return '';
    }
  }

  // Helper function to handle phone number parsing and ensure it's a String
  static String _parsePhone(dynamic phone) {
    if (phone is double || phone is int) {
      return phone.toString();
    } else if (phone is String) {
      return phone;
    } else {
      return '';
    }
  }
}
