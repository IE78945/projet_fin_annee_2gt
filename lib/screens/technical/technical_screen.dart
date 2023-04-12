import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/user_repository.dart';
import 'package:projet_fin_annee_2gt/model/discussions_model.dart';
import 'package:projet_fin_annee_2gt/model/messages_model.dart';
import 'package:projet_fin_annee_2gt/model/user_model.dart';
import 'package:projet_fin_annee_2gt/screens/chat/chat_screen.dart';
import 'package:rive/rive.dart';

class TechnicalScreen extends StatefulWidget {
  const TechnicalScreen({Key? key}) : super(key: key);

  @override
  State<TechnicalScreen> createState() => _TechnicalScreenState();
}

class _TechnicalScreenState extends State<TechnicalScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _ReclamationController = TextEditingController();

  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());
  final _chatRepo = Get.put(ChatRepository());

  final _SimList = ["SIM 1" , "SIM 2"];
  String _selectedSIM = "SIM 1";
  final _IssueList = ["2G (GSM)" , "3G (CDMA)" , "4G (LTE)"];
  String _selectedIssue = "2G (GSM)";
  Map<String,String> cellInfo = new Map<String, String>();
  String generation ="";
  static const CellInfoChannel = MethodChannel('com.example.projet_fin_annee_2gt/cell_info');

  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  getUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email!= null){
      return await _userRepo.getUserDetails(email);
    }
  }

  void send(BuildContext context) {

    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
          () async {
        if (_formKey.currentState!.validate()) {
          await [
            Permission.phone,
            Permission.location,
          ].request();

          //ckek if we have permissions
          if (await Permission.phone.request().isGranted && await Permission.location.request().isGranted ) {
            // Either the permission was already granted before or the user just granted it.
              //check if locaton is enabeled
              bool isLocationServiceEnabled = await _checkLocationServiceEnabled();
              if (isLocationServiceEnabled) {
                // Get Phone Data
                await GetPhoneData();
                // Get Location
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                var Latitude = position.latitude;
                var Longitude = position.longitude;
                // Create a GeoPoint with latitude and longitude
                GeoPoint point = GeoPoint(Latitude, Longitude);

                //Get current userDetails
                UserModel userData = await getUserData();

                // Send data to firestore
                  //create new discussion
                  final discussion = DiscussionModel(
                    type: "Technical Request",
                    lastMessage: _ReclamationController.value.text.trim(),
                    lastMessageDate: DateTime.now(),
                    isLastMessageSeenByAdmin: false,
                    isLastMessageSeenUser: true,
                    phoneNo: userData.phoneNo,
                    userId: userData.id.toString(),
                    generation: generation,
                  );
                  String DiscussionID = await _chatRepo.createDiscussion(discussion);
                  //if user data has been stored in firestore successfully
                  if (DiscussionID !="") {
                    //Discussion is created successfully
                        // Add new message
                        final message = MessageModel(
                            senderId: userData.id.toString(),
                            sentDate: DateTime.now(),
                            message:  _ReclamationController.value.text.trim(),
                            status: "not seen" ,
                            phoneData: cellInfo,
                            location: point,
                        );
                        bool isMessageCreated = await _chatRepo.addMessage(message, DiscussionID);
                        if (isMessageCreated){
                          // show success animation
                          success.fire();
                          Future.delayed(
                            const Duration(seconds: 2),
                                () {
                              setState(() {
                                isShowLoading = false;
                              });
                              confetti.fire();
                              // Navigate & hide confetti
                              Future.delayed(const Duration(seconds: 1), () {
                                // ................do something


                              });
                            },
                          );
                          Get.snackbar(
                            "success",
                            "Your reclamation has been sent successfully.",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white.withOpacity(0.7),
                            colorText: Colors.green,
                          );
                        }
                        else {
                          // show failure animation
                          error.fire();
                          Future.delayed(
                            const Duration(seconds: 2),
                                () {
                              setState(() {
                                isShowLoading = false;
                              });
                              reset.fire();
                            },
                          );
                          Get.snackbar(
                            "Error",
                            "Something went wrong. Please retry later.",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white.withOpacity(0.7),
                            colorText: Colors.red,
                          );
                        }
                  }
                  else {
                    // show failure animation
                    error.fire();
                    Future.delayed(
                      const Duration(seconds: 2),
                          () {
                        setState(() {
                          isShowLoading = false;
                        });
                        reset.fire();
                      },
                    );
                    Get.snackbar(
                      "Error",
                      "Something went wrong. Please retry later.",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.white.withOpacity(0.7),
                      colorText: Colors.red,
                    );
                  }
              }
              else {
                // location button is disabled
                  //show failure animation
                  error.fire();
                  Future.delayed(
                    const Duration(seconds: 2),
                        () {
                      setState(() {
                        isShowLoading = false;
                      });
                      reset.fire();
                    },
                  );
                  //show snack bar
                  Get.snackbar(
                    "Error",
                    "Please enable location service (GPS)",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    colorText: Colors.red,
                  );
              }

          }
          else {
            //Permissions are not granted
                //show failure animation
                error.fire();
                Future.delayed(
                  const Duration(seconds: 2),
                      () {
                    setState(() {
                      isShowLoading = false;
                    });
                    reset.fire();
                  },
                );
                //show snack bar
                Get.snackbar(
                  "Error",
                  "Please grant permissions to send your reclamation",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  colorText: Colors.red,
                );
          }
        }
        else {
          //if form is invalid
              //show failuare animation
              error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                    () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                },
              );
              //show snack bar
              Get.snackbar(
                "Error",
                "Please describe your problem",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.white.withOpacity(0.7),
                colorText: Colors.red,
              );
        }
      },
    );
  }


  Future<bool> _checkLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    return true;
  }


  Future GetPhoneData() async{
    var arguments ;
    if (_selectedSIM == "SIM 1") {arguments = {'RX' : 0};}
    else  { arguments = {'RX' : 1 }; }

    final Map<dynamic,dynamic> newCellInfo = await CellInfoChannel.invokeMethod("getCellInfo",arguments);
    setState(() {
      cellInfo = newCellInfo.cast<String, String>() ;
      generation = newCellInfo['phoneType'];
    });
  }

  _TechnicalScreenState(){
    _selectedSIM = _SimList[0];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Technical Services",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: FutureBuilder(
                              future: getUserData(),
                              builder: (context,snapshot){
                                if (snapshot.connectionState == ConnectionState.done){
                                  if (snapshot.hasData){
                                    UserModel userData = snapshot.data as UserModel;
                                    return Text(
                                      "Please choose your SIM corresponding to your phone number "+userData.phoneNo,
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                }
                                return Text(
                                "Please choose your SIM corresponding to your phone number",
                                textAlign: TextAlign.center,
                                );
                              }
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: DropdownButtonFormField(
                            value: _selectedSIM,
                            items: _SimList.map(
                                    (e) =>DropdownMenuItem(child: Text(e), value: e,)
                            ).toList(),
                            onChanged: (val){
                              setState(() {
                                _selectedSIM = val as String;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Color(0xFF6792FF),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Please select Your connectivity issue",
                              textAlign: TextAlign.center,
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: DropdownButtonFormField(
                            value: _selectedIssue,
                            items: _IssueList.map(
                                    (e) =>DropdownMenuItem(child: Text(e), value: e,)
                            ).toList(),
                            onChanged: (val){
                              setState(() {
                                _selectedIssue = val as String;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Color(0xFF6792FF),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 20,left: 20),
                          child: TextFormField(
                            maxLines:10,
                            keyboardType: TextInputType.multiline,
                            controller: _ReclamationController,
                            validator: (value) {
                              if (value!.isEmpty ) {
                                return "Please enter a your reclamation";
                              }
                              return null;
                            },
                            decoration: InputDecoration(

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            child: Text("Send"),
                            onPressed: () {
                              send(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6792FF),
                              minimumSize: const Size(double.infinity, 56),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      cellInfo.toString(),
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
            isShowLoading
                ? CustomPositioned(
              child: RiveAnimation.asset(
                'assets/RiveAssets/check.riv',
                fit: BoxFit.cover,
                onInit: _onCheckRiveInit,
              ),
            )
                : const SizedBox(),
            isShowConfetti
                ? CustomPositioned(
              scale: 6,
              child: RiveAnimation.asset(
                "assets/RiveAssets/confetti.riv",
                onInit: _onConfettiRiveInit,
                fit: BoxFit.cover,
              ),
            )
                : const SizedBox(),
          ],
        ),

      ),
    );
  }

}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
