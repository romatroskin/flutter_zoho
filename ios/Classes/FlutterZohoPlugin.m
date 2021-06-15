#import "FlutterZohoPlugin.h"
#if __has_include(<flutter_zoho/flutter_zoho-Swift.h>)
#import <flutter_zoho/flutter_zoho-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_zoho-Swift.h"
#endif

@implementation FlutterZohoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterZohoPlugin registerWithRegistrar:registrar];
}
@end
