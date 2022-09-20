import 'dart:convert';

import 'package:cashier_tekaja/api/user_api.dart';
import 'package:cashier_tekaja/cash_out.dart';
import 'package:cashier_tekaja/models/user.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:http/http.dart' as http;

class TopUpPage extends StatefulWidget {
  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  @override
  TextEditingController dataInput = TextEditingController();

  static String _displayUseName(User option) => option.nipd;

  static const List<int> listOfCO = [
    25000,
    50000,
    100000,
    150000,
    200000,
    250000
  ];

  final groupBtnData = GroupButtonController();
  final textFieldData = TextEditingController();

  void _topUp(String nipd, num amount) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      autoCloseDuration: Duration(seconds: 1),
    );
    final url = Uri.parse('https://dompetsantri.herokuapp.com/api/topup');
    final response = await http.post(url,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: mediaQueryWidth / 3,
          child: const FittedBox(
            child: Text(
              'TopUp',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: mediaQueryHeight * 0.02,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
          child: Autocomplete<User>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<User>.empty();
              }
              return UserApi.getUsersNIPDSuggestion(textEditingValue);
            },
            displayStringForOption: _displayUseName,
            fieldViewBuilder: (BuildContext context,
                TextEditingController textDecoration,
                FocusNode fieldFocus,
                VoidCallback onFieldSubmmited) {
              dataInput = textDecoration;
              return TextField(
                controller: textDecoration,
                focusNode: fieldFocus,
                decoration: InputDecoration(
                  labelText: "Please fill NIPD",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: mediaQueryHeight * 0.02,
        ),
        Container(
          height: mediaQueryHeight * 0.1,
          margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
          child: TextField(
            controller: textFieldData,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Another Amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(),
              ),
            ),
          ),
        ),
        Container(
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
        SizedBox(
          height: mediaQueryHeight * 0.03,
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
          child: ElevatedButton(
            onPressed: () {
              int count = 0;
              if (dataInput.text.isEmpty) {
                return;
              } else {
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
                        _topUp(dataInput.text, num.parse(textFieldData.text));
                      }
                    } else {
                      _topUp(dataInput.text,
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
              }
            },
            child: Text('TopUp'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
