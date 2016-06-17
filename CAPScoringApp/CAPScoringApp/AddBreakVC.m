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
//#import "Scor"

@interface AddBreakVC ()
{
    
    NSString *BREAKSTARTTIME;
    NSString *BREAKENDTIME;
    NSString*INNINGSNO;
    NSString *COMMENTS;
    NSString *BREAKNO;
    NSString * ISINCLUDEDURATION;
    NSString*COMPETITIONCODE;
    NSString*MATCHCODE;
    NSDateFormatter *formatter;
    NSDateFormatter *formatter1;
    NSDate *dateFromString;
    NSDate *dateFromString1;
    
    //objInningsno;
    BallEventRecord*obj;
    FetchSEPageLoadRecord*fetchSEPageLoadRecord;
}
@end

@implementation AddBreakVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
   INNINGSNO= fetchSEPageLoadRecord.INNINGSNO;
    COMPETITIONCODE=fetchSEPageLoadRecord.COMPETITIONCODE;
    MATCHCODE=fetchSEPageLoadRecord.MATCHCODE;
    
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
    [formatter setDateFormat:@"dd-MMM-yy hh:mm a "];
    //set date too your lable here
   // =[formate stringFromDate:_date_picker.date];
    
    

    
   
}

-(void)BreakStart:(id)sender
{
    NSLog(@"date is %@",_date_picker.date);
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"dd-MMM-yy hh:mm a "];
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
    [formatter1 setDateFormat:@"dd-MMM-yy hh:mm a "];

//
    
    
    
}


-(void)DurationCalculation
{
   
       dateFromString = [formatter dateFromString:BREAKSTARTTIME];
   

    dateFromString1 = [formatter1 dateFromString:BREAKENDTIME];
    
    NSTimeInterval timeDifference = [dateFromString1 timeIntervalSinceDate:dateFromString];
    double days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%f", days];
    _lbl_Duration.text=[NSString stringWithFormat:@"%@", Duration];
}


-(void)BreakEnd:(id)sender
{
    NSLog(@"date is %@",_date_picker1.date);
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"dd-MMM-yy hh:mm a "];
    _text_EndBreak.text=[formate stringFromDate:_date_picker1.date];
    BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    
}


- (IBAction)Switch_minuts:(id)sender {
    
    if([sender isOn]){
        [ISINCLUDEDURATION isEqual:@"1"];
        NSLog(@"Switch is ON");
    } else{
        [ISINCLUDEDURATION isEqual:@"0"];
        NSLog(@"Switch is OFF");
    }
}

- (IBAction)Finish_btn:(id)sender {
     [self DurationCalculation];
    COMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
   // [self InsertBreaks];
    
    
   //   BREAKNO =[DBManager GetMaxBreakNoForInsertBreaks:COMPETITIONCODE :MATCHCODE :INNINGSNO];

}



-(void) InsertBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:(NSString*)COMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO
{
    
    if([DBManager GetMatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE].length !=0)
    {
        if([DBManager GetCompetitionCodeForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : ISINCLUDEDURATION : BREAKNO])
        {
            if([DBManager MatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE : INNINGSNO])
            {
                [DBManager InsertInningsEvents : COMPETITIONCODE : INNINGSNO : MATCHCODE : BREAKSTARTTIME : BREAKENDTIME : COMMENTS : BREAKNO : ISINCLUDEDURATION];
            }
        }
    }
    
    NSMutableArray*BreaksArray=[DBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    BREAKNO =[DBManager GetMaxBreakNoForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
}

- (IBAction)hidepickerbtn:(id)sender {
    
      [_datePicker_View setHidden:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
