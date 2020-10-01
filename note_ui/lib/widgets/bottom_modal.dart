import 'package:flutter/material.dart';

class BottomModal extends StatefulWidget {
  @override
  _BottomModalState createState () => _BottomModalState();
}

class _BottomModalState extends State<BottomModal>{
  DateTime selectedDate = DateTime.now();
  final TextEditingController _subNotes = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _dateRow(),
            _noteInputs(),
            _handleSubmit(),
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

  Widget _noteInputs () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your notes', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)),
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Card(
            child: TextFormField(
              controller: _subNotes,
              maxLines: 5,
              onChanged: (value) {
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
              ),
            ),
          )
        ),
      ]
    );
  }

  RaisedButton _handleSubmit () {
    return RaisedButton(
      onPressed: () {
        print(_subNotes.text);
      },
      child: Text('Submit'),
    );
  }
}
