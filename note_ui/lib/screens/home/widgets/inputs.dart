import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final String field;
  TextEditingController controller;

  InputCard({this.field, this.controller}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${field}: ', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)),
        Container(
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              child: TextFormField(
                controller: controller,
                onChanged: (value) {
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Please Enter some Text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Input ${field}'
                ),
              ),
            )
        ),
      ]
    );
  }
}
