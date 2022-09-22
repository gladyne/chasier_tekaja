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
  late DateTime startDate;
  late DateTime endDate;
  String startDateFormatDisplay = "";
  String endDateFormatDisplay = "";

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: mediaQueryHeight * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Filter"),
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
                    ? Text("Tanggal Awal")
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
                    ? Text("Tanggal Akhir")
                    : Text(endDateFormatDisplay),
              )
            ],
          ),
          Container(
            height: mediaQueryHeight * 0.1,
            margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cari berdasarkan nama",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Container(
            height: mediaQueryHeight * 0.1,
            margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth / 8),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cari berdasarkan kelas",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                widget.filterHandler(startDate, endDate);
                Navigator.of(context).pop();
              },
              child: Text("Filter"))
        ],
      ),
    );
  }
}
