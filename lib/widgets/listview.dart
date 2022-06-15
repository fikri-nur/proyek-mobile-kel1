import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/models/peminjam.dart';
import 'package:proyek_uts_flutter/widgets/card.dart';

class MyListView extends StatelessWidget {
  const MyListView({Key? key, required this.users, required this.page})
      : super(key: key);

  final List<Peminjam> users;
  final String page;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, page, arguments: user);
          },
          child: MyCard(nama: user.nama_peminjam, alamat: user.alamat_peminjam, total: user.total,)
        );
      },
    );
  }
}
