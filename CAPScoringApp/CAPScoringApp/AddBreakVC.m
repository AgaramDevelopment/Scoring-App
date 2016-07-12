//
//  AddBreakVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "AddBreakVC.h"
#import "DBManager.h"
#import "BallEventRecord.h"
#import "FetchSEPageLoadRecord.h"
#import "BreakVC.h"
#import "Reachability.h"
#import "Utitliy.h"
#import "AppDelegate.h"


//#import "Scor"

@interface AddBreakVC ()
{
    
    NSString *BREAKSTARTTIME;
    NSString *BREAKENDTIME;
 
    NSString *BREAKCOMMENTS;
    NSString *BREAKNO;
    NSString * ISINCLUDEDURATION;
   
    NSDateFormatter *formatter;
    NSDateFormatter *formatter1;
    NSDate *dateFromString;
    NSDate *dateFromString1;
    NSString*Durationtime;
    
    //objInningsno;
    BallEventRecord*obj;
    FetchSEPageLoadRecord*fetchSEPageLoadRecord;
}
@end

@implementation AddBreakVC
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
- (void)viewDidLoad {
    [super viewDidLoad];
  
        //fetchSEPageLoadRecord = [[FetchSEPageLoadRecord alloc]init];
//        INNINGSNO= fetchSEPageLoadRecord.INNINGSNO;
//        COMPETITIONCODE=fetchSEPageLoadRecord.COMPETITIONCODE;
//   INNINGSNO= fetchSEPageLoadRecord.INNINGSNO;
//    COMPETITIONCODE=fetchSEPageLoadRecord.COMPETITIONCODE;
//    MATCHCODE=fetchSEPageLoadRecord.MATCHCODE;
    
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
    
    //_Text_BreakStart.text=_MATCHDATE;
    
  //  _text_EndBreak.text=_MATCHDATE;
    
 //   [self DurationCalculation];

    
    //[self DurationCalculation1];
    
   // [self BreakStart];
   // [self BreakEnd];
    [self DurationCalculation];
}
//
//
//
////Another Dte Picker Tool for Toate Picker
//-(void) ShowSelectedDate1
//{  formatter1=[[NSDateFormatter alloc]init];
//    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    self.text_EndBreak.text=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:_date_picker.date]];
//    [self.text_EndBreak resignFirstResponder];
//}









- (IBAction)StartBreack_btn:(id)sender {
    
    _Text_BreakStart.text=@"";
    [_datePicker_View setHidden:NO];
    [_date_picker1 setHidden:YES];
    [_date_picker setHidden:NO];
    
    _date_picker.datePickerMode = UIDatePickerModeDateAndTime;
    [_date_picker addTarget:self
                     action:@selector(BreakStart:)forControlEvents:UIControlEventValueChanged];
    
    formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:s"];
    //set date too your lable here
    // =[formate stringFromDate:_date_picker.date];
    
    


    
   
}

-(void)BreakStart:(id)sender
{

    NSLog(@"date is %@",_date_picker.date);
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd hh:mm:s"];
    _Text_BreakStart.text=[formate stringFromDate:_date_picker.date];
    BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_Text_BreakStart text]];

      [self DurationCalculation];
}




- (IBAction)EndBreak_btn:(id)sender {
    
    _text_EndBreak.text=@"";
    [_datePicker_View setHidden:NO];
    [_date_picker setHidden:YES];
    [_date_picker1 setHidden:NO];
    _date_picker1.datePickerMode = UIDatePickerModeDateAndTime;
    [_date_picker1 addTarget:self
                      action:@selector(BreakEnd:)forControlEvents:UIControlEventValueChanged];
    
    formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd hh:mm:s"];

}


