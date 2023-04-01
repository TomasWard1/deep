import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';

class UserForm extends GetView<SpacesController> {
  const UserForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DeepWidgets().bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stepper(
                type: StepperType.horizontal,
                steps: [
              Step(title: Text('f'), content: Text('step')),
              Step(title: Text('f'), content: Text('step')),
              Step(title: Text('f'), content: Text('step')),
              Step(title: Text('f'), content: Text('step'))
            ]),
          ),
        ));
  }
}
