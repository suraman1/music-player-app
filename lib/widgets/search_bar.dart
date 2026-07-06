import 'package:flutter/material.dart';
import 'package:my_app/theme/app_styles.dart';

class SearchBar extends StatelessWidget {
  final Icon prefixIcon;
  final String text;
  const SearchBar({super.key, required this.prefixIcon, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hint: Text(text, style: TextStyle(color: Colors.black),),
      hintStyle: AppTextStyles.bodyMedium,
      border: OutlineInputBorder (
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero
      )
    ));
  }
}
