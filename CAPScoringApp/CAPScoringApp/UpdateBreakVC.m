//
//  UpdateBreakVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "UpdateBreakVC.h"
#import "DBManager.h"

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
    
    
    
}


-(void)DurationCalculation
{
    
    dateFromString = [formatter dateFromString:BREAKSTARTTIME];
    
    
    dateFromString1 = [formatter1 dateFromString:BREAKENDTIME];
    
    NSTimeInterval timeDifference = [dateFromString1 timeIntervalSinceDate:dateFromString];
    double days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%f", days];
    _lbl_Duration.text =[NSString stringWithFormat:@"%@", Duration];
    Duration=_lbl_Duration.text;
    
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

    
    [ self UpdateBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKSTARTTIME :BREAKENDTIME :BREAKCOMMENTS :ISINCLUDEDURATION :BREAKNO];
    

    
    
    
    
    
    
    
}




-(void) UpdateBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:
(NSString*)BREAKCOMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO;
{
    
    if([DBManager GetMatchCodeForUpdateBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE] !=0)
    {
        if(![DBManager GetCompetitionCodeForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : ISINCLUDEDURATION : BREAKNO])
        {
            if(![DBManager GetBreakNoForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKNO ])
            {
                [DBManager UpdateInningsEvents : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : ISINCLUDEDURATION : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
            }
        }
    }
    
    NSMutableArray*UpdateBreaksArray=[DBManager GetInningsBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    
    BREAKNO =[DBManager GetMaxBreakNoForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
}







- (IBAction)hidepickerbtn:(id)sender {
    
    [_datePicker_View setHidden:YES];
 
}





-(void) DeleteBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKCOMMENTS:(NSString*)BREAKNO;

{
    
    if([DBManager GetCompetitionCodeForDeleteBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO]!=0)
    {
        
        [DBManager DeleteInningsEvents : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
    }
    
    NSMutableArray*DeleteBreaksArray=[DBManager InningsBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    BREAKNO =[DBManager GetMaxBreakNoForDeleteBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
}


/*
 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)delete_btn:(id)sender {
    
    BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
    
    [self DeleteBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKCOMMENTS :BREAKNO];
}
@end
