import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wintek/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool autoValidate;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.controller,
    this.validator,
    this.autoValidate = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      style: GoogleFonts.roboto(
        color: AppColors.textformfieldSecondaryTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textformfieldActiveBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textformfieldFocuseBorderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.textformfieldErrorBorderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.textformfieldErrorBorderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: AppColors.textformfieldPrimaryColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        contentPadding: const EdgeInsets.all(20),
        prefixIcon: prefix,
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textformfieldPrimaryTextColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
