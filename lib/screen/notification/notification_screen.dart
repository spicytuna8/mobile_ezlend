// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/text_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff000000),
        appBar: AppBar(
          centerTitle: true,
          actions: const [],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                Languages.of(context).notification,
                style: white18w800,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    Languages.of(context).noActivities,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .12,
                ),
                // Text(
                //   'Activities',
                //   style: GoogleFonts.inter(
                //     color: Colors.white,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // const SizedBox(
                //   height: 8.0,
                // ),
                // ListView.separated(
                //   separatorBuilder: (context, index) => SizedBox(
                //     height: 16,
                //   ),
                //   itemCount: 0,
                //   shrinkWrap: true,
                //   physics: const ScrollPhysics(),
                //   itemBuilder: (BuildContext context, int index) {
                //     return Container(
                //       width: double.infinity,
                //       padding: const EdgeInsets.all(16),
                //       clipBehavior: Clip.antiAlias,
                //       decoration: BoxDecoration(
                //         color: Color(0xFF252422),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Loan application status',
                //             style: GoogleFonts.inter(
                //               color: Colors.white,
                //               fontSize: 14,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //           const SizedBox(height: 12),
                //           Text(
                //             'Your loan application has been declined. Please contact our customer service for more information.',
                //             style: GoogleFonts.inter(
                //               color: Color(0xFFBDBDBD),
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //           const SizedBox(height: 12),
                //           Text(
                //             '31 days ago',
                //             style: GoogleFonts.inter(
                //               color: Color(0xFF7D8998),
                //               fontSize: 12,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
                // const SizedBox(
                //   height: 16.0,
                // ),
                // Text(
                //   'Reminder',
                //   style: GoogleFonts.inter(
                //     color: Colors.white,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // const SizedBox(
                //   height: 8.0,
                // ),
                // ListView.separated(
                //   separatorBuilder: (context, index) => SizedBox(
                //     height: 16,
                //   ),
                //   itemCount: 0,
                //   shrinkWrap: true,
                //   physics: const ScrollPhysics(),
                //   itemBuilder: (BuildContext context, int index) {
                //     return Container(
                //       width: double.infinity,
                //       padding: const EdgeInsets.all(16),
                //       clipBehavior: Clip.antiAlias,
                //       decoration: BoxDecoration(
                //         color: Color(0xFF252422),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Loan application status',
                //             style: GoogleFonts.inter(
                //               color: Colors.white,
                //               fontSize: 14,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //           const SizedBox(height: 12),
                //           Text(
                //             'Your loan application has been declined. Please contact our customer service for more information.',
                //             style: GoogleFonts.inter(
                //               color: Color(0xFFBDBDBD),
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //           const SizedBox(height: 12),
                //           Text(
                //             '31 days ago',
                //             style: GoogleFonts.inter(
                //               color: Color(0xFF7D8998),
                //               fontSize: 12,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
