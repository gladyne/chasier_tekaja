import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cashier_tekaja/topup_page.dart';
import 'history_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chashier Tekaja",
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final listOfPages = [
    HomePage(),
    TopUpPage(),
    HistoryPage(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listOfPages[index],
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(
            icon: Icons.account_balance,
            title: 'Home',
          ),
          TabItem(
            icon: Icons.add_card,
            title: 'TopUp',
          ),
          TabItem(
            icon: Icons.history,
            title: 'History',
          )
        ],
        style: TabStyle.react,
        initialActiveIndex: 0,
        onTap: (int i) {
          setState(() {
            index = i;
          });
        },
      ),
    );
  }
}
