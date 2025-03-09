import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseTemplate extends StatelessWidget {
  final GlobalKey globalKey;
  final String title;
  final String description;
  final String currentShowCase;
  final double height;
  final double width;
  final Widget child;
  final ShapeBorder shape;
  final bool isTitleRequired;
  final bool isFinished;
  final int total;

  const ShowCaseTemplate({
    super.key,
    required this.globalKey,
    this.title = "Title",
    this.description = "Description",
    required this.height,
    required this.width,
    required this.child,
    required this.shape,
    this.isTitleRequired = true,
    required this.currentShowCase,
    this.isFinished = false,
    this.total = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: globalKey,
      height: height,
      width: width,
      targetShapeBorder: shape,
      container: Column(
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10).copyWith(bottom: 20),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.pink, width: 2), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("$currentShowCase of $total", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13))],
                ),
                isTitleRequired ? Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) : SizedBox.shrink(),
                const SizedBox(height: 5),
                Text(description, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isFinished)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    ShowCaseWidget.of(context).dismiss();
                  },
                  child: Text("Skip"),
                ),
              if (!isFinished)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: () {
                    ShowCaseWidget.of(context).next();
                  },
                  child: Text("Next", style: TextStyle(color: Colors.white)),
                ),
              if (isFinished)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    ShowCaseWidget.of(context).dismiss();
                  },
                  child: Text("Finish Tutorial"),
                ),
            ],
          ),
        ],
      ),
      child: child,
    );
  }
}
