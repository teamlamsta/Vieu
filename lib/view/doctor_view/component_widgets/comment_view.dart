import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentView extends StatefulWidget {
   CommentView(
      {super.key, required this.comment, required this.replyController});

  final String comment;
   TextEditingController replyController;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .08,
        vertical: size.height * .02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comments",
            style: GoogleFonts.poppins(
                fontSize: size.width * .05, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Text(
            widget.comment,
            style: GoogleFonts.poppins(
                fontSize: size.width * .04, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: size.height * .02,
          ),

           ...replyWidget(widget.replyController.text),



          SizedBox(
            height: size.height * .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: size.height * .065,
                width: size.width * .6,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * .07,
                          vertical: size.height * .01),
                      hintText: "Reply",
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.replyController.text = _controller.text;
                  setState(() {
                    _controller.clear();
                  });
                },

                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(

                      vertical: size.height * .0125),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Icon(
                  Icons.send,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  List<Widget> replyWidget(String reply){
    final size = MediaQuery.of(context).size;
    List<Widget> replyWidget = [];
    if(reply.isEmpty){
      return replyWidget;
    }
    replyWidget.add(
      Text(
        "Reply ",
        style: GoogleFonts.poppins(
            fontSize: size.width * .05, fontWeight: FontWeight.w600),
      )
    );
    replyWidget.add(
      SizedBox(
        height: size.height * .01,
      )
    );
    replyWidget.add(
      Text(
        reply,
        style: GoogleFonts.poppins(
            fontSize: size.width * .04, fontWeight: FontWeight.w400),
      )
    );
    return replyWidget;
  }
}
