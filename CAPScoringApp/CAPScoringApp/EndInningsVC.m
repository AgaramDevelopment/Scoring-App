//
//  EndInningsVC.m
//  CAPScoringApp
//
//  Created by mac on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndInningsVC.h"
#import "EndInnings.h"
#import "EndInningsTVC.h"
#import "DBManagerEndInnings.h"
#import "DashBoardVC.h"
#import "FixturesVC.h"
#import "CustomNavigationVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "FetchSEPageLoadRecord.h"
#import "DBManagerEndInnings.h"
#import "MatchResultListVC.h"
#import "Utitliy.h"
#import "ArchivesVC.h"
@interface EndInningsVC ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDateFormatter *formatter;
    NSObject *fetchEndinnings;
    NSString *CompetitionCode;
    NSString *MatchCode;
    NSString *TOTALRUNS;
    NSString *OVERNO;
    NSString *WICKETS;
    NSString * BtnurrentTittle;
    NSString *OldTeamCode;
    NSString *OldInningsNo;
    NSString *ballNo;
    NSString *MatchDate;
    BOOL isEndDate;
    
}
@end
EndInnings *end;
NSMutableArray *endInningsArray;

@implementation EndInningsVC
@synthesize MATCHCODE;
@synthesize MATCHTYPECODE;
EndInnings *innings;
FetchSEPageLoadRecord *fetchSePageLoad;

