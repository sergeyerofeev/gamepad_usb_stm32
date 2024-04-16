import 'dart:typed_data';

class Globals {
  static int _leftX = 0;
  static int _leftY = 0;
  static int _rightX = 0;
  static int _rightY = 0;

  static final data = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);

  Globals._();

  // Проверяем произошло ли изменение в положении джойстика
  static bool isChange(int leftX, int leftY, int rightX, int rightY) {
    return leftX != _leftX || leftY != _leftY || rightX != _rightX || rightY != _rightY;
  }

  // Возвращаем массив байт для передачи на STM32
  static Uint8List createDataForTransfer(int leftX, int leftY, int rightX, int rightY) {
    Uint8List list = Uint8List(2);

    if (leftX != _leftX) {
      _leftX = leftX;
      list = _int16BigEndianBytes(leftX);
      data[1] = list[0];
      data[2] = list[1];
    }

    if (leftY != _leftY) {
      _leftY = leftY;
      list = _int16BigEndianBytes(leftY);
      data[3] = list[0];
      data[4] = list[1];
    }

    if (rightX != _rightX) {
      _rightX = rightX;
      list = _int16BigEndianBytes(rightX);
      data[5] = list[0];
      data[6] = list[1];
    }

    if (rightY != _rightY) {
      _rightY = rightY;
      list = _int16BigEndianBytes(rightY);
      data[7] = list[0];
      data[8] = list[1];
    }

    return data;
  }

  // Преобразуем int в массив байт
  static Uint8List _int16BigEndianBytes(int value) =>
      Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.big);
}
