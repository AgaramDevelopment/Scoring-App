//
//  UpdateBreakVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "UpdateBreakVC.h"
#import "DBManager.h"
#import "BreakVC.h"
#import "Reachability.h"
#import "Utitliy.h"
#import "AppDelegate.h"

@interface UpdateBreakVC ()
{
NSString *BREAKSTARTTIME;
NSString *BREAKENDTIME;
NSString*INNINGSNO;
NSString *BREAKCOMMENTS;
NSString *BREAKNO;
NSString * ISINCLUDEDURATION;

NSDateFormatter *formatter;
NSDateFormatter *formatter1;
NSDate *dateFromString;
NSDate *dateFromString1;
NSString *DURATION;
    NSMutableArray*UpdateBreaksArray;
    NSMutableArray*DeleteBreaksArray;
}

@end

@implementation UpdateBreakVC
@synthesize  test;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UpdateBreaksArray=[[NSMutableArray alloc]init];
    DeleteBreaksArray=[[NSMutableArray alloc]init];
    
    _Text_BreakStart.text = [test valueForKey:@"BREAKSTARTTIME"];
    
    BREAKSTARTTIME =_Text_BreakStart.text;
    
    
    _text_EndBreak.text = [test valueForKey:@"BREAKENDTIME"];
    BREAKENDTIME =_text_EndBreak.text;
    
    _lbl_Duration.text = [test valueForKey:@"DURATION"];
    DURATION =_lbl_Duration.text;
    
    _text_Comments.text = [test valueForKey:@"BREAKCOMMENTS"];
    
    BREAKCOMMENTS =_text_Comments.text;
    
    BREAKNO=[test valueForKey:@"BREAKNO"];
    
    
    [_datePicker_View setHidden:YES];
    [self.View_BreakStart.layer setBorderWidth:2.0];
    [self.View_BreakStart.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.View_BreakStart.layer setMasksToBounds:YES];
    
    [self.View_EndBreak.layer setBorderWidth:2.0];
    [self.View_EndBreak.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.View_EndBreak.layer setMasksToBounds:YES];
    
    [self.View_Duration.layer setBorderWidth:2.0];
    [self.View_Duration.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.View_Duration.layer setMasksToBounds:YES];
    
    [self.View_Comments.layer setBorderWidth:2.0];
    [self.View_Comments.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.View_Comments.layer setMasksToBounds:YES];
    NSDate *dateFromString = [[NSDate alloc] init];
    NSDate *dateFromString1 = [[NSDate alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)StartBreack_btn:(id)sender {
    

    [_datePicker_View setHidden:NO];
    [_date_picker1 setHidden:YES];
    [_date_picker setHidden:NO];
    
    _date_picker.datePickerMode = UIDatePickerModeDateAndTime;
    [_date_picker addTarget:self
                     action:@selector(BreakStart:)forControlEvents:UIControlEventValueChanged];
   self.Text_BreakStart.inputView =_date_picker;
    
     [self DurationCalculation];
    
    
    
}

-(void)BreakStart:(id)sender
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:_MATCHDATE];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    // for minimum date
    [_date_picker setMinimumDate:matchdate];
    
    // for maximumDate
    int daysToAdd = 1;
    NSDate *newDate1 = [matchdate dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    [_date_picker setMaximumDate:newDate1];
    
    
    
    NSString *minimumdateStr = [dateFormat stringFromDate:matchdate];
    NSString*maxmimumdateStr=[dateFormat stringFromDate:newDate1];
    
    _Text_BreakStart.text=[dateFormat stringFromDate:_date_picker.date];
    NSLog(@"check: %@",_Text_BreakStart.text);
    BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_Text_BreakStart text]];
    [self DurationCalculation];
    


    
}




- (IBAction)EndBreak_btn:(id)sender {
    
    
  //  _text_EndBreak.text=_MATCHDATE;
    [_datePicker_View setHidden:NO];
    [_date_picker setHidden:YES];
    [_date_picker1 setHidden:NO];
    _date_picker1.datePickerMode = UIDatePickerModeDateAndTime;
    [_date_picker1 addTarget:self
                      action:@selector(BreakEnd:)forControlEvents:UIControlEventValueChanged];
    
    
    self.text_EndBreak.inputView =_date_picker1;
     [self DurationCalculation];
    
    
}


-(void)DurationCalculation
{
    NSString *startDateTF = self.Text_BreakStart.text;
    NSString *startEndTF = self.text_EndBreak.text;
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:startDateTF];
    NSDate *date2 = [formatter dateFromString:startEndTF];
    
    NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    int days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
    self.lbl_Duration.text=[NSString stringWithFormat:@"%@", Duration];
    

    Duration=_lbl_Duration.text;
    
}


-(void)BreakEnd:(id)sender
{
    NSLog(@"date is %@",_date_picker1.date);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:_MATCHDATE];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    // for minimum date
    [_date_picker1 setMinimumDate:matchdate];
    
    // for maximumDate
    int daysToAdd = 1;
    NSDate *newDate1 = [matchdate dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    [_date_picker1 setMaximumDate:newDate1];
    
    NSString *minimumdateStr = [dateFormat stringFromDate:matchdate];
    NSString*maxmimumdateStr=[dateFormat stringFromDate:newDate1];
    
    _text_EndBreak.text=[dateFormat stringFromDate:_date_picker1.date];
    BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    
    NSLog(@"check: %@",_text_EndBreak.text);
    BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    
    
    [self DurationCalculation];

    
    
    
}