BOOL IsBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view_datepicker.hidden=YES;
}
-(void)fetchPageload:(NSObject*)fetchRecord:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE{
    
    DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    if (fetchRecord !=0 ) {
        
       MatchDate = [dbEndInnings GetMatchDateForFetchEndInnings : COMPETITIONCODE: MATCHCODE];
        
        fetchSePageLoad = [[FetchSEPageLoadRecord alloc]init];
        
        CompetitionCode = COMPETITIONCODE;
        MatchCode = MATCHCODE;
       
        
        //fetchSePageLoad = fetchRecord;
        fetchEndinnings = fetchRecord;
        
        NSString *SAVE = self.btn_save;
        
        IsBack = NO;
        
        [self.btn_save addTarget:self action:@selector(btn_save:) forControlEvents:UIControlEventTouchUpInside];
        
         [self.btn_delete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
        
     
        
        
        //fetchSePageLoad = [[FetchSEPageLoadRecord alloc]init];
        
        fetchSePageLoad = fetchEndinnings;
        
        innings = [[EndInnings alloc]init];
        
        
        endInningsArray = [[NSMutableArray alloc]init];
        endInningsArray = [dbEndInnings FetchEndInningsDetailsForFetchEndInnings: MATCHCODE];
        
        
        self.view_allControls.hidden = YES;
        
        [innings fetchEndInnings:CompetitionCode :MatchCode :fetchSePageLoad.BATTINGTEAMCODE :fetchSePageLoad.INNINGSNO];
        
        self.lbl_teamName.text = innings.TEAMNAME;
        self.lbl_runScored.text = [NSString stringWithFormat:@"%@", innings.TOTALRUNS];
        
        self.lbl_overPlayed.text = innings.OVERBALLNO;
        
        self.lbl_wktLost.text = innings.WICKETS;
        self.lbl_innings.text = fetchSePageLoad.INNINGSNO;
        
       
        
       
        
        [self.view layoutIfNeeded];
        self.scroll_endInnings.contentSize = CGSizeMake(self.view.frame.size.width, 650);
        
        [self.view_startInnings.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
        self.view_startInnings.layer.borderWidth = 2;
        
        
        [self.view_endInnings.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
        self.view_endInnings.layer.borderWidth = 2;
        
        
        [self.view_duration.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
        self.view_duration.layer.borderWidth = 2;
        
        
        
        
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
        
        //[self datePicker];
       // [self endDatePicker];
        
        
        


        self.btn_delete.backgroundColor=[UIColor colorWithRed:(119/255.0f) green:(57/255.0f) blue:(58/255.0f) alpha:1.0f];
        [_btn_delete setUserInteractionEnabled:NO];
       
        
        if ([fetchSePageLoad.MATCHTYPE isEqualToString:@"MSC022"] || [fetchSePageLoad.MATCHTYPE isEqualToString:@"MSC024"] ||
            [fetchSePageLoad.MATCHTYPE isEqualToString:@"MSC116"] || [fetchSePageLoad.MATCHTYPE isEqualToString:@"MSC115"]) {
            
             self.lbl_thirdnFourthInnings.hidden = YES;
        }else{
            
            
             self.lbl_thirdnFourthInnings.hidden = NO;
        }
        
    }
}

-(void)datePicker{
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    self.view_datepicker.hidden=NO;
    
   //datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
   
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
        [comps setDay:5];
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
    
     datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(self.txt_startInnings.frame.origin.x,self.txt_startInnings.frame.origin.y+30,self.view.frame.size.width,100)];
    //[datePicker setMaximumDate:maxDate];
    //[datePicker setMinimumDate:minDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [datePicker setLocale:locale];

    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:maxDate];
    [datePicker setDate:minDate animated:YES];
    [datePicker reloadInputViews];
    [self.view_datepicker addSubview:datePicker];
    

    
}

-(IBAction)showSelecteddate:(id)sender{

    
    
    
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
        _txt_endInnings.text=[dateFormat stringFromDate:datePicker.date];
    }
    else
    {
        _txt_startInnings.text=[dateFormat stringFromDate:datePicker.date];
    }
    NSLog(@"check: %@",_txt_startInnings.text);
    
    //BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_txt_startInnings text]];
    
    [self duration];
    [self.view_datepicker setHidden:YES];
    
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
    self.txt_endInnings.text=recordDate;
    [self.txt_endInnings resignFirstResponder];
    [self duration];
    
}

-(void)duration{
    
    
    NSString *startDateTF = self.txt_startInnings.text;
    NSString *startEndTF = self.txt_endInnings.text;
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
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

- (IBAction)btn_addInnings:(id)sender {
    
    BtnurrentTittle =[NSString stringWithFormat:self.btn_save.currentTitle];
    BtnurrentTittle = @"INSERT";
    
    IsBack = NO;
    
    self.view_allControls.hidden = NO;
    self.tbl_endInnings.hidden = YES;
    self.view_Header.hidden = YES;
    self.Btn_Add.hidden=YES;
    
    
    [self.btn_save setTitle: @"SAVE" forState: UIControlStateNormal];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    return [endInningsArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    EndInnings *endInnings = [[EndInnings alloc]init];
    static NSString *CellIdentifier = @"row";
    
    
    EndInningsTVC *cell = (EndInningsTVC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EndInningsTVC" owner:self options:nil];
        cell = self.GridRowCell;
        self.GridRowCell = nil;
    }
    
    EndInnings *end=(EndInnings*)[endInningsArray objectAtIndex:indexPath.row];
    
    cell.lbl_startTime.text = end.STARTTIME;
    cell.lbl_endTime.text = end.ENDTIME;
    cell.lbl_duration.text = end.TEAMNAME;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.Btn_Add.hidden=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EndInnings *obj =(EndInnings*)[endInningsArray objectAtIndex:indexPath.row];
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateTF = obj.STARTTIME;
    NSString *startEndTF = obj.ENDTIME;
    
    NSDate *date1 = [formatter dateFromString:startDateTF];
    NSDate *date2 = [formatter dateFromString:startEndTF];
    
    NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    int days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
   BtnurrentTittle = [NSString stringWithFormat:self.btn_save.currentTitle];
    BtnurrentTittle = @"UPDATE";
    
    [self.btn_save setTitle: @"UPDATE" forState: UIControlStateNormal];
    
    [obj fetchEndInnings :CompetitionCode: MatchCode :obj.BATTINGTEAMCODE :obj.INNINGSNO];
    
    
    
  
    
    NSString*startInningsTime = obj.STARTTIME;
    NSString*endInningsTime  = obj.ENDTIME;
    NSString*teamName = obj.TEAMNAME;
    NSString*totalOvers = obj.OVERBALLNO;
    NSString *totalWickets = obj.WICKETS;
    NSString *innings = obj.INNINGSNO;
    
    OldTeamCode = obj.BATTINGTEAMCODE;
    OldInningsNo = obj.INNINGSNO;
    
    self.txt_startInnings.text = startInningsTime;
    self.txt_endInnings.text = endInningsTime;
    self.lbl_duration.text=[NSString stringWithFormat:@"%@", Duration];
    self.lbl_teamName.text = teamName;
    self.lbl_runScored.text = [NSString stringWithFormat:@"%@",obj.TOTALRUNS];
    self.lbl_overPlayed.text = obj.OVERBALLNO;

    self.lbl_wktLost.text = totalWickets;
    self.lbl_innings.text = innings;
    self.tbl_endInnings.hidden = YES;
    self.view_Header.hidden = YES;
    self.view_allControls.hidden = NO;
    
self.btn_delete.backgroundColor=[UIColor colorWithRed:(255/255.0f) green:(86/255.0f) blue:(88/255.0f) alpha:1.0f];
    [_btn_delete setUserInteractionEnabled:YES];
     [self.tbl_endInnings reloadData];

}
/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}


- (IBAction)btn_save:(id)sender {
    
    
        
      
        if ([BtnurrentTittle isEqualToString:@"INSERT"]) {

             [innings InsertEndInnings : CompetitionCode :MatchCode :fetchSePageLoad.BOWLINGTEAMCODE :fetchSePageLoad.BATTINGTEAMCODE :fetchSePageLoad.INNINGSNO  :_txt_startInnings.text :_txt_endInnings.text :OVERNO :TOTALRUNS :WICKETS: BtnurrentTittle];
            
            [self.delegate EndInningsSaveBtnAction];
            
        }else{
            
            [innings InsertEndInnings : CompetitionCode :MatchCode :fetchSePageLoad.BOWLINGTEAMCODE :OldTeamCode :OldInningsNo  :_txt_startInnings.text :_txt_endInnings.text :OVERNO :TOTALRUNS :WICKETS: BtnurrentTittle];
            
            
        }
        
        
     

    if(self.checkInternetConnection){
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
        
        //dispatch_get_main_queue(), ^
        {
            
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDINNINGS/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],CompetitionCode,MatchCode,fetchSePageLoad.BOWLINGTEAMCODE,fetchSePageLoad.BATTINGTEAMCODE,fetchSePageLoad.INNINGSNO ,_txt_startInnings.text,_txt_endInnings.text,OVERNO,TOTALRUNS,WICKETS,BtnurrentTittle];
            
            
            NSLog(@"%@",baseURL);
            
            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if(responseData != nil)
            {
                NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                
                if(rootArray !=nil && rootArray.count>0){
                    NSDictionary *valueDict = [rootArray objectAtIndex:0];
                    NSString *success = [valueDict valueForKey:@"DataItem"];
                    if([success isEqual:@"Success"]){
                        
                    }
                }else{
                    
                }
            }
            [delegate hideLoading];
        }
    }
        [self.tbl_endInnings reloadData];
        [self fetchPageload:fetchEndinnings :CompetitionCode :MatchCode];
        
        
        self.tbl_endInnings.hidden = NO;
        self.view_Header.hidden = NO;
        self.view_allControls.hidden = YES;
        
    


}
    
