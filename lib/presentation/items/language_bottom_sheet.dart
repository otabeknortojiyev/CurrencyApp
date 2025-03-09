import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_screen/currency_page/state.dart';

Future<LanguageStatus?> showLanguageModalBottomSheet(BuildContext context, LanguageStatus langStatus) async {
  return await showModalBottomSheet<LanguageStatus>(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 24),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context: context,
              title: 'Русский',
              isSelected: langStatus == LanguageStatus.rus,
              onTap: () => Navigator.pop(context, LanguageStatus.rus),
            ),
            _buildLanguageOption(
              context: context,
              title: 'Uzbek',
              isSelected: langStatus == LanguageStatus.uz,
              onTap: () => Navigator.pop(context, LanguageStatus.uz),
            ),
            _buildLanguageOption(
              context: context,
              title: 'Kirill',
              isSelected: langStatus == LanguageStatus.kiril,
              onTap: () => Navigator.pop(context, LanguageStatus.kiril),
            ),
            _buildLanguageOption(
              context: context,
              title: 'English',
              isSelected: langStatus == LanguageStatus.eng,
              onTap: () => Navigator.pop(context, LanguageStatus.eng),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildLanguageOption({required BuildContext context, required String title, required bool isSelected, required VoidCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.systemBlue : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 4))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: isSelected ? CupertinoColors.white : CupertinoColors.black, fontWeight: FontWeight.w600, fontSize: 17),
            ),
            if (isSelected) Icon(CupertinoIcons.check_mark, color: CupertinoColors.white, size: 24),
          ],
        ),
      ),
    ),
  );
}
