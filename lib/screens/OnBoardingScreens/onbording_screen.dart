import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:projet_fin_annee_2gt/constants.dart';
import 'package:projet_fin_annee_2gt/screens/EntryPoint/EntryPoint.dart';
import 'package:projet_fin_annee_2gt/screens/OnBoardingScreens/model_onbording.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final LiquidController controller = LiquidController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pages = [
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: tOnBoardingImage1,
          title: tOnBoardingTitle1,
          subTitle: tOnBoardingSubTitle1,
          counterText: tOnBoardingCounter1,
          height: size.height,
          bgcolor: tOnBoardingPage1Color,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: tOnBoardingImage2,
          title: tOnBoardingTitle2,
          subTitle: tOnBoardingSubTitle2,
          counterText: tOnBoardingCounter2,
          height: size.height,
          bgcolor: tOnBoardingPage2Color,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: tOnBoardingImage3,
          title: tOnBoardingTitle3,
          subTitle: tOnBoardingSubTitle3,
          counterText: tOnBoardingCounter3,
          height: size.height,
          bgcolor: tOnBoardingPage3Color,
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: pages,
            enableSideReveal: true,
            liquidController: controller,
            onPageChangeCallback: onPageChangedCallback,
            slideIconWidget: Icon(Icons.arrow_back_ios),
          ),
          Positioned(
            bottom: 60.0,
            child: OutlinedButton(
              onPressed: () {
                if (controller.currentPage==2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EntryPoint()),
                  );
                }
                else {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
                }

              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                foregroundColor: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xff272727),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          if (controller.currentPage!=2) // if we are not at the final page display skip text button
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () => controller.jumpToPage(page: 2),
                child: const Text(
                  'skip',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count: 3,
              effect: const WormEffect(
                activeDotColor: Color(0xff272727),
                dotHeight: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void onPageChangedCallback(int activePageIndex) {
    if (controller.currentPage == 2) {
      // we are on the last page
      if (activePageIndex == 1) {
        // user is trying to go to the previous page using slideIconWidget
        int previousPage = controller.currentPage - 1;
        controller.animateToPage(page: 1);

        print(currentPage);
      } else {
        // user is on the last page and not trying to go to the previous page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EntryPoint()),
        );
      }
    }
    else {
      // user is not on the last page
      setState(() {});
    }
  }




}

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: model.bgcolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage(model.image),height: model.height*0.4,),
          Column(
            children: [
              Text(model.title, style: Theme.of(context).textTheme.displaySmall,),
              Text(model.subTitle, textAlign: TextAlign.center,),
            ],
          ),

          Text(model.counterText,style: Theme.of(context).textTheme.titleSmall,),
          SizedBox(height: 120.0,),
        ],
      ),
    );
  }
}

