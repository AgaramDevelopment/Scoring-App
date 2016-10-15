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
#import "BreakTableViewCell.h"
#import "BreakEventRecords.h"


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
    NSString*Duration;
    NSString*MATCHDATETIME;
    //objInningsno;
    BallEventRecord*obj;
    FetchSEPageLoadRecord*fetchSEPageLoadRecord;
    DBManager *objDBManager;
    
    BOOL isShow_BreakrecordTbl;

}
@property(nonatomic,strong)NSMutableArray*resultarray;

@end
@implementation AddBreakVC
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;

- (void)viewDidLoad {
    [super viewDidLoad];
    objDBManager = [[DBManager alloc]init];


    DBManager *objDBManager = [[DBManager alloc]init];
    
    _resultarray=[objDBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    
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
    // NSDate *dateFromString = [[NSDate alloc] init];
    //    NSDate *dateFromString1 = [[NSDate alloc] init];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:_MATCHDATE];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *MATCHDATE1 = [formatter stringFromDate:date];
    

    
    NSString *timeString=@"00:00:00";
  
  MATCHDATETIME=[NSString stringWithFormat:@"%@ %@",MATCHDATE1,timeString];
    self.btn_Update.hidden=YES;
    self.btn_delete.hidden=YES;
    self.btn_finish.hidden=NO;
    isShow_BreakrecordTbl=YES;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_resultarray count];
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *breakidentifier = @"BreakCell";
    
    
    BreakTableViewCell *cell = (BreakTableViewCell *)[tableView dequeueReusableCellWithIdentifier:breakidentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BreakTableViewCell" owner:self options:nil];
        cell = self.GridBreakcell;
        self.GridBreakcell = nil;
    }
    BreakEventRecords *veb=(BreakEventRecords*)[_resultarray objectAtIndex:indexPath.row];
    
    
    cell.test.text=veb.BREAKCOMMENTS;
    
    cell.Starttime_lbl.text=veb.BREAKSTARTTIME;
    cell.Endtime_lbl.text=veb.BREAKENDTIME;
    cell.duration_lbl.text=veb.DURATION;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     BreakEventRecords * objBreak=(BreakEventRecords*)[_resultarray objectAtIndex:indexPath.row];
    _Text_BreakStart.text = objBreak.BREAKSTARTTIME;      // [test valueForKey:@"BREAKSTARTTIME"];
    
   // BREAKSTARTTIME =_Text_BreakStart.text;
    _addbreak_lbl.text=@"BREAKS";
    _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
    
    _text_EndBreak.text = objBreak.BREAKENDTIME;          //[test valueForKey:@"BREAKENDTIME"];
   // BREAKENDTIME =_text_EndBreak.text;
    
    _lbl_Duration.text = objBreak.DURATION;       //[test valueForKey:@"DURATION"];
    //DURATION =_lbl_Duration.text;
    
    _text_Comments.text = objBreak.BREAKCOMMENTS;   //[test valueForKey:@"BREAKCOMMENTS"];
    
   // BREAKCOMMENTS =_text_Comments.text;
    
    BREAKNO = objBreak.BREAKNO;       //[test valueForKey:@"BREAKNO"];
    
//    UpdateBreakVC*add = [[UpdateBreakVC alloc]initWithNibName:@"UpdateBreakVC" bundle:nil];
//    
//    
//    
//    
//    //vc2 *viewController = [[vc2 alloc]init];
//    
//    NSDictionary *sample=[self.resultarray objectAtIndex:indexPath.row];
//    add.test=sample;
//    
//    add.COMPETITIONCODE=COMPETITIONCODE;
//    add.resultarray=_resultarray;
//    add.MATCHCODE=MATCHCODE;
//    add.INNINGSNO=INNINGSNO;
//    add.MATCHDATE=_MATCHDATE;
//    
//    [self addChildViewController:add];
//    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//    [self.view addSubview:add.view];
//    add.view.alpha = 0;
//    [add didMoveToParentViewController:self];
//    
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         add.view.alpha = 1;
//     }
//                     completion:nil];
//    
    
    
    // //destViewController = [CategoryVC.destViewController objectAtIndex:0];
    
    self.btn_Update.hidden=NO;
    self.btn_delete.hidden=NO;
    self.btn_finish.hidden=YES;
    self.view_gridview.hidden=YES;
    self.btn_Add.hidden=YES;
    isShow_BreakrecordTbl=NO;
    
    
}


