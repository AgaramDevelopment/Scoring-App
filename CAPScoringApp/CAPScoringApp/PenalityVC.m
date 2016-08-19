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
#import "FetchSEPageLoadRecord.h"


@interface PenalityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * selectindexarray;
    NSString *penalty_runs;
    NSString *penalty_type;
    NSString *penalty_reason;
    NSString *btnbatting;
    NSString *penaltytypereasons;
//    NSString *penaltycode;
    
//    NSMutableArray *penaltyarray;
    PenaltyGridTVC *penaltygridTVC;
    
    PenaltyDetailsRecord *penaltyrecord;
    MetaDataRecord *objMetaDataRecord;
    FetchSEPageLoadRecord *fetchSePage;
    DBManager *objDBManager;
    BOOL isSelected;
    BOOL isShow_penaltyrecordTbl;
    
    int selectindex;
}
@property (nonatomic,strong)NSMutableArray *FetchPenalityArray;
@end



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
@synthesize penaltyCode;
@synthesize awardedToteam;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    objDBManager = [[DBManager alloc]init];
    
    isSelected = NO;
    
    NSLog(@"test %@",self.penaltyDetailsRecord == nil ? @"-": _penaltyDetailsRecord.penaltyruns);
     [self.btn_bowling addTarget:self action:@selector(btn_bowling:) forControlEvents:UIControlEventTouchUpInside];
    
      [self.btn_batting addTarget:self action:@selector(btn_batting:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btn_batting.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
    btnbatting=@"MSC134";
    if(_penaltyDetailsRecord != nil){
        txt_penalityruns.text = _penaltyDetailsRecord.penaltyruns;
        _lbl_penaltytype.text = _penaltyDetailsRecord.penaltyreasondescription;
        penaltytypereasons=_penaltyDetailsRecord.penaltyreasoncode;
        
        [self.btn_submitpenality setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        btnbatting=@"MSC134";
        
        if([_penaltyDetailsRecord.penaltytypecode isEqual:@"MSC134"]){
            _FetchPenalityArray=[objDBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];
            self.btn_batting.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
            
            self.btn_bowling.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
//            isbtnbattingselected=YES;
            
        }else{
            _FetchPenalityArray=[objDBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT031"];
 
            
           
//            isbtnbattingselected=NO;
        }
    }else{
        _FetchPenalityArray=[objDBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];

//        isbtnbattingselected=YES;
    }
    
    //[objDBManager GetPenaltyDetailsForPageLoadPenalty:self.competitionCode :self.matchCode :self.inningsNo];
    
    
    
    
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

    awardedToteam = self.teamcode;
    
    self.tbl_penaltyrecord .hidden= NO;
    self.view_penaltyTittle.hidden=NO;
    self.Btn_Add.hidden =NO;
    isShow_penaltyrecordTbl=YES;
    
    self.resultarray =[[NSMutableArray alloc]init];
    
    _resultarray=[objDBManager SetPenaltyDetailsForInsert:self.competitionCode :self.matchCode :self.inningsNo];
  
    
}

- (IBAction)btn_bowling:(id)sender {
    
    self.btn_bowling.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
    
    self.btn_batting.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
    if (isSelected == NO) {
        
        awardedToteam = self.bowlingTeamCode;
        isSelected = YES;
    }else{
        
        isSelected = YES;
    }
    
}

- (IBAction)btn_batting:(id)sender {
    
    self.btn_batting.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
    
    self.btn_bowling.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
    
    if (isSelected == YES) {
        
        awardedToteam = self.teamcode;
        
        isSelected = NO;
    }else{
        isSelected = NO;
    }
    
}

//penality tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isShow_penaltyrecordTbl== YES)
    {
         return [self.resultarray count];
    }
    else
    {
         return [_FetchPenalityArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
   {
       if(isShow_penaltyrecordTbl== YES)
       {
           static NSString *myidentifier = @"penaltygridCell";
           
           
           PenaltyGridTVC *cell = (PenaltyGridTVC *)[tableView dequeueReusableCellWithIdentifier:myidentifier];
           if (cell == nil) {
               [[NSBundle mainBundle] loadNibNamed:@"PenaltyGridTVC" owner:self options:nil];
               cell = self.penalty_gridCell;
               self.penalty_gridCell = nil;
           }
           PenaltyDetailsRecord *veb=(PenaltyDetailsRecord*)[_resultarray objectAtIndex:indexPath.row];
           
           
           cell.lbl_awardedto.text=veb.penaltytypedescription;
           cell.lbl_penaltyruns.text=veb.penaltyruns;
           cell.lbl_penaltytype.text=veb.penaltyreasondescription;
           
           
           return cell;

       }
       else
       {
            static NSString *MyIdentifier = @"Penalitycell";
            PenalityTVC *cell = (PenalityTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            if (cell == nil)
            {
                [[NSBundle mainBundle] loadNibNamed:@"PenalityTVC" owner:self options:nil];
                 cell = self.penality_cell;
                 self.penality_cell = nil;
             }
       
           MetaDataRecord *objmetaRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
       
           cell.lbl_penalitycell.text = objmetaRecord.metasubcodedescription;
       
           [cell setBackgroundColor:[UIColor clearColor]];
       
       
           return cell;
       }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isShow_penaltyrecordTbl== YES)
    {
        PenaltyGridTVC * cell =(PenaltyGridTVC *)[tableView indexPathForCell:indexPath];
        PenaltyDetailsRecord *objmetaRecord=(PenaltyDetailsRecord*)[_resultarray objectAtIndex:indexPath.row];
        CGSize constraint = CGSizeMake(cell.frame.size.width, 20000.0f);
        
        //CGSize size =  //[cell.lbl_penalitycell.text sizeWithFont:[UIFont systemFontOfSize:17]      constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        NSString *obj =cell.lbl_penaltytype.text;
        CGFloat strheight =objmetaRecord.penaltyreasondescription.length ;
        CGFloat height =(strheight > 45)? strheight:40;
        return height;
    }
    else
    {
    PenalityTVC *cell =(PenalityTVC *)[tableView indexPathForCell:indexPath];
    MetaDataRecord *objmetaRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(cell.frame.size.width, 20000.0f);
    
    //CGSize size =  //[cell.lbl_penalitycell.text sizeWithFont:[UIFont systemFontOfSize:17]      constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    NSString *obj =cell.lbl_penalitycell.text;
    CGFloat strheight =objmetaRecord.metasubcodedescription.length ;
     CGFloat height =(strheight > 45)? strheight:40;
    return height;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(isShow_penaltyrecordTbl== YES)
    {

        
        [selectindexarray addObject:objMetaDataRecord];
        _penaltyDetailsRecord=(PenaltyDetailsRecord*)[_resultarray objectAtIndex:indexPath.row];
         selectindex=indexPath.row;
        txt_penalityruns.text = _penaltyDetailsRecord.penaltyruns;
        
        NSString * objpenaltyTypecode =_penaltyDetailsRecord.penaltytypecode;
        if([objpenaltyTypecode isEqualToString:@"MSC134"])
        {
            [self.btn_batting sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self.btn_bowling sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        penaltytypereasons=_penaltyDetailsRecord.penaltyreasoncode;
        self.lbl_penaltytype.text = _penaltyDetailsRecord.penaltyreasondescription;
        self.tbl_penaltyrecord.hidden=YES;
        self.view_penaltyTittle.hidden=YES;
        self.Btn_Add.hidden=YES;
        [self.btn_submitpenality setTitle:[NSString stringWithFormat:@"UPDATE"] forState:UIControlStateNormal];
        isShow_penaltyrecordTbl=NO;
        
    }
    else{
    selectindexarray=[[NSMutableArray alloc]init];
    objMetaDataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
    self.lbl_penaltytype.text =objMetaDataRecord.metasubcodedescription;
     penaltytypereasons=objMetaDataRecord.metasubcode;
  
    [selectindexarray addObject:objMetaDataRecord];
        [self.tbl_penality setHidden:YES];
   isShow_penaltyrecordTbl=YES;
    }
}

//batting buttonF
-(IBAction)didClickBatting:(id)sender
{
    btnbatting=@"MSC134";
    
    self.lbl_penaltytype.text=@"Choose Penalty Type";
    self.tbl_penality.hidden=YES;
    _FetchPenalityArray=[objDBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];
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
    
//    isbtnbattingselected=YES;
    
}

//bowling button
-(IBAction)didClickBowling:(id)sender
{
 btnbatting=@"MSC135";
    self.lbl_penaltytype.text=@"Choose Penalty Type";
    self.tbl_penality.hidden=YES;
    _FetchPenalityArray=[objDBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT031"];
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
    
    //[self.tbl_penality reloadData];
    
    
    self.btn_bowling.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
    
    self.btn_batting.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
    
//    isbtnbattingselected=YES;
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Penalty" message:@"Only Numbers Are Allowed For Participant Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    return NO;
}//drop down button
-(IBAction)didclicktouch:(id)sender{
    
    if(self.tbl_penality.hidden==YES)
    {
        self.tbl_penality.hidden=NO;
        isShow_penaltyrecordTbl=NO;
        [self.tbl_penality reloadData];
       
    }
    else
    {
        self.tbl_penality.hidden=YES;
         isShow_penaltyrecordTbl=YES;
    }
    
}

-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

- (BOOL) formValidation{
    NSString *penaltyTxtf = self.txt_penalityruns.text;
    NSString *penaltyreasonTxtf = self.lbl_penaltytype.text;
    if([penaltyTxtf isEqual:@""] && [penaltyreasonTxtf isEqual:@"Choose Penalty Type"] || [penaltyreasonTxtf isEqualToString:@""]){
        [self showDialog:@"Please Enter Penalty Runs And Choose  Penalty Type " andTitle:@"Penalty"];
        return NO;
    }
     else if([penaltyTxtf isEqual:@""])
     {
          [self showDialog:@"Please Enter Penalty Runs." andTitle:@"Penalty"];
         return NO;
     }
    else if([penaltyreasonTxtf isEqual:@"Choose Penalty Type"] || [penaltyreasonTxtf isEqualToString:@""]){
        [self showDialog:@"Please Choose  Penalty Type" andTitle:@"Penalty"];
        return NO;
    }
    else{
        if([penaltyTxtf isEqual:@""]){
            [self showDialog:@"Please Enter Penalty Runs." andTitle:@"Penalty"];
            return NO;
        }else if([penaltyreasonTxtf isEqual:@"Choose Penalty Type"] || [penaltyreasonTxtf isEqualToString:@""]){
            [self showDialog:@"Please Choose  Penalty Type" andTitle:@"Penalty"];
            return NO;
        }
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
        
        PenaltyDetailsRecord *penaltyrecord = [[PenaltyDetailsRecord alloc]init];
        objMetaDataRecord=[[MetaDataRecord alloc]init];
        penaltyrecord.penaltyruns=txt_penalityruns.text;
        penaltyrecord.penaltytypecode=btnbatting;
        penaltyrecord.penaltyreasoncode=penaltytypereasons;
        if([self formValidation]){
            int penaltyRunsData = [penaltyrecord.penaltyruns intValue];
            if(penaltyRunsData >= 0 && penaltyRunsData <=10){
                
               // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //NSString *username=[defaults stringForKey :@"UserFullname"];
                
                NSString *maxid= [objDBManager getMAXIDPENALTY];
                NSString *paddingString = [[NSString string] stringByPaddingToLength: (7-maxid.length) withString: @"0" startingAtIndex: 0];
                NSString *penaltycode = [NSString stringWithFormat:@"PNT%@%@",paddingString,maxid] ;
                
                if([self.selectStartBallStatus isEqualToString:@"No"])
                {
                   [objDBManager SetPenaltyDetails:self.competitionCode :self.matchCode :self.inningsNo :self.ballcode :penaltycode :self.awardedToteam : penaltyrecord.penaltyruns :penaltyrecord.penaltytypecode :penaltyrecord.penaltyreasoncode];
                
                }
                else
                {
                    [self.delegate InsertPenaltyMethod:self.awardedToteam :penaltyrecord.penaltyruns :penaltyrecord.penaltytypecode :penaltyrecord.penaltyreasoncode];
                }
                
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Penalty" message:@"Penalty Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alter show];
                alter.tag =10;
                
                
                 [self startService];
               
                }
            else {
                [self showDialog:@"Please Enter Runs Between 0 to 10" andTitle:@"Penalty"];
            }
        }
        
    }else{
        
        PenaltyDetailsRecord *penaltyrecord = [[PenaltyDetailsRecord alloc]init];
        objMetaDataRecord=[[MetaDataRecord alloc]init];
        penaltyrecord.penaltyruns=txt_penalityruns.text;
        penaltyrecord.penaltytypecode=btnbatting;
        penaltyrecord.penaltyreasoncode=penaltytypereasons;
        
        if([self formValidation])
        {
        int penaltyRunsData = [penaltyrecord.penaltyruns intValue];
        if(penaltyRunsData >= 0 && penaltyRunsData <=10 ){
            
            
            
//         penaltyarray=[objDBManager SetPenaltyDetailsForInsert:self.competitionCode :self.matchCode :self.inningsNo];
            
//            if (penaltyarray.count >0) {
            
//                PenaltyDetailsRecord *penalty = [penaltyarray objectAtIndex:selectindex];
//                penaltyCode = penalty.penaltycode;
            
                
//            }
           
            
            [objDBManager GetUpdatePenaltyDetails:awardedToteam :penaltyrecord.penaltyruns :penaltyrecord.penaltytypecode :penaltyrecord.penaltyreasoncode :self.competitionCode :self.matchCode :self.inningsNo :_penaltyDetailsRecord.penaltycode];
            
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Penalty" message:@"Penalty Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            alter.tag =10;
            _penaltyDetailsRecord = nil;
            
        }else{
            [self showDialog:@"Please Enter Runs Between 0 to 10" andTitle:@"Penalty"];
        }
        }
    }

    }


- (IBAction)btn_back:(id)sender {
    
    if(isShow_penaltyrecordTbl == YES)
    {
        [self.delegate ChangeVCBackBtnAction];
        [self.delegate reloadScoreEnginOnOtherWicket];
//        self.tbl_penaltyrecord.hidden=NO;
//        isShow_penaltyrecordTbl=NO;
//        self.Btn_Add.hidden =NO;
//        [self.tbl_penaltyrecord reloadData];
    }
    else
    {
        self.tbl_penaltyrecord.hidden=NO;
        self.view_penaltyTittle.hidden=NO;
        isShow_penaltyrecordTbl= YES;
        self.Btn_Add.hidden =NO;
    }
    
}

- (IBAction)btn_addpenalty:(id)sender {
    
    
    if(isShow_penaltyrecordTbl == YES)
    {
        self.tbl_penaltyrecord.hidden=YES;
        self.view_penaltyTittle.hidden=YES;
        isShow_penaltyrecordTbl= NO;
        self.Btn_Add.hidden =YES;
        [self.btn_submitpenality setTitle:[NSString stringWithFormat:@"Submit"] forState:UIControlStateNormal];
        self.lbl_penaltytype.text=@"Choose Penalty Type";
        self.txt_penalityruns.text=@"";
        [_resultarray lastObject];
        int myCount = [_resultarray count];
        selectindex= myCount+1;
        
    }
    else
    {
        self.tbl_penaltyrecord.hidden=YES;
        self.view_penaltyTittle.hidden=YES;
        isShow_penaltyrecordTbl= YES;
        self.Btn_Add.hidden =YES;
    }

    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)//OK button pressed
    {
        if(alertView.tag == 10)
        {
             if([self.selectStartBallStatus isEqualToString:@"No"])
             {
                self.tbl_penaltyrecord.hidden=NO;
                 self.view_penaltyTittle.hidden =NO;
                isShow_penaltyrecordTbl= YES;
                self.Btn_Add.hidden = NO;
                self.resultarray =[[NSMutableArray alloc]init];
            
                _resultarray=[objDBManager SetPenaltyDetailsForInsert:self.competitionCode :self.matchCode :self.inningsNo];
                [self.tbl_penaltyrecord reloadData];
             }
            else
            {
                [self.delegate ChangeVCBackBtnAction];
            }
        }
    }
    else if(buttonIndex == 1)//Annul button pressed.
    {
        //do something
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
