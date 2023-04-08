import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/user_repository.dart';
import 'package:projet_fin_annee_2gt/model/user_model.dart';

import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();

}
// Get user email from firebase athentification and pass it to fetch user details


class _SideBarState extends State<SideBar> {
  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());
  Menu selectedSideMenu = sidebarMenus.first;

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if (email!= null){
      return _userRepo.getUserDetails(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  RiveUtils.chnageSMIBoolState(menu.rive.status!);
                  setState(() {
                    selectedSideMenu = menu;
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
    );
  }
}