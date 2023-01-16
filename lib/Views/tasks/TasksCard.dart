import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/PriorityColors.dart';
import 'package:flutter/material.dart';

import 'TaskDetailsPage.dart';

class TasksCard extends StatelessWidget {
  final int id;
  final String status;
  final String priority;
  String createdDate;
  final String dueDate;
  final String title;
  final String fullName;

  TasksCard({this.id, this.status, this.priority, this.createdDate, this.dueDate, this.title, this.fullName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksDetailsPage(
          id: id,
        )));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 2.0,
                ),
              ],
            color: priorityColor(priority)
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child:  RotatedBox(
                  quarterTurns: 3,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text:
                        '$priority',
                        style: AppTextStyles.c14white400(),
                        /*children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: RotatedBox(
                                      quarterTurns: 1,
                                      child: Icon(
                                        apptype.findReferenceicon(application_type),
                                        size: 13.0,
                                        color: Colors.white,
                                      )),
                                ),
                              )
                            ],*/
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 10,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            12.0, 12, 0.0, 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 10, 0),
                              child: Text(
                                '$title',
                                style: AppTextStyles.c16black600(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 10, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color(0xFFB3B3B3)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                          child: Text(
                                            '${DateTimeConversion().getDDMMMYYYandTIME(dueDate)}',
                                            style: AppTextStyles.c10white400(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: taskStatus(status)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 3.0),
                                          child: Text(
                                            '$status',
                                            style: AppTextStyles.c10white400(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.02,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'By: $fullName',
                                      style: AppTextStyles.c12grey400(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
