import 'dart:convert';

import 'package:flutter/material.dart';
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
  static const List<int> listOfCO = [
    25000,
    50000,
    100000,
    150000,
    200000,
    250000
  ];
  final textFieldData = TextEditingController();
  final groupBtnData = GroupButtonController();

  void _sendData(String nipd, num amount) async {
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
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Your transaction is successful",
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
            margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.05),
            child: TextField(
              controller: textFieldData,
              decoration: InputDecoration(
                labelText: "Another Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: mediaQueryWidth * 0.05),
              child: GroupButton(
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
                      _sendData(widget.nipd,
                          listOfCO[groupBtnData.selectedIndex as int]);
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
              child: Text('CashOut'),
            ),
          )
        ],
      ),
    );
  }
}
