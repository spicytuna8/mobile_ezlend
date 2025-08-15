// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/helper/color_helper.dart';

class MainDropdown extends StatelessWidget {
  final double? width;
  final String? title;
  final dynamic selectedValue;
  final Color? titleColor;
  final double? titleFontSize;
  final Color? iconColor;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? buttonPadding;
  final Function(dynamic)? onChanged;
  final List<DropdownMenuItem<Object>>? items;
  final bool isJustTitle;
  const MainDropdown(
      {Key? key,
      this.width,
      this.onChanged,
      this.boxDecoration,
      this.titleFontSize,
      this.buttonPadding,
      this.title,
      this.titleColor,
      required this.items,
      required this.isJustTitle,
      this.iconColor,
      this.selectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // margin: EdgeInsets.symmetric(horizontal: 10.w),
      // height: 15,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: isJustTitle,
          hint: isJustTitle
              ? Text(
                  title ?? '',
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: titleFontSize ?? 14,
                    // fontWeight: FontWeight.bold,
                    color: titleColor ?? Color(0xFF7D8998),
                  ),
                  // overflow: TextOverflow.ellipsis,
                )
              : Container(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Lukman Hakim',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'lukmanulhakim112@gmail.com',
                                    style: TextStyle(
                                      color: Color(0xFF6B6B6B),
                                      fontSize: 13,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://i.ibb.co/PGv8ZzG/me.jpg",
                                      scale: 1.w),
                                  fit: BoxFit.cover))),
                    ])),

          items: items,
          // items
          //     .map((item) => DropdownMenuItem<String>(
          //           value: item,
          //           child: Text(
          //             item,
          //             style: const TextStyle(
          //               fontSize: 12,
          //               color: Colors.black,
          //             ),
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ))
          //     .toList(),
          value: selectedValue,
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: iconColor ?? Colors.black,
          ),
          iconSize: 20,
          iconEnabledColor: Colors.grey,
          iconDisabledColor: Colors.grey,
          buttonHeight: 45,
          // buttonWidth: 160,
          buttonPadding: buttonPadding ?? EdgeInsets.zero,
          buttonDecoration: boxDecoration,
          buttonElevation: 0,
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: 200,
          // dropdownWidth: 50.w,
          dropdownPadding: null,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
          ),
          dropdownElevation: 2,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          offset: const Offset(0, 0),
        ),
      ),
    );
  }
}
