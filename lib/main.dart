import 'package:admin_side_fashop/view/admin_screen.dart';
import 'package:admin_side_fashop/view/spalsh_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'components/constants.dart';
import 'controller/cash_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CashHelper.init();
  uId = CashHelper.getData(key: 'uId');
  runApp(const AdminFaShop());
}

class AdminFaShop extends StatelessWidget {
  const AdminFaShop({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin FaShop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: uId == null ? const SplashScreen() : const AdminScreen(),
    );
  }
}

