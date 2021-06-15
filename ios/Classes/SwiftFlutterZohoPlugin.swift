import Flutter
import UIKit
import ZohoDeskSDK

public class SwiftFlutterZohoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let channel = FlutterMethodChannel(name: "flutter_zoho", binaryMessenger: registrar.messenger())
    
    channel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "showNativeView") {
                let zohoDictionary = call.arguments as? Dictionary<String, String>
                let config = ZDPortalConfiguration()
                config.enableHelpCenter = true
                config.enableCreateTicket = true
                config.enableMyTicket = true
                config.enableCommunity = true
                ZohoDeskPortalSDK.initializeSDK(zohoDictionary?["orgId"] ?? "",
                appId: zohoDictionary?["appId"] ?? "", dataCenter: ZDDataCenter.EU, configuration: config)
               
               
               
                    ZohoDeskPortalSDK.set(jwtUserIdentifier: zohoDictionary?["accessToken"] ?? "", onComplition: {
                        DispatchQueue.main.async {
                                        ZohoDeskPortalSDK.showHomePage(controller: controller,withConfiguration: config)
                        }
                                        result(String("true"))
                                      }, onError: { (error) in
                                        result(FlutterError(code: "400", message: "server error", details: "false"))
                    
                                      })
               
                
               
                
                
            }else if(call.method=="setFCMId"){
                let fcmId = call.arguments as? Dictionary<String, String>
                ZohoDeskPortalSDK.enablePushNotification(deviceToken: fcmId?["fcmId"] ?? "", mode: .production)
            }
            else{
                result(FlutterError(code: "400", message: "server error", details: "false"))
            }
        }
    
    let instance = SwiftFlutterZohoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
