//
//  ChanceTeamVCViewController.m
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ChangeTeamVC.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManagerChangeTeam.h"
#import "ChangeTeamRecord.h"
#import "DBManagerChangeTeamInsert.h"
@interface ChangeTeamVC ()
{
    NSMutableArray *catagory;
    DBManagerChangeTeam * objDBManagerChanceTeam;
    NSString * BattingTeamCode ;
    NSString * maximumInnings;
    NSString * Bowlingteamcode;
    NSString * lastOverFetchChangeTeam;
    NSString * objLastballFetchChanceTeam;
    NSString *objlastballCount;
    NSString *selectStrikercode;
    NSString * selectnonStrikercode;
    NSString  * selectBowlercode;
    
    BOOL IsStricker;
    BOOL IsNonStricker;
    BOOL IsBowler;
    
}

@end

@implementation ChangeTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view_SelectTeamName.layer.borderWidth = 1.0;
    self.view_SelectTeamName.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_SelectTeamName .layer.cornerRadius =5.0;
    self.view_SelectTeamName.layer .masksToBounds =YES;
    
    
    self.view_ChangeInnings.layer.borderWidth = 1.0;
    self.view_ChangeInnings.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_ChangeInnings .layer.cornerRadius =5.0;
    self.view_ChangeInnings.layer .masksToBounds =YES;
    
     self.view_Bowler.layer.borderWidth = 1.0;
    self.view_Bowler.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_Bowler .layer.cornerRadius =5.0;
    self.view_Bowler.layer .masksToBounds =YES;
   
    self.view_striker.layer.borderWidth = 1.0;
    self.view_striker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_striker .layer.cornerRadius =5.0;
    self.view_striker.layer .masksToBounds =YES;
    
     self.view_nonstriker.layer.borderWidth = 1.0;
    self.view_nonstriker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
   
    self.view_nonstriker .layer.cornerRadius =5.0;
    self.view_nonstriker.layer .masksToBounds =YES;
    self.tbl_strikerlist.hidden=YES;
    [self.view_Bowler layoutIfNeeded ];
    catagory=[[NSMutableArray alloc]init];
    objDBManagerChanceTeam=[[DBManagerChangeTeam alloc]init];
    maximumInnings =[objDBManagerChanceTeam GetMatchmaxInningsForFetchChangeTeam:self.compitionCode :self.MatchCode];
    
    BattingTeamCode =[objDBManagerChanceTeam GetBattingTeamCodeForFetchChangeTeam:self.compitionCode :self.MatchCode :maximumInnings];
    
     Bowlingteamcode   =[objDBManagerChanceTeam GetBowlingTeamCodeForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode];
    
     lastOverFetchChangeTeam =[objDBManagerChanceTeam GetLastOverForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings];
    objLastballFetchChanceTeam =[objDBManagerChanceTeam GetLastBallForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings :lastOverFetchChangeTeam];
    
    objlastballCount =[objDBManagerChanceTeam GetLastBallCountForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings :lastOverFetchChangeTeam :objLastballFetchChanceTeam];
   
    NSMutableArray * objBattingTeamName=[objDBManagerChanceTeam GetBattingteamAndBowlteamForFetchChangeTeam:BattingTeamCode];
    if(objBattingTeamName.count >0)
    {
    ChangeTeamRecord * objChanceTeamRecord=[objBattingTeamName objectAtIndex:0];
    self.lbl_SelectTeamName.text=objChanceTeamRecord.TEAMNAME;
    self.lbl_ChangeInnings.text =maximumInnings;
    }
   
}

