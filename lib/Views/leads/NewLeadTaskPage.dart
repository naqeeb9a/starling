import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/leads/NewLeadAddTaskPage.dart';
import 'package:crm_app/Views/tasks/TasksCard.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ViewingStatusColors.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';

class NewLeadTaskPage extends StatefulWidget {
  final int id;
  NewLeadTaskPage({this.id});

  @override
  _NewLeadTaskPageState createState() => _NewLeadTaskPageState();
}

class _NewLeadTaskPageState extends State<NewLeadTaskPage> {

  Future<List<dynamic>> getLeadTasks() async {
    LeadsDetails ld = LeadsDetails();
    return ld.getLeadTasks(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getLeadTasks(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if(snapshot.hasData){
            if(snapshot.data.isEmpty){
              return Center(
                child: Text(
                  'No Tasks Found',
                  style: AppTextStyles.c14grey400(),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [

                  for(var x in snapshot.data)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: TasksCard(
                            id: x['id'],
                            status: x['status'],
                            priority: x['priority'],
                            createdDate: x['created_at'],
                            dueDate: x['due_at'],
                            title: x['title'],
                            fullName: x['assigned_to']['full_name'],
                          ),
                        ),

                      ],
                    ),
                ],
              ),
            );
          } else {
            return Center(
              child: AnimatedSearch(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlobalColors.globalColor(),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewLeadAddTaskPage(leadId: widget.id,)));
        },
      ),
    );
  }
}
