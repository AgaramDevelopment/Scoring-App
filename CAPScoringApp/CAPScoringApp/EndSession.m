///
//  EndSession.m
//  CAPScoringApp
//
//  Created by deepak on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndSession.h"
#import "EndSessionRecords.h"
#import "FetchSEPageLoadRecord.h"
#import "DBManagerEndSession.h"
#import "EndSessionTVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"
#import "DBManagerEndInnings.h"

@interface EndSession ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString * BtnurrentTittle;
    NSDateFormatter *formatter;
    NSString *competitioncode;
    NSString *matchcode;
   // NSObject *fetchEndSession;
    UITableView *objDrobDowntbl;
    NSString  * Dominate;
    NSString *MatchDate;
    NSString *MatchDateWithTime;
    DBManagerEndSession *dbEndSession;
    BOOL startTimeEqual;
}

@end
int selectedTablePos;
NSMutableArray *endSessionArray;
NSMutableArray *battingTeamArray;
NSMutableArray *bowlingTeamArray;
NSMutableArray *metaCodeArray;

NSMutableArray *battingBowlingArray;

EndSessionRecords *sessionRecords;
FetchSEPageLoadRecord *fetchSeRecord;

BOOL back;
BOOL IsDropDown;
BOOL isEndDate;

int POS_TEAM_TYPE = 1;

