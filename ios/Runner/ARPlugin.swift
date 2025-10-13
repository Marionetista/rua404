import Flutter
import UIKit

public class ARPlugin: NSObject, FlutterPlugin {
    private var arViewController: ARViewController?
    private var methodChannel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.rua404.ar/methods", binaryMessenger: registrar.messenger())
        let instance = ARPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startAR":
            startAR(result: result)
        case "stopAR":
            stopAR(result: result)
        case "setTarget":
            if let args = call.arguments as? [String: Any] {
                setTarget(targetId: args["targetId"] as? String, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startAR(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                result(FlutterError(code: "NO_ROOT_CONTROLLER", message: "No root view controller found", details: nil))
                return
            }
            
            self.arViewController = ARViewController()
            
            // Setup callbacks
            self.arViewController?.onTargetDetected = { targetId in
                self.methodChannel?.invokeMethod("onTargetDetected", arguments: ["targetId": targetId])
            }
            
            self.arViewController?.onTargetLost = {
                self.methodChannel?.invokeMethod("onTargetLost", arguments: nil)
            }
            
            self.arViewController?.onError = { error in
                self.methodChannel?.invokeMethod("onError", arguments: ["error": error])
            }
            
            // Present AR view
            self.arViewController?.modalPresentationStyle = .fullScreen
            rootViewController.present(self.arViewController!, animated: true) {
                result(nil)
            }
        }
    }
    
    private func stopAR(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            self.arViewController?.dismiss(animated: true) {
                self.arViewController = nil
                result(nil)
            }
        }
    }
    
    private func setTarget(targetId: String?, result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            guard let targetId = targetId else {
                result(FlutterError(code: "NO_TARGET_ID", message: "Target ID is required", details: nil))
                return
            }
            
            // Create ARTarget from targetId
            let target = ARTarget(
                id: targetId,
                imagePath: "ar_targets/orelhudo.png",
                videoPath: "ar_videos/orelhudo_1.mov",
                width: 9.0,
                height: 9.0
            )
            
            self.arViewController?.setupTarget(target)
            result(nil)
        }
    }
}

// ARTarget model for iOS
struct ARTarget {
    let id: String
    let imagePath: String
    let videoPath: String
    let width: Double
    let height: Double
}
