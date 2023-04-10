import 'rive_model.dart';

class Menu {
  final int? index ;
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive, this.index});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Requests",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
    index: 0,
  ),

  Menu(
    title: "Commercial service",
    rive: RiveModel(
        src: "assets/RiveAssets/little_icons.riv",
        artboard: "SIGNOUT",
        stateMachineName: "state_machine"),
    index: 1,
  ),


  Menu(
    title: "Technical servise",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
    index: 2,
  ),

  Menu(
    index: 3,
    rive: RiveModel(src: '', artboard: '', stateMachineName: ''),
    title: '',
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
    index: 3,
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
