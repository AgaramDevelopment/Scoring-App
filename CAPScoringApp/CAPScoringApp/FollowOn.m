//
//  FollowOn.m
//  CAPScoringApp
//
//  Created by mac on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FollowOn.h"
#import "DBManagerFollowOn.h"
#import "FollowOnRecords.h"

@interface FollowOn ()
{
   BOOL IsStricker ;
   BOOL IsNonStricker;
   BOOL IsBowler ;
    NSMutableArray *CommonArry;
}

@end

@implementation FollowOn

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view_teamName.layer.borderWidth = 1.0;
    self.view_teamName.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_teamName .layer.cornerRadius =5.0;
    self.view_teamName.layer .masksToBounds =YES;
    
    
    self.view_striker.layer.borderWidth = 1.0;
    self.view_striker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_striker .layer.cornerRadius =5.0;
    self.view_striker.layer .masksToBounds =YES;
    
    self.view_nonStriker.layer.borderWidth = 1.0;
    self.view_nonStriker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_nonStriker .layer.cornerRadius =5.0;
    self.view_nonStriker.layer .masksToBounds =YES;
    
    self.view_Bowler.layer.borderWidth = 1.0;
    self.view_Bowler.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_Bowler .layer.cornerRadius =5.0;
    self.view_Bowler.layer .masksToBounds =YES;
    
   
    self.Tbl_Followon.hidden=YES;
    CommonArry =[[NSMutableArray alloc]init];
    
}
-(IBAction)didClickStrickerSelection:(id)sender
{
    IsStricker =YES;
    IsNonStricker =NO;
    IsBowler =NO;
    NSMutableArray *objStrickernonstrickerdetail=[DBManagerFollowOn GetteamDetailsForFetchFollowOn:self.matchCode :self.battingTeamCode];
    CommonArry =objStrickernonstrickerdetail;
    
    self.Tbl_Followon.hidden=NO;
    self.tbl_FollowonYposition.constant=self.view_striker.frame.origin.y-130;
    [self.Tbl_Followon reloadData];
    
}
-(IBAction)didClickNonStrickerSelection:(id)sender
{
    IsStricker =NO;
    IsNonStricker =YES;
    IsBowler =NO;
    NSMutableArray *objStrickernonstrickerdetail=[DBManagerFollowOn GetteamDetailsForFetchFollowOn:self.matchCode :self.battingTeamCode];
    CommonArry =objStrickernonstrickerdetail;
    
    self.Tbl_Followon.hidden=NO;
    self.tbl_FollowonYposition.constant=self.view_nonStriker.frame.origin.y-130;
    [self.Tbl_Followon reloadData];
}

-(IBAction)didClickBowlerSelection:(id)sender
{
    IsStricker =NO;
    IsNonStricker =NO;
    IsBowler =YES;
    NSMutableArray *objBowlingTeamdetail =[DBManagerFollowOn GetteamDetailsForFetchFollowOn:self.matchCode :self.BowlingTeamCode];
    CommonArry=objBowlingTeamdetail;
    self.Tbl_Followon.hidden=NO;
    self.tbl_FollowonYposition.constant=self.view_Bowler.frame.origin.y-130;
    [self.Tbl_Followon reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickResumeInnings:(id)sender
{
    if([self.lbl_Striker.text isEqualToString:@""] || self.lbl_Striker.text==nil)
    {
        [self ShowAlterView:@"Please Select Stricker"];
    }
    else if([self.lbl_nonStriker.text isEqualToString:@""] || self.lbl_nonStriker.text==nil)
    {
        [self ShowAlterView:@"Please Select NonStricker"];
    }
    else if([self.lbl_Bowler.text isEqualToString:@""] || self.lbl_Bowler.text==nil)
    {
        [self ShowAlterView:@"Please Select Bowler"];
    }
    else{
//        [self InsertChangeTeam:self.compitionCode :self.MatchCode :BattingTeamCode :[NSNumber numberWithInt:maximumInnings.intValue] :_lbl_StrikerName.text :_lbl_NonStrikerName.text :_lbl_BowlerName.text :[NSNumber numberWithInt:maximumInnings.intValue] :BattingTeamCode :@"" :@""];
        [self.delegate RedirectFollowOnPage];
        
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
    
    if(CommonArry.count >0)
    {
        return [CommonArry count];
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
    
    FollowOnRecords *objFollowOnRecords=(FollowOnRecords *)[CommonArry objectAtIndex:indexPath.row];
    
    cell.textLabel.text = objFollowOnRecords.TEAMNAME;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.Tbl_Followon.hidden=YES;
    FollowOnRecords* objFollowOnRecords=[CommonArry objectAtIndex:indexPath.row];
    if(IsStricker== YES)
    {
        self.lbl_Striker.text=objFollowOnRecords.TEAMNAME;
    }
    else if(IsNonStricker== YES)
    {
        if(![self.lbl_Striker.text isEqualToString:objFollowOnRecords.TEAMNAME])
        {
            self.lbl_nonStriker.text=objFollowOnRecords.TEAMNAME;
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
        self.lbl_Bowler.text=objFollowOnRecords.TEAMNAME;
    }
    
}


@end
