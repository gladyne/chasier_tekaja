import 'package:flutter/material.dart';

class SuccessPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Success Payment"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Pembayaran Berhasil",
            style: TextStyle(fontSize: 30),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Tutup",
            ),
          ),
        ],
      ),
    );
  }
}
