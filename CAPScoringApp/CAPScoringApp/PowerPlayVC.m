//
//  PowerPlayVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/22/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PowerPlayVC.h"
#import "PowerPlayTVCell.h"
#import "PowerPlayRecord.h"
#import "PowerPlayGridVC.h"
#import "DBManager.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"


@interface PowerPlayVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isPowerplay_Tbl;
    NSMutableArray * selectindexarray;
    NSArray *PowerPlayData;
    NSString *powerplayvalue;
    NSString *setpowerplaytype;
    NSMutableArray *powerplayarray;
    NSString *powerplayCode;
    
    
    PowerPlayVC *powerplayvc;
    PowerPlayRecord *powerplayrecord;
    NSString *powerplaytype;
    NSString *matchover;
    BOOL isPowerplay;
    NSMutableArray * Resultarray;
}

@property (nonatomic,strong)NSMutableArray *FetchPowerPlayArray;
@end

@implementation PowerPlayVC
@synthesize matchCode;
@synthesize competitionCode;
@synthesize inningsNo;
@synthesize txt_endover;
@synthesize txt_startover;
@synthesize powerplaystartover;
@synthesize powerplayendover;
@synthesize powerplaytyp;
@synthesize powerplaycode;
@synthesize recordstatus;
@synthesize userid;
@synthesize operationtype;