- (IBAction)btn_back:(id)sender {
    
   
    if (IsBack == NO) {
        
         [self.tbl_endInnings reloadData];
        self.view_allControls.hidden = YES;
        self.tbl_endInnings.hidden = NO;
         self.view_Header.hidden = NO;
        self.Btn_Add.hidden=NO;
        IsBack = YES;
    
    }else if (IsBack == YES){
        
        
        self.view_allControls.hidden = YES;
        
        [self.delegate EndInningsBackBtnAction];

        
        IsBack = NO;
    }
    
    
}

//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)btn_delete:(id)sender {
    innings = [[EndInnings alloc]init];
    
    
    BOOL isSuccess = [innings DeleteEndInnings:CompetitionCode :MatchCode :OldTeamCode :OldInningsNo];
    if(isSuccess){
    [self.delegate EndInningsDeleteBtnAction];

    
    
    if(self.checkInternetConnection){
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        //      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
        
        //dispatch_get_main_queue(), ^
        {
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDINNINGS/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],CompetitionCode,MatchCode,@"NULL",fetchSePageLoad.BATTINGTEAMCODE,fetchSePageLoad.INNINGSNO,@"NULL",@"NULL",@"NULL",@"NULL",@"NULL",@"DELETE"];
            
            NSLog(@"%@",baseURL);
            
            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if(responseData != nil)
            {
                NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                
                if(rootArray !=nil && rootArray.count>0){
                    NSDictionary *valueDict = [rootArray objectAtIndex:0];
                    NSString *success = [valueDict valueForKey:@"DataItem"];
                    if([success isEqual:@"Success"]){
                        
                    }
                }else{
                    
                }
            }
            
            [delegate hideLoading];
        }
        
    }
    [endInningsArray removeLastObject];
    
    [self fetchPageload:fetchEndinnings :CompetitionCode :MatchCode];
    [self.tbl_endInnings reloadData];
    
    self.tbl_endInnings.hidden = NO;
     self.view_Header.hidden = NO;
    self.view_allControls.hidden = YES;
    
}
}




@end
