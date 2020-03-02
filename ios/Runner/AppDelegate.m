#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "AsrPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [AsrPlugin registerWithRegistrar:[self registrarForPlugin:@"asr_plugin"]];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
