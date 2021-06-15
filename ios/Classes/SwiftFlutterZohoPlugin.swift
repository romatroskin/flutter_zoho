import Flutter
import UIKit
import ZohoDeskPortalAPIKit
import ZohoDeskPortalCore

public class SwiftFlutterZohoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "flutter_zoho", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterZohoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
//        channel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//            if (call.method == "showNativeView") {
//
//        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "showNativeChat":
            print("ZOHO")
            let zohoDictionary = call.arguments as? Dictionary<String, String>
            let config = ZDPHomeConfiguration()
            config.enableHelpCenter = true
            config.enableCreateTicket = true
            config.enableMyTicket = true
            config.enableCommunity = true
            ZohoDeskPortalSDK.initialize(orgID: zohoDictionary?["orgId"] ?? "",
                                         appID: zohoDictionary?["appId"] ?? "", dataCenter: ZDPDataCenter.EU)
            
            ZDPortalHome.show(withConfiguration: config)
            //                ZohoDeskPortalSDK.set(jwtUserIdentifier: zohoDictionary?["accessToken"] ?? "", onComplition: {
            //                        DispatchQueue.main.async {
            //                            ZDPortalHome.showHomePage(controller: controller, withConfiguration: config)
            //                        }
            //                                        result(String("true"))
            //                                      }, onError: { (error) in
            //                                        result(FlutterError(code: "400", message: "server error", details: "false"))
            //
            //                                      })
            if !ZohoDeskPortalSDK.isUserLoggedIn{
                ZohoDeskPortalSDK.login(withUserToken: zohoDictionary?["accessToken"] ?? "") { (isSuccess: Bool) in
                    // isSuccess shows whether the login attempt was successful
                    // any errors will be logged
                    if(isSuccess) {
                        ZDPortalHome.show(withConfiguration: config)
                        //                                ZDPortalHome.show(withConfiguration: config) {
                        //                                    result(String("true"));
                        //                                } onError: { (error) in
                        //                                    result(FlutterError(code: "400", message: "server error", details: "false"));
                        //                                }
                    }
                    
                }
            } else {
                // user logged in already
            }
            break;
            
        case "setFCMId":
        let fcmId = call.arguments as? Dictionary<String, String>
        ZohoDeskPortalSDK.enablePushNotification(deviceToken: fcmId?["fcmId"] ?? "", mode: .production)
        break;
            
        default:
        result(FlutterError(code: "400", message: "server error", details: "false"))
            break;
        }
    }
}
