import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_event.dart';
import 'package:flutter_ecommerce_project/bloc/category/category_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_event.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/screens/card_screen.dart';
import 'package:flutter_ecommerce_project/screens/category_screen.dart';
import 'package:flutter_ecommerce_project/screens/home_screen.dart';
import 'package:flutter_ecommerce_project/screens/profile_screen.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  int selectedBottomNavigationIndex = 3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CustomColors.backgrounScreenColor,
        body: IndexedStack(
          index: selectedBottomNavigationIndex,
          children: getScreens(),
        ),

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
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'SB',
                fontSize: 10,
                color: CustomColors.blue,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'SM',
                fontSize: 10,
                color: Colors.black,
              ),
              currentIndex: selectedBottomNavigationIndex,
              onTap: (int index) {
                setState(() {
                  selectedBottomNavigationIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_profile.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      child:
                          Image.asset('assets/images/icon_profile_active.png'),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(0.0, 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  label: 'حساب کاربری',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_basket.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      child:
                          Image.asset('assets/images/icon_basket_active.png'),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(0.0, 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  label: 'سبد خرید',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_category.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      child:
                          Image.asset('assets/images/icon_category_active.png'),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(0.0, 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  label: 'دسته بندی',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_home.png'),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      child: Image.asset('assets/images/icon_home_active.png'),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(0.0, 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  label: 'خانه',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getScreens() {
    return <Widget>[
      ProfileScreen(),
      BlocProvider(
        create: ((context) {
          var bloc = locator.get<BasketBloc>();
          bloc.add(BasketFetchFromHiveEvent());
          return bloc;
        }),
        child: CardScreen(),
      ),
      BlocProvider(
        create: (context) => CategoryBloc(),
        child: CategoryScreen(),
      ),
      Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) {
            var bloc = HomeBloc();
            bloc.add(HomeGetInitializedData());
            return bloc;
          },
          child: HomeScreen(),
        ),
      ),
    ];
  }
}
