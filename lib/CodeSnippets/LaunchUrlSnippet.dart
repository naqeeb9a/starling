import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlSnippet {
  launchCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch ti $url');
    }
  }

  launchWhatsapp(String phone) async {
    if (Platform.isAndroid) {
      String url =
          "https://wa.me/$phone/?text=${Uri.parse('Hello !')}"; // new line
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      String url =
          "https://api.whatsapp.com/send?phone=$phone=${Uri.parse('Hello !')}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      } // new line
    }
  }

  launchSMS(String phone) async {
    String uri = 'sms:$phone?body=hello%20there';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      String uri = 'sms:${phone}body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
