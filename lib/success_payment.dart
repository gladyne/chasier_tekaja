import 'package:cashier_tekaja/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'current_formatter.dart';

class SuccessPayment extends StatelessWidget {
  final String name;
  final String method;
  final int paid;
  final int total;

  SuccessPayment(this.name, this.method, this.paid, this.total);

  @override
  Widget build(BuildContext context) {
    final paidRpFormat = CurrencyFormat.convertToIdr(paid, 0);
    final totalRpFormat = CurrencyFormat.convertToIdr(total, 0);
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text("Success Payment"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: mediaQueryHeight / 2.5,
            margin: EdgeInsets.only(
              top: mediaQueryHeight * 0.1,
              left: mediaQueryWidth * 0.1,
              right: mediaQueryWidth * 0.1,
            ),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/images/checklist.jpeg'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Color.fromRGBO(46, 204, 113, 1),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          "${method} Berhasil",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Sebesar : ${paidRpFormat}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "Nama : ${name}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Kelas",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "Total saldo: $totalRpFormat",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Terimakasih telah melakukan transaksi pada Dompet Santri",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.1),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Color.fromRGBO(46, 204, 113, 1),
                  side: BorderSide(
                    width: 2,
                    color: Color.fromRGBO(46, 204, 113, 1),
                  )),
              onPressed: () {
                context.goNamed('mainApp');
              },
              child: Text(
                "Tutup",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
