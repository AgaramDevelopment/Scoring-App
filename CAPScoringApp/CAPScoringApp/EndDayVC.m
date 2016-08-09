//
//  EndDayVC.m
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndDayVC.h"
#import "FetchEndDayDetails.h"
#import "FetchEndDay.h"
#import "InsertEndDay.h"
#import "UpdateEndDay.h"
#import "DeleteEndDay.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"
#import "DBManagerEndInnings.h"

@interface EndDayVC ()<UITextFieldDelegate>{
    
    BOOL IsBack;
    BOOL IsEditMode;
    BOOL isEndDate;
    NSDateFormatter *formatter;
    NSString *MatchDate1;
    NSString *MatchDate;
    BOOL startTimeEqual;
    
    FetchEndDayDetails *fetchEndDayDetails;

}
@end



@implementation EndDayVC
@synthesize MATCHTYPECODE;

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view_datePicker.hidden=YES;
    
     IsBack = NO;
    IsEditMode = NO;
    
    self.view_allControls.hidden = YES;
    self.tbl_endday.hidden = NO;
   self.gridHeaderView.hidden=NO;
    
    fetchEndDayDetails = [[FetchEndDayDetails alloc]init];
    [fetchEndDayDetails FetchEndDay:_COMPETITIONCODE :_MATCHCODE :_TEAMCODE :_INNINGSNO];
    
        DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
   
        MatchDate1 = [dbEndInnings GetMatchDateForFetchEndInnings : _COMPETITIONCODE: _MATCHCODE];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:MatchDate1];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *MATCHDATE1 = [formatter stringFromDate:date];
    
    NSString *timeString=@"00:00:00";
    
    MatchDate=[NSString stringWithFormat:@"%@ %@",MATCHDATE1,timeString];
    
    
    [self.view layoutIfNeeded];
    self.scroll_endDay.contentSize = CGSizeMake(self.view.frame.size.width, 780);
    self.scroll_endDay.scrollEnabled = YES;
    
    [self.view_startTime.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_startTime.layer.borderWidth = 2;
    
    
    [self.view_endTime.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_endTime.layer.borderWidth = 2;
    
    
    [self.view_duration.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_duration.layer.borderWidth = 2;
    
    
    [self.view_day_no.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_day_no.layer.borderWidth = 2;
    

  [self.lbl_day_no.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.lbl_day_no.layer.borderWidth = 2;
    
    [self.view_teamName.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_teamName.layer.borderWidth = 2;
    
    [self.view_runScored.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_runScored.layer.borderWidth = 2;
    
    
    [self.view_OverPlayed.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_OverPlayed.layer.borderWidth = 2;
    
    [self.view_wkts.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_wkts.layer.borderWidth = 2;
    
    [self.view_innings.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_innings.layer.borderWidth = 2;
    
   
    [self duration];
    
    _tbl_endday.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * currentDate = [dateFormat dateFromString:MatchDate];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    if([self.MATCHTYPECODE isEqual:@"MSC114"] || [self.MATCHTYPECODE isEqual:@"MSC023"])
    {
        [comps setDay:5];
        [comps setMonth:0];
        [comps setYear:0];
    }
    else
    {
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


-(void)showSelecteddate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_startTime.text=[NSString stringWithFormat:@"%@",
                             [formatter stringFromDate:datePicker.date]];
    [self.txt_startTime resignFirstResponder];
    [self duration];

}

-(void)endDatePicker{
    
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    [self datePicker];

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
    
    
    return [fetchEndDayDetails.FetchEndDayArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    //FetchEndDay *endInnings = [[FetchEndDay alloc]init];
    static NSString *CellIdentifier = @"end_day_table_cell";
    
    
    EndDayTVC *cell = (EndDayTVC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EndDayTVC" owner:self options:nil];
        cell = self.endDayCell;
        self.endDayCell = nil;
    }
    
    FetchEndDay *fetchEndInn=(FetchEndDay*)[fetchEndDayDetails.FetchEndDayArray  objectAtIndex:indexPath.row];
    
    cell.lbl_day.text = fetchEndInn.DAYNO;
    cell.lbl_runs.text = fetchEndInn.TOTALRUNS;
    cell.lbl_overs.text = fetchEndInn.TOTALOVERS;
    cell.lbl_innings.text = fetchEndInn.INNINGSNO;
    cell.lbl_wickets.text = fetchEndInn.TOTALWICKETS;
    cell.lbl_team_name.text = fetchEndInn.TEAMNAME;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     self.view_addbtn.hidden = YES;
    self.scroll_endDay.scrollEnabled = YES;
    
   FetchEndDay *fetchEndInn=(FetchEndDay*)[fetchEndDayDetails.FetchEndDayArray  objectAtIndex:indexPath.row];
    
    
    self.txt_startTime.text = fetchEndInn.STARTTIME == @"0" ? @"" : fetchEndInn.STARTTIME;
    self.txt_endTime.text = fetchEndInn.ENDTIME == @"0" ? @"" : fetchEndInn.ENDTIME ;
    self.lbl_teamName.text = fetchEndInn.TEAMNAME;
    self.lbl_innings.text = fetchEndInn.INNINGSNO;
    self.lbl_duration.text = fetchEndInn.DURATION;
    self.lbl_day_no.text = fetchEndInn.DAYNO;
    self.lbl_runScored.text = fetchEndInn.TOTALRUNS;
    self.lbl_overPlayed.text = fetchEndInn.TOTALOVERS;
    self.txt_comments.text = fetchEndInn.COMMENTS;
    self.lbl_wktLost.text = fetchEndInn.TOTALWICKETS;

    
    
    
    IsEditMode =YES;

    
    self.tbl_endday.hidden = YES;
    self.view_allControls.hidden = NO;
    self.gridHeaderView.hidden=YES;
    
    [_btn_save setTitle:@"UPDATE" forState:UIControlStateNormal];
    
    
}

- (IBAction)show_SelectedDate:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MatchDate];
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

- (IBAction)btn_addendday:(id)sender {
    
    self.txt_startTime.text = @"";
    self.txt_endTime.text = @"";
    self.lbl_teamName.text = fetchEndDayDetails.TEAMNAME;
    self.lbl_innings.text = [NSString stringWithFormat:@"%@", self.INNINGSNO];
    self.lbl_duration.text =  @"";
    self.lbl_day_no.text = [NSString stringWithFormat:@"%@", fetchEndDayDetails.DAYNO];
    self.lbl_runScored.text = fetchEndDayDetails.RUNS;
    self.lbl_overPlayed.text = fetchEndDayDetails.OVERBALLNO;
    self.txt_comments.text = @"";
    self.lbl_wktLost.text = fetchEndDayDetails.WICKETS;
    
    
    self.view_allControls.hidden = NO;
    self.tbl_endday.hidden = YES;
    self.gridHeaderView.hidden=YES;
    self.view_datePicker.hidden=YES;
    IsBack = NO;
    IsEditMode =NO;
    self.view_addbtn.hidden = YES;
    
    [_btn_save setTitle:@"SAVE" forState:UIControlStateNormal];

}

-(BOOL) checkValidation{
    
    
    if ([self.txt_endTime.text isEqualToString:@""] && ![self.txt_startTime.text isEqualToString:@""]) {
        
        [self showDialog:@"Please Choose Day End Time" andTitle:@"End Day"];
        return NO;
    }
 
    if(![self.lbl_duration.text isEqualToString:@""] && [self.lbl_duration.text integerValue]<=0){
        [self showDialog:@"Duration should be greated than zero" andTitle:@"End Day"];
        
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
    startTimeEqual=(fetchEndDayDetails.FetchEndDayArray.count!=0)? YES:NO;
    for(int i=0; i<fetchEndDayDetails.FetchEndDayArray.count; i++)
    {
        FetchEndDay *fetchEndInn=(FetchEndDay*)[fetchEndDayDetails.FetchEndDayArray  objectAtIndex:i];
        if([self.txt_startTime.text isEqualToString:fetchEndInn.STARTTIME] && [self.txt_endTime.text isEqualToString:fetchEndInn.ENDTIME])
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
  if([self checkValidation]){
        if(IsEditMode){
            NSString *endDayTime = _txt_endTime.text;

            NSString *startTimeData;
            NSString *endTimeData;
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *startdate = [formatter dateFromString:_txt_startTime.text];
            NSDate *enddate = [formatter dateFromString:_txt_endTime.text];
            
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            startTimeData = [formatter stringFromDate:startdate];
            endTimeData = [formatter stringFromDate:enddate];
            
            self.txt_endTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
            [self.txt_endTime resignFirstResponder];
            
            
            UpdateEndDay *updateEndDay = [[UpdateEndDay alloc]init];
            [updateEndDay UpdateEndDay:self.COMPETITIONCODE :self.MATCHCODE :[NSString  stringWithFormat:@"%@",self.INNINGSNO] :_txt_startTime.text :endDayTime : _lbl_day_no.text : self.TEAMCODE :_txt_comments.text :startTimeData :endTimeData];
           
            [self duration];
            [self startService:@"UPDATE"];
           
        }else{
            NSString *endDayTime = _txt_endTime.text;

            NSString *startTimeData;
            NSString *endTimeData;


            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
            NSDate *startdate = [formatter dateFromString:_txt_startTime.text];
            NSDate *enddate = [formatter dateFromString:_txt_endTime.text];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

            startTimeData = [formatter stringFromDate:startdate];
            endTimeData = [formatter stringFromDate:enddate];

            self.txt_endTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
            [self.txt_endTime resignFirstResponder];
            
            
            
           InsertEndDay *insertEndDay = [[InsertEndDay alloc]init];
            [self ValidationStartAndEndTime];
            if(startTimeEqual==NO)
            {
            
            [insertEndDay InsertEndDay:self.COMPETITIONCODE :self.MATCHCODE :[NSString  stringWithFormat:@"%@",self.INNINGSNO] :_txt_startTime.text :endDayTime : _lbl_day_no.text : self.TEAMCODE :_lbl_runScored.text :_lbl_overPlayed.text :_lbl_wktLost.text :_txt_comments.text :startTimeData :endTimeData];
            
            }
            else{
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"End Day" message:@"The Day is already exists in the date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alter show];
            }
            [self startService:@"INSERT"];
            
        }
        
        self.view_allControls.hidden = YES;
        self.tbl_endday.hidden = NO;
           self.gridHeaderView.hidden=NO;
        fetchEndDayDetails = [[FetchEndDayDetails alloc]init];
        [fetchEndDayDetails FetchEndDay:_COMPETITIONCODE :_MATCHCODE :_TEAMCODE :_INNINGSNO];
      self.view_addbtn.hidden = NO;
        [self.tbl_endday reloadData];
        
    }
  
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            DeleteEndDay *deleteEndDay = [[DeleteEndDay alloc]init];
            [deleteEndDay DeleteEndDay:self.COMPETITIONCODE :self.MATCHCODE :[NSString  stringWithFormat:@"%@",self.INNINGSNO] :_lbl_day_no.text];
            
    
            [self startService:@"DELETE"];
            
            fetchEndDayDetails = [[FetchEndDayDetails alloc]init];
            [fetchEndDayDetails FetchEndDay:_COMPETITIONCODE :_MATCHCODE :_TEAMCODE :_INNINGSNO];

            [self.tbl_endday reloadData];
            
            self.view_allControls.hidden = YES;
            self.tbl_endday.hidden = NO;
               self.gridHeaderView.hidden=NO;
        }
        else
        {
        }
    }
}
- (IBAction)btn_back:(id)sender {
    
    
    if (IsBack == NO) {
        
        self.view_allControls.hidden = YES;
        self.tbl_endday.hidden = NO;
           self.gridHeaderView.hidden=NO;
         self.view_addbtn.hidden = NO;
        IsBack = YES;
        
    }else if (IsBack == YES){
        
        [self.delegate ChangeVCBackBtnAction];
        IsBack = NO;
        
//        
//        DashBoardVC * dashVC = [[DashBoardVC alloc]init];
//        
//        dashVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
//        
//        IsBack = NO;
    }
    
    
    
}

- (IBAction)btn_delete:(id)sender {
    
    if(IsEditMode){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"End Day"
                                                       message: @"Do you want to Revert?"
                                                      delegate: self
                                             cancelButtonTitle:@"Yes"
                                             otherButtonTitles:@"No",nil];
        
        alert.tag = 100;
        [alert show];
        
    }
//    
//    innings = [[EndInnings alloc]init];
//    
//    [innings DeleteEndInnings:@"UCC0000004" :@"IMSC02200224DB2663B00003" :@"TEA0000024":@"1"];
    
    
}



//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) startService:(NSString *)OPERATIONTYPE{
    if(self.checkInternetConnection){

        
        NSString *startTimeData;
        NSString *endTimeData;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *startdate = [formatter dateFromString:_txt_startTime.text];
        NSDate *enddate = [formatter dateFromString:_txt_endTime.text];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        startTimeData = [formatter stringFromDate:startdate];
        endTimeData = [formatter stringFromDate:enddate];
        
        NSString *COMMENTS = [_txt_comments.text isEqual: @""] ?@"NULL":_txt_comments.text;
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            NSString *baseURL =[NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDDAY/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],_COMPETITIONCODE ,_MATCHCODE ,_INNINGSNO,_txt_startTime.text,_txt_endTime.text,_lbl_day_no.text,_TEAMCODE,_lbl_runScored.text,_lbl_overPlayed.text,_lbl_wktLost.text,COMMENTS,startTimeData,endTimeData,OPERATIONTYPE];
            NSLog(@"-%@",baseURL);
            
//            SETENDDAY/{COMPETITIONCODE}/{MATCHCODE}/{INNINGSNO}/{STARTTIME}/{ENDTIME}/{DAYNO}/{BATTINGTEAMCODE}/{TOTALRUNS}/{TOTALOVERS}/{TOTALWICKETS}/{COMMENTS}/{STARTTIMEFORMAT}/{ENDTIMEFORMAT}/{OPERATIONTYPE}
//            
            
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
        });
        
        //[delegate hideLoading];
    }
         self.view_addbtn.hidden = NO;
}





@end
