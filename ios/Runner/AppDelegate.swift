import UIKit
import Firebase
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCJisn-kRPI3m5-N0QgeHj5toEAd2wy2EM")
    // GMSServices.provideAPIKEY("AIzaSyCJisn-kRPI3m5-N0QgeHj5toEAd2wy2EM")
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
