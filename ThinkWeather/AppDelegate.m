//
//  AppDelegate.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/15/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

@import GoogleMaps;
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Appearance
    UIColor* navBarTextColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]; /* #333333 */

    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                        NSForegroundColorAttributeName: navBarTextColor,
                                        NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16.0f]
                                                            }];
    [[UINavigationBar appearance] setTintColor: navBarTextColor];
    
    [[UINavigationBar appearance] setBarTintColor:     [UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage: [[UIImage alloc] init]
                                      forBarPosition:   UIBarPositionAny
                                          barMetrics:   UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:     [[UIImage alloc] init]];
    
    
    // Gmaps API key
    [GMSServices provideAPIKey:@"AIzaSyBzMw_OvSIoROwcZNlcz5diFBDNj4fVbEA"];
    
    return YES;
}

@end
