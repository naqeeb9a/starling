import 'dart:convert';
import 'dart:io';
import 'package:crm_app/Views/tasks/TasksListingPage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/tasksController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/PriorityColors.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TasksDetailsPage extends StatelessWidget {
  final int id;
  String status;
  String priority;
  String createdDate;
  String dueDate;
  String title;
  String description;

  TasksDetailsPage({this.id,this.status,this.priority,this.createdDate,this.dueDate,this.title,this.description});
  DateTimeConversion dateTimeConversion = DateTimeConversion();

  Future<List<dynamic>> getTask() async{
    TasksController tc = TasksController();
    return tc.getTaskDetails(id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/anwbackground.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: GlobalColors.globalColor(),
            elevation: 10,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
            ),
            title: Text(
              'Task Details',
              style: TextStyle(
                fontFamily: 'Montserrat-Regular',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: (){
                  },
                  child: Icon(Icons.notifications, color: GlobalColors.globalColor(),size: 27,),
                ),
              )
            ],
          ),
          body: FutureBuilder(
            future: getTask(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                status = snapshot.data[0]['status'];
                priority = snapshot.data[0]['priority'];
                createdDate = snapshot.data[0]['created_at'];
                dueDate = snapshot.data[0]['due_at'];
                title = snapshot.data[0]['title'];
                description = snapshot.data[0]['description'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 14,
                                color: taskStatus(status),
                              ),
                              SizedBox(width: 3,),
                              Text(
                                '$status',
                                style: TextStyle(
                                    color: taskStatus(status),
                                    fontSize: 16,
                                    fontFamily: 'Montserrat-Regular'
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right:8.0),
                          child: Row(
                            children: [
                              Text(
                                'Priority: ',
                                style: AppTextStyles.c12grey400(),
                              ),

                              Text(
                                '$priority',
                                style: TextStyle(
                                    color: priorityColor(priority),
                                    fontSize: 14,
                                    fontFamily: 'Montserrat-Regular'
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(createdDate != null && createdDate != '')
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              'Created on: ${dateTimeConversion.getDDMMMYYY(createdDate)}',
                              style: AppTextStyles.c14grey400(),
                            ),
                          )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RawChip(
                        backgroundColor: Color(0xF1F295C0),
                        label: Text('Due on: ${dateTimeConversion.getDDMMMYYY(dueDate)}'),
                        labelStyle: AppTextStyles.c14black500(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '$title',
                        style: AppTextStyles.c20black600(),
                      ),
                    ),
                    if(description != null && description != '')
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '$description',
                          style: AppTextStyles.c16black500(),
                        ),
                      ),
                    Divider(
                      height: 0.2,
                      thickness: 0.6,
                      color: Colors.grey,
                    ),

                    if(status == 'Pending')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              bool statusUpdated = false;
                              try{
                                String url = '${ApiRoutes.BASE_URL}/api/tasks/$id';
                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                Map data = {'status': 'In Progress'};
                                var response = await http.put(
                                    Uri.parse(url),
                                    headers: {
                                      HttpHeaders.authorizationHeader:
                                      'Bearer ${sharedPreferences.get('token')}',
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(data)
                                );
                                if(response.statusCode == 201){
                                  print(response.body);
                                  statusUpdated = true;
                                } else {
                                  print(response.body);
                                  statusUpdated = false;
                                }
                              } catch(e){
                                print(e);
                                statusUpdated = false;
                              }
                              if(statusUpdated){
                                Fluttertoast.showToast(
                                  msg: 'Status updated',
                                  backgroundColor: Colors.green,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  textColor: Colors.white,
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TasksListingPage()));
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'An Error has occurred',
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                'In Progress',
                                style: AppTextStyles.c16white600(),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.yellow.shade700),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              bool statusUpdated = false;
                              try{
                                String url = '${ApiRoutes.BASE_URL}/api/tasks/$id';
                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                Map data = {'status': 'Completed'};
                                var response = await http.put(
                                    Uri.parse(url),
                                    headers: {
                                      HttpHeaders.authorizationHeader:
                                      'Bearer ${sharedPreferences.get('token')}',
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(data)
                                );
                                if(response.statusCode == 201){
                                  print(response.body);
                                  statusUpdated = true;
                                } else {
                                  print(response.body);
                                  statusUpdated = false;
                                }
                              } catch(e){
                                print(e);
                                statusUpdated = false;
                              }
                              if(statusUpdated){
                                Fluttertoast.showToast(
                                  msg: 'Status updated',
                                  backgroundColor: Colors.green,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  textColor: Colors.white,
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TasksListingPage()));
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'An Error has occurred',
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                'Completed',
                                style: AppTextStyles.c16white600(),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                            ),
                          ),
                        ],
                      ),
                    if(status == 'In Progress')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              bool statusUpdated = false;
                              try{
                                String url = '${ApiRoutes.BASE_URL}/api/tasks/$id';
                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                Map data = {'status': 'Completed'};
                                var response = await http.put(
                                    Uri.parse(url),
                                    headers: {
                                      HttpHeaders.authorizationHeader:
                                      'Bearer ${sharedPreferences.get('token')}',
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(data)
                                );
                                if(response.statusCode == 201){
                                  print(response.body);
                                  statusUpdated = true;
                                } else {
                                  print(response.body);
                                  statusUpdated = false;
                                }
                              } catch(e){
                                print(e);
                                statusUpdated = false;
                              }
                              if(statusUpdated){
                                Fluttertoast.showToast(
                                  msg: 'Status updated',
                                  backgroundColor: Colors.green,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  textColor: Colors.white,
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TasksListingPage()));
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'An Error has occurred',
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                'Completed',
                                style: AppTextStyles.c16white600(),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                            ),
                          ),
                        ],
                      )
                  ],
                );
              } else {
                return Center(child: NetworkLoading(),);
              }
            },
          ),
        ),
      ],
    );
  }
}
