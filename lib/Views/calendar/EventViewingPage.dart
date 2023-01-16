import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/calendar/AddEvent.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'EventModel.dart';
import 'EventProvider.dart';
import 'calendar.dart';

class EventViewingPage extends StatefulWidget {
  final Event event;

  EventViewingPage({this.event});

  @override
  _EventViewingPageState createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Event Details',
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
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEvent(event: widget.event,)));
              },
              child: Icon(Icons.edit, color: Colors.white,size: 27,),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: deleteEvent,
                child: Icon(Icons.delete, color: Colors.white,size: 27,),
              )
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
            child: Text(
              '${widget.event.title}',
              style: AppTextStyles.c20black600(),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
                child: Text(
                  'From: ${DateTimeConversion().getDDMMMYYYandTIME(widget.event.from.toString())}',
                  style: AppTextStyles.c16black600(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
                child: Text(
                  'To: ${DateTimeConversion().getDDMMMYYYandTIME(widget.event.to.toString())}',
                  style: AppTextStyles.c16black600(),
                ),
              ),
            ],
          ),
          /*SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'All Day Event: ',
                  style: AppTextStyles.c16black600(),
                ),
                event.isAllDay == true?Icon(Icons.check,size: 24,color: Colors.green,):Icon(Icons.close,size: 24,color: Colors.red,),
              ],
            ),
          ),*/
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
            child: Text(
              '${widget.event.description}',
              style: AppTextStyles.c16black600(),
            ),
          ),
        ],
      ),
    );
  }

  Future deleteEvent() async {
    final provider = Provider.of<EventProvider>(context,listen: false);
    provider.deleteEvent(widget.event);
    Fluttertoast.showToast(msg: 'Event has been deleted', backgroundColor: Colors.red, textColor: Colors.white,gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Calendar()));
  }
}
