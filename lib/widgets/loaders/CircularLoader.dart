import 'package:crm_app/globals/globalColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkLoading extends StatelessWidget {
  const NetworkLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(
          GlobalColors.globalColor(),
        ),
        strokeWidth: 2,
      ),
    );
  }
}