- (void)viewDidLoad {
    [super viewDidLoad];
  
    if(powerplaystartover != nil){
        
        txt_startover.text = powerplaystartover;
        txt_endover.text = powerplayendover;
        self.lbl_setpowerplay.text = powerplaytyp;
        powerplaycode=powerplaycode;
        
        [self.btn_submit setTitle:@"Update" forState:UIControlStateNormal];
    }
    
    
    
    
    [self.txt_startover.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txt_startover.layer.borderWidth=2;
    
    [self.txt_endover.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txt_endover.layer.borderWidth=2;
    
    [self.view_powerplaytype.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_powerplaytype.layer.borderWidth=2;
    
    self.tbl_powerplaytype.hidden=YES;
    
    self.view_powerplaygrid.hidden=YES;
    Resultarray =[[NSMutableArray alloc]init];
    
    Resultarray= [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
    
    matchover=[DBManager SetMatchRegistration:self.matchCode];
    PowerPlayData = [DBManager fetchpowerplaytype];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//power play tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isPowerplay == NO)
    {
        return [Resultarray count];
    }
    else
    {
       return [PowerPlayData count];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isPowerplay == NO)
    {
        static NSString *myidentifier = @"powerplaygridcell";
        
        
        PowerPlayGridTVC *cell = (PowerPlayGridTVC *)[tableView dequeueReusableCellWithIdentifier:myidentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"PowerPlayGridTVC" owner:self options:nil];
            
            cell=self.powerplay_cell;
            self.powerplay_cell=nil;
        }
        PowerPlayRecord *veb=(PowerPlayRecord*)[Resultarray objectAtIndex:indexPath.row];
        
        
        cell.LBL_STARTOVER.text=veb.startover;
        cell.LBL_ENDOVER.text=veb.endover;
        cell.TOTAL_OVER.text=veb.totalovers;
        cell.LBL_POWERPLAYTYPENAME.text=veb.powerplaytypename;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        return cell;

    }
    else
    {
       static NSString *MyIdentifier = @"powerplaycell";
       PowerPlayTVCell *cell = (PowerPlayTVCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
       if (cell == nil) {
          [[NSBundle mainBundle] loadNibNamed:@"PowerPlayTVCell" owner:self options:nil];
          cell = self.powerplay_cel;
          self.powerplay_cel = nil;
    }
    
      PowerPlayRecord *objpowerplayRecord=(PowerPlayRecord*)[PowerPlayData objectAtIndex:indexPath.row];
      cell.lbl_powerplaycell.text = objpowerplayRecord.powerplaytypename;
    
      [cell setBackgroundColor:[UIColor clearColor]];
    
    
      return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isPowerplay== YES)
    {
//            selectindexarray=[[NSMutableArray alloc]init];
//            powerplayrecord=(PowerPlayRecord*)[PowerPlayData objectAtIndex:indexPath.row];
//            self.lbl_setpowerplay.text =powerplayrecord.powerplaytypename;
//            powerplaytype=powerplayrecord.powerplaytypecode;
//        
//            [selectindexarray addObject:powerplayrecord];
            self.tbl_powerplaytype.hidden=YES;
            //self.view_powerplay.hidden=NO;
            //self.view_powerplaygrid.hidden=YES;
            isPowerplay=NO;
    }
   else
     {
         
         
         //PowerPlayGridTVC *cell = (PowerPlayGridTVC *)[tableView cellForRowAtIndexPath:indexPath];
         powerplayrecord=(PowerPlayRecord*)[Resultarray objectAtIndex:indexPath.row];
         powerplaystartover=powerplayrecord.startover;
         self.txt_startover.text =powerplayrecord.startover;
         self.txt_endover.text  =powerplayrecord.endover;
         self.lbl_setpowerplay.text =powerplayrecord.powerplaytypename;
         powerplaycode=powerplayrecord.powerplaycode;
         
         self.view_powerplay.hidden=YES;
         self.view_powerplaygrid.hidden=NO;
         [self.btn_submit setTitle:@"Update" forState:UIControlStateNormal];
         isPowerplay=YES;
         
     }
    selectindexarray=[[NSMutableArray alloc]init];
    powerplayrecord=(PowerPlayRecord*)[PowerPlayData objectAtIndex:indexPath.row];
    self.lbl_setpowerplay.text =powerplayrecord.powerplaytypename;
    powerplaytype=powerplayrecord.powerplaytypecode;
    
    [selectindexarray addObject:powerplayrecord];
}



- (IBAction)btn_touch:(id)sender {
    
    if(isPowerplay_Tbl == NO)
    {
       self.tbl_powerplaytype.hidden=NO;
        [self.tbl_powerplaytype reloadData];
        isPowerplay_Tbl=YES;
        isPowerplay=YES;
    }
    else{
        self.tbl_powerplaytype.hidden=YES;
        isPowerplay_Tbl=NO;
        isPowerplay=NO;
    }
    
    
}
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

//- (BOOL) formValidation{
//    
//    BOOL flag = YES;
//    
//    NSString *errorMessage = @"";
//
//    
//    NSString *powerplaystartovertxt = self.txt_startover.text;
//    NSString *powerplayendovertxt =self.txt_endover.text;
//    NSString *powerplaytypetxt = self.lbl_setpowerplay.text;
//    
//     if([powerplaystartovertxt isEqual:@""]){
//       // [self showDialog:@"Please enter Start Over." andTitle:@""];
//         errorMessage = [NSString stringWithFormat:@"%@",@"Please enter Start Over.\n"];
//         flag = NO;
//       // return NO;
//    }
//    if([powerplayendovertxt isEqual:@""]){
//      //  [self showDialog:@"Please enter End Over." andTitle:@""];
//        errorMessage = [NSString stringWithFormat:@"%@%@",@"Please enter End Over.\n",errorMessage];
//        flag = NO;
//      //  return NO;
//        
//    }
//    if([powerplaytypetxt isEqual:@"Select Power Play"]){
//     //   [self showDialog:@"Please Choose  Power Play Type" andTitle:@""];
//         errorMessage = [NSString stringWithFormat:@"%@%@",@"Please Choose  Power Play Type.\n",errorMessage];
//        flag = NO;
//     //   return NO;
//    }
//    if([powerplaystartovertxt intValue]  >= [powerplayendovertxt intValue]){
//      //  [self showDialog:@"End Over Should be greater than Start Over." andTitle:@""];
//        errorMessage = [NSString stringWithFormat:@"%@%@",@"End Over Should be greater than Start Over.\n",errorMessage];
//        flag = NO;
//     //   return NO;
//        
//    }
//    if([matchover intValue] < [powerplaystartovertxt intValue]){
//      //  [self showDialog:@"Start Over Should not exceed Maximum Over." andTitle:@""];
//        errorMessage = [NSString stringWithFormat:@"%@%@",@"Start Over Should not exceed Maximum Over.\n",errorMessage];
//        flag = NO;
//     //   return NO;
//        
//    }
//    if([matchover intValue] < [powerplayendovertxt intValue]){
//       // [self showDialog:@"End Over Should not exceed Maximum Over." andTitle:@""];
//        errorMessage = [NSString stringWithFormat:@"%@%@",@"End Over Should not exceed Maximum Over.\n",errorMessage];
//        flag = NO;
//       // return NO;
//    }
//    
//    return YES;
//}



- (BOOL) formValidation{


    NSString *powerplaystartovertxt = self.txt_startover.text;
    NSString *powerplayendovertxt =self.txt_endover.text;
    NSString *powerplaytypetxt = self.lbl_setpowerplay.text;
    
    if([powerplaystartovertxt isEqual:@""] && [powerplayendovertxt isEqual:@""] && [powerplaytypetxt isEqual:@"Select Power Play"]){
         [self showDialog:@"Please enter Start Over,End Over and Powerplaytype." andTitle:@""];
        return NO;
    }else if([powerplayendovertxt isEqual:@""] && [powerplaytypetxt isEqual:@"Select Power Play"]){
        [self showDialog:@"Please enter End Over and Powerplaytype." andTitle:@""];
        return NO;
    }else if([powerplaystartovertxt isEqual:@""] && [powerplaytypetxt isEqual:@"Select Power Play"]){
        [self showDialog:@"Please enter start Over and Powerplaytype." andTitle:@""];
        return NO;
    }else if([powerplaystartovertxt isEqual:@""] && [powerplayendovertxt isEqual:@""]){
        [self showDialog:@"Please enter start Over and End Over." andTitle:@""];
        return NO;
    }else

     if([powerplaystartovertxt isEqual:@""]){
        [self showDialog:@"Please enter Start Over." andTitle:@""];
        return NO;
    }
    else if([powerplayendovertxt isEqual:@""]){
        [self showDialog:@"Please enter End Over." andTitle:@""];
        return NO;

    }
    else if([powerplaytypetxt isEqual:@"Select Power Play"]){
        [self showDialog:@"Please Choose  Power Play Type" andTitle:@""];
        return NO;
    }
    else if([powerplaystartovertxt intValue]  >= [powerplayendovertxt intValue]){
        [self showDialog:@"End Over Should be greater than Start Over." andTitle:@""];
        return NO;

    }
   else  if([matchover intValue] < [powerplaystartovertxt intValue]){
        [self showDialog:@"Start Over Should not exceed Maximum Over." andTitle:@""];
        return NO;

    }
    else if([matchover intValue] < [powerplayendovertxt intValue]){
        [self showDialog:@"End Over Should not exceed Maximum Over." andTitle:@""];
        return NO;
    }
    
    return YES;
}




- (IBAction)btn_submit:(id)sender {
    
    
         if([self formValidation]){
        
    if(powerplaystartover == nil){
       
            
            [self startService];
            [self insertpowerplay];
            
        }
   
    else
    {
        if([self formValidation]){
        [self updateService];
        
        [self updatepowerplay];
        
    }
    }
}

}

- (IBAction)btn_delete:(id)sender {
    
    if(powerplaystartover != nil){
    [self DeleteService];
    

    PowerPlayRecord *powerplayrecord =[[PowerPlayRecord alloc]init];
    
    powerplayrecord.startover= txt_startover.text;
    powerplayrecord.endover= txt_endover.text;
    powerplayrecord.powerplaytypecode= powerplaytype;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username=[defaults stringForKey :@"UserFullname"];
    
   // [DBManager UpdatePowerPlay:self.inningsNo :powerplayrecord.startover :powerplayrecord.endover :powerplayrecord.modifydate :powerplayrecord.powerplaytypecode :@"MSC001" :username :powerplaycode :self.matchCode];
    
    
    
    [DBManager UpdatePowerPlay:self.inningsNo :powerplayrecord.startover :powerplayrecord.endover :powerplayrecord.modifydate :powerplayrecord.powerplaytypecode :@"MSC002" :username :powerplaycode :self.matchCode];
    
    //powerplayarray=[DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
        
        self.view_powerplaygrid.hidden=YES;
        self.view_powerplay.hidden  =NO;
        isPowerplay =NO;
        Resultarray=[[NSMutableArray alloc]init];
        Resultarray= [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
        [self.tbl_powerplay reloadData];
        
//    PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
//    add.resultarray=powerplayarray;
//    
//    add.competitionCode=competitionCode;
//    add.matchCode=matchCode;
//    add.inningsNo=inningsNo;
//    
//    [self addChildViewController:add];
//    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//    [self.view addSubview:add.view];
//    add.view.alpha = 0;
//    [add didMoveToParentViewController:self];
//    
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         add.view.alpha = 1;
//     }
//                     completion:nil];
    }else{
        
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"No Record selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }
    
}

//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) startService{
    if(self.checkInternetConnection){
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETPOWERPLAY/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],self.matchCode,self.inningsNo,txt_startover.text,txt_endover.text,powerplaytype,recordstatus,userid,powerplaycode,operationtype];
        NSLog(@"-%@",baseURL);
        
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        
        NSData *responseData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (responseData != nil) {
        
        
        NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        if(rootArray !=nil && rootArray.count>0){
            NSDictionary *valueDict = [rootArray objectAtIndex:0];
            NSString *success = [valueDict valueForKey:@"DataItem"];
            if([success isEqual:@"Success"]){
                
            }
        }else{
            
        }
        //            NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"LOGIN_STATUS"];
        //            NSLog(@"%@",errorCode);
        //
        //
        //            if([errorCode boolValue] == YES)
        //            {
        //
        //                BOOL isUserLogin = YES;
        //
        //                NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
        //                [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
        //                [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
        //                [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //                [self openContentView];
        //
        //            }else{
        //
        //                [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
        //            }
        }
        [delegate hideLoading];
        //});
        
        //[delegate hideLoading];
    }
}

-(void) updateService{
    if(self.checkInternetConnection){
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETPOWERPLAY/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],self.matchCode,self.inningsNo,txt_startover.text,txt_endover.text,powerplaytype,recordstatus,userid,powerplaycode,operationtype];
        NSLog(@"-%@",baseURL);
        
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        if(rootArray !=nil && rootArray.count>0){
            NSDictionary *valueDict = [rootArray objectAtIndex:0];
            NSString *success = [valueDict valueForKey:@"DataItem"];
            if([success isEqual:@"Success"]){
                
            }
        }else{
            
        }
        //            NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"LOGIN_STATUS"];
        //            NSLog(@"%@",errorCode);
        //
        //
        //            if([errorCode boolValue] == YES)
        //            {
        //
        //                BOOL isUserLogin = YES;
        //
        //                NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
        //                [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
        //                [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
        //                [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //                [self openContentView];
        //
        //            }else{
        //
        //                [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
        //            }
        [delegate hideLoading];
        //});
        
        //[delegate hideLoading];
    }
}




-(void) DeleteService{
    if(self.checkInternetConnection){
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETPOWERPLAY/%@/%@/%@/%@/%@/@'MSC002'/%@/%@/%@",[Utitliy getIPPORT],self.matchCode,self.inningsNo,txt_startover.text,txt_endover.text,powerplaytype,recordstatus,userid,powerplaycode,operationtype];
        NSLog(@"-%@",baseURL);
        
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        if(rootArray !=nil && rootArray.count>0){
            NSDictionary *valueDict = [rootArray objectAtIndex:0];
            NSString *success = [valueDict valueForKey:@"DataItem"];
            if([success isEqual:@"Success"]){
                
            }
        }else{
            
        }
        //            NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"LOGIN_STATUS"];
        //            NSLog(@"%@",errorCode);
        //
        //
        //            if([errorCode boolValue] == YES)
        //            {
        //
        //                BOOL isUserLogin = YES;
        //
        //                NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
        //                [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
        //                [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
        //                [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //                [self openContentView];
        //
        //            }else{
        //
        //                [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
        //            }
        [delegate hideLoading];
        //});
        
        //[delegate hideLoading];
    }
}

    -(BOOL)insertpowerplay{
       
        
        
        
        if(![DBManager checkpowerplay:txt_startover.text ENDOVER:txt_endover.text MATCHCODE:self.matchCode INNINGSNO:self.inningsNo])
        {
            if(![DBManager getpowerplaytype:self.matchCode INNINGSNO:self.inningsNo POWERPLAYTYPE:powerplaytype]){
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *username=[defaults stringForKey :@"UserFullname"];
                
                NSString *maxid= [DBManager getMAXIDPOWERPLAY];
                
                
                
                NSString *paddingString = [[NSString string] stringByPaddingToLength: (7-maxid.length) withString: @"0" startingAtIndex: 0];
                powerplayCode = [NSString stringWithFormat:@"PPC%@%@",paddingString,maxid] ;
                
                [DBManager SetPowerPlayDetails :powerplayCode:self.matchCode :self.inningsNo :txt_startover.text:txt_endover.text :powerplayrecord.powerplaytypecode :@"MSC001" :username :powerplayrecord.crateddate:username : powerplayrecord.modifydate];
                Resultarray =[[NSMutableArray alloc]init];
                
                Resultarray= [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];

                
                self.view_powerplay.hidden=NO;
                self.view_powerplaygrid.hidden=YES;
                isPowerplay = NO;
                [self.tbl_powerplay reloadData];
//                PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
//                add.resultarray=powerplayarray;
//                
//                add.competitionCode=competitionCode;
//                add.matchCode=matchCode;
//                add.inningsNo=inningsNo;
//                
//                [self addChildViewController:add];
//                add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//                [self.view addSubview:add.view];
//                add.view.alpha = 0;
//                [add didMoveToParentViewController:self];
//                
//                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//                 {
//                     add.view.alpha = 1;
//                 }
//                                 completion:nil];
                
                return YES;
                
            }
            else{
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"The powerplay type already exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alter show];
                return  NO;
                
                
            }
        }else{
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Given Over details has been exist in Powerplay details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            return NO;
        }

            }

    


-(BOOL)updatepowerplay{
   
    if(![DBManager checkpowerplayforupdate:txt_startover.text ENDOVER:txt_endover.text MATCHCODE:self.matchCode INNINGSNO:self.inningsNo POWERPLAYCODE:powerplaycode]){
        
        if([DBManager getpowerplaytypeforupdate:self.matchCode INNINGSNO:self.inningsNo POWERPLAYTYPE:powerplaytype POWERPLAYCODE:powerplaycode].count == 0){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *username=[defaults stringForKey :@"UserFullname"];
            
            
            [DBManager UpdatePowerPlay:self.inningsNo :txt_startover.text :txt_endover.text :powerplayrecord.modifydate :powerplayrecord.powerplaytypecode :@"MSC001" :username :powerplaycode :self.matchCode];
            
            
            self.view_powerplaygrid.hidden=YES;
            self.view_powerplay.hidden  =NO;
            isPowerplay =NO;
            
            Resultarray=powerplayarray;
            [self.tbl_powerplay reloadData];
//            PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
//            add.resultarray=powerplayarray;
//            
//            add.competitionCode=competitionCode;
//            add.matchCode=matchCode;
//            add.inningsNo=inningsNo;
//           
//            
//            [self addChildViewController:add];
//            add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//            [self.view addSubview:add.view];
//            add.view.alpha = 0;
//            [add didMoveToParentViewController:self];
//            
//            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//             {
//                 add.view.alpha = 1;
//             }
//                             completion:nil];
            
            return YES;
        }
        else{
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"The powerplay type already exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            return  NO;
            
            
        }
    }
    else{
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Given Over details has been exist in Powerplay details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
        return NO;
    }

    
    
}
-(IBAction)didClickAddBtnAction:(id)sender
{
    self.view_powerplaygrid.hidden=NO;
    self.view_powerplay.hidden   =YES;
    isPowerplay=YES;
    [self.tbl_powerplaytype reloadData];
    [self.btn_submit setTitle:@"Submit" forState:UIControlStateNormal];
}

- (IBAction)btn_back:(id)sender {
    
    if(isPowerplay ==YES)
    {
        self.view_powerplaygrid.hidden=YES;
        self.view_powerplay.hidden   =NO;
        isPowerplay=NO;
    }
    else
    {
//        self.view_powerplaygrid.hidden=NO;
//        self.view_powerplay.hidden   =YES;
        [self.delegate ChangeVCBackBtnAction];
        isPowerplay=YES;
    }
    
    
//     PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
//       add.resultarray=powerplayarray;
//       add.competitionCode=competitionCode;
//       add.matchCode=matchCode;
//       add.inningsNo=inningsNo;
//    //vc2 *viewController = [[vc2 alloc]init];
//       [self addChildViewController:add];
//       add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//       [self.view addSubview:add.view];
//       add.view.alpha = 0;
//       [add didMoveToParentViewController:self];
//    
//      [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         add.view.alpha = 1;
//     }
//                     completion:nil];
        //isPowerplay=YES;
    }
    

    

@end
