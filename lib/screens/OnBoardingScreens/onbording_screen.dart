import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet_fin_annee_2gt/constants.dart';

import '../EntryPoint/EntryPoint.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;


  @override
  void initState(){
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {

                      _pageIndex = index;

                    });
                  } ,
                  itemBuilder: (context,index) => OnboardContent(
                  image: demo_data[index].image,
                  title: demo_data[index].title,
                  description: demo_data[index].description,
                ),),
              ),
              Row(
                children: [
                  ...List.generate(demo_data.length, (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: DotIndicator(isActive: index== _pageIndex,),
                  )),
                  Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: (){
                        if (_pageIndex == demo_data.length - 1) { // check if on the last onboarding screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => EntryPoint()),
                          );
                        } else {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 300), curve: Curves.ease);
                        }

                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Mypink, shape: CircleBorder()),
                      child: SvgPicture.asset("assets/icons/Arrow Right.svg",color: Colors.white,),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key, required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive? 12:4,
      width: 4,
      decoration:  BoxDecoration(
        color: isActive? Mypink: Mypink.withOpacity(0.4),
        borderRadius:  BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Onboard{
  final String image,title,description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
});
}

final List<Onboard> demo_data = [
  Onboard(
      image: "assets/images/OnBoarding1.png",
      title: "Easy & Simple",
      description: "Say goodbye to long wait times and complicated processes.Manage your mobile operator account easily with our app.",
  ),

  Onboard(
    image: "assets/images/OnBoarding2.png",
    title: "Smooth & Hassle-free experience",
    description: "Our app is designed with the highest standards of quality in mind, ensuring a seamless user experience.",
  ),

  Onboard(
    image: "assets/images/OnBoarding3.png",
    title: "Secure",
    description: "Our app employs advanced security measures to protect your privacy and safeguard your data.",
  ),

];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image,title,description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          ),
        const Spacer(),
      ],
    );
  }
}
