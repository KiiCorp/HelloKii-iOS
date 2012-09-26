//
//  AppDelegate.m
//  HelloKii
//
//  Created by Chris Beauchamp on 9/10/12.
//  Copyright (c) 2012 Kii. All rights reserved.
//

#import <KiiSDK/Kii.h>

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Initialize the Kii SDK!
    [Kii beginWithID:@"__KII_APP_ID__"
              andKey:@"__KII_APP_key__"
       withCustomURL:@"__KII_API_URL__"];
                
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