- (IBAction)StartBreack_btn:(id)sender {
      [_date_picker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_FR"]];
    
    _Text_BreakStart.text=MATCHDATETIME;
    
    
    [_datePicker_View setHidden:NO];
    [_date_picker1 setHidden:YES];
    [_date_picker setHidden:NO];
    
    _date_picker.datePickerMode = UIDatePickerModeDateAndTime;
    [_date_picker addTarget:self
                     action:@selector(BreakStart:)forControlEvents:UIControlEventValueChanged];
    self.Text_BreakStart.inputView =_date_picker;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MATCHDATETIME];
    
   
    self.date_picker.date = matchdate;
   [self DurationCalculation];
    
}

-(void)BreakStart:(id)sender
{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
 //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MATCHDATETIME];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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
      [_date_picker1 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_FR"]];
   
    [_datePicker_View setHidden:NO];
    [_date_picker setHidden:YES];
    [_date_picker1 setHidden:NO];
    _date_picker1.datePickerMode = UIDatePickerModeDateAndTime;
    [_date_picker1 addTarget:self
                      action:@selector(BreakEnd:)forControlEvents:UIControlEventValueChanged];
  
    self.text_EndBreak.inputView =_date_picker1;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MATCHDATETIME];
    
    
    self.date_picker1.date = matchdate;
    
    
   [self DurationCalculation];
}


-(void)DurationCalculation
{
    
    NSString *startDateTF = self.Text_BreakStart.text;
    NSString *startEndTF = self.text_EndBreak.text;
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:startDateTF];
    NSDate *date2 = [formatter dateFromString:startEndTF];
    
    NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    int days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
    self.lbl_Duration.text=[NSString stringWithFormat:@"%@", Duration];
    

}


-(void)BreakEnd:(id)sender
{
    NSLog(@"date is %@",_date_picker1.date);
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MATCHDATETIME];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
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

-(void)viewWillAppear:(BOOL)animated{
 
    BOOL test= [[NSUserDefaults standardUserDefaults] boolForKey:@"switch"];
    NSLog(@"%@",test?@"YES":@"NO");
   [_mySwitch setOn:test animated:YES];
}






- (IBAction)Switch_minuts:(UISwitch*)sender {
    
 [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"switch"];
    if([_mySwitch isOn]){
        NSString *checkoffon=@"1";
        [checkoffon isEqual:@"1"];
        ISINCLUDEDURATION=@"1";
        NSLog(@"Switch is ON 1");
    } else{
        
        ISINCLUDEDURATION=@"0";
        NSLog(@"Switch is OFF 0");
    }
}


- (void)saveValue  {
    [[NSUserDefaults standardUserDefaults] setBool:self.mySwitch.on forKey:@""];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)Finish_btn:(id)sender {
      [self DurationCalculation];
    
//     BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
//     BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
//       BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_Text_BreakStart text]];
//    
//    if([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil && [self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil && [self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)
//    {
//        [self ShowAlterView:@"Please Select Start Time\nPlease Select End Time\nPlease Add Comments"];
//    }
//    else if([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil)
//    {
//        [self ShowAlterView:@"Please Select Start Time"];
//    }
//    else if([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil)
//    {
//        [self ShowAlterView:@"Please Select End Time"];
//    }
//   else if([self.lbl_Duration.text integerValue]<=0){
//        [self ShowAlterView:@"Duration should be greated than zero"];
//   }
////    else if([self.lbl_Duration.text isEqualToString:@""] || self.lbl_Duration.text==nil)
////    {
////        [self ShowAlterView:@"Duration Not Calculated"];
////    }
//    else if([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)
//    {
//        [self ShowAlterView:@"Please Add Comments"];
//    }
//   
    if ([ self   formValidation]) {
   BREAKNO =[objDBManager GetMaxBreakNoForInsertBreaks:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    
    


    
   [self InsertBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKSTARTTIME :BREAKENDTIME :BREAKCOMMENTS :ISINCLUDEDURATION :BREAKNO];
    
        _addbreak_lbl.text=@"BREAKS";
        _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
        
        
 //[self startService:@"INSERT"];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"AlertView"]) {
            NSLog(@"yes");
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AlertView"];
            [self showDialog:@"Break Already Inserted." andTitle:@"Breaks"];
        }
        else
        
             [self showDialog:@"Break Inserted Successfully." andTitle:@"Breaks"];
    
    }
    
}


-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:@"Breaks" message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}



