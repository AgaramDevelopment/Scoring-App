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
@interface EndInningsVC ()
{
    NSDateFormatter *formatter;
    NSObject *fetchEndinnings;
    NSString *CompetitionCode;
    NSString *MatchCode;
    NSString *TOTALRUNS;
    NSString *OVERNO;
    NSString *WICKETS;
    
}
@end
EndInnings *end;
NSMutableArray *endInningsArray;

@implementation EndInningsVC
@synthesize MATCHCODE;
EndInnings *innings;
FetchSEPageLoadRecord *fetchSePageLoad;

BOOL IsBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)fetchPageload:(NSObject*)fetchRecord:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE{
    if (fetchRecord !=0 ) {
        fetchSePageLoad = [[FetchSEPageLoadRecord alloc]init];
        
        CompetitionCode = COMPETITIONCODE;
        MatchCode = MATCHCODE;
        
        //fetchSePageLoad = fetchRecord;
        fetchEndinnings = fetchRecord;
        
        NSString *SAVE = self.btn_save;
        
        IsBack = NO;
        
        [self.btn_save addTarget:self action:@selector(btn_save:) forControlEvents:UIControlEventTouchUpInside];
        
        self.lbl_thirdnFourthInnings.hidden = YES;
        
        //fetchSePageLoad = [[FetchSEPageLoadRecord alloc]init];
        
        fetchSePageLoad = fetchEndinnings;
        
        innings = [[EndInnings alloc]init];
        
        
        endInningsArray = [[NSMutableArray alloc]init];
        endInningsArray = [DBManagerEndInnings FetchEndInningsDetailsForFetchEndInnings: MATCHCODE];
        
        
        //self.view_allControls.hidden = YES;
        
        [innings fetchEndInnings:CompetitionCode :MatchCode :fetchSePageLoad.BATTINGTEAMCODE :fetchSePageLoad.INNINGSNO ];
        
        self.lbl_teamName.text = innings.TEAMNAME;
        self.lbl_runScored.text = [NSString stringWithFormat:@"%@", innings.TOTALRUNS];
        self.lbl_overPlayed.text = innings.OVERNO;
        self.lbl_wktLost.text = innings.WICKETS;
        self.lbl_innings.text = fetchSePageLoad.INNINGSNO;
        
        
        // Do any additional setup after loading the view from its nib.
        //self.view.frame =CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 100);
        
        //self.view.frame =CGRectMake(200,500, [[UIScreen mainScreen] bounds].size.width/2,500);
        
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
        
        [self datePicker];
        [self endDatePicker];
        [self duration];
        
        
        
        
        TOTALRUNS=[DBManagerEndInnings GetTotalRunsForFetchEndInnings : CompetitionCode: MatchCode :fetchSePageLoad.BATTINGTEAMCODE: fetchSePageLoad.INNINGSNO ];
        
        OVERNO=[DBManagerEndInnings GetOverNoForFetchEndInnings : CompetitionCode: MatchCode :fetchSePageLoad.BATTINGTEAMCODE: fetchSePageLoad.INNINGSNO ];
        
        WICKETS=[DBManagerEndInnings GetWicketForFetchEndInnings : CompetitionCode: MatchCode :fetchSePageLoad.BATTINGTEAMCODE: fetchSePageLoad.INNINGSNO];
        
    }
}
-(void)datePicker{
    
    datePicker =[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.txt_startInnings setInputView:datePicker];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(showSelecteddate)];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneBtn,space, nil]];
    
    [self.txt_startInnings setInputAccessoryView:toolbar];
    
    
}
-(void)showSelecteddate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_startInnings.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txt_startInnings resignFirstResponder];
    [self duration];
    
}

-(void)endDatePicker{
    datePicker =[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.txt_endInnings setInputView:datePicker];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(showEndDatePicker)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneBtn,space, nil]];
    
    [self.txt_endInnings setInputAccessoryView:toolbar];
}
-(void)showEndDatePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_endInnings.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txt_endInnings resignFirstResponder];
    [self duration];
    
}

-(void)duration{
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateTF = self.txt_startInnings.text;
    NSString *startEndTF = self.txt_endInnings.text;
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btn_addInnings:(id)sender {
    
    
    self.view_allControls.hidden = NO;
    self.tbl_endInnings.hidden = YES;
    
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
    EndInnings *obj =(EndInnings*)[endInningsArray objectAtIndex:indexPath.row];
    
    NSString*startInningsTime = obj.STARTTIME;
    NSString*endInningsTime  = obj.ENDTIME;
    NSString*teamName = obj.TEAMNAME;
    //NSNumber*totalRuns =  obj.TOTALRUNS;
    NSString*totalOvers = obj.TOTALOVERS;
    NSNumber *totalWickets = obj.TOTALWICKETS;
    
    self.txt_startInnings.text = startInningsTime;
    self.txt_endInnings.text = endInningsTime;
    self.lbl_teamName.text = teamName;
    //self.lbl_runScored.text = [NSString stringWithFormat:@"%@",totalRuns];
    self.lbl_wktLost.text = [NSString stringWithFormat:@"%@", totalWickets];
    self.tbl_endInnings.hidden = YES;
    self.view_allControls.hidden = NO;
    
}
- (IBAction)btn_save:(id)sender {
    
    NSString * BtnurrentTittle=[NSString stringWithFormat:self.btn_save.currentTitle];
    BtnurrentTittle = @"INSERT";
    [innings InsertEndInnings:CompetitionCode :MatchCode :fetchSePageLoad.BOWLINGTEAMCODE :fetchSePageLoad.BATTINGTEAMCODE :fetchSePageLoad.INNINGSNO  :_txt_startInnings.text :_txt_endInnings.text :OVERNO :TOTALRUNS :WICKETS :BtnurrentTittle];
    
    innings = [[EndInnings alloc]init];
    
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
}
- (IBAction)btn_back:(id)sender {
    
    if (IsBack == NO) {
        
        self.view_allControls.hidden = YES;
        self.tbl_endInnings.hidden = NO;
        
        IsBack = YES;
        
    }else if (IsBack == YES){
        
        DashBoardVC * dashVC = [[DashBoardVC alloc]init];
        
        dashVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        
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
    
    [innings DeleteEndInnings:CompetitionCode :MatchCode :fetchSePageLoad.BATTINGTEAMCODE :fetchSePageLoad.INNINGSNO];
    
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
}




@end
