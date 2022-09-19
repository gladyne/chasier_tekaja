import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class CashOutPage extends StatefulWidget {
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
            child: FittedBox(
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
                'Nama',
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
              )),
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
                print("textfield : ${textFieldData.text}");
                print(
                    "groupbtn : ${listOfCO[groupBtnData.selectedIndex as int]}");
              },
              child: Text('CashOut'),
            ),
          )
        ],
      ),
    );
  }
}
