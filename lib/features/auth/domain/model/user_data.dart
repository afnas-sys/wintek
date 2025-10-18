class UserProfileData {
  final String? name;
  final String? email;
  final String? mobileNumber;
  final DateTime? dob;
  final String? gender;
  final String? profileImage; // New field

  UserProfileData({
    this.name,
    this.email,
    this.mobileNumber,
    this.dob,
    this.gender,
    this.profileImage,
  });

  /// Create from JSON
  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      gender: json['gender'],
      profileImage: json['profileImage'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'profileImage': profileImage,
    };
  }

  /// Copy with new values
  UserProfileData copyWith({
    String? name,
    String? email,
    String? mobileNumber,
    DateTime? dob,
    String? gender,
    String? profileImage,
  }) {
    return UserProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
