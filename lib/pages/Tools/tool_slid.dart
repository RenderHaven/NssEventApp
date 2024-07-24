import "dart:ui";

import "package:flutter/animation.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
class ToolSlid extends StatefulWidget {
  final int initialLabelIndex;
  final double minWidth;
  final double minHeight;
  final Color inactiveBgColor;
  final Color activeBgColor;
  final List<String> labels;
  final ValueChanged<int?> onToggle;

  ToolSlid({
    required this.initialLabelIndex,
    required this.minWidth,
    required this.minHeight,
    required this.inactiveBgColor,
    required this.labels,
    required this.onToggle,
    this.activeBgColor=Colors.deepPurple,
  });

  @override
  _CustomToggleSwitchState createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<ToolSlid> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialLabelIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.labels.length, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                currentIndex = index;
              });
              widget.onToggle(index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: currentIndex == index ? widget.activeBgColor : widget.inactiveBgColor,
              ),
              height: widget.minHeight,
              alignment: Alignment.center,
              child: Text(
                widget.labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: currentIndex == index ? Colors.white : Colors.black,
                    fontSize: widget.minWidth/12+widget.minHeight/12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
