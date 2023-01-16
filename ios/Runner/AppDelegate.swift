import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      GMSServices.provideAPIKey("AIzaSyCWU6mEq2k7V-jgPgIa0ebPsUMhzwFIKhM")
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
