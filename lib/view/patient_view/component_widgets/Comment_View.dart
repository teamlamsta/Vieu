import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CommentView extends StatelessWidget {
  const CommentView({super.key, required this.comment, required this.deleteComment});
  final String comment;
  final Function deleteComment;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Delete Comment",
                  style: GoogleFonts.poppins(),
                ),
                content: Text(
                  "Are you sure you want to delete this comment?",
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("Yes")),
                ],
              );
            });
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        deleteComment();
      },
      key: const ValueKey(2),
      child: Text(
        comment,
        style: GoogleFonts.poppins(
            fontSize: size.width * .04),
      ),
    );
  }
}
