import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
  dairy,
}

class Category {
  const Category(this.title, this.color);
  final String title;
  final Color color;
}
