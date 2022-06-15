import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.nama,
    required this.alamat,
    required this.total,
  }) : super(key: key);

  final String nama;
  final String alamat;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF5DB075),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
          title: Text(nama),
          subtitle: Text(total,
          ),
          trailing: SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          )),
    );
  }
}
