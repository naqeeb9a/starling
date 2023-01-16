/*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ExpansionTileCard(
                baseColor: Color(0xFF104A9C),
                expandedColor: Color(0xFFBAADAD),
                expandedTextColor: Colors.black,
                title: Center(child: Text('Portal Listings')),
                children: [

                ],
              ),
            )*/
/*Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xFFDCDADA), width: 2),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(30)
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(
                            'LEADS STATISTICS',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<LeadsCountResponse>(
                        future: futureLeadsCount,
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            Map <String,double> dataMap = {
                              'Active': snapshot.data.active.toDouble(),
                              'Closed': snapshot.data.closed.toDouble(),
                              'Lost': snapshot.data.lost.toDouble(),
                              'New': snapshot.data.newLead.toDouble(),
                              'Open': snapshot.data.open.toDouble(),
                              'Prospect': snapshot.data.prospect.toDouble(),
                              'Won': snapshot.data.won.toDouble()
                            };
                            return PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 10000),
                              chartLegendSpacing: 100,
                              chartRadius: MediaQuery.of(context).size.width / 4.5,
                              chartType: ChartType.ring,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: false,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                            );
                          } else {
                            return Center(child: AnimatedSearch(),);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),*/

/*Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFFFFFFFF),
                        ),
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                                  color: Color(0xFF104A9C),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5),
                                  child: Center(
                                    child: Text(
                                      'Leads',
                                      style: AppTextStyles.c16white600(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '10',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 22
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 0.2,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Image.asset('assets/images/icons/bayut-icon.png'),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '3',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset('assets/images/icons/pf-icon.png'),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '3',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset('assets/images/icons/dubizzle-icon.ico',scale: 2,),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '3',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )*/

/*Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFFFFF),
                ),
                height: MediaQuery.of(context).size.height * 0.35,

                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          'LISTINGS STATISTICS',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      FutureBuilder<ListingCountResponse>(
                        future: futureListingCount,
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            Map<String,double> dataMap = {
                              'Approved': snapshot.data.approved.toDouble(),
                              'Archived': snapshot.data.archived.toDouble(),
                              'Closed': snapshot.data.closed.toDouble(),
                              'Draft': snapshot.data.draft.toDouble(),
                              'Expired': snapshot.data.expired.toDouble(),
                              'Published': snapshot.data.published.toDouble(),
                              'Pending': snapshot.data.pending.toDouble(),
                              'Scheduled': snapshot.data.scheduled.toDouble(),
                              'Unpublished': snapshot.data.unpublished.toDouble()
                            };
                            return PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 10000),
                              chartLegendSpacing: 100,
                              chartRadius: MediaQuery.of(context).size.width/4.5,
                              chartType: ChartType.ring,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: true,
                                decimalPlaces: 0,
                              ),
                            );
                          } else {
                            return Center(child: AnimatedSearch(),);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),*/


//Radio Button
/*child: GridView.count(
                                                    crossAxisCount: 3,
                                                    children: [
                                                      ListTile(
                                                        title: Text(statusList[0],style: AppTextStyles.c14black500(),),
                                                        leading: Radio(
                                                          value: 0,
                                                          groupValue: val,
                                                          onChanged: (value){
                                                            setState(() {
                                                              val = value;
                                                            });
                                                          },
                                                          activeColor: Color(0xFF104A9C),
                                                        )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[1],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 1,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[2],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 2,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[3],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 3,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[4],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 4,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[5],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 5,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[6],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 6,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[7],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 7,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[8],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 8,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[9],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value:9,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                      ListTile(
                                                          title: Text(statusList[10],style: AppTextStyles.c14black500(),),
                                                          leading: Radio(
                                                            value: 10,
                                                            groupValue: val,
                                                            onChanged: (value){
                                                              setState(() {
                                                                val = value;
                                                              });
                                                            },
                                                            activeColor: Color(0xFF104A9C),
                                                          )
                                                      ),
                                                    ],
                                                  ),*/



// Color(0xFF104A9C)




/*child: DropdownButton<String>(
                                                        elevation: 0,
                                                        selectedItemBuilder: (BuildContext context){
                                                          return statusList.map((String v){
                                                            return Padding(
                                                              padding: EdgeInsets.only(left:15),
                                                              child: Row(
                                                                children: [
                                                                  Center(
                                                                    child: Text(
                                                                      v,
                                                                      style: AppTextStyles.c16black500(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                        value: setStatus,
                                                        disabledHint: Padding(
                                                          padding: EdgeInsets.only(left: 15.0),
                                                          child: Center(
                                                            child: Text(
                                                              'No Status',
                                                              style: AppTextStyles.c14lightGrey400(),
                                                            ),
                                                          ),
                                                        ),
                                                        hint: Padding(
                                                          padding: EdgeInsets.only(left: 15.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Set Status',
                                                              style: AppTextStyles.c14grey400(),
                                                            ),
                                                          ),
                                                        ),
                                                        iconDisabledColor: Colors.grey.shade400,
                                                        items: statList,
                                                        onChanged: (String value){
                                                          setStatus = value;
                                                          setState(() {
                                                            status = value;
                                                            print(status);
                                                          });
                                                        },
                                                      ),*/