-(void) InsertBreaks:COMPETITIONCODE:INNINGSNO:MATCHCODE:BREAKSTARTTIME:BREAKENDTIME:BREAKCOMMENTS:ISINCLUDEDURATION:BREAKNO
{
    
    if([objDBManager GetMatchCodeForInsertBreaks :BREAKSTARTTIME:BREAKENDTIME:COMPETITIONCODE : MATCHCODE])
    {
       if(![objDBManager GetCompetitionCodeForInsertBreaks :COMPETITIONCODE: MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : ISINCLUDEDURATION : BREAKNO:BREAKCOMMENTS])
      {
           if(![objDBManager MatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE : INNINGSNO])
{
                [objDBManager InsertInningsEvents : COMPETITIONCODE : INNINGSNO : MATCHCODE : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : BREAKNO : ISINCLUDEDURATION];
     }
   }
   }
    
    NSMutableArray*BreaksArray=[objDBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    self.resultarray =BreaksArray;
   BREAKNO =[objDBManager GetMaxBreakNoForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];

    
    self.view_gridview.hidden=NO;
    self.btn_Add.hidden=NO;
    [self.tbl_breaklist reloadData];

    
    
    
}

- (IBAction)hidepickerbtn:(id)sender {
    [self DurationCalculation];
      [_datePicker_View setHidden:YES];
 

}

-(IBAction)didClickAddBtnAction:(id)sender
{
    if(isShow_BreakrecordTbl == YES)
    {
        _Text_BreakStart.text = @"";
        
        _btn_finish.hidden=NO;
        _btn_delete.hidden=YES;
        _btn_Update.hidden=YES;
        _addbreak_lbl.text=@"BREAKS";
        _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
        
        _text_EndBreak.text = @"";
    
        
        _lbl_Duration.text = @"";
        _text_Comments.text =@"";
        
        self.view_gridview.hidden=YES;
       // self.view_penaltyTittle.hidden=YES;
        isShow_BreakrecordTbl= NO;
        self.btn_Add.hidden =YES;
       // [self.btn_submitpenality setTitle:[NSString stringWithFormat:@"Submit"] forState:UIControlStateNormal];
        //self.lbl_penaltytype.text=@"Choose Penalty Type";
        //self.txt_penalityruns.text=@"";
        //[_resultarray lastObject];
        //int myCount = [_resultarray count];
        //selectindex= myCount+1;
        
    }
    else
    {
        _Text_BreakStart.text = @"";
        
        _btn_finish.hidden=NO;
        _btn_delete.hidden=YES;
        _btn_Update.hidden=YES;
        _addbreak_lbl.text=@"BREAKS";
        _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
        
        _text_EndBreak.text = @"";
        
        
        _lbl_Duration.text = @"";
        _text_Comments.text =@"";
        
        self.view_gridview.hidden=YES;
        // self.view_penaltyTittle.hidden=YES;
        isShow_BreakrecordTbl= NO;
        self.btn_Add.hidden =YES;
        
//        _Text_BreakStart.text = @"";
//        
//        
//        _addbreak_lbl.text=@"ADD BREAK";
//        _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
//        
//        _text_EndBreak.text = @"";
//        
//        
//        _lbl_Duration.text = @"";
//        _text_Comments.text =@"";
//        self.view_gridview.hidden=YES;
////        self.tbl_breaklist.hidden=YES;
//       // self.view_penaltyTittle.hidden=YES;
//        isShow_BreakrecordTbl= YES;
//        self.btn_Add.hidden =YES;
        [self.tbl_breaklist reloadData];
    }

}

- (IBAction)Update_btn:(id)sender {
    self.view_gridview.hidden=NO;
    self.btn_Add.hidden =NO;
    BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
    
    if([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil && [self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil && [self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)
    {
        [self ShowAlterView:@"Please Select Start Time\nPlease Select End Time\nPlease Add Comments"];
    }
    else if([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil)
    {
        [self ShowAlterView:@"Please Select Start Time"];
    }
    else if([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil)
    {
        [self ShowAlterView:@"Please Select End Time"];
    }
    else if([self.lbl_Duration.text integerValue]<=0){
        [self ShowAlterView:@"Duration should be greated than zero"];
    }
    //    else if([self.lbl_Duration.text isEqualToString:@""] || self.lbl_Duration.text==nil)
    //    {
    //        [self ShowAlterView:@"Duration Not Calculated"];
    //    }
    else if([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)
    {
        [self ShowAlterView:@"Please Add Comments"];
    }
    
    else{
        [ self UpdateBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKSTARTTIME :BREAKENDTIME :BREAKCOMMENTS :ISINCLUDEDURATION :BREAKNO];
        
       
        _addbreak_lbl.text=@"BREAKS";
        _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
    //[self startService:@"UPDATE"];
  [self showDialog:@"Break Updated Successfully." andTitle:@"Breaks"];
//        BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
//        
//        add.COMPETITIONCODE=self.COMPETITIONCODE;
//        add.MATCHCODE=self.MATCHCODE;
//        add.INNINGSNO=self.INNINGSNO;
//        add.MATCHDATE=self.MATCHDATE;
//        add.resultarray=UpdateBreaksArray;
//        
//        //vc2 *viewController = [[vc2 alloc]init];
//        [self addChildViewController:add];
//        add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//        [self.view addSubview:add.view];
//        add.view.alpha = 0;
//        [add didMoveToParentViewController:self];
//        
//        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//         {
//             add.view.alpha = 1;
//         }
//                         completion:nil];
        
        
    }
    
}
-(void) UpdateBreaks:COMPETITIONCODE:INNINGSNO:MATCHCODE:BREAKSTARTTIME:BREAKENDTIME:
       BREAKCOMMENTS:ISINCLUDEDURATION:BREAKNO;
{
    
      if([objDBManager GetMatchCodeForUpdateBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE] !=0)
     {
           if(![objDBManager GetCompetitionCodeForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : ISINCLUDEDURATION : BREAKNO])
          {
            if(![objDBManager GetBreakNoForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKNO ])
             {
    [objDBManager UpdateInningsEvents : BREAKSTARTTIME : BREAKENDTIME : BREAKCOMMENTS : ISINCLUDEDURATION : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
                }
            }
        }
    
    UpdateBreaksArray=[objDBManager GetInningsBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    self.resultarray =UpdateBreaksArray;
    [self.tbl_breaklist reloadData];
    
}


- (IBAction)delete_btn:(id)sender {
    _addbreak_lbl.text=@"BREAKS";
    _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
    self.view_gridview.hidden=NO;
    self.btn_Add.hidden =NO;
    
   BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
   
    [self DeleteBreaks:COMPETITIONCODE :INNINGSNO :MATCHCODE :BREAKCOMMENTS :BREAKNO];
 
    
      [self showDialog:@"Break Deleted Successfully." andTitle:@"Breaks"];
    
    
}


-(void) DeleteBreaks:COMPETITIONCODE:INNINGSNO:MATCHCODE:BREAKCOMMENTS:BREAKNO;

{
    
    
    
    [objDBManager DeleteInningsEvents : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
    
    DeleteBreaksArray=[objDBManager InningsBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
   
    self.resultarray=DeleteBreaksArray;
    
    [self.tbl_breaklist reloadData];
}





- (IBAction)back_btn:(id)sender {
    
    _addbreak_lbl.text=@"BREAKS";
    _addbreak_lbl.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
    if(isShow_BreakrecordTbl == YES)
    {
        [self.delegate ChangeVCBackBtnAction];
       // [self.delegate reloadScoreEnginOnOtherWicket];
    }
    else
    {
        self.view_gridview.hidden=NO;
        isShow_BreakrecordTbl= YES;
        self.btn_Add.hidden =NO;
    }
    

    
//    
//    intialBreakVC*add = [[intialBreakVC alloc]initWithNibName:@"intialBreakVC" bundle:nil];
    
//    BreakVC*add = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
//    add.COMPETITIONCODE=self.COMPETITIONCODE;
//    add.MATCHCODE=self.MATCHCODE;
//    add.INNINGSNO=self.INNINGSNO;
//    add.MATCHDATE=self.MATCHDATE;
//    //vc2 *viewController = [[vc2 alloc]init];
//    [self addChildViewController:add];
//    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//    [self.view addSubview:add.view];
//    add.view.alpha = 0;
//    [add didMoveToParentViewController:self];
//    
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         add.view.alpha = 1;
//     }
//                     completion:nil];
}








- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


//-(void) startService:(NSString *)OPERATIONTYPE{
//    if(self.checkInternetConnection){
//           NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
//        [dateFmt setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
//        NSDate *date = [dateFmt dateFromString:BREAKSTARTTIME];
//        NSLog(@"date:",date);
//        
//        [dateFmt setDateFormat:@"yyyy-MM-dd"];
//        NSString *BREAKSTARTTIME1 = [dateFmt stringFromDate:date];
//        NSLog(@"dateString:",BREAKSTARTTIME1);
//        
//        
//           NSDateFormatter *dateFmt1 = [[NSDateFormatter alloc] init];
//        [dateFmt1 setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
//        NSDate *date1= [dateFmt1 dateFromString:BREAKENDTIME];
//        NSLog(@"date:",date1);
//        
//        [dateFmt1 setDateFormat:@"yyyy-MM-dd"];
//        NSString *BREAKENDTIME1 = [dateFmt1 stringFromDate:date1];
//        NSLog(@"dateString:",BREAKENDTIME1);
//        
//        
//        MATCHCODE = MATCHCODE == nil ?@"NULL":MATCHCODE;
//        COMPETITIONCODE = COMPETITIONCODE == nil ?@"NULL":COMPETITIONCODE;
//        INNINGSNO= INNINGSNO == nil ?@"NULL":INNINGSNO;
//        
//        
//        BREAKSTARTTIME1 = BREAKSTARTTIME1 == nil ?@"NULL":BREAKSTARTTIME1;
//        BREAKENDTIME1 = BREAKENDTIME1 == nil ?@"":BREAKENDTIME1;
//        BREAKCOMMENTS= BREAKCOMMENTS == nil ?@"NULL":BREAKCOMMENTS;
//        ISINCLUDEDURATION = ISINCLUDEDURATION == nil ?@"NULL":ISINCLUDEDURATION;
//        BREAKNO = BREAKNO == nil ?@"NULL":BREAKNO;
//        
//        
//        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        
//        //Show indicator
//        [delegate showLoading];
//                  
//            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETBREAK/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT], COMPETITIONCODE,INNINGSNO,MATCHCODE,BREAKSTARTTIME1,BREAKENDTIME1,BREAKCOMMENTS,ISINCLUDEDURATION,BREAKNO,OPERATIONTYPE];
//            NSLog(@"-%@",baseURL);
//            
//            
//            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            NSURLResponse *response;
//            NSError *error;
//            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            if (responseData != nil) {
//            
//            NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//            
//            if(rootArray !=nil && rootArray.count>0){
//                NSDictionary *valueDict = [rootArray objectAtIndex:0];
//                NSString *success = [valueDict valueForKey:@"DataItem"];
//                if([success isEqual:@"Success"]){
//                    
//                }
//            }else{
//                
//            }
//           
//            [delegate hideLoading];
//            }
//
//        
//       
//    }
//    
//
//}


- (BOOL) formValidation{
    
    
    
    BREAKCOMMENTS=[NSString stringWithFormat:@"%@",[_text_Comments text]];
    BREAKENDTIME =[NSString stringWithFormat:@"%@",[_text_EndBreak text]];
    BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_Text_BreakStart text]];
    
    if(([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil) && ([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil) && ([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil))
    {
        [self showDialog:@"Please Select Start Time\nPlease Select End Time\nPlease Add Comments" andTitle:@"Breaks"];
        return NO;
    }
    
    else if(([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil) && ([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil) )
    {
        [self showDialog:@"Please Select Start Time \n Please Add Comments" andTitle:@"Breaks"];
        return NO;
    }
    else if(([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil) && ([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)  )
    {
        [self showDialog:@"Please Select End Time \n Please Add Comments" andTitle:@"Breaks"];
        return NO;
        
    }
    else if (([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil) &&  ([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil))
    {
        [self showDialog:@"Please Select Start Time \n Please Select End Time" andTitle:@"Breaks"];
        return NO;
        
        
    }
    else
    {
        if([self.Text_BreakStart.text isEqualToString:@""] || self.Text_BreakStart.text==nil)
        {
            [self showDialog:@"Please Select Start Time" andTitle:@"Breaks"];
            return NO;
        }
        else if([self.text_EndBreak.text isEqualToString:@""] || self.text_EndBreak.text==nil)
        {
            [self showDialog:@"Please Select End Time" andTitle:@"Breaks"];
            return NO;
        }
        else if([self.lbl_Duration.text integerValue]<=0){
            [self showDialog:@"Duration should be greated than zero" andTitle:@"Breaks"];
            return NO;
        }
        //    else if([self.lbl_Duration.text isEqualToString:@""] || self.lbl_Duration.text==nil)
        //    {
        //        [self ShowAlterView:@"Duration Not Calculated"];
        //    }
        else if([self.text_Comments.text isEqualToString:@""] || self.text_Comments.text==nil)
        {
            [self showDialog:@"Please Add Comments" andTitle:@"Breaks"];
            return NO;
        }
    }
    
    return YES;
}

-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alertDialog show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
