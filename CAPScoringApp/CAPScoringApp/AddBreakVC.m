//
//  AddBreakVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "AddBreakVC.h"
#import "DBManager.h"

@interface AddBreakVC ()
{
    
    NSString *BREAKSTARTTIME;
    NSString *BREAKENDTIME;
    NSString*INNINGSNO;
    NSString *COMMENTS;
    NSString * ISINCLUDEDURATION;
    NSDateFormatter *formatter;
    NSDateFormatter *formatter1;
}
@end

@implementation AddBreakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.frame =CGRectMake(100,350, [[UIScreen mainScreen] bounds].size.width/2, 500);
    
    
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
    
    
    datepicker=[[UIDatePicker alloc]init];
    datepicker1=[[UIDatePicker alloc]init];
    
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker1.datePickerMode=UIDatePickerModeDate;
    
    
    
    // [self.ok_lbl.text:datepicker];
    [self.Text_BreakStart setInputView:datepicker];
    [self.text_EndBreak setInputView:datepicker1];
    
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    
    UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.Text_BreakStart setInputAccessoryView:toolbar];
    
    //Another Dte Picker Tool for Toate Picker
    UIToolbar *toolbar1 =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar1 setTintColor:[UIColor grayColor]];
    //  datepicker.backgroundColor=[UIColor blueColor];
    // toolbar.backgroundColor=[UIColor b];
    UIBarButtonItem *doneBtn1=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate1)];
    UIBarButtonItem *space1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar1 setItems:[NSArray arrayWithObjects:space1,doneBtn1, nil]];
    [self.text_EndBreak setInputAccessoryView:toolbar1];
    
    
//    NSDate *minutes = [BREAKSTARTTIME timeIntervalSinceDate:BREAKENDTIME];
//    int numberOfDays = minutes / 1440;
    
  
}


-(void) ShowSelectedDate

{
    formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.Text_BreakStart.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datepicker.date]];
    
    [self.Text_BreakStart resignFirstResponder];
}

//Another Dte Picker Tool for Toate Picker
-(void) ShowSelectedDate1
{  formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.text_EndBreak.text=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:datepicker1.date]];
    [self.text_EndBreak resignFirstResponder];
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




- (IBAction)StartBreack_btn:(id)sender {
    
    BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_Text_BreakStart text]];
   
}
- (IBAction)EndBreak_btn:(id)sender {
     BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    
      NSDate *date1 = [formatter dateFromString:BREAKSTARTTIME];
     NSDate *date2 = [formatter dateFromString:BREAKENDTIME];
    
      NSTimeInterval timeDifference = [date1 timeIntervalSinceDate:date2];
    double days = timeDifference / 1440;
    NSString *Duration = [NSString stringWithFormat:@"%.20f", days];
    _lbl_Duration.text=[NSString stringWithFormat:@"%@", Duration];
    
    
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
    
    COMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
    

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

@end
