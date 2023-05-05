import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/user_repository.dart';
import 'package:projet_fin_annee_2gt/constants.dart';
import 'package:projet_fin_annee_2gt/model/discussions_model.dart';
import 'package:projet_fin_annee_2gt/model/messages_model.dart';
import 'package:projet_fin_annee_2gt/model/user_model.dart';
import 'package:rive/rive.dart';

class CommercialScreen extends StatefulWidget {
  const CommercialScreen({Key? key}) : super(key: key);

  @override
  State<CommercialScreen> createState() => _CommercialScreenState();
}

class _CommercialScreenState extends State<CommercialScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _ReclamationController = TextEditingController();

  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());
  final _chatRepo = Get.put(ChatRepository());

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
          //Get current userDetails
          UserModel userData = await getUserData();
          // Send data to firestore
          //create new discussion
          final discussion = DiscussionModel(
            type: "Commercial Request",
            lastMessage: _ReclamationController.value.text.trim(),
            lastMessageDate: DateTime.now(),
            isLastMessageSeenByAdmin: false,
            isLastMessageSeenUser: true,
            userId: userData.id.toString(),
            phoneNo: userData.phoneNo,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Commercial Services",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: ,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20,left: 20),
                            child: Text(
                              "Please enter your reclamation ",
                              //textAlign: TextAlign.left,
                              style: ReclamationTextStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20,left: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color:Colors.black, width: 2),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey,
                              child: TextFormField(
                                maxLines:14,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              child: Text("Send"),
                              onPressed: () {
                                send(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Mypink,
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

                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),


              ],
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

