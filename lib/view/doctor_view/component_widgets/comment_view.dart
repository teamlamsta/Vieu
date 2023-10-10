import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentView extends StatelessWidget {
  const CommentView({super.key,required this.comment,required this.replyController});
  final String comment;
  final TextEditingController replyController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Container(
      width: size.width,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comments",
            style: GoogleFonts.poppins(
                fontSize: size.width * .05,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Text(
            comment,
            style: GoogleFonts.poppins(
                fontSize: size.width * .04,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: size.height * .03,
          ),
          SizedBox(
            height: size.height * .08,
            width: size.width * .7,
            child: TextField(
              controller: replyController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: size.width * .07,
                      vertical: size.height * .01),
                  prefixIcon:  Icon(
                    Icons.add_circle,
                    color: Theme.of(context).primaryColorDark,
                    size: size.width * .09,
                  ),
                  hintText: "Reply",
                  hintStyle: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
