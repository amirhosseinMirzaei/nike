import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyViewe extends StatelessWidget {
  final String message;
  final Widget? callToAction;
  final Widget image;

  const EmptyViewe(
      {super.key,
      required this.message,
      this.callToAction,
      required this.image});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image,
        Padding(
          padding:
              const EdgeInsets.only(right: 48, left: 48, top: 24, bottom: 16),
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline6!.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        if (callToAction != null) callToAction!
      ],
    );
  }
}
