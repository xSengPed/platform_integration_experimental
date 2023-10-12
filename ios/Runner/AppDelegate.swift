import UIKit
import Flutter
import Reachability
import flutter_callkit_voximplant

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let callKitPlugin = FlutterCallkitPlugin.sharedInstance
    
    @UserDefault("blockedNumbers", defaultValue: [])
    private var blockedNumbers: [BlockableNumber]

    @UserDefault("identifiedNumbers", defaultValue: [])
    private var identifiedNumbers: [IdentifiableNumber]
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // MARK : - Initialize Channel Name
        let channel : String = "callkit.flutter.dev"
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        // MARK : - Channel Handler SetUp Session
        let messageChannel = FlutterMethodChannel(name : "\(channel)/message", binaryMessenger: controller.binaryMessenger)
        // MARK : - Set UP [MESSAGE_CHANNEL] Method Handler
        messageChannel.setMethodCallHandler({
            (call :FlutterMethodCall , result : FlutterResult) -> Void in
            guard call.method == "getMessage" else {
                result(FlutterMethodNotImplemented)
                return
            }
            // MARK : - Call GetMessage Function
            self.getMessage(result: result)
        })
        
        let networkChannel = FlutterMethodChannel(name : "\(channel)/network", binaryMessenger: controller.binaryMessenger)
        // MARK : - Set UP [NETWORK_CHANNEL] Method Handler
        networkChannel.setMethodCallHandler({
            (call : FlutterMethodCall , result : FlutterResult) -> Void in
            guard call.method == "getNetworkStatus" else {
                result(FlutterMethodNotImplemented)
                return
            }
            let networkInfo = Reachability.shared.currentPath
            result(networkInfo.isReachable)
        })
        
        let computeChannel = FlutterMethodChannel(name : "\(channel)/compute",binaryMessenger: controller.binaryMessenger)
        // MARK : - Set UP [COMPUTE_CHANNEL] Method Handler
        computeChannel.setMethodCallHandler({
            (call : FlutterMethodCall , result : FlutterResult) -> Void in
            
            let operands : [String] = ["+","-","*","/"]
            
            guard call.method == "getCompute" else {
                result(FlutterMethodNotImplemented)
                return
            }
            guard 
                let args = call.arguments as? Dictionary<String, Any> ,
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
                result(x+y)
            case "-":
                result(x-y)
            case "*":
                result(x*y)
            case "/":
                result(x/y)
            default:
                result("Exception : Invalid Operand")
            }
            
        })
        
        
        callKitPlugin.getBlockedPhoneNumbers = { [weak self] in
            guard let self = self else { return [] }
            return self.blockedNumbers.compactMap {
                if $0.isRemoved {
                    return nil
                } else {
                    return FCXCallDirectoryPhoneNumber(number: $0.number)
                }
            }
        }
        
        
        callKitPlugin.didAddBlockedPhoneNumbers = { [weak self] numbers in
            guard let self = self else { return }
            self.blockedNumbers.append(
                contentsOf: numbers.map { BlockableNumber(blockableNumber: $0) }
            )
            self.blockedNumbers.sort()
        }
        
        callKitPlugin.didRemoveBlockedPhoneNumbers = { [weak self] numbers in
            guard let self = self else { return }
            self.blockedNumbers = self.blockedNumbers.map { number in
                if numbers.contains(where: { $0.number == number.number }) {
                    return number.copyWithRemovalMark
                } else {
                    return number
                }
            }
        }
        callKitPlugin.getIdentifiablePhoneNumbers = { [weak self] in
            guard let self = self else { return [] }
            return self.identifiedNumbers.compactMap {
                if $0.isRemoved {
                    return nil
                } else {
                    return FCXIdentifiablePhoneNumber(number: $0.number, label: $0.label)
                }
            }
        }
        
        
        
                
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getMessage(result : FlutterResult) -> Void {
        result("Get Message From iOS")
    }

}

fileprivate extension BlockableNumber {
    init(blockableNumber: FCXCallDirectoryPhoneNumber, removed: Bool = false) {
        self.number = blockableNumber.number
        self.modificationDate = Date()
        self.isRemoved = removed
    }

    var copyWithRemovalMark: BlockableNumber {
        BlockableNumber(
            number: number,
            modificationDate: Date(),
            isRemoved: true
        )
    }
}

fileprivate extension IdentifiableNumber {
    init(identifiableNumber: FCXIdentifiablePhoneNumber, removed: Bool = false) {
        self.number = identifiableNumber.number
        self.label = identifiableNumber.label
        self.modificationDate = Date()
        self.isRemoved = removed
    }

    var copyWithRemovalMark: IdentifiableNumber {
        IdentifiableNumber(
            number: number,
            label: label,
            modificationDate: Date(),
            isRemoved: true
        )
    }
}

