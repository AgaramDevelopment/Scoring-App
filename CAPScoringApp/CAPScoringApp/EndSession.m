//
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
@interface EndSession ()<UITableViewDelegate,UITableViewDataSource>

{
    NSDateFormatter *formatter;
    NSString *competitioncode;
    NSString *matchcode;
    NSObject *fetchEndSession;
    
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
UITableView *popTable;

int POS_TEAM_TYPE = 1;

@implementation EndSession

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
}




-(void)fetchPageEndSession:(NSObject*)fetchRecord:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE
{
    fetchSeRecord = [[FetchSEPageLoadRecord alloc]init];
    
    competitioncode = COMPETITIONCODE;
    matchcode = MATCHCODE;
    fetchEndSession = fetchRecord;
    
    fetchSeRecord = fetchEndSession;
    
    sessionRecords = [[EndSessionRecords alloc]init];
    
    back = NO;
   
    
   battingTeamArray = [[NSMutableArray alloc]init];
battingTeamArray =[DBManagerEndSession GetBattingTeamForFetchEndSession:fetchSeRecord.BATTINGTEAMCODE];
    
    bowlingTeamArray = [[NSMutableArray alloc]init];
    bowlingTeamArray = [DBManagerEndSession GetBattingTeamUsingBowlingCode:fetchSeRecord.BOWLINGTEAMCODE];
    
    metaCodeArray = [[NSMutableArray alloc]init];
    metaCodeArray = [DBManagerEndSession GetMetaSubCode];
    
    
    battingBowlingArray = [[NSMutableArray alloc]init];
    
    [battingBowlingArray addObject:battingTeamArray];
    [battingBowlingArray addObject:bowlingTeamArray];
    [battingBowlingArray addObject:metaCodeArray];
    
    
    endSessionArray = [[NSMutableArray alloc]init];
    
    endSessionArray = [DBManagerEndSession GetSessionEventsForFetchEndSession:competitioncode :matchcode ];
 
    
    
    
    
    
    NSString *INSERT = self.btn_save;
[self.btn_save addTarget:self action:@selector(btn_save:) forControlEvents:UIControlEventTouchUpInside];
    
   // [self.btn_dropDown addTarget:self action:@selector(btn_dropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [sessionRecords FetchEndSession:competitioncode :matchcode :fetchSeRecord.INNINGSNO :fetchSeRecord.BATTINGTEAMCODE :fetchSeRecord.BOWLINGTEAMCODE];
    
    
     _lbl_day.text = sessionRecords.DAYNO;
    _lbl_sessionNo.text = [NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO];
    _lbl_InningsNo.text = [NSString stringWithFormat:@"%@",sessionRecords.INNINGSNOS];
    _lbl_teamBatting.text = sessionRecords.TEAMNAMES;
    _lbl_sessionStartOver.text = [NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO];
    _lbl_sessionEndOver.text = [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO];
    _lbl_runScored.text = [NSString stringWithFormat:@"%@",sessionRecords.RUNSSCORED];
    _lbl_wicketLost.text = [NSString stringWithFormat:@"%@",sessionRecords.WICKETLOST];

    
    

    [self.view layoutIfNeeded];
    self.scroll_EndSession.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    
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
    
    
    static NSString *CellIdentifier = @"row";
    EndSessionTVC *cell = (EndSessionTVC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"EndSessionTVC" owner:self options:nil];
        cell = self.GridRow;
       self.GridRow = nil;
    }
    
    
    EndSessionRecords *end=(EndSessionRecords*)[endSessionArray objectAtIndex:indexPath.row];
    
    cell.lbl_startSessionTime.text = end.SESSIONSTARTTIME;
    cell.lbl_endSessionTime.text = end.SESSIONENDTIME;
    cell.lbl_teamName.text = end.SHORTTEAMNAME;
    cell.lbl_sessionNo.text = [NSString stringWithFormat:@"%@",end.SESSIONNO];
    cell.lbl_dayNo.text = end.DAYNO;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EndSessionRecords *obj =(EndSessionRecords*)[endSessionArray objectAtIndex:indexPath.row];
    
    NSString*startInningsTime = obj.SESSIONSTARTTIME;
    NSString*endInningsTime  = obj.SESSIONENDTIME;
    NSString*teamName = obj.TEAMNAME;
    
    NSString*dayNo = obj.DAYNO;
   //NSNumber *sessionNo = obj.SESSIONNO;
    NSNumber *inningsNo = obj.INNINGSNO;
    NSNumber *startOver = obj.STARTOVER;
    NSNumber *endOver = obj.ENDOVER;
    NSNumber *runScored = obj.RUNSSCORED;
    NSNumber *wicket = obj.WICKETLOST;
    
    

    
    
    self.txt_startTime.text = startInningsTime;
    self.txt_endTime.text = endInningsTime;
    self.lbl_teamBatting.text = teamName;

    
    self.lbl_day.text = dayNo;
   // self.lbl_sessionNo.text = [NSString stringWithFormat:@"%@", sessionNo];
    self.lbl_InningsNo.text = [NSString stringWithFormat:@"%@",inningsNo];
    
    _lbl_sessionStartOver.text = [NSString stringWithFormat:@"%@",startOver];
    _lbl_sessionEndOver.text = [NSString stringWithFormat:@"%@",endOver];
    _lbl_runScored.text = [NSString stringWithFormat:@"%@",runScored];
    _lbl_wicketLost.text = [NSString stringWithFormat:@"%@",wicket];
    
    self.tbl_session.hidden = YES;
    self.view_allControls.hidden = NO;
    
}


