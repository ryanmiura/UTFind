class CampusUnit {
  final String name;
  final String address;
  final String phone;
  final String lat;
  final String long;

  CampusUnit({
    required this.name,
    required this.address,
    required this.phone,
    required this.lat,
    required this.long,
  });

  factory CampusUnit.fromJson(Map<String, dynamic> json) {
    return CampusUnit(
      name: json['unidNomeVc'] ?? '',
      address: json['unidEnderecoVc'] ?? '',
      phone: json['unidfonevc'] ?? '',
      lat: json['unidlatitudenr'] ?? '',
      long: json['unidlongitudenr'] ?? '',
    );
  }
}
