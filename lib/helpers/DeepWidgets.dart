import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/SpaceClass.dart';

class DeepWidgets {
  Color bgColor = const Color(0xFFF2E5D0);
  Color textColor = const Color(0xFF2C1810);
  Color accentColor = const Color(0xFFdaaa63);

  Widget titleText(String title, Color color) => Text(
        title,
        style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: color)),
      );

  Widget bodyText(String body, Color color) => Text(
        body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: color)),
      );

  Widget headingText(String heading, Color color) => Text(
        heading,
        style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
      );

  Widget spaceListTile(Space s) => GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: bgColor,
              // color: s.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: textColor, blurRadius: 3, spreadRadius: 1)]),
          child: Column(
            children: [
              Row(
                //
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.workspaces_outlined, color: textColor),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: headingText(s.name, textColor),
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5, bottom: 10),
                child: bodyText(s.description, textColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Expanded(child: participantOverlapList(s.participantIds, s.color)), joinButton()],
                ),
              )
            ],
          ),
        ),
      );

  Widget joinButton() {
    return ElevatedButton(
        onPressed: () {
          //join space
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: bodyText('Join', textColor));
  }

  Widget participantOverlapList(List<String> users, Color color) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          shrinkWrap: false,
          itemCount: (users.length < 4) ? users.length : 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) {
            String u = users[i];

            if (i == 3) {
              return userCircle('+${users.length - 3}', color);
            } else {
              return userCircle(u.toUpperCase(), color);
            }
          }),
    );
  }

  Widget userCircle(String text, Color color) {
    return Align(
      widthFactor: .6,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: accentColor, width: 2), shape: BoxShape.circle),
        child: CircleAvatar(
            backgroundColor: bgColor,
            child: Text(
              text,
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.normal)),
            )),
      ),
    );
  }
}
