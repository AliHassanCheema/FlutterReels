import 'package:flutter/material.dart';

extension SpaceXY on num {
  SizedBox get spaceX => SizedBox(width: toDouble());
  SizedBox get spaceY => SizedBox(height: toDouble());
}

extension BMPadding on num {
  EdgeInsets get padAll => EdgeInsets.all(toDouble());
  EdgeInsets get padX => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get padY => EdgeInsets.symmetric(vertical: toDouble());
}
