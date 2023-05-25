import UIKit
import  Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(withRegistry: self)
      GMSServices.provideAPIKey("AIzaSyCJisn-kRPI3m5-N0QgeHj5toEAd2wy2EM")
//    GMSServices.provideAPIKEY("AIzaSyCJisn-kRPI3m5-N0QgeHj5toEAd2wy2EM")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
