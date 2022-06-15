import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyek_uts_flutter/widgets/formatMataUang.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _peminjam =
      FirebaseFirestore.instance.collection('peminjam').orderBy("nama_peminjam").snapshots();

  int decimalDigit = 2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _peminjam,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                    color: Color(0xFF5DB075),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person),
                        ),
                        title: Text(data['nama_peminjam']),
                        subtitle:
                            Text(FormatMataUang.convertToIdr(data['total'], 2)),
                        // Text(data['total'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await deleteData(document);
                                },
                              ),
                            ],
                          ),
                        )));
              })
              .toList()
              .cast(),
        );
      },
    );
  }

  Future<void> deleteData(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection('peminjam')
        .doc(doc.id)
        .delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Berhasil Menghapus Data')));
  }
}
