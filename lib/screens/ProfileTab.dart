import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';
import '../helpers/Functions.dart';

class ProfileTab extends GetView<SpacesController> {
  ProfileTab({super.key});

  final DeepWidgets dw = DeepWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: dw.bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(
              () => Column(
                children: [
                  SizedBox(width: double.infinity, child: dw.titleText('Perfil', dw.textColor, TextAlign.left)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 40),
                            child: Row(
                              children: [
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(65),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(20),
                                      image: (controller.currentUser.imageUrl != null)
                                          ? DecorationImage(
                                              image: NetworkImage(controller.currentUser.imageUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null),
                                  child: (controller.currentUser.imageUrl != null)
                                      ? Container()
                                      : Icon(Icons.person, color: dw.textColor, size: 40),
                                ),
                                const Spacer()
                              ],
                            ),
                          ),
                          dw.headingText(controller.currentUser.fullName, dw.textColor),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: dw.bodyText(
                                '${controller.currentUser.pseudonym} - ${controller.currentUser.type.toString().split('.')[1]}',
                                dw.textColor,
                                1),
                          ),
                          Divider(
                            color: dw.accentColor,
                            thickness: 1,
                            endIndent: Get.size.width * 0.2,
                            indent: Get.size.width * 0.2,
                            height: 40,
                          ),
                          if (controller.connectedToWallet) ...[
                            dw.bodyText(controller.accountId, dw.textColor, 1),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (controller.connectedToWallet) ? Colors.green : Colors.red),
                                  ),
                                  dw.bodyText(
                                      (controller.sessionGlobal.value == null)
                                          ? 'Not Connected'
                                          : Functions().getNetworkName(controller.sessionGlobal.value?.chainId),
                                      dw.textColor,
                                      1),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ] else ...[
                            dw.actionButton('Conectar Wallet', Icons.wallet, () => Functions().loginWithMetamask(true))
                          ],
                          Divider(
                              color: dw.accentColor,
                              thickness: 1,
                              endIndent: Get.size.width * 0.2,
                              indent: Get.size.width * 0.2,
                              height: 40),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: dw.profileStats(),
                          ),
                          if (controller.currentUser.hasBooks)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 25, left: 5),
                              child: dw.headingText(
                                'Preliminares',
                                dw.textColor,
                              ),
                            ),
                          dw.preliminares(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
