import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Requests",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
  ),

  Menu(
    title: "Commercial service",
    rive: RiveModel(
        src: "assets/RiveAssets/little_icons.riv",
        artboard: "SIGNOUT",
        stateMachineName: "state_machine"),
  ),


  Menu(
    title: "Technical servise",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),
];

List<Menu> sidebarMenus2 = [
  Menu(
    title: "Sign out",
    rive: RiveModel(
      src: "assets/RiveAssets/icons_5.riv",
      artboard: "EXIT",
      stateMachineName: "exitstate",
      //status: SMIBool.fromValue(false),
    ),
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
