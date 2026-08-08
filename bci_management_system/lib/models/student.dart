class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final DateTime dateOfBirth;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    required this.dateOfBirth,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return (f + l).toUpperCase();
  }

  Student copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
  }) {
    return Student(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
