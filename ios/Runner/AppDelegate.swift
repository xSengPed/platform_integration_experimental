import Flutter
import flutter_background_service_ios
import Reachability
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"
        let controller = window?.rootViewController as! FlutterViewController

        GeneratedPluginRegistrant.register(with: self)
        SwiftMethodHandler.register(with: self.registrar(forPlugin: "SwiftMethodHandler")!)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
