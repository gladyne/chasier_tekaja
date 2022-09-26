import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              context.goNamed('mainApp');
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