@implementation EndSession
@synthesize MATCHTYPECODE;
@synthesize SESSIONNO;
@synthesize STARTOVERNO;
@synthesize ENDOVERNO;
@synthesize RUNSSCORED;
@synthesize DAYNO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.frame =CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 100);
  [self.tbl_session setBackgroundColor:[UIColor clearColor]];
    _btn_save.hidden = YES;
    _btn_delete.hidden = YES;
    
    self.btn_delete.backgroundColor=[UIColor colorWithRed:(119/255.0f) green:(57/255.0f) blue:(58/255.0f) alpha:1.0f];
    [_btn_delete setUserInteractionEnabled:NO];
    _tbl_session.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)fetchPageEndSession:(NSObject *) fetchRecord:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE
{
     dbEndSession = [[DBManagerEndSession alloc]init];
    fetchSeRecord = [[FetchSEPageLoadRecord alloc]init];
    
    competitioncode = COMPETITIONCODE;
    matchcode = MATCHCODE;
   // fetchEndSession = fetchRecord;
    
    fetchSeRecord = fetchRecord;
    
    sessionRecords = [[EndSessionRecords alloc]init];
    
    back = YES;
   
    
    DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    
    MatchDate = [dbEndInnings GetMatchDateForFetchEndInnings : COMPETITIONCODE :MATCHCODE];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:MatchDate];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *MATCHDATE1 = [formatter stringFromDate:date];
    
    NSString *timeString=@"00:00:00";
    
    MatchDateWithTime = [NSString stringWithFormat:@"%@ %@",MATCHDATE1,timeString];
    
    
   battingTeamArray = [[NSMutableArray alloc]init];
    battingTeamArray =[dbEndSession GetBattingTeamForFetchEndSession:fetchSeRecord.BATTINGTEAMCODE :fetchSeRecord.BOWLINGTEAMCODE];
    
    bowlingTeamArray = [[NSMutableArray alloc]init];
    bowlingTeamArray = [dbEndSession GetBattingTeamUsingBowlingCode:fetchSeRecord.BOWLINGTEAMCODE];
    
    metaCodeArray = [[NSMutableArray alloc]init];
    metaCodeArray = [dbEndSession GetMetaSubCode];
    
    
    battingBowlingArray = [[NSMutableArray alloc]init];
    
    [battingBowlingArray addObject:battingTeamArray];
    [battingBowlingArray addObject:bowlingTeamArray];
    [battingBowlingArray addObject:metaCodeArray];
    
    
    endSessionArray = [[NSMutableArray alloc]init];
    
    endSessionArray = [dbEndSession GetSessionEventsForFetchEndSession:competitioncode :matchcode];

    
   // [self.btn_dropDown addTarget:self action:@selector(btn_dropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [sessionRecords FetchEndSession:competitioncode :matchcode :fetchSeRecord.INNINGSNO :fetchSeRecord.BATTINGTEAMCODE :fetchSeRecord.BOWLINGTEAMCODE];
    
    
     _lbl_day.text = sessionRecords.DAYNO;
    _lbl_SessionNo.text = [NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO];
    _lbl_InningsNo.text = [NSString stringWithFormat:@"%@",sessionRecords.INNINGSNOS];
    _lbl_teamBatting.text = sessionRecords.TEAMNAMES;
    _lbl_sessionStartOver.text = [NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO == nil ? @"0" : sessionRecords.STARTOVERNO];
    
    _lbl_sessionEndOver.text = [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO = @"" ? @"0" :sessionRecords.ENDOVERNO];
    
    _lbl_runScored.text = [NSString stringWithFormat:@"%@",sessionRecords.RUNSSCORED];
    _lbl_wicketLost.text = [NSString stringWithFormat:@"%@",sessionRecords.WICKETLOST];

    
    SESSIONNO = sessionRecords.SESSIONNO;
    DAYNO = sessionRecords.DAYNO;

    STARTOVERNO = sessionRecords.STARTOVERNO;
    ENDOVERNO = sessionRecords.ENDOVERNO;
    RUNSSCORED = sessionRecords.RUNSSCORED;
    
    

    [self.view layoutIfNeeded];
    self.scroll_EndSession.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    
    _scroll_EndSession.scrollEnabled = YES;
    
    [self.view_StartSession.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_StartSession.layer.borderWidth = 2;
    
    [self.view_EndSession.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_EndSession.layer.borderWidth = 2;
    
    [self.view_duration.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_duration.layer.borderWidth = 2;
    
    
    [self.view_Day.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_Day.layer.borderWidth = 2;
    
    
    [self.view_SessionNo.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_SessionNo.layer.borderWidth = 2;
    
    
    [self.view_InningsNo.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_InningsNo.layer.borderWidth = 2;
    
    [self.view_teamBatting.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_teamBatting.layer.borderWidth = 2;
    
    [self.view_sessionStartOver.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_sessionStartOver.layer.borderWidth = 2;
    
    [self.view_sessionEndOver.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_sessionEndOver.layer.borderWidth = 2;
    
    [self.view_runScored.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_runScored.layer.borderWidth = 2;
    
    [self.view_wicketLost.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_wicketLost.layer.borderWidth = 2;
    
    [self.view_sessionDominant.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_sessionDominant.layer.borderWidth = 2;
    
    

   // [self duration];
      self.view_allControls.hidden = YES;
    self.view_datePicker.hidden=YES;
    self.btn_save.hidden = YES;
    self.btn_delete.hidden = YES;
    
}

-(void)datePicker{
    
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    self.view_datePicker.hidden=NO;
    
    datePicker =[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.txt_startTime setInputView:datePicker];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * currentDate = [dateFormat dateFromString:MatchDateWithTime];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    if([self.MATCHTYPECODE isEqual:@"MSC114"] || [self.MATCHTYPECODE isEqual:@"MSC023"])
    {
        [comps setDay:5];
        [comps setMonth:0];
        [comps setYear:0];
    }
    else if([fetchSeRecord.INNINGSNO isEqualToString:@"1"])
    {
        [comps setDay:1];
        [comps setMonth:0];
        [comps setYear:0];
        
    }else{
        
        [comps setDay:1];
        [comps setMonth:0];
        [comps setYear:0];
    }
    
   
    
    // self.timestamp = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    //[comps setYear:-1];
    [comps setDay:0];
    [comps setMonth:0];
    [comps setYear:0];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(self.txt_startTime.frame.origin.x,self.txt_startTime.frame.origin.y+30,self.view.frame.size.width,100)];
    //[datePicker setMaximumDate:maxDate];
    //[datePicker setMinimumDate:minDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [datePicker setLocale:locale];
    
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:maxDate];
    [datePicker setDate:minDate animated:YES];
    [datePicker reloadInputViews];
    [self.view_datePicker addSubview:datePicker];
}


-(void)endDatePicker{
    
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    [self datePicker];
    
}

-(void)showSelecteddate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_startTime.text=[NSString stringWithFormat:@"%@",
                             [formatter stringFromDate:datePicker.date]];
    [self.txt_startTime resignFirstResponder];
    [self duration];
    
}



-(void)showEndDatePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *selectedDate = [datePicker date];
    NSString *recordDate = [formatter stringFromDate:selectedDate];
    self.txt_endTime.text=recordDate;
    [self.txt_endTime resignFirstResponder];
    [self duration];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        isEndDate=NO;
        [self datePicker];
        [textField resignFirstResponder];
    }
    else if (textField.tag == 2)
    {
        isEndDate=YES;
        [self endDatePicker];
        [textField resignFirstResponder];
    }
}


-(void)duration{
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateTF = self.txt_startTime.text;
    NSString *startEndTF = self.txt_endTime.text;
    
    NSDate *date1 = [formatter dateFromString:startDateTF];
    NSDate *date2 = [formatter dateFromString:startEndTF];
    
    NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    int days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
    self.lbl_duration.text=[NSString stringWithFormat:@"%@", Duration];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    
    
     return [endSessionArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    if(tableView== objDrobDowntbl)
    {
        static NSString *CellIdentifier = @"row";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier];
        }
        EndSessionRecords *end=(EndSessionRecords*)[endSessionArray objectAtIndex:indexPath.row];
        cell.textLabel.text = end.BATTINGTEAMNAME;
        return cell;
        
    
 
    }
    else if(tableView == _tbl_session){
        static NSString *CellIdentifier = @"row";
        EndSessionTVC *cell = (EndSessionTVC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"EndSessionTVC" owner:self options:nil];
            cell = self.GridRow;
            self.GridRow = nil;
        }
        
        EndSessionRecords *end=(EndSessionRecords*)[endSessionArray objectAtIndex:indexPath.row];
        
        
        cell.lbl_startSessionTime.text = end.SESSIONSTARTTIME == @"" ? @"0" : end.SESSIONSTARTTIME ;
        cell.lbl_endSessionTime.text = end.SESSIONENDTIME== @"" ? @"0" : end.SESSIONENDTIME;
        cell.lbl_teamName.text = end.SHORTTEAMNAME;
        
        
        cell.lbl_sessionNo.text = [NSString stringWithFormat:@"%@", end.SESSIONNO];
        
        
        cell.lbl_dayNo.text = end.DAYNO;
        
        return cell;

    }
    
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.view_addBtn.hidden = YES;
     EndSessionRecords *obj =(EndSessionRecords*)[endSessionArray objectAtIndex:indexPath.row];
    _scroll_EndSession.scrollEnabled = YES;
  
    if(tableView== objDrobDowntbl)
    {
       
        if (IsDropDown == YES) {
            
            self.lbl_sessionDominant.text = obj.BATTINGTEAMNAME;
            Dominate  =obj.BATTINGTEAMCODE;
            IsDropDown = NO;
            
        }
        objDrobDowntbl.hidden=YES;
    }
    else
    {
    //EndSessionRecords *obj =(EndSessionRecords*)[endSessionArray objectAtIndex:indexPath.row];
        
    dbEndSession = [[DBManagerEndSession alloc]init];
        
        //RUNSSCORED
   NSString *run=[dbEndSession GetRunsScoredForFetchEndSession :competitioncode: matchcode :sessionRecords.SESSIONNO : obj.INNINGSNO : obj.DAYNO];
        //TOTALWICKET
    NSString *wickets=[dbEndSession GetWicketLoftForFetchEndSession :competitioncode: matchcode :obj.INNINGSNO :sessionRecords.SESSIONNO : obj.DAYNO];
        
    NSString *startOver =[dbEndSession GetStartOverNoForFetchEndSession :competitioncode :matchcode :sessionRecords.SESSIONNO : obj.INNINGSNO : obj.DAYNO];
        
    NSString *endOverNO = [dbEndSession GetEndOverNoForFetchEndSession:competitioncode :matchcode :sessionRecords.SESSIONNO :obj.DAYNO :obj.INNINGSNO];
        
    NSString *sessionNo =[dbEndSession  GetSessionNoForFetchEndSession :competitioncode: matchcode : obj.DAYNO];
        
    NSString*startInningsTime = obj.SESSIONSTARTTIME;
    NSString*endInningsTime  = obj.SESSIONENDTIME;
    NSString*teamName = obj.TEAMNAME;
    
    NSString*dayNo = obj.DAYNO;
        
   //NSNumber *sessionNo = obj.SESSIONNO;
    NSNumber *inningsNo = obj.INNINGSNO;
  
   
        
        BtnurrentTittle = [NSString stringWithFormat:self.btn_save.currentTitle];
        //BtnurrentTittle = @"UPDATE";
        [self.btn_save setTitle: @"UPDATE" forState: UIControlStateNormal];
    
    
    self.txt_startTime.text = startInningsTime;
    self.txt_endTime.text = endInningsTime;
    self.lbl_teamBatting.text = teamName;

    
    self.lbl_day.text = dayNo;
        NSLog(@"SESSIONNUMBER = %@", obj.SESSIONNO);
        
     self.lbl_SessionNo.text =obj.SESSIONNO;
        
    self.lbl_InningsNo.text = [NSString stringWithFormat:@"%@",inningsNo];
    
        _lbl_sessionStartOver.text = startOver;
        _lbl_sessionEndOver.text = endOverNO = @"" ? @"0" : endOverNO;
        _lbl_runScored.text = run;
        _lbl_wicketLost.text = wickets;
        _lbl_sessionDominant.text = obj.DOMINANTNAME;
        
         self.view_heading.hidden = YES;
    self.tbl_session.hidden = YES;
    self.view_allControls.hidden = NO;
    
        _btn_save.hidden = NO;
        _btn_delete.hidden = NO;
        
      self.btn_delete.backgroundColor=[UIColor colorWithRed:(255/255.0f) green:(86/255.0f) blue:(88/255.0f) alpha:1.0f];
        [_btn_delete setUserInteractionEnabled:YES];
    
}

}
//Check internet connection
- (BOOL)checkInternetConnection
{

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)btn_addEndSession:(id)sender {
    
    BtnurrentTittle = [NSString stringWithFormat:self.btn_save.currentTitle];
    BtnurrentTittle = @"INSERT";
    
    [self.btn_save setTitle: @"SAVE" forState: UIControlStateNormal];
    
    self.view_addBtn.hidden = YES;
    self.lbl_duration.text = @"";
    self.txt_startTime.text = @"";
    self.txt_endTime.text = @"";
    self.lbl_sessionDominant.text = @"";
    
    self.view_heading.hidden = YES;
    self.view_allControls.hidden = NO;
    self.tbl_session.hidden = YES;
    _btn_save.hidden = NO;
    _btn_delete.hidden = NO;
    back=NO;
    
    self.btn_delete.backgroundColor=[UIColor colorWithRed:(119/255.0f) green:(57/255.0f) blue:(58/255.0f) alpha:1.0f];
    [_btn_delete setUserInteractionEnabled:NO];
    
}

-(BOOL) checkValidation{
    
    
    if([self.txt_endTime.text isEqualToString:@""]){
        [self showDialog:@"Please Choose End Session Time" andTitle:@"End Session"];
        return NO;
    }
    
    if(![self.lbl_duration.text isEqualToString:@""] && [self.lbl_duration.text integerValue]<=0){
         [self showDialog:@"Duration should be greated than zero" andTitle:@"End Session"];
        return NO;
    }
    

   
    return YES;
}

/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

-(void)ValidationStartAndEndTime
{
   startTimeEqual=(endSessionArray.count>0)?NO:YES;
    for(int i=0; i<endSessionArray.count; i++)
    {
        EndSessionRecords *obj =(EndSessionRecords*)[endSessionArray objectAtIndex:i];
        if([self.txt_startTime.text isEqualToString:obj.SESSIONSTARTTIME] && [self.txt_endTime.text isEqualToString: obj.SESSIONENDTIME])
        {
            NSLog(@"same");
            startTimeEqual=YES;
        }
        else
        {
            NSLog(@"notsame");
            startTimeEqual=NO;
        }
        
    }

}
- (IBAction)btn_save:(id)sender {
    
    if ([self checkValidation]) {
    
    if ([BtnurrentTittle isEqualToString:@"INSERT"])
    {
        
        //int SESSIONNO =[sessionRecords.SESSIONNO intValue];
        int STARTOVERNO  = [sessionRecords.STARTOVERNO intValue];
        int ENDOVERNO   =[sessionRecords.ENDOVERNO intValue];
        int  RUNSSCORED =[sessionRecords.RUNSSCORED intValue];
        [self ValidationStartAndEndTime];
     if(startTimeEqual== NO)
    {
        [sessionRecords InsertEndSession:competitioncode : matchcode :fetchSeRecord.BATTINGTEAMCODE :fetchSeRecord.INNINGSNO :fetchSeRecord.DAYNO : SESSIONNO :_txt_startTime.text :_txt_endTime.text :[NSString stringWithFormat:@"%d",STARTOVERNO]: [NSString stringWithFormat:@"%d",ENDOVERNO] :[NSString stringWithFormat:@"%d" ,RUNSSCORED] :[NSString stringWithFormat:@"%d",fetchSeRecord.BATTEAMWICKETS] :Dominate];
        
        if(self.checkInternetConnection){
            
            
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            //Show indicator
            [delegate showLoading];
            //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
            
            //dispatch_get_main_queue(), ^
            {
                
                NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDSESSION/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],competitioncode, matchcode,fetchSeRecord.BATTINGTEAMCODE,fetchSeRecord.INNINGSNO,sessionRecords.DAYNO,[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO],_txt_startTime.text,_txt_endTime.text ,[NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO], [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO],[NSString stringWithFormat:@"%@" ,sessionRecords.RUNSSCORED],sessionRecords.WICKETLOST,@"(null)",BtnurrentTittle];
         
                
                NSLog(@"%@",baseURL);
                
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
                
                [delegate hideLoading];
            }
            
           
            
        }
        
     
    else{
        
        
        dbEndSession = [[DBManagerEndSession alloc]init];
        
        NSString *dayNO =  [dbEndSession getDayNo : competitioncode: matchcode];
        
        if ([dayNO isEqualToString:@"0"]) {
            
           dayNO = @"1";
        }
        
        
        NSString *sessionNo =[dbEndSession  GetSessionNoForFetchEndSession :competitioncode: matchcode : dayNO];

        
        [sessionRecords UpdateEndSession:competitioncode :matchcode :fetchSeRecord.INNINGSNO :dayNO :sessionNo :_txt_startTime.text :_txt_endTime.text :Dominate:fetchSeRecord.INNINGSNO:fetchSeRecord.BATTINGTEAMCODE:dayNO];
        

        
        if(self.checkInternetConnection){
            
            
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            //Show indicator
            [delegate showLoading];
            //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
            
            //dispatch_get_main_queue(), ^
            {
                
                
        NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDSESSION/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],competitioncode, matchcode,fetchSeRecord.BATTINGTEAMCODE,fetchSeRecord.INNINGSNO,sessionRecords.DAYNO,[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO],_txt_startTime.text,_txt_endTime.text ,[NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO], [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO],[NSString stringWithFormat:@"%@" ,sessionRecords.RUNSSCORED],sessionRecords.WICKETLOST,@"(null)",BtnurrentTittle];
                
                
                NSLog(@"%@",baseURL);
                
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
                
                [delegate hideLoading];
            }
            
            
        }
        
    }
    
    

    
    [self fetchPageEndSession : fetchSeRecord: competitioncode : matchcode];
    [self.tbl_session reloadData];
    self.tbl_session.hidden = NO;
    self.view_allControls.hidden = YES;
    self.view_heading.hidden = NO;
    self.view_addBtn.hidden = NO;
        
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"End Session" message:@"End Session Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }

    else{
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"End Session" message:@"The Session is already exists in the date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];

    }
    }
    }
}

- (IBAction)btn_delete:(id)sender {
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert"
                                                   message: @"Do you want to Revert?"
                                                  delegate: self
                                         cancelButtonTitle:@"Yes"
                                         otherButtonTitles:@"No",nil];
    
    alert.tag = 100;
    [alert show];
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            dbEndSession = [[DBManagerEndSession alloc]init];
            
            NSString *dayNO =  [dbEndSession getDayNo : competitioncode: matchcode];
            
            if ([dayNO isEqualToString:@"0"]) {
                
                dayNO = @"1";
            }
            
            NSString *sessionNo =[dbEndSession  GetSessionNoForFetchEndSession :competitioncode: matchcode : dayNO];
            
            [sessionRecords DeleteEndSession:competitioncode :matchcode :fetchSeRecord.INNINGSNO : dayNO : sessionNo];
            
            
            if(self.checkInternetConnection){
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                
                //Show indicator
                [delegate showLoading];
                //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                
                //dispatch_get_main_queue(), ^
                {
                    
                    NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDSESSION/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],competitioncode,matchcode,@"NULL",fetchSeRecord.INNINGSNO,sessionRecords.DAYNO,[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO],@"NULL",@"NULL",@"NULL",@"NULL",@"NULL",@"NULL",@"NULL"@"DELETE"];
                    
                    
                    NSLog(@"%@",baseURL);
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
                    
                    [delegate hideLoading];
                }
                
                
            }
            
            
            [self fetchPageEndSession : fetchSeRecord: competitioncode : matchcode];
            [self.tbl_session reloadData];
            
            // [endSessionArray removeLastObject];
            
            self.tbl_session.hidden = NO;
            self.view_heading.hidden = NO;
            self.view_allControls.hidden = YES;
            self.btn_delete.hidden = YES;
            self.btn_save.hidden = YES;
            self.view_addBtn.hidden = NO;
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"End Session" message:@"End Session Deleted Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            
           
        }
        }
    
    else
    {
        
    }
}





