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
#import "intialBreakVC.h"


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
    
    //[self DurationCalculation1];
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

//
      [self DurationCalculation];
    
    
}


-(void)DurationCalculation
{
   
       dateFromString = [formatter dateFromString:BREAKSTARTTIME];
   

    dateFromString1 = [formatter1 dateFromString:BREAKENDTIME];
    
    NSTimeInterval timeDifference = [dateFromString1 timeIntervalSinceDate:dateFromString];
    double days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%f", days];
   _lbl_Duration.text =[NSString stringWithFormat:@"%@", Duration];
    Durationtime=_lbl_Duration.text;
    
}


-(void)BreakEnd:(id)sender
{
    NSLog(@"date is %@",_date_picker1.date);
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd hh:mm:s"];
    _text_EndBreak.text=[formate stringFromDate:_date_picker1.date];
    BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    
    
   
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
//    MATCHCODE=@"IMSC02214DDA97AF2FD00004";
//    COMPETITIONCODE=@"UCC0000004";
//    INNINGSNO=@"2";
    
    BREAKNO =[DBManager GetMaxBreakNoForInsertBreaks:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    
    BREAKNO=  [NSString stringWithFormat:@"%d", [BREAKNO integerValue] + 1];
  
   
    [self InsertBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKSTARTTIME :BREAKENDTIME :BREAKCOMMENTS :ISINCLUDEDURATION :BREAKNO];

    
    
    
    
    
    
}






-(void) InsertBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:(NSString*)BREAKCOMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO
{
    
    if([DBManager GetMatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE])
    {
        if(![DBManager GetCompetitionCodeForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : ISINCLUDEDURATION : BREAKNO:BREAKCOMMENTS])
        {
            if(![DBManager MatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE : INNINGSNO])
            {
                [DBManager InsertInningsEvents : COMPETITIONCODE : INNINGSNO : MATCHCODE : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : BREAKNO : ISINCLUDEDURATION];
            }
        }
    }
    
    NSMutableArray*BreaksArray=[DBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    //BREAKNO =[DBManager GetMaxBreakNoForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    
    
    BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
    
    add.resultarray=BreaksArray;
    add.MATCHCODE=MATCHCODE;
    add.COMPETITIONCODE=COMPETITIONCODE;
    add.INNINGSNO=INNINGSNO;
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
