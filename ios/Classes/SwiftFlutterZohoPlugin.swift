import Flutter
import UIKit
import ZohoDeskPortalAPIKit
import ZohoDeskPortalCore

public class SwiftFlutterZohoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "flutter_zoho", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterZohoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "initZoho":
            let zohoDictionary = call.arguments as? Dictionary<String, String>
            
            ZohoDeskPortalSDK.initialize(orgID: zohoDictionary?["orgId"] ?? "",
                                         appID: zohoDictionary?["appId"] ?? "", dataCenter: ZDPDataCenter.EU)
            ZohoDeskPortalSDK.enablePushNotification(deviceToken: zohoDictionary?["fcmId"] ?? "", mode: .production)

            result(String("true"));
            break;
            
            
        case "showNativeView":
            let accessToken = call.arguments as? Dictionary<String, String>

            let config = ZDPHomeConfiguration()
            config.enableHelpCenter = true
            config.enableCreateTicket = true
            config.enableMyTicket = true
            config.enableCommunity = true

            if !ZohoDeskPortalSDK.isUserLoggedIn{
                ZohoDeskPortalSDK.login(withUserToken: accessToken?["accessToken"] ?? "") { (isSuccess: Bool) in
                    if(isSuccess) {
                        ZDPortalHome.show(withConfiguration: config)
                        result(String("true"));
                        
                    }else{
                        result(FlutterError(code: "400", message: "server error", details: "false"));
                    }
                }
            } else {
                // user logged in already
                ZDPortalHome.show(withConfiguration: config)
                        result(String("true"));
            }
            break;
            
        default:
            result(FlutterError(code: "400", message: "server error", details: "false"))
            break;
        }
    }
}
