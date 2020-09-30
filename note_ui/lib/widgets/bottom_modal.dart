import 'package:flutter/material.dart';

class BottomModal extends StatefulWidget {
  @override
  _BottomModalState createState () => _BottomModalState();
}

class _BottomModalState extends State<BottomModal>{
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )
        ),
        child: Column(
          children: [
            _dateRow(),

          ],
        ),
      ),
    );
  }

  Widget _dateRow () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date:'),
          Expanded(
            child: Card(
              child: ListTile(
                onTap: () async {
                  final DateTime date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2030),
                  );
                  setState(() {
                    selectedDate = date;
                  });
                },
                title: Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}', textAlign: TextAlign.center)
              ),
            ),
          )
        ],
      ),
    );
  }
}
