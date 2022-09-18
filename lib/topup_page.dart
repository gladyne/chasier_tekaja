import 'package:cashier_tekaja/api/user_api.dart';
import 'package:cashier_tekaja/models/user.dart';
import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  @override
  final dataInput = TextEditingController();

  static String _displayUseName(User option) => option.nipd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TopUp',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Text('coba'),
        SizedBox(
          height: 20,
        ),
        Autocomplete<User>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<User>.empty();
            }
            return UserApi.getUsersNIPDSuggestion(textEditingValue);
          },
          displayStringForOption: _displayUseName,
          // fieldViewBuilder: (BuildContext context,
          //     TextEditingController textDecoration,
          //     FocusNode fieldFocus,
          //     VoidCallback onFieldSubmmited) {
          //   return TextField(
          //     controller: dataInput,
          //   );
          // },
        ),
        ElevatedButton(
            onPressed: () {
              print(dataInput.text);
            },
            child: Text('TopUp'))
      ],
    );
  }
}
