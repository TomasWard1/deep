import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/SpaceClass.dart';

class DeepWidgets {
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
              color: s.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0)]),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.workspaces_outlined, color: Colors.black),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: headingText(s.name, Colors.black),
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5, bottom: 10),
                child: bodyText(s.description, Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right:10),
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
            backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: bodyText('Join', Colors.black));
  }

  Widget participantOverlapList(List<String> users, Color color) {
    return Container(
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
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2), shape: BoxShape.circle),
        child: CircleAvatar(
            backgroundColor: color,
            child: Text(
              text,
              style: GoogleFonts.nunito(
                  textStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
            )),
      ),
    );
  }
}
