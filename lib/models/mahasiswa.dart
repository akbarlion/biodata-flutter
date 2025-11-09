class Mahasiswa {
  final int id;
  final String nama;
  final String nim;
  final String email;
  final String fakultas;
  final String prodi;
  final String angkatan;
  final String? createdAt;
  final String? updatedAt;

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.nim,
    required this.email,
    required this.fakultas,
    required this.prodi,
    required this.angkatan,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      email: json['email'] ?? '',
      fakultas: json['fakultas'] ?? '',
      prodi: json['prodi'] ?? '',
      angkatan: json['angkatan'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

