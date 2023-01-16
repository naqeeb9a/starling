import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  DateTime to;
  final bool isAllDay;
  final dynamic object;
  final String type;
  final Color backgroundColor;

  Event({
    this.title,
    this.description,
    this.from,
    this.to,
    this.isAllDay = false,
    this.object,
    this.type,
    this.backgroundColor = Colors.lightGreen
});
}