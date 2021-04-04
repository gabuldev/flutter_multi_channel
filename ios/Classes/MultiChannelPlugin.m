#import "MultiChannelPlugin.h"
#if __has_include(<multi_channel/multi_channel-Swift.h>)
#import <multi_channel/multi_channel-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "multi_channel-Swift.h"
#endif

@implementation MultiChannelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMultiChannelPlugin registerWithRegistrar:registrar];
}
@end
