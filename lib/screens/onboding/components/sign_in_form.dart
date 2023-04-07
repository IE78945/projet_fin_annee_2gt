import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/screens/entryPoint/entry_point.dart';
import 'package:projet_fin_annee_2gt/screens/onboding/components/forgot_password_dialog.dart';
import 'package:rive/rive.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _PasswordController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  bool isShowForgotPasswordDialog = false;

  bool _isObscure = true;

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

  void signIn(BuildContext context) {

    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
          () {
        if (_formKey.currentState!.validate()) {
          //si les champs sont validées alors vérifier phone number and devise
          TruecallerSdk.initializeSDK(
              sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP,
              footerType: TruecallerSdkScope.FOOTER_TYPE_NONE,
              buttonColor: 0xFFF77D8E,
          );
          TruecallerSdk.isUsable.then((isUsable) {
            if (isUsable) {
              TruecallerSdk.getProfile;
            } else {
              final snackBar = SnackBar(content: Text("Not Usable"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print("***Not usable***");
            }
          });
          TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) async {
            switch (truecallerSdkCallback.result) {
            //If Truecaller user and has Truecaller app on his device, you'd directly get the Profile
              case TruecallerSdkCallbackResult.success:
                {
                    String firstName = truecallerSdkCallback.profile!.firstName;
                  String? lastName = truecallerSdkCallback.profile!.lastName;
                  //Get device phone number
                  String phNo = truecallerSdkCallback.profile!.phoneNumber;
                  print("**********************************firstName: " +
                      firstName + "\t phNO:" + phNo);

                  // login user in firebase
                  Future<bool> isLoggedIn;
                  isLoggedIn = AuthentificationRepository.instance
                      .LoginUserWithEmailAndPassword(_emailController.text.trim(),
                      _PasswordController.text.trim());

                  if (await isLoggedIn) {
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
                          // Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EntryPoint(),
                            ),
                          );
                        });
                      },
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
                  }
                }
                break;

              case TruecallerSdkCallbackResult.failure:
                {
                  String errorCode = truecallerSdkCallback.error!.message
                      .toString();
                  print("--------------------------------NO!" +
                      errorCode.toString());
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
                }
                break;

              default:
                print("Invalid result 2 ");
            }
          });


        }
        else {
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
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //Email
                const Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                  ),
                ),

                // password
                const Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0),
                  child: TextFormField(
                    obscureText: _isObscure,
                    controller: _PasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                        return 'Please enter a valid password';
                      }
                      return null; // Return null if the input is valid
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: _isObscure ? Colors.grey : Color(0xFFF77D8E),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                //forgot password
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        //show forgot password dialog
                        Future.delayed(
                          const Duration(milliseconds: 800),
                              () {
                            setState(() {
                              isShowForgotPasswordDialog = true;
                            });
                            showForgotPasswordCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowForgotPasswordDialog = false;
                                });
                              },
                            );
                          },
                        );
                      },
                      child: Text("Forgot password?",style: TextStyle(
                        color: Colors.black54,
                      ),),
                    ),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      signIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
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
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Color(0xFFFE0037),
                    ),
                    label: const Text("Sign In"),
                  ),
                ),
              ],
            ),
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
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
