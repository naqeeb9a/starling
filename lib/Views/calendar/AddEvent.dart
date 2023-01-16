import 'dart:ui';

import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/calendar/EventProvider.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'EventModel.dart';

import 'package:flutter/material.dart';

import 'calendar.dart';

class AddEvent extends StatefulWidget {

  final Event event;
  final DateTime from;
  AddEvent({
    this.event,
    this.from
});

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  final _formKey = GlobalKey<FormState>();

  bool isAllDay = false;

  DateTime fromDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController fromDateTimeController = TextEditingController();
  TextEditingController toDateTimeController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd HH:mm");

  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now().add(Duration(hours: 1));

  @override
  void initState(){
    super.initState();

    if(widget.event == null){
      fromDate = DateTime.now();
      if(widget.from != null){
        fromDateTimeController.text = DateTimeConversion().getDDMMMYYYandTIME(widget.from.toString());
      } else {
        fromDateTimeController.text = DateTimeConversion().getDDMMMYYYandTIME(DateTime.now().toString());
      }
      toDateTimeController.text = DateTimeConversion().getDDMMMYYYandTIME(DateTime.now().add(Duration(hours: 1)).toString());
    } else {
      titleController.text = widget.event.title;
      fromDateTimeController.text = DateTimeConversion().getDDMMMYYYandTIME(widget.event.from.toString());
      toDateTimeController.text = DateTimeConversion().getDDMMMYYYandTIME(widget.event.to.toString());
      isAllDay = widget.event.isAllDay;
      notesController.text= widget.event.description;
      selectedFromDate = widget.event.from;
      selectedToDate = widget.event.to;
    }
    if(widget.from != null){
      selectedFromDate = widget.from;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.event != null?'Edit Event':'Add Event',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 27,),
        ),
        backgroundColor: GlobalColors.globalColor(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: saveForm,
              child: Icon(Icons.check, color: Colors.white,size: 27,),
            ),
          ),
          if(widget.event != null)
            Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: deleteEvent,
                  child: Icon(Icons.delete, color: Colors.white,size: 27,),
                )
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Title *',
                    labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Cairo",
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontFeatures: <FontFeature>[
                          FontFeature.superscripts(),
                        ]
                    ),
                    hintText: 'Add Title',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                    ),
                    focusColor: GlobalColors.globalColor()
                ),
                validator: (value) => value!= null && value.isEmpty?'Title cannot be empty': null,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
              child: DateTimeField(
                controller: fromDateTimeController,
                decoration: InputDecoration(
                    labelText: 'From Date and time',
                    labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Cairo",
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontFeatures: <FontFeature>[
                          FontFeature.superscripts(),
                        ]
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                    ),
                    focusColor: GlobalColors.globalColor()
                ),
                format: format,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (value){
                  selectedFromDate = value;
                  print(selectedFromDate.toString());
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
              child: Text(
                'Details :',
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Cairo",
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontFeatures: <FontFeature>[
                      FontFeature.superscripts(),
                    ]
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.7),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.2),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: notesController,
                    style: AppTextStyles.c14grey400(),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future saveForm() async {

    bool isValid = true;
    if(isValid){
      final isEditing = widget.event != null;
      final Event event = Event(
        title: titleController.text,
        description: 'Desc',
        from: selectedFromDate,
        to: selectedToDate,
        isAllDay: false
      );

      final provider = Provider.of<EventProvider>(context,listen: false);
      if(isEditing){
        provider.editEvent(event, widget.event);
        Navigator.pop(context);
      }
      provider.addEvent(event);
      Fluttertoast.showToast(msg: 'Event successfully created', backgroundColor: Colors.green, textColor: Colors.white,gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Please enter a title', backgroundColor: Colors.red, textColor: Colors.white,gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);
    }
  }

  Future deleteEvent() async {
      final provider = Provider.of<EventProvider>(context,listen: false);
      provider.deleteEvent(widget.event);
      Fluttertoast.showToast(msg: 'Event has been deleted', backgroundColor: Colors.red, textColor: Colors.white,gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Calendar()));
    }

}
