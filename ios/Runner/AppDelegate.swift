import Flutter
import Reachability
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: - Initialize Channel Name

        let channel = "callkit.flutter.dev"
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        // MARK: - Channel Handler SetUp Session

        let messageChannel = FlutterMethodChannel(name: "\(channel)/message", binaryMessenger: controller.binaryMessenger)

        // MARK: - Set UP [MESSAGE_CHANNEL] Method Handler

        messageChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) in
            guard call.method == "getMessage" else {
                result(FlutterMethodNotImplemented)
                return
            }

            // MARK: - Call GetMessage Function

            self.getMessage(result: result)
        }

        let networkChannel = FlutterMethodChannel(name: "\(channel)/network", binaryMessenger: controller.binaryMessenger)

        // MARK: - Set UP [NETWORK_CHANNEL] Method Handler

        networkChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) in
            guard call.method == "getNetworkStatus" else {
                result(FlutterMethodNotImplemented)
                return
            }
            let networkInfo = Reachability.shared.currentPath
            result(networkInfo.isReachable)
        }

        let computeChannel = FlutterMethodChannel(name: "\(channel)/compute", binaryMessenger: controller.binaryMessenger)

        // MARK: - Set UP [COMPUTE_CHANNEL] Method Handler

        computeChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) in

            let operands: [String] = ["+", "-", "*", "/"]

            guard call.method == "getCompute" else {
                result(FlutterMethodNotImplemented)
                return
            }
            guard
                let args = call.arguments as? [String: Any],
                let x = args["x"] as? Double,
                let y = args["y"] as? Double,
                let operand = args["operand"] as? String
            else {
                result("Exception : Invalid Argument")
                return
            }

            guard operands.contains(operand) else {
                result("Exception : Invalid Operand")
                return
            }
            switch operand {
            case "+":
                result(x + y)
            case "-":
                result(x - y)
            case "*":
                result(x * y)
            case "/":
                result(x / y)
            default:
                result("Exception : Invalid Operand")
            }
        }

        let callKitChannel = FlutterMethodChannel(name: "\(channel)/callkit", binaryMessenger: controller.binaryMessenger)

        callKitChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) in
            if call.method == "startCall" {
                self.callKitStartCall(result: result)
            } else {}
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getMessage(result: FlutterResult) {
        result("Get Message From iOS")
    }

    private func callKitStartCall(result: FlutterResult) {
        if #available(iOS 14.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CallManager().startCall(id: UUID(), handle: "Donnukrit")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
