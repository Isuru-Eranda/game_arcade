import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class HUD extends StatelessWidget {
  final Function onpausePressed;
  final ValueNotifier<int> life;
  const HUD({
    Key? key,
    required this.onpausePressed,
    required this.life,
    // ignore: unnecessary_null_comparison
    }) : assert(onpausePressed != null),
    // ignore: unnecessary_null_comparison
    assert(life != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.pause,
            color: BasicPalette.green.color,
            size: 35.0,
          ),
          onPressed: () {
            onpausePressed();
          },
        ),
        ValueListenableBuilder<int>(
          valueListenable: life,
          builder: (BuildContext context, int value, Widget? child) {
            final list = <Widget>[];
            for (int i = 0; i < 4; i++) {
              list.add(
                Padding(padding: EdgeInsets.only(right: 5.0),
                child: Icon(
                Icons.favorite,
                color: i < value ? BasicPalette.red.color : BasicPalette.white.color,
                size: 35.0,
              ),
              ),
              );
            }
            return Row(children: list);
          },
        ),
      ],
    );
  }
}