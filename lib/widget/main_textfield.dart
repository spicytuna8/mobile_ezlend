import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';

class MainTextFormField extends StatelessWidget {
  const MainTextFormField(
      {super.key,
      this.hintText,
      this.suffixIcon,
      this.readOnly,
      this.enabled,
      this.onTap,
      this.minLines = 1,
      this.obscureText,
      this.maxLines,
      this.controller,
      this.inputFormatters,
      this.validator,
      this.prefixIcon,
      this.onComplete,
      this.onChanged,
      this.border,
      this.hintStyle,
      this.keyboardType,
      this.label,
      this.errorText,
      this.labelTextRich1,
      this.labelTextRich2,
      this.prefixText,
      this.isTextRichLabel = false,
      this.contentPaddingVertical,
      this.contentPaddingHorizontal,
      this.focusNode});
  final String? hintText;
  final String? prefixText;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? readOnly;
  final bool? enabled;
  final bool? obscureText;
  final int? minLines;
  final void Function()? onTap;
  final int? maxLines;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onComplete;
  final void Function(String)? onChanged;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final Widget? label;
  final String? labelTextRich1;
  final String? labelTextRich2;
  final bool? isTextRichLabel;
  final double? contentPaddingVertical;
  final double? contentPaddingHorizontal;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      focusNode: focusNode,
      minLines: minLines,
      onEditingComplete: onComplete,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      enabled: enabled,
      onTap: onTap,
      readOnly: readOnly ?? false,
      style: const TextStyle(
        color: Color(0xFF7D8998),
      ),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        errorMaxLines: 1,
        errorText: errorText,
        filled: true,
        fillColor: enabled == false ? Colors.grey : Colors.transparent,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffixIcon: suffixIcon,
        // counterText: '+852',

        // prefixStyle: const TextStyle(color: Colors.white),
        prefixIconConstraints: const BoxConstraints(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            EdgeInsets.symmetric(horizontal: contentPaddingHorizontal ?? 16, vertical: contentPaddingVertical ?? 16),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 0.50,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFF354150),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0.50,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: baseColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 0.50,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFF354150),
          ),
        ),
        hintText: hintText ?? Languages.of(context).enterYourPassword,
        hintStyle: GoogleFonts.poppins(
          color: greyBlackColor,
          fontSize: 14,
          // fontWeight: FontWeight.w400,
          letterSpacing: 0.01,
        ),
        label: isTextRichLabel!
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: labelTextRich1,
                      style: TextStyle(
                        color: greyBlackColor,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0.09,
                        letterSpacing: 0.15,
                      ),
                    ),
                    TextSpan(
                      text: labelTextRich2,
                      style: const TextStyle(
                        color: Color(0xFFD91515),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 0.09,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              )
            : label,
      ),
      validator: validator ??
          (value) {
            if (value == null || value == "") {
              return Languages.of(context).fieldIsRequired;
            }
            return null;
          },
    );
  }
}
