import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/dashboard/Dashboard.dart';
import 'package:crm_app/Views/tasks/AddTask.dart';
import 'package:crm_app/Views/tasks/TasksCard.dart';
import 'package:crm_app/controllers/addViewingController.dart';
import 'package:crm_app/controllers/tasksController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ScheduleView extends StatefulWidget {
  int id;
  ScheduleView({this.id});

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {


  String currentUser;
  String selectedUser;
  List<String> userNames = [];
  List users;


  @override
  void initState() {
    agentId = widget.id;


    // TODO: implement initState
    super.initState();
  }

  Future<List> getSchedule() async {
    TasksController tc = TasksController();
    return tc.getTasksSchedule(widget.id);
  }

  Future<List> getDayTasks(String date) async {
    TasksController tc = TasksController();
    return tc.getDayTasks(date,widget.id);
  }

  Future<List> getUsers() async{
    AddViewingController avc = AddViewingController();
    users = await avc.getUserData();
    return users;
  }
  final box = GetStorage();

  DateTime newDate = DateTime.now();
  int agentId;

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  @override
  Widget build(BuildContext context) {
    if(agentId == null){
      agentId = box.read('user_id');
    }
    currentUser = box.read('full_name');
    selectedUser = currentUser;

    List permissions = box.read('permissions');

    return FutureBuilder(
        future: getSchedule(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          //print(snapshot.data);



          if(snapshot.hasData){
            return GestureDetector(
              onTap: _removeFocus,
              onPanDown: (focus) {
                _isPanDown = true;
                _removeFocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Schedule',
                                        style: AppTextStyles.c25grey500(),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FutureBuilder(
                                        future: getDayTasks(newDate.toString()),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            //print(snapshot.data);
                                            if(snapshot.data[0] == [] || snapshot.data[0]['data'].length == 0){
                                              return Text(
                                                'No tasks for today',
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data[0]['data'].length == 1?'${snapshot.data[0]['data'].length} task for today':'${snapshot.data[0]['data'].length} tasks for today',
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }
                                          } else {
                                            return Text(
                                              'No tasks for today',
                                              style: AppTextStyles.c14grey400(),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  if(permissions.contains('todo_view_other'))
                                    Padding(
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                                      child: GestureDetector(
                                        onTap: (){
                                          showGeneralDialog(
                                            barrierLabel: "Barrier",
                                            barrierDismissible: true,
                                            barrierColor: Colors.black.withOpacity(0.5),
                                            transitionDuration: Duration(milliseconds: 700),
                                            context: context,
                                            pageBuilder: (_, __, ___) {
                                              return Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                                                  child: Container(

                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(15)
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            'Select Agent',
                                                            style: AppTextStyles.c18black500(),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(context).size.height *0.03,
                                                        ),
                                                        FutureBuilder(
                                                            future: getUsers(),
                                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                              if(snapshot.hasData){
                                                                for(var x in snapshot.data){
                                                                  userNames.add(x['full_name']);
                                                                }
                                                                return Material(
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                                                    child: DropdownButtonFormField(
                                                                      items: users.map((dynamic user){
                                                                        return DropdownMenuItem<dynamic>(
                                                                          child: Text(
                                                                            '${user['full_name']}',
                                                                            style: AppTextStyles.c14grey400(),
                                                                          ),
                                                                          value: user['id'],
                                                                        );
                                                                      }).toList(),
                                                                      value: agentId,
                                                                      selectedItemBuilder: (BuildContext context) {
                                                                        return userNames.map<Widget>((String item) {
                                                                          return Text(item,style: AppTextStyles.c14grey400(),);
                                                                        }).toList();
                                                                      },
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          agentId = value;
                                                                        });
                                                                      },
                                                                      hint: Text('Select User',style: AppTextStyles.c14grey400(),),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                return Center(
                                                                  child: AnimatedSearch(),
                                                                );
                                                              }
                                                            }
                                                        ),

                                                        SizedBox(
                                                          height: MediaQuery.of(context).size.height *0.01,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            TextButton(
                                                              onPressed: (){
                                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: AppTextStyles.c14black500(),
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {

                                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(id: agentId,)));
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                  'Submit',
                                                                  style: AppTextStyles.c14black500(),
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            transitionBuilder: (_, anim, __, child) {
                                              return SlideTransition(
                                                position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                                                child: child,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: GlobalColors.globalColor(),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                                            child: Icon(
                                              Icons.person,
                                              size: 26,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),

                          ],
                        ),
                      ),
                    ),

                    //TODAY
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Today, ${DateTimeConversion().getDDMMMYYY(newDate.toString())}',
                              style: AppTextStyles.c20grey500(),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            FutureBuilder(
                              future: getDayTasks(newDate.toString()),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  //print(snapshot.data);
                                  if(snapshot.data[0] == []){
                                    return SizedBox(width: 0,height: 0,);
                                  } else {
                                    //print(snapshot.data[0]['data']);
                                    return Column(
                                      children: [
                                        for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: TasksCard(
                                              id: snapshot.data[0]['data'][i]['id'],
                                              status: snapshot.data[0]['data'][i]['status'],
                                              priority: snapshot.data[0]['data'][i]['priority'],
                                              createdDate: snapshot.data[0]['data'][i]['created_at'],
                                              dueDate: snapshot.data[0]['data'][i]['due_at'],
                                              title: snapshot.data[0]['data'][i]['title'],
                                              fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                            ),
                                          ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }
                                } else {
                                  return SizedBox(width: 0,height: 0,);
                                }
                              },
                            ),

                            //Add Button
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap:(){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFFE6E6E6)),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            )

                          ],
                        ),
                      ),
                    ),

                    //TOMORROW
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Tomorrow, ${DateTimeConversion().getDDMMMYYY(newDate.add(Duration(days: 1)).toString())}',
                              style: AppTextStyles.c20grey500(),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            FutureBuilder(
                              future: getDayTasks(newDate.add(Duration(days: 1)).toString()),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  //print(snapshot.data);
                                  if(snapshot.data[0] == []){
                                    return SizedBox(width: 0,height: 0,);
                                  } else {
                                    //print(snapshot.data[0]['data']);
                                    return Column(
                                      children: [
                                        for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: TasksCard(
                                              id: snapshot.data[0]['data'][i]['id'],
                                              status: snapshot.data[0]['data'][i]['status'],
                                              priority: snapshot.data[0]['data'][i]['priority'],
                                              createdDate: snapshot.data[0]['data'][i]['created_at'],
                                              dueDate: snapshot.data[0]['data'][i]['due_at'],
                                              title: snapshot.data[0]['data'][i]['title'],
                                              fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                            ),
                                          ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }
                                } else {
                                  return SizedBox(width: 0,height: 0,);
                                }
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFFE6E6E6)),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            )

                          ],
                        ),
                      ),
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        elevation: 5,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '${DateFormat('EEEE').format(newDate.add(Duration(days: 2)))}, ${DateTimeConversion().getDDMMMYYY(newDate.add(Duration(days: 2)).toString())}',
                              style: AppTextStyles.c20grey500(),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            FutureBuilder(
                              future: getDayTasks(newDate.add(Duration(days: 2)).toString()),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  //print(snapshot.data);
                                  if(snapshot.data[0] == []){
                                    return SizedBox(width: 0,height: 0,);
                                  } else {
                                    //print(snapshot.data[0]['data']);
                                    return Column(
                                      children: [
                                        for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: TasksCard(
                                              id: snapshot.data[0]['data'][i]['id'],
                                              status: snapshot.data[0]['data'][i]['status'],
                                              priority: snapshot.data[0]['data'][i]['priority'],
                                              createdDate: snapshot.data[0]['data'][i]['created_at'],
                                              dueDate: snapshot.data[0]['data'][i]['due_at'],
                                              title: snapshot.data[0]['data'][i]['title'],
                                              fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                            ),
                                          ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }
                                } else {
                                  return SizedBox(width: 0,height: 0,);
                                }
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFFE6E6E6)),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            )

                          ],
                        ),
                      ),
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${DateFormat('EEEE').format(newDate.add(Duration(days: 3)))}, ${DateTimeConversion().getDDMMMYYY(newDate.add(Duration(days: 3)).toString())}',
                                style: AppTextStyles.c20grey500(),
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              FutureBuilder(
                                future: getDayTasks(newDate.add(Duration(days: 3)).toString()),
                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                  if(snapshot.hasData){
                                    //print(snapshot.data);
                                    if(snapshot.data[0] == []){
                                      return SizedBox(width: 0,height: 0,);
                                    } else {
                                      //print(snapshot.data[0]['data']);
                                      return Column(
                                        children: [
                                          for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: TasksCard(
                                                id: snapshot.data[0]['data'][i]['id'],
                                                status: snapshot.data[0]['data'][i]['status'],
                                                priority: snapshot.data[0]['data'][i]['priority'],
                                                createdDate: snapshot.data[0]['data'][i]['created_at'],
                                                dueDate: snapshot.data[0]['data'][i]['due_at'],
                                                title: snapshot.data[0]['data'][i]['title'],
                                                fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                              ),
                                            ),
                                          SizedBox(height: 10,)
                                        ],
                                      );
                                    }
                                  } else {
                                    return SizedBox(width: 0,height: 0,);
                                  }
                                },
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Color(0xFFE6E6E6)),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Color(0xFFE6E6E6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              )

                            ],
                          ),
                          elevation: 5
                      ),
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${DateFormat('EEEE').format(newDate.add(Duration(days: 4)))}, ${DateTimeConversion().getDDMMMYYY(newDate.add(Duration(days: 4)).toString())}',
                                style: AppTextStyles.c20grey500(),
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              FutureBuilder(
                                future: getDayTasks(newDate.add(Duration(days: 4)).toString()),
                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                  if(snapshot.hasData){
                                    //print(snapshot.data);
                                    if(snapshot.data[0] == []){
                                      return SizedBox(width: 0,height: 0,);
                                    } else {
                                      //print(snapshot.data[0]['data']);
                                      return Column(
                                        children: [
                                          for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: TasksCard(
                                                id: snapshot.data[0]['data'][i]['id'],
                                                status: snapshot.data[0]['data'][i]['status'],
                                                priority: snapshot.data[0]['data'][i]['priority'],
                                                createdDate: snapshot.data[0]['data'][i]['created_at'],
                                                dueDate: snapshot.data[0]['data'][i]['due_at'],
                                                title: snapshot.data[0]['data'][i]['title'],
                                                fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                              ),
                                            ),
                                          SizedBox(height: 10,)
                                        ],
                                      );
                                    }
                                  } else {
                                    return SizedBox(width: 0,height: 0,);
                                  }
                                },
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Color(0xFFE6E6E6)),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Color(0xFFE6E6E6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              )

                            ],
                          ),
                          elevation: 5
                      ),
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '${DateFormat('EEEE').format(newDate.add(Duration(days: 5)))}, ${DateTimeConversion().getDDMMMYYY(newDate.add(Duration(days: 5)).toString())}',
                              style: AppTextStyles.c20grey500(),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            FutureBuilder(
                              future: getDayTasks(newDate.add(Duration(days: 5)).toString()),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  //print(snapshot.data);
                                  if(snapshot.data[0] == []){
                                    return SizedBox(width: 0,height: 0,);
                                  } else {
                                    //print(snapshot.data[0]['data']);
                                    return Column(
                                      children: [
                                        for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: TasksCard(
                                              id: snapshot.data[0]['data'][i]['id'],
                                              status: snapshot.data[0]['data'][i]['status'],
                                              priority: snapshot.data[0]['data'][i]['priority'],
                                              createdDate: snapshot.data[0]['data'][i]['created_at'],
                                              dueDate: snapshot.data[0]['data'][i]['due_at'],
                                              title: snapshot.data[0]['data'][i]['title'],
                                              fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                            ),
                                          ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }
                                } else {
                                  return SizedBox(width: 0,height: 0,);
                                }
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFFE6E6E6)),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            )

                          ],
                        ),
                        elevation: 5,
                      ),
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '${DateFormat('EEEE').format(newDate.add(Duration(days: 6)))}, ${DateTimeConversion().getDDMMMYYY(newDate.add(Duration(days: 6)).toString())}',
                              style: AppTextStyles.c20grey500(),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            FutureBuilder(
                              future: getDayTasks(newDate.add(Duration(days: 6)).toString()),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  //print(snapshot.data);
                                  if(snapshot.data[0] == []){
                                    return SizedBox(width: 0,height: 0,);
                                  } else {
                                    //print(snapshot.data[0]['data']);
                                    return Column(
                                      children: [
                                        for(int i = 0;i< snapshot.data[0]['data'].length;i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: TasksCard(
                                              id: snapshot.data[0]['data'][i]['id'],
                                              status: snapshot.data[0]['data'][i]['status'],
                                              priority: snapshot.data[0]['data'][i]['priority'],
                                              createdDate: snapshot.data[0]['data'][i]['created_at'],
                                              dueDate: snapshot.data[0]['data'][i]['due_at'],
                                              title: snapshot.data[0]['data'][i]['title'],
                                              fullName: snapshot.data[0]['data'][i]['created_by']!=null?snapshot.data[0]['data'][i]['created_by']['full_name']:'',
                                            ),
                                          ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }
                                } else {
                                  return SizedBox(width: 0,height: 0,);
                                }
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTask()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFFE6E6E6)),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            )

                          ],
                        ),
                        elevation: 5,
                      ),
                    ),


                  ],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Your Schedule',
                                  style: AppTextStyles.c25grey500(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                              ''
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }

  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }
  }

}
