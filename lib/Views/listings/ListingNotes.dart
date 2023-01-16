import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListingNotes extends StatefulWidget {
  final int id;
  ListingNotes({this.id});

  @override
  _ListingNotesState createState() => _ListingNotesState();
}

class _ListingNotesState extends State<ListingNotes> {


  final textController = TextEditingController();

  bool showButton = false;

  DateTimeConversion dateTimeConv = DateTimeConversion();

  Future<List<dynamic>> getListingDetails() async {
    ListingController lc = ListingController();
    return lc.getListingDetails(widget.id);
  }

  Future<bool> addNote(String note) async {
    ListingController lc = ListingController();
    return lc.newNote(widget.id, note);
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 100.0),
            child: FutureBuilder(
              future: getListingDetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){

                  if(snapshot.data[0]['notes_list'].length > 0){
                    return Scaffold(
                      body: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for(int i = 0; i < snapshot.data[0]['notes_list'].length; i++)
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 5.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: CircleAvatar(
                                                      minRadius: 23,
                                                      backgroundImage: snapshot.data[0]['notes_list'][i]['user']['profile_picture_url']!=null && snapshot.data[0]['notes_list'][i]['user']['profile_picture_url']!= ''?NetworkImage(snapshot.data[0]['notes_list'][i]['user']['profile_picture_url']):NetworkImage('https://ui-avatars.com/api/?background=EEEEEE&color=3F729B&name=${snapshot.data[0]['notes_list'][i]['user']['full_name']}&size=128&font-size=0.33'),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Text(
                                                      '${snapshot.data[0]['notes_list'][i]['user']['full_name']}',
                                                      style: AppTextStyles.c14black500(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: 4.0),
                                              child: Text(
                                                '${dateTimeConv.getDDMMMYYYandTIME(snapshot.data[0]['notes_list'][i]['created_at'])}',
                                                style: AppTextStyles.c12grey400(),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${snapshot.data[0]['notes_list'][i]['notes']}',
                                                  style: AppTextStyles.c14black600(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('No notes available', style: AppTextStyles.c14grey400(),));
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
              padding: EdgeInsets.only(left: 10,right: 10,top: 10),
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  if(showButton)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: FloatingActionButton(
                        onPressed: () async {
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
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: GlobalColors.globalColor(),
                        elevation: 0,
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
