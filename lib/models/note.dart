import 'package:flutter/cupertino.dart';

class Note {
  final int id;
  final String title;
  final String description;

  Note({
    required this.id,
    required this.title,
    this.description = "",
  });
}
