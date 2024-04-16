import 'package:flutter/material.dart';

import '../gamepad/thumbstick.dart';

class JoystickView extends StatelessWidget {
  final int _x, _y;

  const JoystickView({super.key, required int x, required int y})
      : _x = x,
        _y = y;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Text('X:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 60,
              child: Text(
                '$_x',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Y:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 60,
              child: Text(
                '$_y',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 120,
          width: 120,
          child: ThumbstickView(x: _x, y: _y),
        ),
      ],
    );
  }
}
