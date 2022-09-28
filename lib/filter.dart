import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Filter extends StatefulWidget {
  final Function filterHandler;

  Filter(this.filterHandler);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  DateTime date = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String startDateFormatDisplay = "";
  String endDateFormatDisplay = "";

  final inputName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: mediaQueryHeight * 0.01,
            ),
            const Text(
              "Filter",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2022),
                      lastDate: date,
                    ).then((seletedDate) {
                      if (seletedDate != null) {
                        setState(
                          () {
                            startDate = seletedDate;
                            startDateFormatDisplay =
                                DateFormat('d-MMM-y').format(seletedDate);
                          },
                        );
                      }
                    });
                  },
                  child: startDateFormatDisplay.isEmpty
                      ? const Text("Tanggal Awal")
                      : Text(startDateFormatDisplay),
                ),
                OutlinedButton(
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2022),
                      lastDate: date,
                    ).then((seletedDate) {
                      if (seletedDate != null) {
                        setState(
                          () {
                            endDate = seletedDate;
                            endDateFormatDisplay =
                                DateFormat('d-MMM-y').format(seletedDate);
                          },
                        );
                      }
                    });
                  },
                  child: endDateFormatDisplay.isEmpty
                      ? const Text("Tanggal Akhir")
                      : Text(endDateFormatDisplay),
                )
              ],
            ),
            Container(
              height: mediaQueryHeight * 0.1,
              margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
              child: TextField(
                controller: inputName,
                decoration: InputDecoration(
                  labelText: "Cari berdasarkan nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            // Container(
            //   height: mediaQueryHeight * 0.1,
            //   margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
            //   child: TextField(
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       labelText: "Cari berdasarkan kelas",
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(25),
            //       ),
            //     ),
            //   ),
            // ),
            ElevatedButton(
                onPressed: () {
                  // if (inputName.text.isEmpty) {
                  //   if (!(DateTime.now().hour == startDate.hour)) {
                  //     if (!(DateTime.now().day == endDate.day)) {
                  //       print('Waktu filter');
                  //       widget.filterHandler(startDate, endDate);
                  //     }
                  //   }
                  // } else {
                  //   print(inputName.text);
                  //   if (DateTime.now().hour == startDate.hour) {
                  //     if (DateTime.now().day == endDate.day) {
                  //       print('filtername');
                  //       widget.filterNameHandler(inputName.text);
                  //     }
                  //   } else {
                  //     print(startDate.hour);
                  //     print(DateTime.now().hour);
                  //     print("Not Ok");
                  //   }
                  // }

                  widget.filterHandler(inputName.text, startDate, endDate);

                  // print(endDate);
                  // widget.filterHandler(startDate, endDate);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Filter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
