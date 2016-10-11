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
#import "DBManagerCaptransactionslogEntry.h"
#import "CaptransactionslogEntryRecord.h"
#import "Utitliy.h"
#import "Reachability.h"
@interface AppDelegate ()
{
    UIActivityIndicatorView *indicator;
    UINavigationController *navigationController;
    BOOL IsTimer;
    NSTimer* _timer;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIViewController *initViewController;
    
     
    
   UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
        BOOL isValiduser = YES;
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults boolForKey:@"isUserLoggedin"]) {
            NSLog(@"Loged in");
            DBManager *objDBManager = [[DBManager alloc]init];

            if([objDBManager checkExpiryDate:[defaults objectForKey:@"userCode"]]){
                if ([objDBManager checkSecurityExpiryDate: [defaults objectForKey:@"USERNAME"]]) {
                
    
           initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
    
                isValiduser = NO;
                }
            }
        }
    
        if(isValiduser) {
            NSLog(@"NOT Loged in");
          
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"login_sbid"];
    

        }


    navigationController = [[UINavigationController alloc] initWithRootViewController:initViewController];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    navigationController.navigationBarHidden = YES;
    _window.rootViewController = navigationController;
    //[_window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    
     

    return YES;
}


-(void)showLoading {
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.transform = CGAffineTransformMakeScale(2, 2);
    indicator.color=[UIColor greenColor];
    indicator.center = self.window.center;
    indicator.hidesWhenStopped = YES;
    [self.window addSubview:indicator];
    [indicator startAnimating];
    
}

+(BOOL) isIpadPro
{
    
    
    if ([UIScreen mainScreen].bounds.size.height == 1366) {
        return  YES;
    }
    return NO;
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
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    IsTimer=NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    IsTimer=YES;
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function methodRunAfterBackground
//        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
    });

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    IsTimer=YES;
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function methodRunAfterBackground
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:YES];
      [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
       [[NSRunLoop currentRunLoop] run];
    });

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)methodRunAfterBackground
{
     NSLog(@"background process method");
    if(IsTimer == YES)
    {
//        DBManagerCaptransactionslogEntry *objCaptransactions = [[DBManagerCaptransactionslogEntry alloc]init];
//        NSMutableArray *objCaptransactionArray=[[NSMutableArray alloc]init];
//        objCaptransactionArray= [objCaptransactions GetCaptransactionslogentry];
//        if(objCaptransactionArray.count > 0)
//        {
//            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETACTIVECOMPETITION/%@",[Utitliy getSyncIPPORT],[Utitliy SecureId]];
//            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            NSURLResponse *response;
//            NSError *error;
//            
//            NSData *responseData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            if (responseData != nil) {
////                //DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc]init];
//                NSDictionary *serviceResponse=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//                
//                if([serviceResponse objectForKey:@"Success"])
//                {
//                    for(int i=0; objCaptransactionArray.count >i; i++)
//                    {
//                        CaptransactionslogEntryRecord * objRecord =[objCaptransactionArray objectAtIndex:i];
//                        NSString * objmatchcode= objRecord.MATCHCODE;
//                        NSString * objSeqno = objRecord.SEQNO;
//                        [objCaptransactions updateCaptransactionslogentry:@"MSC248" matchCode:objmatchcode SEQNO:objSeqno];
//                    }
//                }
//            }
//                else
//                {
//                    
//                }
////                NSMutableArray *checkErrorItem=[serviceResponse objectForKey:@"lstErrorItem"];
////                
////                NSDictionary * ErrorNoDict =[checkErrorItem objectAtIndex:0];
////                
////                NSString *ErrorNoStr=[ErrorNoDict valueForKey:@"SUCCESS"];
////                NSString *message=[ErrorNoDict valueForKey:@"DataItem"];
//                
////                if ([ErrorNoStr isEqualToString:CompareErrorno]) {
////                }
//            }
        
        
        
        //-----------------------------------
        if(self.checkInternetConnection){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            
             if([defaults boolForKey:@"isUserLoggedin"])
             {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                DBManagerCaptransactionslogEntry *objCaptransactions = [[DBManagerCaptransactionslogEntry alloc]init];
                NSMutableArray *DBManagerCaptransactionslogEntryArray=[objCaptransactions GetCaptransactionslogentry];
                
                NSMutableDictionary *PushDict =[[NSMutableDictionary alloc]init];
                [PushDict setValue :DBManagerCaptransactionslogEntryArray forKey:@"ScriptData"];
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:PushDict options:kNilOptions error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"JSON String: %@",jsonString);
                
                NSData* responseData = [NSMutableData data];
                NSString *urlString = [NSString stringWithFormat: @"http://%@/CAPMobilityService.svc/ONLINEPUSHDATA",[Utitliy getSyncIPPORT]];
                NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:jsonData];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField : @"Content-Length"];
                
                NSURLResponse* response;
                NSError* error = nil;
                responseData = [NSURLConnection sendSynchronousRequest:request     returningResponse:&response error:&error];
                if (responseData != nil) {
                    NSMutableArray *serviceResponse=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                    NSDictionary  *responseDict = [serviceResponse objectAtIndex:0];
                    NSString *ErrorNoStr =[responseDict objectForKey:@"ErrorNo"];
                    
                    NSString *CompareErrorno=@"MOB0005";
                   // if ([ErrorNoStr isEqualToString:CompareErrorno]) {
//
//                        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"SYNC DATA COMPLETED. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                        [altert show];
//                        [altert setTag:10405];
//                        
//                    }else{
//                        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"SYNC DATA FAILED. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                        [altert show];
//                        [altert setTag:10406];
//                    }
                }
                
                
                
                //  NSLog(@"the final output is:%@",responseString);
            });
        }
        
        
        else{
             IsTimer=NO;
//            UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Network Error. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [altert show];
//            [altert setTag:10405];
            
        }
        }
            
        //-----------------------------------
        
    }
    else if( IsTimer== NO)
    {
                //NSTimer* _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
        
    }
   
}

- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
