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

@interface EndInningsVC ()
{
    NSDateFormatter *formatter;
}
@end
EndInnings *end;
NSMutableArray *endInningsArray;
@implementation EndInningsVC
@synthesize MATCHCODE;
EndInnings *innings;
BOOL IsBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IsBack = NO;
    
    [self.btn_save addTarget:self action:@selector(btn_save:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lbl_thirdnFourthInnings.hidden = YES;
    
     innings = [[EndInnings alloc]init];
    MATCHCODE = @"IMSC02200224DB2663B00003";
    endInningsArray = [[NSMutableArray alloc]init];
   endInningsArray = [DBManagerEndInnings FetchEndInningsDetailsForFetchEndInnings: MATCHCODE];
    
   
    //self.view_allControls.hidden = YES;
    
   
    
  [innings fetchEndInnings:@"UCC0000004" :@"IMSC02200224DB2663B00003" :@"TEA0000024":@"1"];
    
    
    
    //EndInningsVC *endInnings = [[EndInningsVC alloc]init];
    
//    [innings InsertEndInnings:@"UCC0000004" :@"IMSC02200224DB2663B00003" :@"TEA0000024" :@"TEA0000022" :@"1" :@"2015-10-15 12:04:00" :@"2015-10-16 12:05:00" :@"49" :@"249" :@"8" :@"SAVE"];
    
    
    

    
    self.lbl_teamName.text = innings.TEAMNAME;
    self.lbl_runScored.text = [NSString stringWithFormat:@"%@", innings.TOTALRUNS];
    self.lbl_overPlayed.text = innings.OVERNO;
    self.lbl_wktLost.text = innings.WICKETS;
    self.lbl_innings.text = innings.INNINGSNO;
    
    
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
    
}

-(void)duration{
    
NSDate *date1 = [formatter dateFromString:self.txt_startInnings];
NSDate *date2 = [formatter dateFromString:self.txt_endInnings];

NSTimeInterval timeDifference = [date1 timeIntervalSinceDate:date2];
double days = timeDifference / 1440;
NSString *Duration = [NSString stringWithFormat:@"%.20f", days];

self.lbl_duration.text=[NSString stringWithFormat:@"%.20f", Duration];

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
    
    
    [_btn_save setTitle:@"UPDATE" forState:UIControlStateNormal];

    
}


- (IBAction)btn_save:(id)sender {
    
    self.view_allControls.hidden = YES;
    
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

- (IBAction)btn_delete:(id)sender {
    

    
    innings = [[EndInnings alloc]init];
    
   [innings DeleteEndInnings:@"UCC0000004" :@"IMSC02200224DB2663B00003" :@"TEA0000024":@"1"];
    
    
}
@end
