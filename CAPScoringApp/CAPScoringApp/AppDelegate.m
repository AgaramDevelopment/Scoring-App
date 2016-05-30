//
//  AppDelegate.m
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "DBManager.h"
#import "FixturesVC.h"
@interface AppDelegate ()
{UIActivityIndicatorView *indicator;
    UINavigationController *navigationController;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"login_sbid"];
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initViewController;
        [self.window makeKeyAndVisible];
    
        BOOL isValiduser = YES;
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults boolForKey:@"isUserLoggedin"]) {
            NSLog(@"Loged in");
            if([DBManager checkExpiryDate:[defaults objectForKey:@"userCode"]]){
    
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
    
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = initViewController;
            [self.window makeKeyAndVisible];
    
                isValiduser = NO;
            }
        }
    
        if(isValiduser) {
            NSLog(@"NOT Loged in");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"login_sbid"];
    
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = initViewController;
            [self.window makeKeyAndVisible];
        }
    
    
    // fixtures to match setup
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FixturesVC*tossvc =(FixturesVC*) [storyBoard instantiateViewControllerWithIdentifier:@"fixtureSBID"];
//   navigationController=[[UINavigationController alloc]initWithRootViewController:tossvc];
//    self.window.rootViewController = navigationController;
//    [self.window makeKeyAndVisible];


    return YES;
}


-(void)showLoading {
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    indicator.color=[UIColor blueColor];
    indicator.center = self.window.center;
    indicator.hidesWhenStopped = YES;
    [self.window addSubview:indicator];
    [indicator startAnimating];
    
}

-(void)hideLoading {
    [indicator removeFromSuperview];
    indicator = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
