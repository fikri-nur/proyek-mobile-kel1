import 'package:cloud_firestore/cloud_firestore.dart';

class HutangPiutang {
  final String id;
  final String ref_peminjam_id;
  final String status;
  final double nominal;
  final String deskripsi;
  final DateTime created_at;

  HutangPiutang({
    required this.id,
    required this.ref_peminjam_id,
    required this.status,
    required this.nominal,
    required this.deskripsi,
    required this.created_at,
  });

  static HutangPiutang fromJson(Map<String, dynamic> json) {
    return HutangPiutang(
      id: json["id"],
      ref_peminjam_id: json['ref_peminjam_id'],
      status: json['status'],
      nominal: json["nominal"],
      deskripsi: json["deskripsi"],
      created_at: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'ref_peminjam_id': ref_peminjam_id,
      'status': status,
      "nominal": nominal,
      "deskripsi": deskripsi,
      'created_at': created_at,
    };
  }
}
