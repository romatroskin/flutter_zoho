import Flutter
import UIKit
import ZohoDeskPortalSDK

public class SwiftFlutterZohoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_zoho", binaryMessenger: registrar.messenger())
    
    channel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "showNativeView") {
                let zohoDictionary = call.arguments as? Dictionary<String, String>
                let config = ZDPortalConfiguration()
                config.enableHelpCenter = true
                config.enableCreateTicket = true
                config.enableMyTicket = true
                config.enableCommunity = true
                ZohoDeskPortalSDK.initializeSDK(zohoDictionary?["OrgId"] ?? "",
                appId: zohoDictionary?["AppId"] ?? "", dataCenter: ZDDataCenter.EU, configuration: config)
               
               
               
                    ZohoDeskPortalSDK.set(jwtUserIdentifier: zohoDictionary?["AccessToken"] ?? "", onComplition: {
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
