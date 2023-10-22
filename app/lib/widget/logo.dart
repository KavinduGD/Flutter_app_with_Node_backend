import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: NetworkImage(
                "https://res.cloudinary.com/dnoobzfxo/image/upload/v1697960415/images-removebg-preview_r2jq2n.png",
              ),
            ),
          ),
        ),
        Text(
          "TODO app",
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        Text(
          "make your life easier",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: const Color.fromARGB(255, 44, 2, 9),
          ),
        ),
      ],
    );
  }
}