- (IBAction)btn_dropDown:(id)sender {
    
    [self.view layoutIfNeeded];
    if(IsDropDown ==NO)
    {
    IsDropDown = YES;
    
    objDrobDowntbl=[[UITableView alloc]initWithFrame:CGRectMake(self.view_sessionDominant.frame.origin.x, self.view_sessionDominant.frame.origin.y+self.view_sessionDominant.frame.size.height+5, 280, 300)];
    objDrobDowntbl.dataSource=self;
    objDrobDowntbl.delegate=self;
        objDrobDowntbl.hidden=NO;
    
    [self.scroll_EndSession addSubview:objDrobDowntbl];
    self.scroll_EndSession.scrollEnabled = NO;
    
    NSMutableArray *teamArray = [dbEndSession GetBattingTeamForFetchEndSession:fetchSeRecord.BATTINGTEAMCODE:fetchSeRecord.BOWLINGTEAMCODE];
    
    endSessionArray = teamArray;
    
    
    [objDrobDowntbl reloadData];
    }
    else{
        IsDropDown = NO;
         objDrobDowntbl.hidden=YES;
    }

    
}

- (IBAction)btn_back:(id)sender {
    
    if (back == NO) {
        
        self.view_allControls.hidden = YES;
        self.tbl_session.hidden = NO;
        self.view_heading.hidden = NO;
        self.view_datePicker.hidden = YES;
        _btn_save.hidden = YES;
        _btn_delete.hidden = YES;
        self.view_addBtn.hidden = NO;
         objDrobDowntbl.hidden=YES;
        back = YES;
        
    }else if (back == YES){
        
        
        //        DashBoardVC * dashVC = [[DashBoardVC alloc]init];
        //
        //        dashVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        
        
        [self.delegate ChangeVCBackBtnAction];
       

        back = NO;
    }
    

}
- (IBAction)show_SelectedDate:(id)sender {
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MatchDateWithTime];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // for minimum date
    [datePicker setMinimumDate:matchdate];
    
    // for maximumDate
    int daysToAdd = 1;
    NSDate *newDate1 = [matchdate dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    [datePicker setMaximumDate:newDate1];
    
    
    NSString *minimumdateStr = [dateFormat stringFromDate:matchdate];
    NSString*maxmimumdateStr=[dateFormat stringFromDate:newDate1];
    if(isEndDate==YES)
    {
        _txt_endTime.text=[dateFormat stringFromDate:datePicker.date];
    }
    else
    {
        _txt_startTime.text=[dateFormat stringFromDate:datePicker.date];
    }
    NSLog(@"check: %@",_txt_startTime.text);
    
    //BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_txt_startInnings text]];
    
    [self duration];
    [self.view_datePicker setHidden:YES];

    
    
}
@end
