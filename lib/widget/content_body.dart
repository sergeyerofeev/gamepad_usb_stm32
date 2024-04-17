import 'package:flutter/material.dart';
import 'package:gamepad_usb_stm32/data/globals.dart';
import 'package:gamepad_usb_stm32/widget/joystick_view.dart';

import '../gamepad/gamepad.dart';
import '../main.dart';

class ContentBody extends StatefulWidget {
  const ContentBody({super.key});

  @override
  ContentBodyState createState() => ContentBodyState();
}

class ContentBodyState extends State<ContentBody> with TickerProviderStateMixin {
  late final Gamepad gamepad;
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();

  @override
  void initState() {
    gamepad = Gamepad(0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        gamepad.updateState();
        int leftX = gamepad.state.leftThumbstickX;
        int leftY = gamepad.state.leftThumbstickY;
        int rightX = gamepad.state.rightThumbstickX;
        int rightY = gamepad.state.rightThumbstickY;
        // Отправляем изменённые данные
        if (Globals.isChange(leftX, leftY, rightX, rightY)) {
          if (hid.open() == 0) {
            Future(() async {
              int result = await hid.write(Globals.createDataForTransfer(leftX, leftY, rightX, rightY));
              // Если функция вернула -1, произошёл разрыв соединения
              if (result == -1) {
                hid.close();
                hidOpen();
              }
            });
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            JoystickView(x: leftX, y: leftY),
            const SizedBox(width: 20),
            JoystickView(x: rightX, y: rightY),
          ],
        );
      },
    );
  }
}
