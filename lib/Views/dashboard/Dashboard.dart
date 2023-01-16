import 'package:convex_bottom_app_bar/convex_bottom_app_bar.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Login/LogoutPage.dart';
import 'package:crm_app/Views/NearByListings/NearByListings.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/Viewings/ViewingsList.dart';
import 'package:crm_app/Views/calendar/calendar.dart';
import 'package:crm_app/Views/contacts/AddContact.dart';
import 'package:crm_app/Views/contacts/ContactsListing.dart';
import 'package:crm_app/Views/dashboard/Schedule.dart';
import 'package:crm_app/Views/dashboard/indicator.dart';
import 'package:crm_app/Views/leads/LeadsLandingPage.dart';
import 'package:crm_app/Views/leads/NewLeadsListingPage.dart';
import 'package:crm_app/Views/listings/ListingLandingPage.dart';
import 'package:crm_app/Views/listings/NewListingLandingPage.dart';
import 'package:crm_app/Views/tasks/AddTask.dart';
import 'package:crm_app/Views/tasks/TaskDetailsPage.dart';
import 'package:crm_app/Views/tasks/TasksCard.dart';
import 'package:crm_app/Views/tasks/TasksListingPage.dart';
import 'package:crm_app/controllers/dashboardController.dart';
import 'package:crm_app/controllers/loginController.dart';
import 'package:crm_app/controllers/tasksController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/LeadsSubStatusColors.dart';
import 'package:crm_app/widgets/ColorFunctions/ListingStatusColors.dart';
import 'package:crm_app/widgets/ColorFunctions/PriorityColors.dart';
import 'package:crm_app/widgets/ProfileHeader.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {

  int id;
  DashboardPage({this.id});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {

  Animation<double> _animation;
  AnimationController _animationController;

  Future<ListingCountResponse> futureListingCount;
  Future<LeadsCountResponse> futureLeadsCount;
  Future<TodayViewingsCount> futureViewingsCount;
  Future<PublishedListingsCount> futurePublishedCount;
  Future<PortalsCount> futurePortalsCount;
  Future<Tasks> futureTasks;
  List<String> permissions;


  DateTimeConversion dateTimeConversion = DateTimeConversion();
  final box = GetStorage();



  Future<List> getChart() async {
    DashboardController dc = DashboardController();
    return dc.getChartData();
  }

  Future<List> getSchedule() async {
    TasksController tc = TasksController();
    return tc.getTasksSchedule(widget.id);
  }

  Future<List> getDayTasks(String date) async {
    TasksController tc = TasksController();
    return tc.getDayTasks(date,widget.id);
  }

  int roleId;

  @override
  void initState() {
    roleId = box.read('role_id');
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  int currentPage = 0;

  int touchedIndex = -1;

  void onBottomIconPressed(int index) {
    setState(() {
      currentPage = index;
    });
  }
  DateTime newDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    List permissions = box.read('permissions');
    LoginController().fetchProfile(context);
    futureListingCount = DashboardController().fetchListingCount();
    futureLeadsCount = DashboardController().fetchLeadsCount();
    futureViewingsCount = DashboardController().fetchViewingsCount();
    futurePublishedCount = DashboardController().fetchPublishedListings();
    futurePortalsCount = DashboardController().getPortalsCount();
    futureTasks = DashboardController().getTasks();
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
            elevation: 10,
            iconTheme: IconThemeData(color: GlobalColors.globalColor(), size: 27),
            backgroundColor: Colors.white,
            title: Center(child: Image.asset('assets/images/anw.png',scale: 2,)),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsListPage()));
                  },
                  child: Icon(Icons.notifications, color: GlobalColors.globalColor(),size: 27,),
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                SafeArea(child: ProfileHeader()),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewListingLandingPage()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.list,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Listings',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NearByListings(rad: 5000,)));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.location_on,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Nearby Listings',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewLeadsListingPage()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.bar_chart,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Leads',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactsListing()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.contacts,
                                  size: 43,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Contacts',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TasksListingPage()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.task,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Tasks',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ViewingsList()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Viewings',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Calendar()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.globalColor(),
                              radius: 30,
                              child: Center(
                                child: Icon(
                                  Icons.calendar_today,
                                  size: 42,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Calendar',
                              style: AppTextStyles.c16Global500(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                ListTile(
                                  title: Text("Logout",
                                      style: AppTextStyles.c16black600()),
                                  leading: Icon(Icons.logout),
                                  onTap: () {
                                    showGeneralDialog(
                                      barrierLabel: "Label",
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withOpacity(0.5),
                                      transitionDuration: Duration(milliseconds: 200),
                                      context: context,
                                      pageBuilder: (context, anim1, anim2) {
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                            child: SizedBox.expand(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [LogoutPage()],
                                                )),
                                            margin: EdgeInsets.only(
                                                bottom: 50, left: 12, right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      transitionBuilder:
                                          (context, anim1, anim2, child) {
                                        return SlideTransition(
                                          position: Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                              .animate(anim1),
                                          child: child,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ))))
              ],
            ),
          ),
          body: IndexedStack(
            index: currentPage,
            children: [

              ScheduleView(id: widget.id,),

              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Headings
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,left: 5.0,right: 5.0,bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewListingLandingPage()));
                            },
                            child: Column(
                              children: [
                                //DECOR LISTINGS
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: GlobalColors.globalColor(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Icon(
                                            Icons.home_work,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        Text(
                                          'LISTINGS',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                //NUMBER OF LISTINGS
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: GlobalColors.globalColor(),
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: Center(
                                    child: FutureBuilder<ListingCountResponse>(
                                      future: futureListingCount,
                                      builder: (context,snapshot){
                                        if(snapshot.hasData){
                                          var totalListingCount = snapshot.data.approved + snapshot.data.archived +snapshot.data.draft + snapshot.data.pending!=null?snapshot.data.pending:0 + snapshot.data.scheduled + snapshot.data.published + snapshot.data.unpublished + snapshot.data.closed + snapshot.data.rejected + snapshot.data.expired;
                                          return Text(
                                            '$totalListingCount',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w800
                                            ),
                                          );
                                        } else {
                                          return Center(child: AnimatedSearch(),);
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewLeadsListingPage()));
                            },
                            child: Column(
                              children: [
                                //DECOR LISTINGS
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: GlobalColors.globalColor(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Icon(
                                            Icons.contact_phone,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        Text(
                                          'LEADS',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                //NUMBER OF LISTINGS
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: GlobalColors.globalColor(),
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: Center(
                                    child: FutureBuilder<LeadsCountResponse>(
                                      future: futureLeadsCount,
                                      builder: (context,snapshot){
                                        if(snapshot.hasData){
                                          var totalListingCount = snapshot.data.active + snapshot.data.closed;
                                          return Text(
                                            '$totalListingCount',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w800
                                            ),
                                          );
                                        } else {
                                          return Center(child: AnimatedSearch(),);
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewingsList()));
                            },
                            child: Column(
                              children: [
                                //DECOR LISTINGS
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: GlobalColors.globalColor(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        Text(
                                          'VIEWINGS',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                //NUMBER OF LISTINGS
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: GlobalColors.globalColor(),
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: Center(
                                    child: FutureBuilder<TodayViewingsCount>(
                                      future: futureViewingsCount,
                                      builder: (BuildContext context,AsyncSnapshot snapshot){
                                        if(snapshot.hasData){

                                          return Text(
                                            '${snapshot.data.paginator['total']}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w800
                                            ),
                                          );
                                        } else {
                                          return Center(child: AnimatedSearch(),);
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //LISTINGS
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.023),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02,),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.0),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewListingLandingPage()));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.97,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                              color: GlobalColors.globalColor(),
                                            ),
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                                  child: Text(
                                                    'LISTINGS',
                                                    style: AppTextStyles.c16white600(),
                                                  ),
                                                ),
                                                Align(alignment: Alignment.topRight,child: Padding(
                                                  padding: EdgeInsets.only(top: 10.0,right: 15),
                                                  child: InkWell(
                                                      onTap: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewListingLandingPage()));
                                                      },
                                                      child: Icon(Icons.read_more,size: 25,color: Colors.white,)),
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              //Published Column
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: ['%7B%22column%22:%22portal_status%22,%22operator%22:%22=%22,%22value%22:%22Published%22%7D'],)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF28B16D),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Icon(
                                                          Icons.publish,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),

                                                      FutureBuilder<PublishedListingsCount>(
                                                        future: futurePublishedCount,
                                                        builder: (context,snapshot){
                                                          if(snapshot.hasData){
                                                            return Text(
                                                              '${snapshot.data.rental + snapshot.data.sale}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontFamily: 'Cairo',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(child: NetworkLoading(),);
                                                          }
                                                        },
                                                      ),
                                                      Text(
                                                        'Published',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontFamily: 'Cairo',
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),

                                              //Draft Column
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: ['%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22Draft%22%7D'],)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF0974F1),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Icon(
                                                          Icons.bookmark_border,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      FutureBuilder<ListingCountResponse>(
                                                        future: futureListingCount,
                                                        builder: (context,snapshot){
                                                          if(snapshot.hasData){
                                                            //var totalListingCount = snapshot.data.approved + snapshot.data.archived +snapshot.data.draft + snapshot.data.pending + snapshot.data.scheduled + snapshot.data.published + snapshot.data.unpublished + snapshot.data.closed + snapshot.data.rejected + snapshot.data.expired;
                                                            return Text(
                                                              '${snapshot.data.draft}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontFamily: 'Cairo',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(child: NetworkLoading(),);
                                                          }
                                                        },
                                                      ),
                                                      Text(
                                                        'Draft',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontFamily: 'Cairo',
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),

                                              //Pending Column
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: ['%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22Pending%22%7D'],)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFF930F),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Icon(
                                                          Icons.published_with_changes,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      FutureBuilder<ListingCountResponse>(
                                                        future: futureListingCount,
                                                        builder: (context,snapshot){
                                                          if(snapshot.hasData){
                                                            //var totalListingCount = snapshot.data.approved + snapshot.data.archived +snapshot.data.draft + snapshot.data.pending + snapshot.data.scheduled + snapshot.data.published + snapshot.data.unpublished + snapshot.data.closed + snapshot.data.rejected + snapshot.data.expired;
                                                            return Text(
                                                              '${snapshot.data.pending}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontFamily: 'Cairo',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(child: NetworkLoading(),);
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Text(
                                                          'Pending',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontFamily: 'Cairo',
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),

                                              //Rejected Column
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: ['%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22Rejected%22%7D'],)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF40752),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      FutureBuilder<ListingCountResponse>(
                                                        future: futureListingCount,
                                                        builder: (context,snapshot){
                                                          if(snapshot.hasData){
                                                            //var totalListingCount = snapshot.data.approved + snapshot.data.archived +snapshot.data.draft + snapshot.data.pending + snapshot.data.scheduled + snapshot.data.published + snapshot.data.unpublished + snapshot.data.closed + snapshot.data.rejected + snapshot.data.expired;
                                                            return Text(
                                                              '${snapshot.data.rejected}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontFamily: 'Cairo',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(child: NetworkLoading(),);
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Text(
                                                          'Rejected',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontFamily: 'Cairo',
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              //Scheduled
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: ['%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22Scheduled%22%7D'],)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF07A1F4),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Icon(
                                                          Icons.schedule,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      FutureBuilder<ListingCountResponse>(
                                                        future: futureListingCount,
                                                        builder: (context,snapshot){
                                                          if(snapshot.hasData){
                                                            //var totalListingCount = snapshot.data.approved + snapshot.data.archived +snapshot.data.draft + snapshot.data.pending + snapshot.data.scheduled + snapshot.data.published + snapshot.data.unpublished + snapshot.data.closed + snapshot.data.rejected + snapshot.data.expired;
                                                            return Text(
                                                              '${snapshot.data.scheduled}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontFamily: 'Cairo',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(child: NetworkLoading(),);
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Text(
                                                          'Scheduled',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontFamily: 'Cairo',
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: ['%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22Scheduled%22%7D'],)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF179500),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      FutureBuilder<ListingCountResponse>(
                                                        future: futureListingCount,
                                                        builder: (context,snapshot){
                                                          if(snapshot.hasData){
                                                            //var totalListingCount = snapshot.data.approved + snapshot.data.archived +snapshot.data.draft + snapshot.data.pending + snapshot.data.scheduled + snapshot.data.published + snapshot.data.unpublished + snapshot.data.closed + snapshot.data.rejected + snapshot.data.expired;
                                                            return Text(
                                                              '${snapshot.data.prospect}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontFamily: 'Cairo',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(child: NetworkLoading(),);
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Text(
                                                          'Prospect',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontFamily: 'Cairo',
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 10
                                      ),
                                      Padding(
                                        padding:EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Divider(
                                          height: 0.2,
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FutureBuilder<PortalsCount>(
                                        future: futurePortalsCount,
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            int bayutId = 5;
                                            int dubizzleId = 1;
                                            int pfId = 3;
                                            int pfTotal = 0;
                                            int bayutTotal = 0;
                                            int dbTotal = 0;

                                            List<String> userPortals = [];
                                            for(int i = 0; i < snapshot.data.users.length;i++){
                                              for(int j =0; j < snapshot.data.users[i]['portals'].length; j++){

                                                userPortals.add(snapshot.data.users[i]['portals'][j]['name']);
                                                if(snapshot.data.users[i]['portals'][j]['name'] == 'PropertyFinder')
                                                  pfTotal += snapshot.data.users[i]['portals'][j]['rental_published'] + snapshot.data.users[i]['portals'][j]['sale_published'];
                                                if(snapshot.data.users[i]['portals'][j]['name'] == 'Bayut')
                                                  bayutTotal += snapshot.data.users[i]['portals'][j]['rental_published'] + snapshot.data.users[i]['portals'][j]['sale_published'];
                                                if(snapshot.data.users[i]['portals'][j]['name'] == 'Dubizzle')
                                                  dbTotal += snapshot.data.users[i]['portals'][j]['rental_published'] + snapshot.data.users[i]['portals'][j]['sale_published'];
                                              }

                                            }
                                            return Padding(
                                              padding: EdgeInsets.only(top: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                                          child: Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 7.0,vertical: 15),
                                                              child: Image.asset('assets/images/bayut.png',scale: 4,),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(
                                                                    color: Color(0xFF28B16D)
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Color(0xFF28B16D),
                                                                borderRadius: BorderRadius.circular(5)
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                                                              child: Center(
                                                                child: Text(
                                                                  '$bayutTotal',
                                                                  style: AppTextStyles.c16white600(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(portalId: bayutId,)));
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                                                            child: Image.asset('assets/images/pf.png',scale: 4),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(
                                                                  color: Color(0xFFEF5E4E)
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFEF5E4E),
                                                              borderRadius: BorderRadius.circular(5)
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.11),
                                                            child: Center(
                                                              child: Text(
                                                                '$pfTotal',
                                                                style: AppTextStyles.c16white600(),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(portalId: pfId,)));
                                                    },
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                                    child: InkWell(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 13),
                                                              child: Image.asset('assets/images/db.png',scale: 4,),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(
                                                                    color: Color(0xFFBB2025)
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Color(0xFFBB2025),
                                                                borderRadius: BorderRadius.circular(5)
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.10),
                                                              child: Center(
                                                                child: Text(
                                                                  '$dbTotal',
                                                                  style: AppTextStyles.c16white600(),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      onTap: (){
                                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> NewListingLandingPage(portalId: dubizzleId,)));
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Center(child: NetworkLoading(),);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    //LEADS
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFFFFFFF),
                          ),

                          width: MediaQuery.of(context).size.width * 0.97,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewLeadsListingPage()));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                      color: GlobalColors.globalColor(),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                          child: Text(
                                            'LEADS',
                                            style: AppTextStyles.c16white600(),
                                          ),
                                        ),
                                        Align(alignment: Alignment.topRight,child: Padding(
                                          padding: EdgeInsets.only(top: 10.0,right: 15),
                                          child: InkWell(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewLeadsListingPage()));
                                              },
                                              child: Icon(Icons.read_more,size: 25,color: Colors.white,)),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Column(

                                children: [
                                  Row(
                                    children: [
                                      FutureBuilder(
                                        future: getChart(),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            //print(snapshot.data);
                                            return Padding(
                                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  for(var x in snapshot.data)
                                                    Indicator(
                                                      color: leadsSubStatusColor('${x['sub_status']}'),
                                                      text: '${x['sub_status']} (${x['count']})',
                                                      isSquare: false,
                                                    ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Center(child: NetworkLoading());
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.08,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        child: FutureBuilder(
                                          future: getChart(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot){
                                            if(snapshot.hasData){

                                              return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return PieChart(
                                                        PieChartData(
                                                            pieTouchData: PieTouchData(touchCallback:
                                                                (FlTouchEvent event, pieTouchResponse) {
                                                              setState(() {
                                                                if (!event.isInterestedForInteractions ||
                                                                    pieTouchResponse == null ||
                                                                    pieTouchResponse.touchedSection == null) {
                                                                  touchedIndex = -1;
                                                                  return;
                                                                }
                                                                touchedIndex = pieTouchResponse
                                                                    .touchedSection.touchedSectionIndex;
                                                              });
                                                            }),
                                                            borderData: FlBorderData(
                                                              show: false,
                                                            ),
                                                            sectionsSpace: 0,
                                                            centerSpaceRadius: 0,
                                                            sections: showingSections(snapshot.data)
                                                        )
                                                    );
                                                  }
                                              );
                                            } else {
                                              return Center(child: NetworkLoading());
                                            }
                                          },
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //TASKS
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFFFFFFF),
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.93,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksListingPage()));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                      color: GlobalColors.globalColor(),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                          child: Text(
                                            'TASKS',
                                            style: AppTextStyles.c16white600(),
                                          ),
                                        ),
                                        Align(alignment: Alignment.topRight,child: Padding(
                                          padding: EdgeInsets.only(top: 10.0,right: 15),
                                          child: InkWell(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksListingPage()));
                                              },
                                              child: Icon(Icons.read_more,size: 25,color: Colors.white,)),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: FutureBuilder<Tasks>(
                                  future: futureTasks,
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.hasData){
                                      //print(snapshot.data.data);
                                      if(snapshot.data.data.isEmpty){
                                        return Center(
                                          child: Text(
                                            'No tasks',
                                            style: AppTextStyles.c16black600(),
                                          ),
                                        );
                                      } else {
                                        var len;
                                        if(snapshot.data.data.length > 3){
                                          len = 3;
                                        } else {
                                          len = snapshot.data.data.length;
                                        }
                                        return SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: 15.0),
                                            child: Column(
                                              children: [
                                                for(int i=0;i < len;i++)
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksDetailsPage(
                                                        id: snapshot.data.data[i]['id'],
                                                        status: snapshot.data.data[i]['status'],
                                                        priority: snapshot.data.data[i]['priority'],
                                                        createdDate: snapshot.data.data[i]['created_at'],
                                                        dueDate: snapshot.data.data[i]['due_at'],
                                                        title: snapshot.data.data[i]['title'],
                                                        description: snapshot.data.data[i]['description'],
                                                      )));
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02, vertical: MediaQuery.of(context).size.height * 0.005),
                                                      child: TasksCard(
                                                        id: snapshot.data.data[i]['id'],
                                                        status: snapshot.data.data[i]['status'],
                                                        priority: snapshot.data.data[i]['priority'],
                                                        createdDate: snapshot.data.data[i]['created_at'],
                                                        dueDate: snapshot.data.data[i]['due_at'],
                                                        title: snapshot.data.data[i]['title'],
                                                        fullName: snapshot.data.data[i]['assigned_to']['full_name'],
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      return NetworkLoading();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: ConvexBottomAppBar(
            backgroundColor: GlobalColors.globalColor(),
            /// onClick for all BottomSheet items
            onClickParent: onBottomIconPressed,
            isUseTitle: true,
            selectedColor: Colors.white,
            unselectedColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.white,
            ),
            convexBottomAppBarItems: [
              ConvexBottomAppBarItem(
                Icons.calendar_today,
                title: "Schedule",
                titleTextStyle: AppTextStyles.c14white400(),
              ),
              ConvexBottomAppBarItem(
                Icons.speed,
                title: "Dashboard",
                titleTextStyle: AppTextStyles.c14white400(),
              ),
              /*ConvexBottomAppBarItem(
                Icons.card_travel,
              ),
              ConvexBottomAppBarItem(
                Icons.favorite_border,
                title: "Fav",
                /// override onClick for only one items
                overrideOnClick: (index) { },
              ),*/
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.07,right: MediaQuery.of(context).size.width * 0.02),
            child: FloatingActionBubble(
              // Menu items
              items: [

                // Floating action menu item
                Bubble(
                  title:"Add Task",
                  iconColor :Colors.white,
                  bubbleColor : GlobalColors.globalColor(),
                  icon:Icons.task,
                  titleStyle: AppTextStyles.c14white400(),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
                  },
                ),
                // Floating action menu item
                Bubble(
                  title:"Add Contact",
                  iconColor :Colors.white,
                  bubbleColor : GlobalColors.globalColor(),
                  icon:Icons.group_add,
                  titleStyle: AppTextStyles.c14white400(),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddContact()));
                  },
                ),
                //Floating action menu item
                Bubble(
                  title:"View Leads",
                  iconColor :Colors.white,
                  bubbleColor : GlobalColors.globalColor(),
                  icon:Icons.bar_chart,
                  titleStyle: AppTextStyles.c14white400(),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewLeadsListingPage()));
                  },
                ),
                //Floating action menu item
                Bubble(
                  title:"View Listings",
                  iconColor :Colors.white,
                  bubbleColor : GlobalColors.globalColor(),
                  icon:Icons.list,
                  titleStyle: AppTextStyles.c14white400(),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage()));
                  },
                ),
              ],

              // animation controller
              animation: _animation,

              // On pressed change animation state
              onPress: () => _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),

              // Floating Action button Icon color
              iconColor: Colors.white,

              // Floating Action button Icon
              iconData: Icons.more_horiz,
              backGroundColor: GlobalColors.globalColor(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List l) {
    int total = 0;
    for(var x in l) {
      total += x['count'];
    }
    return List.generate(l.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = 16.0;
      final radius = isTouched ? 95.0 : 85.0;
      double val = (l[i]['count']/total) * 100;
      return PieChartSectionData(
        color: leadsSubStatusColor(l[i]['sub_status']),
        value: val,
        showTitle: isTouched ? true: false,
        title: '${val.toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            color: const Color(0xffffffff)),
        titlePositionPercentageOffset: 0.5
      );
    });
  }

}
/*InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeadsLandingPage()));
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'LEADS',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w600
                                  ),
                                ),

                              ],
                            ),
                          ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewingsList()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'VIEWINGS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600
                              ),
                            ),

                          ],
                        ),
                      )*/

/*
Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ProfileHeader(),
                      ListTile(
                        title: Text("Listings",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.list, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ListingLandingPage()));
                        },
                      ),
                      ListTile(
                        title: Text("Nearby Listings",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.location_on_outlined, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NearByListings(rad: 5000,)));
                        },
                      ),
                      ListTile(
                        title: Text("Leads",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.import_contacts, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewLeadsListingPage()));
                        },
                      ),
                      ListTile(
                        title: Text("Contacts",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.call_outlined, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactsListing()));
                        },
                      ),
                      ListTile(
                        title: Text("Tasks",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.task, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TasksListingPage()));
                        },
                      ),
                      ListTile(
                        title: Text("Viewings",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.remove_red_eye_outlined, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ViewingsList()));
                        },
                      ),
                      ListTile(
                        title: Text("Calendar",
                            style: AppTextStyles.c16black600()),
                        leading: Icon(Icons.calendar_today, color: GlobalColors.globalColor(),),
                        trailing: Icon(Icons.arrow_forward_ios,color: GlobalColors.globalColor(),),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Calendar()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                ListTile(
                                  title: Text("Logout",
                                      style: AppTextStyles.c16black600()),
                                  leading: Icon(Icons.logout),
                                  onTap: () {
                                    showGeneralDialog(
                                      barrierLabel: "Label",
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withOpacity(0.5),
                                      transitionDuration: Duration(milliseconds: 200),
                                      context: context,
                                      pageBuilder: (context, anim1, anim2) {
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                            child: SizedBox.expand(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [LogoutPage()],
                                                )),
                                            margin: EdgeInsets.only(
                                                bottom: 50, left: 12, right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      transitionBuilder:
                                          (context, anim1, anim2, child) {
                                        return SlideTransition(
                                          position: Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                              .animate(anim1),
                                          child: child,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ))))
              ],
            ),
          )
 */
