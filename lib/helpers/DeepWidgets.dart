import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackitba/screens/SpaceDetail.dart';

import '../classes/BookClass.dart';
import '../classes/SpaceClass.dart';
import 'SnackbarManager.dart';

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
              boxShadow: [BoxShadow(color: textColor, blurRadius: 3, spreadRadius: 0)]),
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
                    child: Hero(tag: s.id, child: headingText(s.name, textColor)),
                  ))
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 5.0, top: 5, bottom: 10),
                child: bodyText(s.description, textColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Expanded(child: participantOverlapList(s.participantIds, s.color)), joinButton(s)],
                ),
              )
            ],
          ),
        ),
      );

  Widget joinButton(Space s) {
    return ElevatedButton(
        onPressed: () async {
          //join space
          await SnackBarManager().success('Joined ${s.name}');
          Get.to(() => SpaceDetail(id: s.id));
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
              return userCircle('+${users.length - 3}', color, true);
            } else {
              return userCircle(u.toUpperCase(), color, true);
            }
          }),
    );
  }

  Widget userCircle(String text, Color color, bool withOffset) {
    return Align(
      widthFactor: (withOffset) ? .6 : null,
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

  Widget topContributors(Space s) {
    return ExpansionTile(
      leading: Icon(Icons.workspace_premium_outlined, color: textColor),
      title: const Text('Top Contributors'),
      textColor: textColor,
      iconColor: textColor,
      collapsedIconColor: textColor,
      collapsedTextColor: textColor,
      collapsedBackgroundColor: accentColor,
      backgroundColor: accentColor,
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: s.contributors.length,
            itemBuilder: (c, i) {
              String username = s.contributors.keys.elementAt(i);
              int totalBooks = s.contributors[username]!.totalBooks;
              int totalAmount = s.contributors[username]!.totalAmount;
              return contributorListTile(username, totalBooks, totalAmount);
            })
      ],
    );
  }

  Widget contributorListTile(String username, int totalBooks, int totalAmount) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
      child: Row(
        children: [
          userCircle(username.toUpperCase(), textColor, false),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: bodyText('User', textColor),
          )),
          bodyText("$totalAmount ETH", textColor)
        ],
      ),
    );
  }

  Widget authorListTile(String username, int totalBooks, int totalAmount) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
      child: Row(
        children: [
          userCircle(username.toUpperCase(), textColor, false),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: bodyText('Author', textColor),
          )),
          Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.favorite,
                color: textColor,
                size: 20,
              )),
          bodyText('100', textColor)
        ],
      ),
    );
  }

  Widget topAuthors(Space s) {
    return ExpansionTile(
      leading: Icon(Icons.history_edu_outlined, color: textColor),
      title: const Text('Top Authors'),
      textColor: textColor,
      iconColor: textColor,
      collapsedIconColor: textColor,
      collapsedTextColor: textColor,
      collapsedBackgroundColor: accentColor,
      backgroundColor: accentColor,
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: s.contributors.length,
            itemBuilder: (c, i) {
              String username = s.contributors.keys.elementAt(i);
              int totalBooks = s.contributors[username]!.totalBooks;
              int totalAmount = s.contributors[username]!.totalAmount;
              return authorListTile(username, totalBooks, totalAmount);
            })
      ],
    );
  }

  Widget bookList(Space s) {
    return ListView.builder(
      primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: s.books.length,
        itemBuilder: (c, i) {
          Book b = s.books[i];
          return Container(
            margin: const EdgeInsets.only(bottom:10),
              child: ListTile(
            contentPadding: const EdgeInsets.only(left: 5, right: 5),
            minLeadingWidth: 10,
            leading: Icon(Icons.bookmark_border, color: textColor),
            title:Text(
              b.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textColor)),
            ),
            subtitle:Text(
              b.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: textColor)),
            ),
            trailing: Icon(Icons.arrow_right, color: textColor),
          ));
        });
  }
}
