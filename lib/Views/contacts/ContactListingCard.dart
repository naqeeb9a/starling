import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

class ContactListingCard extends StatelessWidget {

  final int id;
  String reference;
  String fullName;
  String phone;
  String email;

  ContactListingCard({this.id,this.reference,this.fullName,this.phone,this.email});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundColor: Colors.blue,
              foregroundImage: NetworkImage('https://ui-avatars.com/api/?background=EEEEEE&color=3F729B&name=$fullName&size=128&font-size=0.33'),
              radius: 25,
            )
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$reference',
                    style: AppTextStyles.c14grey400(),
                  ),

                  Text(
                    '$fullName',
                    style: AppTextStyles.c20black400(),
                  ),

                  Text(
                    '$phone',
                    style: AppTextStyles.c16black500(),
                  ),

                  Text(
                    (email!=null&&email!='')?'$email':'No email',
                    style: AppTextStyles.c14grey400(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
