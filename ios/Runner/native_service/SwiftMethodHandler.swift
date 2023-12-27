import Flutter
import Foundation

public class SwiftMethodHandler: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "callkit.flutter.dev", binaryMessenger: registrar.messenger())
        let instance = SwiftMethodHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getMessage": NativeMethod.getMessage(result: result)
        case "setIncomingCall": NativeMethod.setIncomingCall(result: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

enum NativeMethod {
    static func getMessage(result: FlutterResult) {
        result("Hello from Swift! test")
    }

    static func setIncomingCall(result: FlutterResult) {
        result("Set Incomingcall from Swift!")
    }
}
