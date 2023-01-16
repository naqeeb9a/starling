import 'package:crm_app/globals/globalColors.dart';
import 'package:flutter/material.dart';
import 'package:image_slider/image_slider.dart';
import 'package:image_viewer/image_viewer.dart';

class ImageSliderContainer extends StatefulWidget {
  final int length;
  final List<String> imgUrls;
  ImageSliderContainer({this.length,this.imgUrls});

  @override
  _ImageSliderContainerState createState() => _ImageSliderContainerState();
}

class _ImageSliderContainerState extends State<ImageSliderContainer> with SingleTickerProviderStateMixin {

  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: widget.length, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ImageSlider(
      /// Shows the tab indicating circles at the bottom
      showTabIndicator: false,

      /// Cutomize tab's colors
      tabIndicatorColor: Colors.white.withOpacity(0.6),

      /// Customize selected tab's colors
      tabIndicatorSelectedColor: GlobalColors.globalColor().withOpacity(0.6),

      /// Height of the indicators from the bottom
      tabIndicatorHeight: 6,

      /// Size of the tab indicator circles
      tabIndicatorSize: 6,

      /// tabController for walkthrough or other implementations
      tabController: tabController,

      /// Animation curves of sliding
      curve: Curves.easeIn,

      /// Width of the slider
      width: MediaQuery.of(context).size.width,

      /// Height of the slider
      height: MediaQuery.of(context).size.height * 0.25,

      /// If automatic sliding is required
      autoSlide: true,

      /// Time for automatic sliding
      duration: new Duration(seconds: 20),

      /// If manual sliding is required
      allowManualSlide: true,

      /// Children in slideView to slide
      children: widget.imgUrls.map((String link) {
        return GestureDetector(
          onTap: (){
            ImageViewer.showImageSlider(
              images: widget.imgUrls,
              startingPosition: tabController.index
            );
          },
          child: new ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                link,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.fill,
              )),
        );
      }).toList(),
    );
  }
}
