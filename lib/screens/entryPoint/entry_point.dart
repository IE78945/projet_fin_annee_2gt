import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/user_repository.dart';
import 'package:projet_fin_annee_2gt/constants.dart';
import 'package:projet_fin_annee_2gt/model/user_model.dart';
import 'package:projet_fin_annee_2gt/screens/chat/chat_screen.dart';
import 'package:projet_fin_annee_2gt/screens/commercial/commercial_screen.dart';
import 'package:projet_fin_annee_2gt/screens/onboding/onboding_screen.dart';
import 'package:projet_fin_annee_2gt/screens/technical/technical_screen.dart';
import 'package:projet_fin_annee_2gt/utils/rive_utils.dart';
import 'package:rive/rive.dart';

import '../../model/menu.dart';
import 'components/MenuIndex.dart';
import 'components/btm_nav_item.dart';
import 'components/info_card.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';
import 'components/side_menu.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

  late SMIBool isMenuOpenInput;

  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());


  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  void updateSelectedSideNav(Menu menu) {
    if (selectedSideMenu != menu) {
      setState(() {
        selectedSideMenu = menu;
      });
    }
  }

  /*
  int getVariable() {
    return MySingleton().myVariable;
  }
  void setVariable(int value) {
    MySingleton().myVariable = value;
  }
  */

  GotoPage(){
    //setVariable(pageIndex);
    //pageIndex = getVariable();
    if (pageIndex ==  0) return ChatScreen();
    else if (pageIndex ==  1) return CommercialScreen();
    else if (pageIndex ==  2) return TechnicalScreen();
  }

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if (email!= null){
      return _userRepo.getUserDetails(email);
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  late int pageIndex =0;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [

          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: Container(
              width: 288,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF17203A),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: getUserData(),
                      builder: (context,snapshot){
                        if (snapshot.connectionState == ConnectionState.done){
                          if (snapshot.hasData){
                            UserModel userData = snapshot.data as UserModel;
                            return InfoCard(
                              name: userData.firstName,
                              phone: userData.phoneNo,
                            );
                          }
                          else return InfoCard(
                            name: "User Name",
                            phone: "User Number",
                          );
                        }
                        else return InfoCard(
                          name: "User Name",
                          phone: "User Number",
                        );
                      },

                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                      child: Text(
                        "Browse".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white70),
                      ),
                    ),
                    ...sidebarMenus
                        .map((menu) => SideMenu(
                      menu: menu,
                      selectedMenu: selectedSideMenu,
                      press: () {
                        updateSelectedBtmNav(bottomNavItems[menu.index as int]);
                        RiveUtils.chnageSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                          switch (selectedSideMenu.index){
                            case 0 : pageIndex = 0;break;
                            case 1 : pageIndex = 1;break;
                            case 2 : pageIndex = 2;break;
                            default: print ("Noooooooooooooooooooooooooooooooo");break;
                          }
                        });
                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    ))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                      child: Text(
                        "Account".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white70),
                      ),
                    ),

                    ...sidebarMenus2
                        .map((menu) => SideMenu(
                      menu: menu,
                      selectedMenu: selectedSideMenu,
                      press: () {
                        RiveUtils.chnageSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                          AuthentificationRepository.instance.logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                          );
                        });

                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    ))
                        .toList(),


                  ],
                ),
              ),
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child:  ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: GotoPage(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(
                  () {
                    isSideBarOpen = !isSideBarOpen;
                  },
                );
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(
                    artboard, "State Machine");

                artboard.addController(controller!);

                isMenuOpenInput =
                    controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                  (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                        updateSelectedBtmNav(navBar);
                        updateSelectedSideNav(sidebarMenus[index]);
                        switch (index){
                          case 0 : pageIndex = 0;break;
                          case 1 : pageIndex = 1;break;
                          case 2 : pageIndex = 2;break;
                          case 3 : pageIndex = 3 ; {AuthentificationRepository.instance.logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                          );
                          };break;
                          default: print ("Noooooooooooooooooooooooooooooooo");break;
                        }
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: navBar.rive.stateMachineName);

                      },
                      selectedNav: selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
