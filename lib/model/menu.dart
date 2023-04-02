import 'package:rive/rive.dart';

import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Home",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Search",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity"),
  ),
  Menu(
    title: "Favorites",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "LIKE/STAR",
        stateMachineName: "STAR_Interactivity"),
  ),
  Menu(
    title: "Help",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
  ),
];
List<Menu> sidebarMenus2 = [
  Menu(
    title: "History",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
  ),
  Menu(
    title: "Notifications",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
];

List<Menu> bottomNavItems = [
  Menu(
    title: "Chat",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
  ),

  Menu(
    title: "Commercial",
    rive: RiveModel(
        src: "assets/RiveAssets/little_icons.riv",
        artboard: "SIGNOUT",
        stateMachineName: "state_machine"),
  ),


  Menu(
    title: "Technique",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),

  Menu(
    title: "LogOut",
    rive: RiveModel(
        src: "assets/RiveAssets/icons_5.riv",
        artboard: "EXIT",
        stateMachineName: "exitstate",
        //status: SMIBool.fromValue(false),
        ),
  ),

];
