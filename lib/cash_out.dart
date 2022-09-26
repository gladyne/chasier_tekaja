import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';

class CashOutPage extends StatefulWidget {
  final String namaUser;
  final String nipd;

  CashOutPage(this.namaUser, this.nipd);

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  static const List<String> listOfCO = [
    "Rp. 50.000 ",
    "Rp. 100.000",
    "Rp. 150.000",
    "Rp. 200.000",
    "Rp. 250.000",
    "Rp. 300.000"
  ];
  final textFieldData = TextEditingController();
  final groupBtnData = GroupButtonController();

  void _sendData(String nipd, num amount) async {
    print(amount);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      autoCloseDuration: Duration(seconds: 1),
    );
    final response = await http.post(
        Uri.parse('https://dompetsantri.herokuapp.com/api/cashout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{"nipd": nipd, "amount": amount}));

    if (response.statusCode == 201) {
      final result = json.decode(response.body);
      Future.delayed(Duration(seconds: 1));
      context.goNamed('successPayment');
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.success,
      //   text: "Your transaction is successful",
      //   onConfirmBtnTap: () {
      //     Navigator.of(context).pop();
      //   },
      // );
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('CashOut'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: mediaQueryHeight * 0.04,
              margin: EdgeInsets.only(
                left: mediaQueryWidth * 0.05,
                top: mediaQueryHeight * 0.02,
              ),
              child: const FittedBox(
                child: Text(
                  'Cash Out Santri',
                ),
              ),
            ),
            SizedBox(
              height: mediaQueryHeight * 0.01,
            ),
            Container(
              height: mediaQueryHeight * 0.05,
              margin: EdgeInsets.only(left: mediaQueryWidth * 0.05),
              child: FittedBox(
                child: Text(
                  widget.namaUser,
                ),
              ),
            ),
            SizedBox(
              height: mediaQueryHeight * 0.05,
            ),
            Container(
              height: mediaQueryHeight * 0.1,
              margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
              child: TextField(
                controller: textFieldData,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefix: Text("Rp. "),
                  labelText: "Jumlah lain",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            // Container(
            //   height: mediaQueryHeight * 0.1,
            //   margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.05),
            //   child: TextField(
            //     controller: textFieldData,
            //     decoration: InputDecoration(
            //       labelText: "Another Amount",
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(25),
            //         borderSide: BorderSide(),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mediaQueryWidth * 0.05),
                child: GroupButton(
                  enableDeselect: true,
                  controller: groupBtnData,
                  buttons: listOfCO,
                  options: GroupButtonOptions(
                    borderRadius: BorderRadius.circular(25),
                    mainGroupAlignment: MainGroupAlignment.center,
                    crossGroupAlignment: CrossGroupAlignment.center,
                    groupRunAlignment: GroupRunAlignment.start,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  int count = 0;
                  if (textFieldData.text.isEmpty &&
                      groupBtnData.selectedIndex == null) {
                    return;
                  } else {
                    if (!textFieldData.text.isEmpty) {
                      count++;
                    }
                    if (!(groupBtnData.selectedIndex == null)) {
                      count++;
                    }
                    if (count < 2) {
                      if (!textFieldData.text.isEmpty) {
                        num topUpValue = num.parse(textFieldData.text);
                        if (topUpValue <= 0) {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: "Failed",
                              text: "Can't Assing zero to lower");
                        } else {
                          _sendData(widget.nipd, num.parse(textFieldData.text));
                        }
                      } else {
                        print("pilihabn");
                        num selected = num.parse(
                          listOfCO[groupBtnData.selectedIndex as int]
                              .replaceAll(RegExp('[^0-9]'), ''),
                        );
                        print(widget.nipd);
                        _sendData(widget.nipd, selected);
                      }
                    } else {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: "Failed",
                          text: "Please chose one Another amount or pick");
                    }
                  }
                },
                child: Text(
                  'CashOut',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