//Check internet connection
- (BOOL)checkInternetConnection
{

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)btn_addEndSession:(id)sender {
    self.view_allControls.hidden = NO;
    self.tbl_session.hidden = YES;
    
}


- (IBAction)btn_save:(id)sender {
    
    
        
        NSString * BtnurrentTittle=[NSString stringWithFormat:self.btn_save.currentTitle];
        BtnurrentTittle = @"INSERT";
        
        
       sessionRecords  = [[EndSessionRecords alloc]init];
    
    if ([BtnurrentTittle isEqualToString:@"INSERT"]) {
        
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
            
            
        }else{
            
            
            
        }
        
        
  [sessionRecords InsertEndSession:competitioncode : matchcode :fetchSeRecord.BATTINGTEAMCODE :fetchSeRecord.INNINGSNO :sessionRecords.DAYNO :[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO] :_txt_startTime.text :_txt_endTime.text :[NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO]: [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO] :[NSString stringWithFormat:@"%@" ,sessionRecords.RUNSSCORED] :sessionRecords.WICKETLOST :@"(null)"];
        
        
    }else{
        
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
            
            
        }else{
            
            
            
        }
        
        
        [sessionRecords UpdateEndSession:competitioncode :matchcode :fetchSeRecord.INNINGSNO :sessionRecords.DAYNO :[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO] :_txt_startTime.text :_txt_endTime.text :@""];
        


        
    }
        

    
}

- (IBAction)btn_delete:(id)sender {
    
    {
        
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
        
        
    
    sessionRecords = [[EndSessionRecords alloc]init];
    
    [sessionRecords DeleteEndSession:competitioncode :matchcode :fetchSeRecord.INNINGSNO :sessionRecords.DAYNO :[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO]];
    
}
}



-(void) openPopTableView: (CGFloat) yValue{
        popTable=[[UITableView alloc]initWithFrame:CGRectMake(275, yValue,285,200)];
        popTable.scrollEnabled = YES;
        popTable.userInteractionEnabled = YES;
        popTable.backgroundColor = [UIColor whiteColor];
        popTable.dataSource = self;
        popTable.delegate = self;
        [self.scroll_EndSession addSubview:popTable];
        [popTable reloadData];
        self.scroll_EndSession.scrollEnabled = NO;
    
}

- (IBAction)btn_dropDown:(id)sender {
    
    [self.view layoutIfNeeded];
    
    UITableView* objtbl=[[UITableView alloc]initWithFrame:CGRectMake(self.view_sessionDominant.frame.origin.x, self.view_sessionDominant.frame.origin.y+self.view_sessionDominant.frame.size.height+5, 280, 300)];
//    objtbl.dataSource=self;
//    objtbl.delegate=self;
    
    
    [self.view_allControls addSubview:objtbl];
    self.scroll_EndSession.scrollEnabled = NO;


    
}

- (IBAction)btn_back:(id)sender {
    
    if (back == NO) {
        
        self.view_allControls.hidden = YES;
        self.tbl_session.hidden = NO;
        
        back = YES;
        
    }else if (back == YES){
        
        
        //        DashBoardVC * dashVC = [[DashBoardVC alloc]init];
        //
        //        dashVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        
        back = NO;
    }
    

}
@end