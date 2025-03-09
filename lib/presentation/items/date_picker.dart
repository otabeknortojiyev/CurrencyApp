import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showMyDatePicker(BuildContext context) async {
  DateTime date = DateTime.now();
  final Completer<String?> completer = Completer<String?>();
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 350,
        padding: const EdgeInsets.only(top: 16.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text('Готово', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        completer.complete(formattedDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: CupertinoColors.separator.resolveFrom(context)),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: date,
                  maximumDate: date,
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  onDateTimeChanged: (DateTime newDate) {
                    date = newDate;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  return completer.future;
}
