import 'package:flutter/material.dart';
import 'package:newzzy/utils/colors.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'All news are fetched from https://newsapi.org/',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: textColor1, fontWeight: FontWeight.w500, fontSize: 18),
          maxLines: 3,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Email',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: textColor4, fontWeight: FontWeight.w500, fontSize: 18),
          maxLines: 3,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'avinashupadhyay56@gmail.com',
          style: const TextStyle(
              color: textColor3, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Mobile Number',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: textColor4, fontWeight: FontWeight.w500, fontSize: 18),
          maxLines: 3,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '7550169761',
          style: const TextStyle(
              color: textColor3, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
