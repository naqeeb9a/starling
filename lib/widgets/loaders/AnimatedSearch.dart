import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedSearch extends StatelessWidget {
  const AnimatedSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator()  /*Lottie.asset(
        'assets/lottie/animatedsearch.json',
        height: 160,
        width: MediaQuery.of(context).size.height * .5,)*/);
  }
}