import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let channel : String = "callkit.flutter.dev"
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let batteryChannel = FlutterMethodChannel(name : "\(channel)/battery",binaryMessenger: controller.binaryMessenger)
      let messageChannel = FlutterMethodChannel(name : "\(channel)/message", binaryMessenger: controller.binaryMessenger)
      
      
      
      batteryChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        
        guard call.method == "getBatteryLevel" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.receiveBatteryLevel(result: result)
      })
      
      messageChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          
          
          if (call.method == "getMessageFromSwift") {
              self?.sendMessageToDart(result: result)
          }
          
          if (call.method == "getMultiplyFromSwift") {
              if let args = call.arguments as? Dictionary<String,Any>,
                    let numA = args["a"] as? Int,
                    let numB = args["b"] as? Int {
                  self?.multiplyOnSwift(result: result, a: numA, b: numB)
              } else {
                  result(FlutterMethodNotImplemented)
              }
          }

      })
      
    
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  if device.batteryState == UIDevice.BatteryState.unknown {
    result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery level not available.",
                        details: nil))
  } else {
    result(Int(device.batteryLevel * 100))
  }
}

    
    private func sendMessageToDart(result : FlutterResult) {
        result("Hello From Swift")
    }
    
    
    private func multiplyOnSwift(result : FlutterResult , a : Int , b : Int) {
        
        
        result(a*b)
        
    }
}
