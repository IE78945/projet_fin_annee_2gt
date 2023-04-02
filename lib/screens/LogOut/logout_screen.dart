import 'package:flutter/cupertino.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';

class LogOut extends StatefulWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  State<LogOut> createState() => _LogOutState();

  @override
  void initState(){
    AuthentificationRepository.instance.logout();

  }
}



class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
