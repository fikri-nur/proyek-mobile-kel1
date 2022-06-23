import 'package:cloud_firestore/cloud_firestore.dart';

class Peminjam {
  final String id;
  final String ref_user_id;
  final String nama_peminjam;
  final String alamat_peminjam;
  final double total;
  final DateTime created_at;

  Peminjam({
    required this.id,
    required this.ref_user_id,
    required this.nama_peminjam,
    required this.alamat_peminjam,
    required this.total,
    required this.created_at,
  });

  static Peminjam fromJson(Map<String, dynamic> json) {
    return Peminjam(
      id: json["id"],
      ref_user_id: json['ref_user_id'],
      nama_peminjam: json["nama_peminjam"],
      alamat_peminjam: json["alamat_peminjam"],
      total: json["total"],
      created_at: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'ref_user_id': ref_user_id,
      "nama_peminjam": nama_peminjam,
      "alamat_peminjam": alamat_peminjam,
      'total': total,
      'created_at': created_at,
    };
  }
}
