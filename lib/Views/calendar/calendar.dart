import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/calendar/AddEvent.dart';
import 'package:crm_app/controllers/calendarController.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'EventModel.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'EventDataSource.dart';
import 'EventProvider.dart';
import 'TasksWidget.dart';

class Calendar extends StatefulWidget {


  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime dateSel;

  void initState(){
    EventProvider().clearEvent();
    super.initState();
  }

  Future<List<Event>> getCal(){
    CalendarControl cc = CalendarControl();
    return cc.fetchCalendar();
  }

  @override
  Widget build(BuildContext context) {

    final events = Provider.of<EventProvider>(context).events;
    events.clear();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Calendar',
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsListPage()));
              },
              child: Icon(Icons.notifications, color: Colors.white,size: 27,),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCal(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            final provider = Provider.of<EventProvider>(context,listen: false);
            for(var x in snapshot.data){
              provider.addEvent(x);
            }
            final events = Provider.of<EventProvider>(context).events;
            return SfCalendar(
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              onSelectionChanged: (details){
                dateSel = details.date;
                print(dateSel);
              },
              dataSource: EventDataSource(events),
              onTap: (details){
                final provider = Provider.of<EventProvider>(context,listen: false);

                provider.setDate(details.date);
                showModalBottomSheet(
                  context: context,
                  builder: (context) => TasksWidget(),
                );
              },
            );
          } else {
            return Center(child: AnimatedSearch());
          }
        },
      ),
    );
  }
}