-(void)DurationCalculation
{
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateTF = self.Text_BreakStart.text;
    NSString *startEndTF = self.text_EndBreak.text;
    
    NSDate *date1 = [formatter dateFromString:startDateTF];
    NSDate *date2 = [formatter dateFromString:startEndTF];
    
    NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    int days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
    self.lbl_Duration.text=[NSString stringWithFormat:@"%@", Duration];
    
    
//   
//       dateFromString = [formatter dateFromString:BREAKSTARTTIME];
//   
//
//    dateFromString1 = [formatter1 dateFromString:BREAKENDTIME];
//    
//    NSTimeInterval timeDifference = [dateFromString1 timeIntervalSinceDate:dateFromString];
//    int days = timeDifference / 60;
//    NSString *Duration = [NSString stringWithFormat:@"%f", days];
//   _lbl_Duration.text =[NSString stringWithFormat:@"%@", Duration];
//    Durationtime=_lbl_Duration.text;
    
}


-(void)BreakEnd:(id)sender
{
    NSLog(@"date is %@",_date_picker1.date);
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd hh:mm:s"];
    _text_EndBreak.text=[formate stringFromDate:_date_picker1.date];
    BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    
      [self DurationCalculation];
    
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"hh:mm:ss"];
//  //  NSDate *date = [dateFormat dateFromString:_MATCHDATE];
//     // [dateFormat setDateFormat:@"hh:mm:ss"];
//   // [_date_picker1 setDate:date];
//   //[_date_picker1 setMinimumDate:date];
//    
//  
//    NSString *Time = [dateFormat stringFromDate:date];
//    BREAKENDTIME =[NSString stringWithFormat:@"%@ %@" ,[_text_EndBreak text],Time];
    

   
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
      [self DurationCalculation];
    
     BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
    
    if([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil)
    {
        [self ShowAlterView:@"Please Select Start Time"];
    }
    else if([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil)
    {
        [self ShowAlterView:@"Please Select End Time"];
    }
    else if([self.lbl_Duration.text isEqualToString:@""] || self.lbl_Duration.text==nil)
    {
        [self ShowAlterView:@"Duration Not Calculated"];
    }
    else if([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)
    {
        [self ShowAlterView:@"Please Add Comments"];
    }
   
    else{
    
    BREAKNO =[DBManager GetMaxBreakNoForInsertBreaks:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    
    


    
   [self InsertBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKSTARTTIME :BREAKENDTIME :BREAKCOMMENTS :ISINCLUDEDURATION :BREAKNO];
    
    
 [self startService:@"INSERT"];
    
    }
    
}


-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}



-(void) InsertBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:(NSString*)BREAKCOMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO
{
    
    if([DBManager GetMatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE])
    {
//        if(![DBManager GetCompetitionCodeForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : ISINCLUDEDURATION : BREAKNO:BREAKCOMMENTS])
//        {
//            if(![DBManager MatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE : INNINGSNO])
//            {
                [DBManager InsertInningsEvents : COMPETITIONCODE : INNINGSNO : MATCHCODE : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : BREAKNO : ISINCLUDEDURATION];
          //  }
       // }
    }
    
    NSMutableArray*BreaksArray=[DBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    //BREAKNO =[DBManager GetMaxBreakNoForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    
    
    BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
    
    add.resultarray=BreaksArray;
    add.MATCHCODE=MATCHCODE;
    add.COMPETITIONCODE=COMPETITIONCODE;
    add.INNINGSNO=INNINGSNO;
    add.MATCHDATE=_MATCHDATE;
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

- (IBAction)hidepickerbtn:(id)sender {
    
      [_datePicker_View setHidden:YES];
 

}

- (IBAction)back_btn:(id)sender {
    
//    
//    intialBreakVC*add = [[intialBreakVC alloc]initWithNibName:@"intialBreakVC" bundle:nil];
    
    BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
    add.COMPETITIONCODE=self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
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
        });
        
        //[delegate hideLoading];
    }
    
//    else{
//    
//      [self showDialog:@"Network Error" andTitle:@""];
//    }
}
//-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
//    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
//    
//    [alertDialog show];
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
