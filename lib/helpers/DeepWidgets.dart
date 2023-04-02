import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackitba/controllers/SpacesController.dart';
import 'package:hackitba/screens/SpaceDetail.dart';

import '../classes/BookClass.dart';
import '../classes/SpaceClass.dart';
import '../classes/UserClass.dart';
import 'DialogManager.dart';
import 'Functions.dart';
import 'Web3Manager.dart';

class DeepWidgets {
  Color bgColor = const Color(0xFFF2E5D0);
  Color textColor = const Color(0xFF2C1810);
  Color accentColor = const Color(0xFFEEC78E);

  SpacesController get sc => Get.find<SpacesController>();

  Web3Controller get wc => Get.find<Web3Controller>();

  Widget titleText(String title, Color color, TextAlign align) => Text(
        title,
        textAlign: align,
        style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: color)),
      );

  Widget bodyText(String body, Color color, int? maxLines) => Text(
        body,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
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
                child: bodyText(s.description, textColor, 2),
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
          await DialogManager().success('Te uniste a ${s.name}');
          await Get.to(() => SpaceDetail(id: s.id));
          sc.currentSpace.value = s;
          sc.currentSpace.refresh();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: bodyText('Unirse', textColor, 1));
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
              return userCircleWithLetter('+${users.length - 3}', color, true);
            } else {
              return userCircleWithLetter(u.toUpperCase(), color, true);
            }
          }),
    );
  }

  Widget userCircle(String userImageUrl, Color color, bool withOffset) {
    return Align(
      widthFactor: (withOffset) ? .6 : null,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: accentColor, width: 2), shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundColor: bgColor,
          backgroundImage: NetworkImage(userImageUrl),
        ),
      ),
    );
  }

  Widget userCircleWithLetter(String username, Color color, bool withOffset) {
    return Align(
      widthFactor: (withOffset) ? .6 : null,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: accentColor, width: 2), shape: BoxShape.circle),
        child: CircleAvatar(
            backgroundColor: bgColor,
            child: Text(username.toUpperCase(), style: TextStyle(color: DeepWidgets().textColor))),
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
            child: bodyText('User', textColor, 1),
          )),
          bodyText("$totalAmount ETH", textColor, 1)
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
            child: bodyText('Author', textColor, 1),
          )),
          Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.favorite,
                color: textColor,
                size: 20,
              )),
          bodyText('100', textColor, 1)
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
    print(s.books.length);
    return ListView.builder(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: s.books.length,
        itemBuilder: (c, i) {
          Book b = s.books[i];
          return bookListTile(b);
        });
  }

  Widget bookListTile(Book b) {
    return GestureDetector(
      onTap: () {
        DialogManager().bookDetail(b);
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: NetworkImage(b.coverImageUrl), fit: BoxFit.fill))),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        b.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textColor)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        b.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: textColor)),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right, color: textColor)
            ],
          )),
    );
  }

  Widget bookDetail(Book b) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Divider(
            height: 5,
            indent: Get.size.width * 0.4,
            endIndent: Get.size.width * 0.4,
            color: accentColor,
            thickness: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 70,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(b.coverImageUrl), fit: BoxFit.fill))),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    children: [
                      SizedBox(width: double.infinity, child: headingText(b.title, textColor)),
                      SizedBox(width: double.infinity, child: bodyText(b.description, textColor, null)),
                    ],
                  ),
                )),
                userCircle(b.author.imageUrl!, textColor, false)
              ],
            ),
          ),
          const Spacer(),
          Icon(
            Icons.picture_as_pdf,
            color: textColor,
            size: 40,
          ),
          const Spacer(),
          bookActionButtons(b)
        ],
      ),
    );
  }

  Widget actionButton(String title, IconData icon, Function onPressed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            backgroundColor: accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: () => onPressed(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                icon,
                color: textColor,
              ),
            ),
            bodyText(title, textColor, 1),
          ],
        ));
  }

  Widget bookActionButtons(Book b) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: actionButton('Fund', Icons.credit_card, () async {
            DialogManager().getAmountToFund(b);
          }),
        )),
        actionButton('Like', Icons.favorite_border, () {}),
      ],
    );
  }

  Widget textFormField(
      TextEditingController c, String hintText, bool bold, double size, TextAlign align, int? maxLines) {
    return TextFormField(
      maxLines: maxLines,
      validator: (t) {
        if (t == null || t.isEmpty) {
          return 'Cannot be empty';
        }
        return null;
      },
      controller: c,
      textAlign: align,
      style: GoogleFonts.nunito(
          textStyle:
              TextStyle(fontWeight: (bold) ? FontWeight.bold : FontWeight.normal, fontSize: size, color: textColor)),
      decoration: InputDecoration(contentPadding: EdgeInsets.zero, hintText: hintText, border: InputBorder.none),
    );
  }

  Widget get profileImageSelector => Obx(
        () => GestureDetector(
          onTap: () async {
            await Functions().pickImage(true);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(65),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                      image: (sc.profileImage.value != null)
                          ? DecorationImage(
                              image: FileImage(sc.profileImage.value!),
                              fit: BoxFit.cover,
                            )
                          : null),
                  child: (sc.profileImage.value != null)
                      ? Container()
                      : Icon(Icons.add_a_photo, color: textColor, size: 40),
                ),
                const Spacer()
              ],
            ),
          ),
        ),
      );

  Widget cuadradoRol(String imageName, String title, UserType type) {
    return GestureDetector(
      onTap: () {
        Functions()
            .saveProfileInfo(sc.fullNameController.text, sc.pseudonymController.text, sc.profileImage.value, type);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: AssetImage(imageName)),
                color: accentColor,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: headingText(title, textColor),
          )
        ],
      ),
    );
  }

  Widget profileStats() {
    return Row(
      children: [
        profileStatTile(Icons.workspaces_outline, '${sc.currentUser.spaceCount} Spaces'),
        const Spacer(),
        profileStatTile(
            (sc.currentUser.isAuthor) ? Icons.bookmark_border_outlined : Icons.monetization_on,
            (sc.currentUser.isAuthor)
                ? '${sc.currentUser.bookCount} Libros'
                : '${sc.currentUser.totalContributions} ETH'),
      ],
    );
  }

  Widget preliminares() {
    return (sc.currentUser.bookCount == 0)
        ? Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: bodyText('Todavia no tiene libros!', textColor, 1),
          )
        : ListView.builder(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: sc.currentUser.bookCount,
            itemBuilder: (c, i) {
              Book b = sc.currentUser.books![i];
              return bookListTile(b);
            });
  }

  Widget profileStatTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 55, right: 55),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: accentColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, color: textColor), bodyText(title, textColor, 1)],
      ),
    );
  }
}
