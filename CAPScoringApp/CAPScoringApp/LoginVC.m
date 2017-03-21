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
#import "Utitliy.h"
#import "LoginDBmanager.h"

@interface LoginVC ()
{
  NSString*USERNAME;
}
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
    
    if([self.txt_user_name.text isEqualToString:@""] || self.txt_user_name.text==nil && [self.txt_password.text isEqualToString:@""] || self.txt_password.text==nil)
    {
         [self showDialog:@"Please Enter User Name\nPlease Enter Password" andTitle:@"Login"];
    }
    else if([self.txt_user_name.text isEqualToString:@""] || self.txt_user_name.text==nil)
    {
        [self showDialog:@"Please Enter User Name." andTitle:@"Login"];

    }
    else if([self.txt_password.text isEqualToString:@""] || self.txt_password.text==nil)
    {
        [self showDialog:@"Please Enter Password." andTitle:@"Login"];

    }
        else{
        NSString *userNameLbl = self.txt_user_name.text;
        NSString *passwordLbl = self.txt_password.text;
        //passwordLbl=[]
        if(self.checkInternetConnection){
            
            
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            //Show indicator
            [delegate showLoading];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETAUTHORIZATIONDETAILS/%@/%@/admin",[Utitliy getSyncIPPORT] ,userNameLbl,passwordLbl];
                NSLog(@"LoginURL=%@",baseURL);
                NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response;
                NSError *error;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                
                if ([responseData length] >0 && error == nil)
                {
               

                
                
                NSMutableDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                
                NSMutableArray *errorItemArray = [rootDictionary objectForKey: @"lstErrorItem"];
                NSMutableDictionary  *errorItemObj = [errorItemArray objectAtIndex:0];
                
//                
//                NSMutableArray *errorItemArray = [rootDictionary objectForKey: @"UserDetails"];
                
                
                
                if([[errorItemObj objectForKey:@"ErrorNo"] isEqual:@"MOB0005"]){
                    BOOL isUserLogin = YES;
                    
                  LoginDBmanager *objLoginDBmanager = [[LoginDBmanager alloc] init];
                    [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];

                    
                    NSArray *temp =   [rootDictionary objectForKey:@"UserDetails"];
                    
                    int i;
                    for (i=0; i<[temp count]; i++) {
                        NSDictionary*test=[temp objectAtIndex:i];
                        NSString*USERCODE=[test objectForKey:@"Usercode"];
                        [[NSUserDefaults standardUserDefaults] setObject:USERCODE forKey:@"userCode"];
                        NSString *USERROLEID=[test objectForKey:@"Userroleid"];
                        NSString *LOGINID=[test objectForKey:@"Loginid"];
                        NSString *PASSWORD=[test objectForKey:@"Password"];
                        NSString *REMEMBERME=[test objectForKey:@"Rememberme"];
                        NSString *REMENTDATE=[test objectForKey:@"Rementdate"];
                        NSString *USERFULLNAME=[test objectForKey:@"Userfullname"];
                      [[NSUserDefaults standardUserDefaults] setObject:USERFULLNAME forKey:@"UserFullname"];
                        
                        
                        NSString *MACHINEID=[test objectForKey:@"Machineid"];
                        NSString*LICENSEUPTO=[test objectForKey:@"Licenseupto"];
                        NSString*CREATEDBY =[test objectForKey:@"Createdby"];
                        NSString*CREATEDDATE=[test objectForKey:@"Createddate"];
                        NSString*MODIFIEDBY=[test objectForKey:@"Modifiedby"];
                        NSString*MODIFIEDDATE=[test objectForKey:@"Modifieddate"];
                        NSString*RECORDSTATUS=[test objectForKey:@"Recordstatus"];
                        
                        
                        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
                        //   6/23/2016 5:45:00 PM
                        [dateFmt setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
                        NSDate *date = [dateFmt dateFromString:LICENSEUPTO];
                        NSLog(@"date:",date);
                        
                        [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                        LICENSEUPTO = [dateFmt stringFromDate:date];
                        NSLog(@"dateString:",LICENSEUPTO);
                        
                        
                        bool CheckStatus=[objLoginDBmanager CheckUserDetails : LOGINID:PASSWORD];
                        if (CheckStatus==YES)
                        {
                            [objLoginDBmanager UPDATEUSERDETAILS:LOGINID:PASSWORD:LICENSEUPTO];
                        }
                        
                        else
                        {
                            [objLoginDBmanager INSERTUSERDETAILS :USERCODE: USERROLEID:LOGINID: PASSWORD:REMEMBERME:REMENTDATE:USERFULLNAME:MACHINEID : LICENSEUPTO: CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:RECORDSTATUS];
                            
                        }
                      
                    }
                    
                    
                    
                    
                    NSArray *temp1 =   [rootDictionary objectForKey:@"SecureIdDetails"];
                    
                    int j;
                    for (j=0; j<[temp1 count]; j++) {
                        NSDictionary*test1=[temp1 objectAtIndex:j];
                      USERNAME=[test1 objectForKey:@"Username"];
                        NSString *SECUREID=[test1 objectForKey:@"Secureid"];
                        [[NSUserDefaults standardUserDefaults] setObject:SECUREID forKey:[Utitliy SecureId]];
                        [[NSUserDefaults standardUserDefaults] setObject:USERNAME forKey:@"USERNAME"];

                        NSString *STARTDATE=[test1 objectForKey:@"Startdate"];
                        NSString *ENDDATE=[test1 objectForKey:@"Enddate"];
                        NSString *CREATEDBY=[test1 objectForKey:@"Createdby"];
                        NSString *CREATEDDATE=[test1 objectForKey:@"Createddate"];
                        NSString *MODIFIEDBY=[test1 objectForKey:@"Modifiedby"];
                        NSString *MODIFIEDDATE=[test1 objectForKey:@"Modifieddate"];
                        NSString*RECORDSTATUS=[test1 objectForKey:@"Recordstatus"];
                      
                        
                        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
                        //   6/23/2016 5:45:00 PM
                        [dateFmt setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
                        NSDate *date = [dateFmt dateFromString:STARTDATE];
                        NSLog(@"date:",date);
                        
                        [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                        STARTDATE = [dateFmt stringFromDate:date];
                        NSLog(@"dateString:",STARTDATE);
                        
                        
                        [dateFmt setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
                         date = [dateFmt dateFromString:ENDDATE];
                        NSLog(@"date:",date);
                        
                        [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                        ENDDATE = [dateFmt stringFromDate:date];
                        NSLog(@"dateString:",ENDDATE);
                        
                        
                        bool CheckStatus= [objLoginDBmanager CheckSecureIdDetails :USERNAME];
                        if (CheckStatus==YES)
                        {
                            [objLoginDBmanager UPDATESECUREIDDETAILS : USERNAME:SECUREID:STARTDATE:ENDDATE:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:RECORDSTATUS];
                        }
                        
                        else
                        {
                            [objLoginDBmanager INSERTSECUREIDDETAILS:USERNAME:SECUREID:STARTDATE:ENDDATE:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:RECORDSTATUS];

                            
                        }
                        
                        
                    }
                    
                    
                    //Match Scorer Details
                    
                    NSArray *matchScorerDetailsArray =   [rootDictionary objectForKey:@"MatchScorerDetails"];

                    
                    for (int k=0; k<[matchScorerDetailsArray count]; k++) {
                        NSDictionary*test1 =[matchScorerDetailsArray objectAtIndex:k];

                        NSString *Competitioncode=[test1 objectForKey:@"Competitioncode"];
                        NSString *Matchcode=[test1 objectForKey:@"Matchcode"];
                        NSString *Scorercode=[test1 objectForKey:@"Scorercode"];
                        NSString *Recordstatus=[test1 objectForKey:@"Recordstatus"];
                        NSString *Createdby=[test1 objectForKey:@"Createdby"];
                        NSString *Createddate=[test1 objectForKey:@"Createddate"];
                        NSString *Modifiedby=[test1 objectForKey:@"Modifiedby"];
                        NSString*Modifieddate=[test1 objectForKey:@"Modifieddate"];
                        
                        
                        
                        
                        bool CheckStatus= [objLoginDBmanager CheckMatchScorerDetails:Competitioncode :Matchcode :Scorercode ];
                        if (CheckStatus==YES)
                        {
                            [objLoginDBmanager UpdateMatchScorerDetails:Competitioncode :Matchcode :Scorercode :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                        }
                        
                        else
                        {
                            [objLoginDBmanager InsertMatchScorerDetails:Competitioncode :Matchcode :Scorercode :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    //User default
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                      //Open Dashboard
                    [self openContentView];
                }else{
                    
                    [self showDialog:[errorItemObj objectForKey:@"DataItem"] andTitle:@"Login"];
                }
                
                    
                    
                }
                else if ([responseData length] == 0 && error == nil)
                {
                    [self showDialog:@"Server error please try again" andTitle:@"Login"];

                }
                else if (responseData == nil){
                    [self showDialog:@"Server error please try again" andTitle:@"Login"];

                }
                
//                NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"lstErrorItem"];
//                NSLog(@"%@",errorCode);
//                
//                
//                if([errorCode boolValue] == YES)
//                {
//                    
//                    BOOL isUserLogin = YES;
//                    
//                    NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
//                    [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
//                    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    [self openContentView];
//                    
//                }else{
//                    
//                    [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
//                }
                [delegate hideLoading];
            });
            

            //[delegate hideLoading];
        }else{
            DBManager *objDBManager = [[DBManager alloc]init];

            NSMutableArray *userMutableArray = [objDBManager checkUserLogin : userNameLbl password:passwordLbl];
            if([userMutableArray count]!=0){
                UserRecord *userRecode = [userMutableArray objectAtIndex:0];

                if([objDBManager checkExpiryDate:[userRecode userCode]]){
                  
                     if ([objDBManager checkSecurityExpiryDate :userRecode.userName ])
                     {
                    BOOL isUserLogin = YES;
                    NSString *userCode = [userRecode userCode];
                    [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
                    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
                     [[NSUserDefaults standardUserDefaults] setObject:userRecode.userName forKey:@"USERNAME"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self openContentView];
                         
                     }
                     else{
                         [self showDialog:@"SecurityId expired" andTitle:@"Login"];
                         // [self openContentView];
                     }
                    
                }else{
                    [self showDialog:@"User Licence expired" andTitle:@"Login"];
                }
            }else{
                [self showDialog:@"No internet connection" andTitle:@"Login"];
                 
            }
        }
            
    }
    
}

// Show hide password
- (IBAction)btn_show_pwd:(id)sender {
    if (self.txt_password.secureTextEntry == YES) {
        self.txt_password.secureTextEntry = NO;
      
        _eye_imgview.image = [UIImage imageNamed:@"eyeImgSelect.png"];
      //  self.txt_password.font= [UIFont fontWithName:@"Rajdhani-Bold" size:28];
        self.txt_password.font= [UIFont fontWithName:@"Rajdhani-Bold" size:31];
        self.txt_password.font = [UIFont fontWithName:@"Rajdhani-Bold" size:30.0f];
    }
    else
    {
        self.txt_password.secureTextEntry = YES;
            self.txt_password.clearsOnBeginEditing = NO;
         _eye_imgview.image = [UIImage imageNamed:@"ico-show-pwd.png"];
        self.txt_password.font= [UIFont fontWithName:@"Rajdhani-Bold" size:31];
        self.txt_password.font = [UIFont fontWithName:@"Rajdhani-Bold" size:30.0f];
           self.txt_password.clearsOnBeginEditing = NO;
        
    }
    
}


/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:@"Login" message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
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
   if([userNameTxtf isEqual:@""]||[passwordTxtf isEqual:@""])
   {  [self showDialog:@"Please Enter User Name\nPlease Enter Password" andTitle:@"Login"];
         return NO;
   }
    
    else if([userNameTxtf isEqual:@""]){
        [self showDialog:@"Please Enter User Name." andTitle:@"Login"];
        return NO;
    }else if([passwordTxtf isEqual:@""]){
        [self showDialog:@"Please Enter User Name." andTitle:@"Login"];
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


- (void)viewDidDisappear:(BOOL)animated
{
   _eye_imgview.image = [UIImage imageNamed:@"ico-show-pwd.png"];
}


@end
