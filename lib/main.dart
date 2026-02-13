import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_project/data/model/card_item.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/screens/dashbord_screen.dart';
import 'package:flutter_ecommerce_project/screens/login_screen.dart';
import 'package:flutter_ecommerce_project/util/auth_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BasketItemAdapter());
  await Hive.openBox<BasketItem>('CardBox');
  await getItInit();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedBottomNavigationIndex = 3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey,
      home: (AuthManager.readAuth().isEmpty) ? LoginScreen() : DashbordScreen(),
    );
  }
}

 // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //         onPressed: () async {
      //           var either = await AuthenticationRepository()
      //               .login('Mobina', '12345678');
      //           // var shared = locator.get<SharedPreferences>();
      //           // print(shared.getString('access_token'));
      //           // either.fold((errorMessage) {
      //           //   print(errorMessage);
      //           // }, (successMessage) {
      //           //   print(successMessage);
      //           // });
      //         },
      //         child: Text('Login')),
      //     ElevatedButton(
      //       onPressed: () async {
      //         AuthManager.logOut();
      //       },
      //       child: Text('LogOut'),
      //     ),
      //     ValueListenableBuilder(
      //         valueListenable: AuthManager.authChangeNotifier,
      //         builder: ((context, value, child) {
      //           if (value == null || value.isEmpty) {
      //             return Text(
      //               'شما وارد نشده اید',
      //               style: TextStyle(
      //                 fontFamily: 'SB',
      //                 fontSize: 15,
      //                 color: CustomColors.blue,
      //               ),
      //             );
      //           } else {
      //             return Text(
      //               'شما وارد شده اید',
      //               style: TextStyle(
      //                 fontFamily: 'SB',
      //                 fontSize: 15,
      //                 color: CustomColors.blue,
      //               ),
      //             );
      //           }
      //         }))
      //   ],
      // ),