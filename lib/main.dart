import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'data/data_sources/my_storage.dart';
import 'hidapi/hid.dart';
import 'provider/provider.dart';
import 'settings/key_store.dart';
import 'ui/my_app.dart';

HID hid = HID(idVendor: 1149, idProduct: 22349);
late Uint8List rawData;
final container = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Создаём только один экземпляр приложения
  if (!await FlutterSingleInstance.platform.isFirstInstance()) {
    exit(0);
  }

  await windowManager.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  // Извлекаем из хранилища положение окна на экране монитора
  final double? dx = sharedPreferences.getDouble(KeyStore.offsetX);
  final double? dy = sharedPreferences.getDouble(KeyStore.offsetY);

  const initialSize = Size(300, 230);
  WindowOptions windowOptions = const WindowOptions(
    size: initialSize,
    minimumSize: initialSize,
    maximumSize: initialSize,
    skipTaskbar: false,
    title: 'GamePad',
    titleBarStyle: TitleBarStyle.hidden, // Скрыть панель с кнопками Windows
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Начальное положение окна
    if (dx == null || dy == null) {
      // Если пользователь не выбрал положение окна на экране монитора, размещаем по центру
      await windowManager.center();
    } else {
      await windowManager.setPosition(Offset(dx, dy));
    }
    await windowManager.setAlwaysOnTop(true); // Размещаем приложение поверх других окон
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ProviderScope(
    parent: container,
    overrides: [
      storageProvider.overrideWithValue(MyStorage(sharedPreferences)),
    ],
    child: const MyApp(),
  ));

  Timer(Duration.zero, hidOpen);
}

// Пытаемся подключиться к usb устройству
void hidOpen() {
  if (hid.open() != 0) {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (hid.open() == 0) {
        timer.cancel();
      }
    });
  }
}