-(IBAction)didClickStrickerSelection:(id)sender
{
   
    if(IsStricker == NO)
    {
    IsStricker =YES;
    IsNonStricker =NO;
    IsBowler =NO;
    NSMutableArray *objStrickernonstrickerdetail=[objDBManagerChanceTeam GetStickerNonStrickerNamesdetailsDetails:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings];
    catagory =objStrickernonstrickerdetail;
    
    self.tbl_strikerlist.hidden=NO;
    self.tbl_yposition.constant=self.view_striker.frame.origin.y-130;
    [_tbl_strikerlist reloadData];
    

    }
    else
    {
         self.tbl_strikerlist.hidden=YES;
        IsStricker =NO;
    }
   
}
-(IBAction)didClickNonStrickerSelection:(id)sender
{
   
    if(IsNonStricker == NO)
    {
    IsStricker =NO;
    IsNonStricker =YES;
    IsBowler =NO;
    NSMutableArray *objStrickernonstrickerdetail=[objDBManagerChanceTeam GetStickerNonStrickerNamesdetailsDetails:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings];
    catagory =objStrickernonstrickerdetail;

        self.tbl_strikerlist.hidden=NO;
        self.tbl_yposition.constant=self.view_nonstriker.frame.origin.y-130;
        [_tbl_strikerlist reloadData];
        
    }
    else
    {
        self.tbl_strikerlist.hidden=YES;
        IsNonStricker=NO;
    }
}

-(IBAction)didClickBowlerSelection:(id)sender
{
    if(IsBowler==NO)
    {
    IsStricker =NO;
    IsNonStricker =NO;
    IsBowler =YES;
     NSMutableArray *objBowlingTeamdetail =[objDBManagerChanceTeam GetBowlingTeamNamesdetailsDetails:self.compitionCode :self.MatchCode :Bowlingteamcode :maximumInnings ];
    catagory=objBowlingTeamdetail;
    self.tbl_strikerlist.hidden=NO;
     self.tbl_yposition.constant=self.view_Bowler.frame.origin.y-130;
     [_tbl_strikerlist reloadData];
    }
    else
    {
        self.tbl_strikerlist.hidden=YES;
        IsBowler=NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickResumeInnings:(id)sender
{
    if([self.lbl_StrikerName.text isEqualToString:@""] || self.lbl_StrikerName.text==nil)
    {
        [self ShowAlterView:@"Please Select Stricker"];
    }
    else if([self.lbl_NonStrikerName.text isEqualToString:@""] || self.lbl_NonStrikerName.text==nil)
    {
        [self ShowAlterView:@"Please Select NonStricker"];
    }
    else if([self.lbl_BowlerName.text isEqualToString:@""] || self.lbl_BowlerName.text==nil)
    {
        [self ShowAlterView:@"Please Select Bowler"];
    }
    else{
        
        [DBManagerChangeTeam InsertChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :[NSNumber numberWithInt:maximumInnings.intValue] :selectStrikercode :selectnonStrikercode :selectBowlercode :[NSNumber numberWithInt:maximumInnings.intValue] :BattingTeamCode :@"" :@""];
        [self.delegate processSuccessful];

    }
   
}

-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(catagory.count >0)
    {
    return [catagory count];
    }
    return NO;
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    ChangeTeamRecord *objChanceTeamRecord=(ChangeTeamRecord *)[catagory objectAtIndex:indexPath.row];
   
    cell.textLabel.text = objChanceTeamRecord.TEAMNAME;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tbl_strikerlist.hidden=YES;
    ChangeTeamRecord* objChanceTeamRecord=[catagory objectAtIndex:indexPath.row];
    if(IsStricker== YES)
    {
        if(![self.lbl_NonStrikerName.text isEqualToString:objChanceTeamRecord.TEAMNAME])
        {
        self.lbl_StrikerName.text=objChanceTeamRecord.TEAMNAME;
        selectStrikercode=objChanceTeamRecord.TEAMCODE;
    }
    else if(IsNonStricker== YES)
    {
        if(![self.lbl_StrikerName.text isEqualToString:objChanceTeamRecord.TEAMNAME])
        {
           self.lbl_NonStrikerName.text=objChanceTeamRecord.TEAMNAME;
            selectnonStrikercode=objChanceTeamRecord.TEAMCODE;
        }
        else{
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Striker and Non Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];

        }
    }
    else if(IsBowler== YES)
    {
        self.lbl_BowlerName.text=objChanceTeamRecord.TEAMNAME;
        selectBowlercode=objChanceTeamRecord.TEAMCODE;
    }
    
    }
}
-(IBAction)didClickBackBtnAction:(id)sender
{
    [self.delegate ChangeVCBackBtnAction];
}

// insertChanceTeam
    
    @end
