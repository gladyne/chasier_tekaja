import 'dart:convert';

import 'package:cashier_tekaja/widgets/history_list.dart';
import 'package:cashier_tekaja/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      title: "Chashier Tekaja",
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  void _sendData(String nipd, num amount) async {
    final response = await http.post(
        Uri.parse('https://dompetsantri.herokuapp.com/api/transaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{"nipd": nipd, "amount": amount}));
    final result = json.decode(response.body);
    print(result);
    setState(() {});
  }

  void _startNewTransaction() {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction(_sendData),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 40),
            child: Text(
              'Dompet Santri',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 199,
            width: double.infinity,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basith',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: 16,
                ),
                Text('Saldo:',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
                SizedBox(
                  height: 15,
                ),
                Text('Rp. 5.000.000',
                    style: TextStyle(fontSize: 27, color: Colors.white)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Riwayat terakhir :',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: ListTile(
                    title: Text('Nama'),
                    subtitle: Text('tanggal'),
                    trailing: Text(
                      '- Rp. 10.000',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.payment, title: 'TopUp'),
          TabItem(icon: Icons.history, title: 'History')
        ],
        style: TabStyle.fixed,
      ),
    );
  }
}
