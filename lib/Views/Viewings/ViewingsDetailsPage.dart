import 'dart:convert';
import 'dart:io';
import 'package:crm_app/Views/Viewings/ViewingsList.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/viewingsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ViewingStatusColors.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewingsDetailsPage extends StatelessWidget {
  final int id;
  ViewingsDetailsPage({this.id});


  Future<List<dynamic>> getViewingData(){
    ViewingsController vc = ViewingsController();
    return vc.getViewingData(id);
  }



  DateTimeConversion dateTimeConversion = DateTimeConversion();


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
            title: Center(
              child: Text(
                'Viewing Details',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: GlobalColors.globalColor(),
          ),
          body: FutureBuilder(
            future: getViewingData(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 11,
                                color: viewingStatusColors(snapshot.data[0]['status']),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${snapshot.data[0]['status']}',
                                style: TextStyle(
                                  color: viewingStatusColors(snapshot.data[0]['status']),
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Created On: ${dateTimeConversion.getDDMMMYYY(snapshot.data[0]['created_at'])}',
                            style: AppTextStyles.c14grey400(),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${snapshot.data[0]['agent']['full_name']}',
                            style: AppTextStyles.c18black500(),
                          ),
                          Text(
                            'Updated On: ${dateTimeConversion.getDDMMMYYY(snapshot.data[0]['updated_at'])}',
                            style: AppTextStyles.c14grey400(),
                          )
                        ],
                      ),
                      Text(
                        'by ${snapshot.data[0]['user']['full_name']}',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Row(
                        children: [
                          Text(
                            'LEAD: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 14
                            ),
                          ),
                          Text(
                            '${snapshot.data[0]['lead']['reference']}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 14
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'LISTING: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 14
                                ),
                              ),
                              Text(
                                '${snapshot.data[0]['listing']['reference']}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              '${dateTimeConversion.getDDMMMYYYandTIME(snapshot.data[0]['datetime'])}',
                              style: AppTextStyles.c12grey400(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        height: 0.2,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      if(snapshot.data[0]['notes'] != null && snapshot.data[0]['notes'] != '')
                        Text(
                          'NOTES :',
                          style: AppTextStyles.c16black600(),
                        ),
                      (snapshot.data[0]['notes'] != null)?Text('${snapshot.data[0]['notes']}', style: AppTextStyles.c16black500(),):SizedBox(width: 0,),

                      if(snapshot.data[0]['status'] == 'Scheduled')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                bool statusUpdated = false;
                                try{
                                  String url = '${ApiRoutes.BASE_URL}/api/leads/views/$id';
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  Map data = {'status': 'Successful'};
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
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewingsList()));
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
                                  'Successful',
                                  style: AppTextStyles.c16white600(),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                bool statusUpdated = false;
                                try{
                                  String url = '${ApiRoutes.BASE_URL}/api/leads/views/$id';
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  Map data = {'status': 'Unsuccessful'};
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
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewingsList()));
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
                                  'Unsuccessful',
                                  style: AppTextStyles.c16white600(),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                bool statusUpdated = false;
                                try{
                                  String url = '${ApiRoutes.BASE_URL}/api/leads/views/$id';
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  Map data = {'status': 'Cancelled'};
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
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewingsList()));
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
                                  'Cancel',
                                  style: AppTextStyles.c16white600(),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
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
