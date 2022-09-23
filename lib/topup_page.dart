import 'dart:convert';

import 'package:cashier_tekaja/api/user_api.dart';
import 'package:cashier_tekaja/cash_out.dart';
import 'package:cashier_tekaja/models/user.dart';
import 'package:cashier_tekaja/success_payment.dart';
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
  late List<User> getDataNama;
  String nipd = "";

  static String _displayUseName(User option) => option.nama;

  void _fetchData() async {
    final url = Uri.parse('`https://dompetsantri.herokuapp.com/api/user`');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      getDataNama = data.map((json) {
        User(
          nama: json['nama'],
          nipd: json['nipd'],
          pesantren: json['pesantren'],
        );
      }).toList() as List<User>;

      //  . where((user) {
      //   final nipdToLower = user.nipd.toLowerCase();
      //   final queryToLower = query.text.toLowerCase();

      //   return nipdToLower.contains(queryToLower);
      // }).toList();
    } else {
      throw Exception();
    }
  }

  static const List<String> listOfCO = [
    "Rp. 50.000 ",
    "Rp. 100.000",
    "Rp. 150.000",
    "Rp. 200.000",
    "Rp. 250.000",
    "Rp. 300.000"
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) {
            return SuccessPayment();
          },
        ),
      );
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.success,
      //   text: "Your transaction is successful",
      //   onConfirmBtnTap: () {
      //     Navigator.of(context).pop();
      //   },
      // );
    }
  }

  void _anotherFetch() async {
    getDataNama = await UserApi.getUsersNIPDSuggestion();
    print(getDataNama[0].nama);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
    _anotherFetch();
    // print(getDataNama);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: mediaQueryHeight / 6),
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
                // return getDataNama.where((element) {
                //   return element.nama
                //       .toLowerCase()
                //       .contains(textEditingValue.text.toLowerCase());
                // });
                return getDataNama.where((element) {
                  return element.nama
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
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
                    labelText: "Isi Data Santri",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(),
                    ),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<User> onSelected,
                  Iterable<User> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: Container(
                      width: 300,
                      color: Colors.amber,
                      child: ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final User option = options.elementAt(index);

                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text("${option.nama}"),
                              trailing: Text("${option.nipd}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (User selected) {
                nipd = selected.nipd;
                // print("${selected.nipd}");
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
                prefix: Text("Rp. "),
                labelText: "Jumlah lain",
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
          SizedBox(
            height: mediaQueryHeight * 0.03,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
            child: ElevatedButton(
              onPressed: () {
                int count = 0;
                if (nipd.isEmpty) {
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
                              text: "Can't Assign zero to lower");
                        } else {
                          _topUp(nipd, num.parse(textFieldData.text));
                        }
                      } else {
                        num selected = num.parse(
                          listOfCO[groupBtnData.selectedIndex as int]
                              .replaceAll(RegExp('[^0-9]'), ''),
                        );
                        _topUp(nipd, selected);
                      }
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: "Failed",
                        text: "Please chose one Another amount or pick",
                      );
                    }
                  }
                }
              },
              child: Text('TopUp',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
