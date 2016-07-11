//
//  PenalityVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/16/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PenalityVC.h"
#import "PenalityTVC.h"
#import "DBManager.h"
#import "MetaDataRecord.h"
#import "PenaltyDetailsRecord.h"
#import "PenaltyGridTVC.h"
#import "PenaltygridVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"


@interface PenalityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * selectindexarray;
    NSString *penalty_runs;
    NSString *penalty_type;
    NSString *penalty_reason;
    BOOL isbtnbattingselected;
    
   
}
@property (nonatomic,strong)NSMutableArray *FetchPenalityArray;
@end

NSString *btnbatting;
NSString *penaltytypereasons;
NSString *penaltycode;

 NSMutableArray *penaltyarray;
PenaltyGridTVC *penaltygridTVC;

@implementation PenalityVC
@synthesize metadatatypecode;
@synthesize matchCode;
@synthesize metasubcode;
@synthesize inningsNo;
@synthesize competitionCode;
@synthesize ballcode;
@synthesize teamcode;
@synthesize txt_penalityruns;
@synthesize  test;

PenaltyDetailsRecord *penaltyrecord;
MetaDataRecord *objMetaDataRecord;




NSString *btnbatting;
NSString *penaltytypereasons;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"test %@",self.penaltyDetailsRecord == nil ? @"-": _penaltyDetailsRecord.penaltyruns);
    
    if(_penaltyDetailsRecord != nil){
        txt_penalityruns.text = _penaltyDetailsRecord.penaltyruns;
        _lbl_penaltytype.text = _penaltyDetailsRecord.penaltyreasondescription;
        penaltytypereasons=_penaltyDetailsRecord.penaltyreasoncode;
        
        [self.btn_submitpenality setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        btnbatting=@"MSC134";
        
        if([_penaltyDetailsRecord.penaltytypecode isEqual:@"MSC134"]){
            _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];
            self.btn_batting.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
            
            self.btn_bowling.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
            isbtnbattingselected=YES;
            
        }else{
            _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT031"];
            self.btn_bowling.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
            
            self.btn_batting.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
            
            isbtnbattingselected=NO;
        }
    }else{
        _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];
        self.btn_batting.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        self.btn_bowling.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        isbtnbattingselected=YES;
    }
    
    [DBManager GetPenaltyDetailsForPageLoadPenalty:self.competitionCode :self.matchCode :self.inningsNo];
    
    
    
    
    [self.txt_penalityruns.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txt_penalityruns.layer.borderWidth=2;
    
    [self.view_batting.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_batting.layer.borderWidth=2;
    
    [self.view_bowling.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_bowling.layer.borderWidth=2;
    
    [self.view_penalityreason.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_penalityreason.layer.borderWidth=2;
    
    self.tbl_penality.hidden=YES;
    
    [super viewWillAppear:YES];
    
    penalty_runs =self.txt_penalityruns.text;
    NSLog(@"penaltyruns:%@",penalty_runs);

    
    
}


//penality tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_FetchPenalityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
   {
       static NSString *MyIdentifier = @"Penalitycell";
       PenalityTVC *cell = (PenalityTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
       if (cell == nil) {
           [[NSBundle mainBundle] loadNibNamed:@"PenalityTVC" owner:self options:nil];
           cell = self.penality_cell;
           self.penality_cell = nil;
       }
       
       MetaDataRecord *objmetaRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
       
       cell.lbl_penalitycell.text = objmetaRecord.metasubcodedescription;
       
       [cell setBackgroundColor:[UIColor clearColor]];
       
       
       return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    selectindexarray=[[NSMutableArray alloc]init];
    objMetaDataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
    self.lbl_penaltytype.text =objMetaDataRecord.metasubcodedescription;
     penaltytypereasons=objMetaDataRecord.metasubcode;
    [selectindexarray addObject:objMetaDataRecord];
    self.tbl_penality.hidden=YES;
}

//batting button
-(IBAction)didClickBatting:(id)sender
{
    btnbatting=@"MSC134";
    
    self.lbl_penaltytype.text=@"Choose Penalty Type";
    self.tbl_penality.hidden=YES;
    _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];
    for(int i=0; i < [_FetchPenalityArray count]; i++)
    {
        MetaDataRecord *objmetadataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:i];
        NSLog(@"%@",objmetadataRecord.metasubcodedescription);
        NSString *metastatus=objmetadataRecord.metasubcodedescription;
        if([metastatus isEqualToString:@"MDT030"])
        {
            [_FetchPenalityArray addObject:objmetadataRecord];
        }
        penaltyrecord.penaltytypedescription=@"MSC134";
        
    }
    [self.tbl_penality reloadData];
    
    self.btn_batting.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
    
    self.btn_bowling.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
    
    isbtnbattingselected=YES;
    
}

//bowling button
-(IBAction)didClickBowling:(id)sender
{
 btnbatting=@"MSC135";
    self.lbl_penaltytype.text=@"Choose Penalty Type";
    self.tbl_penality.hidden=YES;
    _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT031"];
    for(int i=0; i < [_FetchPenalityArray count]; i++)
    {
        
        MetaDataRecord *objmetadataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:i];
        NSLog(@"%@",objmetadataRecord.metasubcodedescription);
        NSString *metastatus=objmetadataRecord.metasubcodedescription;
        if([metastatus isEqualToString:@"MDT031"])
        {
            [_FetchPenalityArray addObject:objmetadataRecord];
        }
        
    }
   penaltyrecord.penaltytypedescription=@"MSC135";
    
    [self.tbl_penality reloadData];
    
    
    self.btn_bowling.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
    
    self.btn_batting.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
    
    isbtnbattingselected=YES;
}



//drop down button
-(IBAction)didclicktouch:(id)sender{
    
   self.tbl_penality.hidden=NO;
    
}

-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

- (BOOL) formValidation{
    NSString *penaltyTxtf = self.txt_penalityruns.text;
    NSString *penaltyreasonTxtf = self.lbl_penaltytype.text;
    if([penaltyTxtf isEqual:@""]){
        [self showDialog:@"Please enter Penalty Runs." andTitle:@""];
        return NO;
    }else if([penaltyreasonTxtf isEqual:@"Choose Penalty Type"]){
        [self showDialog:@"Please Choose  Penalty Type" andTitle:@""];
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


-(void) startService{
    if(self.checkInternetConnection){
        
//        NSString *txt_penalityruns = selectedpenaltyruns == nil ?@"NULL":selectedpenaltyruns.penaltyruns;
//        NSString *penalty_type = selectedpenaltytype == nil ?@"NULL":selectedpenaltytype.penaltytypecode;
//        NSString *penalty_reason = selectedpenaltyreason == nil ?@"NULL":selectedpenaltyreason.penaltyreasoncode;
    
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETPENALTY/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT], self.competitionCode,self.matchCode,self.inningsNo,self.ballcode,self.teamcode,txt_penalityruns.text,btnbatting,penaltyrecord.penaltyreasoncode];
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



-(IBAction)didclicksubmit:(id)sender{
    
    
    if(_penaltyDetailsRecord == nil){
        
        [self startService];
        
        PenaltyDetailsRecord *penaltyrecord = [[PenaltyDetailsRecord alloc]init];
        objMetaDataRecord=[[MetaDataRecord alloc]init];
        penaltyrecord.penaltyruns=txt_penalityruns.text;
        penaltyrecord.penaltytypecode=btnbatting;
        penaltyrecord.penaltyreasoncode=penaltytypereasons;
        if([self formValidation]){
            int penaltyRunsData = [penaltyrecord.penaltyruns intValue];
            if(penaltyRunsData >= 0 && penaltyRunsData <=10){
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *username=[defaults stringForKey :@"UserFullname"];
                
                NSString *maxid= [DBManager getMAXIDPENALTY];
                NSString *paddingString = [[NSString string] stringByPaddingToLength: (7-maxid.length) withString: @"0" startingAtIndex: 0];
                penaltycode = [NSString stringWithFormat:@"PNT%@%@",paddingString,maxid] ;
                
                
                [DBManager SetPenaltyDetails:self.competitionCode :self.matchCode :self.inningsNo :self.ballcode :penaltycode :self.teamcode :penaltyrecord.penaltyruns :penaltyrecord.penaltytypecode :penaltyrecord.penaltyreasoncode];
                
                
                
                penaltyarray=[DBManager SetPenaltyDetailsForInsert:self.competitionCode :self.matchCode :self.inningsNo];
                
                PenaltygridVC *add = [[PenaltygridVC alloc]initWithNibName:@"PenaltygridVC" bundle:nil];
                add.resultarray=penaltyarray;
                add.competitionCode=competitionCode;
                add.matchCode=matchCode;
                add.inningsNo=inningsNo;
                //vc2 *viewController = [[vc2 alloc]init];
                [self addChildViewController:add];
                add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
                [self.view addSubview:add.view];
                add.view.alpha = 0;
                [add didMoveToParentViewController:self];
                
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
                 {
                     add.view.alpha = 1;
                 }
                                 completion:nil];
            }
            else {
                [self showDialog:@"Please enter Runs between 0 to 10" andTitle:@"Error"];
            }
        }
        
    }else{
        
        PenaltyDetailsRecord *penaltyrecord = [[PenaltyDetailsRecord alloc]init];
        objMetaDataRecord=[[MetaDataRecord alloc]init];
        penaltyrecord.penaltyruns=txt_penalityruns.text;
        penaltyrecord.penaltytypecode=btnbatting;
        penaltyrecord.penaltyreasoncode=penaltytypereasons;
        
        
        int penaltyRunsData = [penaltyrecord.penaltyruns intValue];
        if(penaltyRunsData >= 0 && penaltyRunsData <=10 ){
            
            [DBManager GetUpdatePenaltyDetails:self.teamcode :penaltyrecord.penaltyruns :penaltyrecord.penaltytypecode :penaltyrecord.penaltyreasoncode :self.competitionCode :self.matchCode :self.inningsNo :penaltycode];
            
            penaltyarray=[DBManager SetPenaltyDetailsForInsert:self.competitionCode :self.matchCode :self.inningsNo];
            
            PenaltygridVC *add = [[PenaltygridVC alloc]initWithNibName:@"PenaltygridVC" bundle:nil];
            add.resultarray=penaltyarray;
            add.competitionCode=competitionCode;
            add.matchCode=matchCode;
            add.inningsNo=inningsNo;
            //vc2 *viewController = [[vc2 alloc]init];
            [self addChildViewController:add];
            add.view.frame =CGRectMake(0, 0, add.view.frame.size.width-50, add.view.frame.size.height);
            [self.view addSubview:add.view];
            add.view.alpha = 0;
            [add didMoveToParentViewController:self];
            
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
             {
                 add.view.alpha = 1;
             }
                             completion:nil];
            
        }else{
            [self showDialog:@"Please enter Runs between 0 to 10" andTitle:@"Error"];
        }
    }



}

- (IBAction)btn_back:(id)sender {
    
    PenaltygridVC *add = [[PenaltygridVC alloc]initWithNibName:@"PenaltygridVC" bundle:nil];
    add.resultarray=penaltyarray;
    add.competitionCode=competitionCode;
    add.matchCode=matchCode;
    add.inningsNo=inningsNo;
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:add];
    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
    [self.view addSubview:add.view];
    add.view.alpha = 0;
    [add didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         add.view.alpha = 1;
     }
                     completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
