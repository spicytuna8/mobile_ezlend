import 'package:flutter/material.dart';

class CardBlacklist extends StatelessWidget {
  const CardBlacklist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/close.png',
              width: 131.5,
              height: 150,
            ),
            const SizedBox(
              height: 40.0,
            ),
            const SizedBox(
              width: 330,
              child: Text(
                'You have been blacklisted. Please clear your outstanding balance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7D8998),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
