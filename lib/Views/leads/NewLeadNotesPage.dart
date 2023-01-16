import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/editLeadController.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewLeadNotesPage extends StatefulWidget {
  final int id;
  NewLeadNotesPage({this.id});

  @override
  _NewLeadNotesPageState createState() => _NewLeadNotesPageState();
}

class _NewLeadNotesPageState extends State<NewLeadNotesPage> {
  DateTimeConversion datetimeConv = DateTimeConversion();

  Future<List<dynamic>> getLeads(){
    LeadsDetails lc = LeadsDetails();
    return lc.getLeadsDetails(widget.id);
  }

  final textController = TextEditingController();

  bool showButton = false;

  Future<bool> addNote(String note) async {
    EditLeadController elc = EditLeadController(id: widget.id);
    return elc.sendNote(note);
  }

  @override
  void initState(){
    textController.addListener(() {
      if (textController.text.length > 0)
        setState(() {
          showButton = true;
        });
      if (textController.text.length <= 0)
        setState(() {
          showButton = false;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 100.0),
            child: FutureBuilder(
              future: getLeads(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  if(snapshot.data[0]['notes_list'].length == 0){
                    return Center(
                      child: Text(
                        'No notes added to this lead',
                        style: AppTextStyles.c14grey400(),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0 ; i < snapshot.data[0]['notes_list'].length;i++)
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF9E79B),
                                                borderRadius: BorderRadius.circular(10)
                                              ),

                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${snapshot.data[0]['notes_list'][i]['notes']}',
                                                  style: AppTextStyles.c16grey500(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:10.0),
                                          child: Text(
                                            'Created By: ${snapshot.data[0]['notes_list'][i]['user']['full_name']}',
                                            style: AppTextStyles.c12grey400(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Text(
                                            '${datetimeConv.getDDMMMYYYandTIME(snapshot.data[0]['notes_list'][i]['created_at'])}',
                                            style: AppTextStyles.c12grey400(),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(child: AnimatedSearch(),);
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: GlobalColors.globalColor(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,vertical: MediaQuery.of(context).size.height * 0.025),
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "Type the note message here",
                    hintStyle: AppTextStyles.c14grey400(),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
                    suffixIcon: InkWell(
                      onTap: () async {
                        if(textController.text.length <= 0){
                          Fluttertoast.showToast(
                              msg: 'Please enter a message',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG
                          );
                        } else {
                          String note = textController.text;
                          bool notePosted = await addNote(note);
                          if(notePosted){
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: 'Note created successfully',
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG
                              );
                            });
                          } else {
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: 'Error Occurred while creating note. Please try again',
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG
                              );
                            });
                          }
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Color(0xFF999999),
                      ),
                    )
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
