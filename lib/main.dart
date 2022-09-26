import 'package:cashier_tekaja/success_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cashier_tekaja/topup_page.dart';
import 'history_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(App());
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return MainApp();
      },
      name: 'mainApp',
    ),
    GoRoute(
        path: '/success',
        builder: (context, state) {
          return SuccessPayment();
        },
        name: 'successPayment')
  ], initialLocation: '/');

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Chashier Tekaja",
      theme: ThemeData(primarySwatch: Colors.amber),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int index = 0;
  final listOfPages = [
    HomePage(),
    TopUpPage(),
    HistoryPage(),
  ];

  @override
  void didUpdateWidget(covariant MainApp oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    print("main ke build lagi");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.yellow[50],
        body: listOfPages[index],
        bottomNavigationBar: ConvexAppBar(
          items: const [
            TabItem(
              icon: Icons.account_balance,
              title: 'Beranda',
            ),
            TabItem(
              icon: Icons.add_card,
              title: 'TopUp',
            ),
            TabItem(
              icon: Icons.history,
              title: 'Riwayat',
            )
          ],
          style: TabStyle.fixedCircle,
          initialActiveIndex: 0,
          onTap: (int i) {
            setState(() {
              index = i;
            });
          },
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }
}
