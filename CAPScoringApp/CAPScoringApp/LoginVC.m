//
//  LoginVC.m
//  CAPScoringApp
//
//  Created by Sathish on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "LoginVC.h"
#import "DashBoardVC.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "DBManager.h"
#import "UserRecord.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Border for password
    [self.view_password.layer setBorderWidth:2.0];
    [self.view_password.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_password.layer setMasksToBounds:YES];
    
    //Border for username
    [self.view_user_name.layer setBorderWidth:2.0];
    [self.view_user_name.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_user_name.layer setMasksToBounds:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)btn_login:(id)sender {
    if([self formValidation]){
        NSString *userNameLbl = self.txt_user_name.text;
        NSString *passwordLbl = self.txt_password.text;
        
        if(self.checkInternetConnection){
            
            
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            //Show indicator
            [delegate showLoading];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.245:8087/CAPService.svc/LOGIN/%@/%@",userNameLbl,passwordLbl];
                NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response;
                NSError *error;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                
                NSMutableDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                
                
                NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"LOGIN_STATUS"];
                NSLog(@"%@",errorCode);
                
                
                if([errorCode boolValue] == YES)
                {
                    
                    BOOL isUserLogin = YES;
                    
                    NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
                    [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
                    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self openContentView];
                    
                }else{
                    
                    [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
                }
                [delegate hideLoading];
            });
            
            //[delegate hideLoading];
        }else{
            NSMutableArray *userMutableArray = [DBManager checkUserLogin:userNameLbl password:passwordLbl];
            if([userMutableArray count]!=0){
                UserRecord *userRecode = [userMutableArray objectAtIndex:0];
                
                if([DBManager checkExpiryDate:[userRecode userCode]]){
                    
                    BOOL isUserLogin = YES;
                    NSString *userCode = [userRecode userCode];
                    [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
                    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self openContentView];
                }else{
                    [self showDialog:@"Login expired" andTitle:@""];
                }
            }else{
                [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
            }
        }
    }
    
}

// Show hide password
- (IBAction)btn_show_pwd:(id)sender {
    if (self.txt_password.secureTextEntry == YES) {
        self.txt_password.secureTextEntry = NO;
    }
    else
    {
        self.txt_password.secureTextEntry = YES;
    }
    
}


/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

/**
 * Open content page
 */
-(void) openContentView{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    DashBoardVC  *homeVc =(DashBoardVC*) [storyBoard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
//    [homeVc setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:homeVc animated:NO completion:nil];
    
    DashBoardVC *loginVC = [[DashBoardVC alloc]init];
    loginVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
    [self.navigationController pushViewController:loginVC animated:YES];
    
    
}




/**
 * Form Validation
 */
- (BOOL) formValidation{
    NSString *userNameTxtf = self.txt_user_name.text;
    NSString *passwordTxtf = self.txt_password.text;
    if([userNameTxtf isEqual:@""]){
        [self showDialog:@"Please enter User Name." andTitle:@""];
        return NO;
    }else if([passwordTxtf isEqual:@""]){
        [self showDialog:@"Please enter password" andTitle:@""];
        return NO;
    }
    
    return YES;
}

//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


@end
