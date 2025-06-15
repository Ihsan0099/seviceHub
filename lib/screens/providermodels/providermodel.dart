class ProviderModel {
  final String fullName;
  final String serviceType;
  final String businessName;
  final String phone;
  final String email;
  // final double rating;
  final String address;
  // final int reviewCount;
  final String? photoUrl;

  ProviderModel({
    required this.fullName,
    required this.serviceType,
    required this.businessName,
    required this.phone,
    required this.email,
    required this.address,
    // required this.rating,
    // required this.reviewCount,
    this.photoUrl,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      fullName: map['fullName'] ?? 'N/A',
      serviceType: map['serviceType'] ?? 'N/A',
      businessName: map['businessName'] ?? 'N/A',
      phone: map['phone'] ?? 'N/A',
      email: map['email'] ?? 'N/A',
      // rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      // reviewCount: map['review_count'] ?? 0,
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'serviceType': serviceType,
      'businessName': businessName,
      'phone': phone,
      'email': email,
      // 'rating' : rating,
      // 'review_count' : reviewCount,
      'address' : address,
      'photoUrl': photoUrl,
    };
  }
}