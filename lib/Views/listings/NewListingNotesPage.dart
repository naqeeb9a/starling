import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewListingNotesPage extends StatefulWidget {
  final int id;
  NewListingNotesPage({this.id});

  @override
  _NewListingNotesPageState createState() => _NewListingNotesPageState();
}

class _NewListingNotesPageState extends State<NewListingNotesPage> {

  final textController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                      backgroundColor: Colors.transparent,
                      body: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for(int i = 0; i < snapshot.data[0]['notes_list'].length; i++)
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
                                                  '${dateTimeConv.getDDMMMYYYandTIME(snapshot.data[0]['notes_list'][i]['created_at'])}',
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
