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


@interface EndDayVC (){
    BOOL IsBack;
    BOOL IsEditMode;
NSDateFormatter *formatter;
    FetchEndDayDetails *fetchEndDayDetails;

}
@end



@implementation EndDayVC

- (void)viewDidLoad {
    [super viewDidLoad];
     IsBack = NO;
    IsEditMode = NO;
    
    self.view_allControls.hidden = YES;
    self.tbl_endday.hidden = NO;

    fetchEndDayDetails = [[FetchEndDayDetails alloc]init];
    [fetchEndDayDetails FetchEndDay:_COMPETITIONCODE :_MATCHCODE :_TEAMCODE :_INNINGSNO];
    
    
    [self.view layoutIfNeeded];
    self.scroll_endDay.contentSize = CGSizeMake(self.view.frame.size.width, 780);
    
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
    
    [self datePicker];
    [self endDatePicker];
    [self duration];
}


-(void)datePicker{
    
    datePicker =[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.txt_startTime setInputView:datePicker];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(showSelecteddate)];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneBtn,space, nil]];
    
    [self.txt_startTime setInputAccessoryView:toolbar];
    
    
}
-(void)showSelecteddate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_startTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txt_startTime resignFirstResponder];
    [self duration];

}

-(void)endDatePicker{
    
    datePicker =[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.txt_endTime setInputView:datePicker];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(showEndDatePicker)];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneBtn,space, nil]];
    
    [self.txt_endTime setInputAccessoryView:toolbar];
}
-(void)showEndDatePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_endTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
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
    double days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%f", days];
    
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
    
    
    
   FetchEndDay *fetchEndInn=(FetchEndDay*)[fetchEndDayDetails.FetchEndDayArray  objectAtIndex:indexPath.row];
    
    
    self.txt_startTime.text = fetchEndInn.STARTTIME;
    self.txt_endTime.text = fetchEndInn.ENDTIME;
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
    
    
    [_btn_save setTitle:@"UPDATE" forState:UIControlStateNormal];
    
    
}

- (IBAction)btn_addendday:(id)sender {
    
    self.txt_startTime.text = @"";
    self.txt_endTime.text = @"";
    self.lbl_teamName.text = fetchEndDayDetails.TEAMNAME;
    self.lbl_innings.text = [NSString stringWithFormat:@"%@", self.INNINGSNO];
    self.lbl_duration.text =  @"1";
    self.lbl_day_no.text = [NSString stringWithFormat:@"%@", fetchEndDayDetails.DAYNO];
    self.lbl_runScored.text = fetchEndDayDetails.RUNS;
    self.lbl_overPlayed.text = fetchEndDayDetails.OVERBALLNO;
    self.txt_comments.text = @"";
    self.lbl_wktLost.text = fetchEndDayDetails.WICKETS;
    
    
    self.view_allControls.hidden = NO;
    self.tbl_endday.hidden = YES;
    
    IsBack = NO;
    IsEditMode =NO;
    
    [_btn_save setTitle:@"SAVE" forState:UIControlStateNormal];

}

-(BOOL) checkValidation{
 
    return YES;
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
             
           
        }else{
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
            
            
            
           InsertEndDay *insertEndDay = [[InsertEndDay alloc]init];
            
            [insertEndDay InsertEndDay:self.COMPETITIONCODE :self.MATCHCODE :[NSString  stringWithFormat:@"%@",self.INNINGSNO] :_txt_startTime.text :endDayTime : _lbl_day_no.text : self.TEAMCODE :_lbl_runScored.text :_lbl_overPlayed.text :_lbl_wktLost.text :_txt_comments.text :startTimeData :endTimeData];
            
        }
    }
  
    
//    //self.view_allControls.hidden = YES;
//    // EndInnings *endInnings = [[EndInnings alloc]init];
//    NSString * BtnurrentTittle=[NSString stringWithFormat:self.btn_save.currentTitle];
//    
//    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
//        
//        
//        NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.49:8079/CAPMobilityService.svc/SETENDINNINGS/UCC0000004/IMSC02200224DB2663B00003/TEA0000024/TEA0000024/1/2015-10-15 12:04:00/2015-10-16 12:05:00/49/249/8/INSERT"];
//        
//        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSURLResponse *response;
//        NSError *error;
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        
//        
//        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//        
//        
//    }else{
//        
//        [innings InsertEndInnings:@"UCC0000004" :@"IMSC02200224DB2663B00003" :@"TEA0000024" :@"TEA0000024" :@"1" :@"2015-10-15 12:04:00" :@"2015-10-16 12:05:00" :@"49" :@"249" :@"8" :BtnurrentTittle:@"45"];
//        
//    }
//    FixturesVC *fixturevc = [[FixturesVC alloc]init];
//    
//    fixturevc =  (FixturesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"fixtureSBID"];
//    
//    //    fixturevc.Matchcode = matchCode;
//    //    fixturevc.competitionCode = competitionCode;
//    
//    [self.navigationController pushViewController:fixturevc animated:YES];
    
}
- (IBAction)btn_back:(id)sender {
    
    
    if (IsBack == NO) {
        
        self.view_allControls.hidden = YES;
        self.tbl_endday.hidden = NO;
        
        IsBack = YES;
        
    }else if (IsBack == YES){
        
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
        DeleteEndDay *deleteEndDay = [[DeleteEndDay alloc]init];
        [deleteEndDay DeleteEndDay:self.COMPETITIONCODE :self.MATCHCODE :[NSString  stringWithFormat:@"%@",self.INNINGSNO] :_lbl_day_no.text];
        
    }
//    
//    innings = [[EndInnings alloc]init];
//    
//    [innings DeleteEndInnings:@"UCC0000004" :@"IMSC02200224DB2663B00003" :@"TEA0000024":@"1"];
    
    
}


@end
