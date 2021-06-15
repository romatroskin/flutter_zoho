import Flutter
import UIKit
import ZohoDeskPortalAPIKit
import ZohoDeskPortalCore

public class SwiftFlutterZohoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        @available(iOS 13.0, *)
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            var window: UIWindow?
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
            let channel = FlutterMethodChannel(name: "flutter_zoho", binaryMessenger: registrar.messenger())
            
            channel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if (call.method == "showNativeView") {
                    let zohoDictionary = call.arguments as? Dictionary<String, String>
                    let config = ZDPHomeConfiguration()
                    config.enableHelpCenter = true
                    config.enableCreateTicket = true
                    config.enableMyTicket = true
                    config.enableCommunity = true
                    ZohoDeskPortalSDK.initialize(orgID: zohoDictionary?["orgId"] ?? "",
                                                 appID: zohoDictionary?["appId"] ?? "", dataCenter: ZDPDataCenter.EU)
                    
                    
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
        
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
