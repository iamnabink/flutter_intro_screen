import 'package:flutter/material.dart';
import 'package:flutter_intro_screen/flutter_intro_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: introPage());
  }

  Widget introPage() {
    return IntroductionScreen(
      pages:
      getPageViewModelList(['assets/images/splash_image.png', 'assets/images/splash_image2.png']),
      showSkipButton: true,
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
      // skip: Container(decoration: WidgetConstants.kCircularBoxDecoration(100,color: AppColors.colorBlack(0.1)),
      //   child: const Padding(
      //     padding: EdgeInsets.all(4.0),
      //     child: Icon(Icons.clear),
      //   ),),
      skip: const Text('Skip'),
      next: const Text('Next'),
      done: const Text("Done",
          style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
      },

      onSkip: () {
      },
    );
  }

  List<PageViewModel> getPageViewModelList(List<String> imagePath) {
    final List<PageViewModel> imageViews = [];
    for (int i = 0; i < imagePath.length; i++) {
      imageViews.add(_pageViewModel(imagePath[i]));
    }
    return imageViews;
  }

  PageViewModel _pageViewModel(String imagePath) {
    return PageViewModel(
      title: "",
      decoration: PageDecoration(
          boxDecoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage(imagePath), fit: BoxFit.cover))),
      body: "",
    );
  }

}