- (IBAction)Switch_minuts:(id)sender {
    
    if([sender isOn]){
        
        NSString *checkoffon=@"1";
        [checkoffon isEqual:@"1"];
        ISINCLUDEDURATION=@"1";
        NSLog(@"Switch is ON 1");
    } else{
        
        ISINCLUDEDURATION=@"0";
        NSLog(@"Switch is OFF 0");
    }
}

- (IBAction)Finish_btn:(id)sender {
    
    BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];

    
    [ self UpdateBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKSTARTTIME :BREAKENDTIME :BREAKCOMMENTS :ISINCLUDEDURATION :BREAKNO];
    
    //  [self startService:@"UPDATE"];

    
    BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
    
    add.COMPETITIONCODE=self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
    add.MATCHDATE=self.MATCHDATE;
     add.resultarray=UpdateBreaksArray;
    
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




-(void) UpdateBreaks:COMPETITIONCODE:INNINGSNO:MATCHCODE:BREAKSTARTTIME:BREAKENDTIME:
BREAKCOMMENTS:ISINCLUDEDURATION:BREAKNO;
{
    
//    if([DBManager GetMatchCodeForUpdateBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE] !=0)
//    {
//        if(![DBManager GetCompetitionCodeForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : ISINCLUDEDURATION : BREAKNO])
//        {
//            if(![DBManager GetBreakNoForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKNO ])
//            {
                [DBManager UpdateInningsEvents : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : ISINCLUDEDURATION : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
//            }
//        }
//    }
    
   UpdateBreaksArray=[DBManager GetInningsBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    

}







- (IBAction)hidepickerbtn:(id)sender {
[self DurationCalculation];
    [_datePicker_View setHidden:YES];
    
}





-(void) DeleteBreaks:COMPETITIONCODE:INNINGSNO:MATCHCODE:BREAKCOMMENTS:BREAKNO;

{
    

        
        [DBManager DeleteInningsEvents : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
  
    
   DeleteBreaksArray=[DBManager InningsBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
}




- (IBAction)delete_btn:(id)sender {
    
    BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
    
    [self DeleteBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKCOMMENTS :BREAKNO];
    BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
    
    add.COMPETITIONCODE=self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
    add.MATCHDATE=self.MATCHDATE;
  //  add.test=self.test;
    add.resultarray=DeleteBreaksArray;
 //   [self startService:@"DELETE"];
    
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

- (IBAction)bck_btn:(id)sender {
    
    
    AddBreakVC*add = [[AddBreakVC alloc]initWithNibName:@"AddBreakVC" bundle:nil];
    

    add.COMPETITIONCODE=self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
     add.test=self.test;
    add.MATCHDATE=self.MATCHDATE;
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





- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) startService:(NSString *)OPERATIONTYPE{
    if(self.checkInternetConnection){
        
        
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        [dateFmt setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date = [dateFmt dateFromString:BREAKSTARTTIME];
        NSLog(@"date:",date);
        
        [dateFmt setDateFormat:@"yyyy-MM-dd"];
        NSString *BREAKSTARTTIME1 = [dateFmt stringFromDate:date];
        NSLog(@"dateString:",BREAKSTARTTIME1);
        
        
        NSDateFormatter *dateFmt1 = [[NSDateFormatter alloc] init];
        [dateFmt1 setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date1= [dateFmt1 dateFromString:BREAKENDTIME];
        NSLog(@"date:",date1);
        
        [dateFmt1 setDateFormat:@"yyyy-MM-dd"];
        NSString *BREAKENDTIME1 = [dateFmt1 stringFromDate:date1];
        NSLog(@"dateString:",BREAKENDTIME1);

        
        
        
        MATCHCODE = MATCHCODE == nil ?@"NULL":MATCHCODE;
        COMPETITIONCODE = COMPETITIONCODE == nil ?@"NULL":COMPETITIONCODE;
        INNINGSNO= INNINGSNO == nil ?@"NULL":INNINGSNO;
        BREAKSTARTTIME1 = BREAKSTARTTIME1 == nil ?@"NULL":BREAKSTARTTIME1;
        BREAKENDTIME1 = BREAKENDTIME1 == nil ?@"":BREAKENDTIME1;
        BREAKCOMMENTS= BREAKCOMMENTS == nil ?@"NULL":BREAKCOMMENTS;
        ISINCLUDEDURATION = ISINCLUDEDURATION == nil ?@"NULL":ISINCLUDEDURATION;
        BREAKNO = BREAKNO == nil ?@"NULL":BREAKNO;
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETBREAK/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT], COMPETITIONCODE,INNINGSNO,MATCHCODE,BREAKSTARTTIME1,BREAKENDTIME1,BREAKCOMMENTS,ISINCLUDEDURATION,BREAKNO,OPERATIONTYPE];
            NSLog(@"-%@",baseURL);
            
            
            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (responseData != nil) {

            
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



@end
