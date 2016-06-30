//
//  ChanceTeamVCViewController.m
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ChanceTeamVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ArchivesVC.h"
#import "DBManagerChanceTeam.h"
#import "ChanceTeamRecord.h"
@interface ChanceTeamVC ()
{
    NSMutableArray *catagory;
    DBManagerChanceTeam * objDBManagerChanceTeam;
    NSString * BattingTeamCode ;
    NSString * maximumInnings;
    NSString * Bowlingteamcode;
    NSString * lastOverFetchChangeTeam;
    NSString * objLastballFetchChanceTeam;
    NSString *objlastballCount;
    BOOL IsStricker;
    BOOL IsNonStricker;
    BOOL IsBowler;
    
}

@end

@implementation ChanceTeamVC

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
    objDBManagerChanceTeam=[[DBManagerChanceTeam alloc]init];
    maximumInnings =[objDBManagerChanceTeam GetMatchmaxInningsForFetchChangeTeam:self.compitionCode :self.MatchCode];
    
    BattingTeamCode =[objDBManagerChanceTeam GetBattingTeamCodeForFetchChangeTeam:self.compitionCode :self.MatchCode :maximumInnings];
    
     Bowlingteamcode   =[objDBManagerChanceTeam GetBowlingTeamCodeForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode];
    
     lastOverFetchChangeTeam =[objDBManagerChanceTeam GetLastOverForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings];
    objLastballFetchChanceTeam =[objDBManagerChanceTeam GetLastBallForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings :lastOverFetchChangeTeam];
    
    objlastballCount =[objDBManagerChanceTeam GetLastBallCountForFetchChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :maximumInnings :lastOverFetchChangeTeam :objLastballFetchChanceTeam];
   
    NSMutableArray * objBattingTeamName=[objDBManagerChanceTeam GetBattingteamAndBowlteamForFetchChangeTeam:BattingTeamCode];
    
    ChanceTeamRecord * objChanceTeamRecord=[objBattingTeamName objectAtIndex:0];
    self.lbl_SelectTeamName.text=objChanceTeamRecord.TEAMNAME;
    self.lbl_ChangeInnings.text =maximumInnings;
   
}

-(IBAction)didClickStrickerSelection:(id)sender
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
-(IBAction)didClickNonStrickerSelection:(id)sender
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

-(IBAction)didClickBowlerSelection:(id)sender
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
        ArchivesVC * objArchiveVC=[[ArchivesVC alloc]init];
        objArchiveVC=(ArchivesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
       
        objArchiveVC.CompitionCode=self.compitionCode;
        [self.navigationController pushViewController:objArchiveVC animated:YES];
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
    
    ChanceTeamRecord *objChanceTeamRecord=(ChanceTeamRecord *)[catagory objectAtIndex:indexPath.row];
   
    cell.textLabel.text = objChanceTeamRecord.TEAMNAME;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tbl_strikerlist.hidden=YES;
    ChanceTeamRecord* objChanceTeamRecord=[catagory objectAtIndex:indexPath.row];
    if(IsStricker== YES)
    {
        self.lbl_StrikerName.text=objChanceTeamRecord.TEAMNAME;
    }
    else if(IsNonStricker== YES)
    {
        if(![self.lbl_StrikerName.text isEqualToString:objChanceTeamRecord.TEAMNAME])
        {
           self.lbl_NonStrikerName.text=objChanceTeamRecord.TEAMNAME;
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
    }
    
}
@end
