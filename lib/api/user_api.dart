import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<List<User>> getUsersNIPDSuggestion() async {
    final url = Uri.parse('https://dompetsantri.herokuapp.com/api/user');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) {
        return User(
          nama: json['nama'],
          nipd: json['nipd'],
          pesantren: json['pesantren'],
        );
      }).toList();
      //  . where((user) {
      //   final nipdToLower = user.nipd.toLowerCase();
      //   final queryToLower = query.text.toLowerCase();

      //   return nipdToLower.contains(queryToLower);
      // }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<User>> getUsersPesantrenSuggestion(
      TextEditingValue query) async {
    final url = Uri.parse('https://dompetsantri.herokuapp.com/api/user');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) {
        return User(
          nama: json['nama'],
          nipd: json['nipd'],
          pesantren: json['pesantren'],
        );
      }).where((user) {
        final pesantrenToLower = user.pesantren.toLowerCase();
        final queryToLower = query.text.toLowerCase();

        return pesantrenToLower.contains(queryToLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
