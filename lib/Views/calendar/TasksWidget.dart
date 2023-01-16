import 'package:crm_app/Views/Viewings/ViewingsDetailsPage.dart';
import 'package:crm_app/Views/calendar/EventDataSource.dart';
import 'package:crm_app/Views/tasks/TaskDetailsPage.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/CalendarTypeColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'EventProvider.dart';
import 'EventViewingPage.dart';

class TasksWidget extends StatefulWidget {


  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context,listen: false);
    final selectedEvents = Provider.of<EventProvider>(context).events;
    var events = [];
    if(selectedEvents.isEmpty){
      return Center(
        child: Text(
          'No Events scheduled!',
          style: AppTextStyles.c22black400(),
        ),
      );
    }
    print(provider.selectedDate);
    String date = new DateFormat("yyyy-MM-dd").format(provider.selectedDate);
    for(var i in selectedEvents){
      String newDate = i.from.toString();
      if(newDate.contains(date)){
        events.add(i);
      }
    }
    /*return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      onTap: (details){
        if(details.appointments == null) return;
        final event = details.appointments.first;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewingPage(event: event,)));
      },
    );*/
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Events scheduled',
                style: AppTextStyles.c20black600(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            for(var i in events)
              Column(
                children: [
                  InkWell(
                    onTap: (){
                      if(i.type == 'lead_view'){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewingsDetailsPage(id: i.object['id'],)));
                      } else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksDetailsPage(id: i.object['id'],)));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 18,
                            color: calendarColor(i.type),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              '${i.title}',
                              style: AppTextStyles.c18black500(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade500,
                    thickness: 0.7,
                  )
                ],
              ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.c16black600(),
        ),
      ),
    );
  }
}
