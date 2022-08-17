import 'package:flutter/material.dart';

class BackgroundNews extends StatelessWidget {
  final String sourceImage;
  const BackgroundNews({
    Key? key,
    required this.sourceImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade700],
            radius: 0.9,
          )),
        ),
        SizedBox(
          height: height * 0.2,
          width: width * 0.2,
          child: sourceImage.isNotEmpty
              ? Image.network(
                  sourceImage,
                  fit: BoxFit.contain,
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
