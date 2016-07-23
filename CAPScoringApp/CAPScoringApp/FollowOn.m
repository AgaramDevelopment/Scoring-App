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
#import "InitializeInningsScoreBoardRecord.h"
#import "DBManager.h"
#import "BowlerEvent.h"
@interface FollowOn ()
{
   BOOL IsStricker ;
   BOOL IsNonStricker;
   BOOL IsBowler ;
    NSMutableArray *CommonArry;
    NSString *followon;
    DBManagerFollowOn *dbFollowOn;
}

@end


@implementation FollowOn
@synthesize TEAMCODE,TEAMNAME,TOTALRUN,TOTALRUNS,OVERNO,OVERBALLNO,OVERSTATUS,BALLNO,BOWLINGTEAMCODE,WICKETS,INNINGSSCORECARD;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dbFollowOn = [[DBManagerFollowOn alloc]init];
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
    
    self.lbl_Teamname.text =self.battingTeamName;
    self.TEAMCODE =self.battingTeamCode;
    self.Tbl_Followon.hidden=YES;
    CommonArry =[[NSMutableArray alloc]init];
   
    followon=[DBManager getFollowOn:self.matchCode :self.compitionCode :self.inningsno];
    if([self.inningsno isEqualToString:@"2"] || [self.inningsno isEqualToString:@"3"])
    {
        if([followon isEqualToString:@"1"])
        {
            
        [self.btn_Proceed setBackgroundColor:[UIColor grayColor]];
        self.btn_Proceed.userInteractionEnabled=NO;
        [self.btn_Revert setBackgroundColor:[UIColor colorWithRed:(255/255.0f) green:(86/255.0f) blue:(88/255.0f) alpha:1.0f]];
        self.btn_Revert.userInteractionEnabled=YES;
            self.lbl_Striker.text=self.strikerName;
            self.lbl_nonStriker.text=self.nonStrikerName;
            self.lbl_Bowler.text =self.bowlerName;
            [self.btn_Striker setHidden:YES];
            [self.btn_nonStriker setHidden:YES];
            [self.btn_Bowler setHidden:YES];
            
        }
        else
        {
            [self.btn_Proceed setBackgroundColor:[UIColor colorWithRed:(16/255.0f) green:(210/255.0f) blue:(158/255.0f) alpha:1.0f]];
            self.btn_Proceed.userInteractionEnabled=YES;
            [self.btn_Revert setBackgroundColor:[UIColor grayColor]];
            self.btn_Revert.userInteractionEnabled=NO;
            [self.btn_Striker setHidden:NO];
            [self.btn_nonStriker setHidden:NO];
            [self.btn_Bowler setHidden:NO];
        }

    }
    else
    {
        [self.btn_Proceed setBackgroundColor:[UIColor grayColor]];
        self.btn_Proceed.userInteractionEnabled=NO;
        [self.btn_Revert setBackgroundColor:[UIColor grayColor]];
         self.btn_Revert.userInteractionEnabled=NO;
    }
    
}
-(IBAction)didClickStrickerSelection:(id)sender
{
    if(IsStricker==NO)
    {
    IsStricker =YES;
    IsNonStricker =NO;
    IsBowler =NO;
    NSMutableArray *objStrickernonstrickerdetail=[dbFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged:self.matchCode :self.battingTeamCode];
    CommonArry =objStrickernonstrickerdetail;
    
    self.Tbl_Followon.hidden=NO;
    self.tbl_FollowonYposition.constant=self.view_striker.frame.origin.y-130;
    [self.Tbl_Followon reloadData];
    }
    else
    {
        self.Tbl_Followon.hidden=YES;
        IsStricker=NO;
    }
    
}
-(IBAction)didClickNonStrickerSelection:(id)sender
{
    if(IsNonStricker==NO)
    {
    IsStricker =NO;
    IsNonStricker =YES;
    IsBowler =NO;
    NSMutableArray *objStrickernonstrickerdetail=[dbFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged:self.matchCode :self.battingTeamCode];
    CommonArry =objStrickernonstrickerdetail;
    
    self.Tbl_Followon.hidden=NO;
    self.tbl_FollowonYposition.constant=self.view_nonStriker.frame.origin.y-130;
    [self.Tbl_Followon reloadData];
    }
    else
    {
       self.Tbl_Followon.hidden=YES;
        IsNonStricker =NO;
    }
}

-(IBAction)didClickBowlerSelection:(id)sender
{
    if(IsBowler== NO)
    {
    IsStricker =NO;
    IsNonStricker =NO;
    IsBowler =YES;
//    NSMutableArray *objBowlingTeamdetail =[dbFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged:self.matchCode :self.BowlingTeamCode];
    CommonArry=self.objBowlingTeamdetail;
    self.Tbl_Followon.hidden=NO;
    self.tbl_FollowonYposition.constant=self.view_Bowler.frame.origin.y-130;
    [self.Tbl_Followon reloadData];
    }
    else
    {
         self.Tbl_Followon.hidden=YES;
          IsBowler =NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickProcessInnings:(id)sender
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
        UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"DO You Want To Enfourced Follow on" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        [objAlter show];
        objAlter.tag = 100;
    }
    
}

-(IBAction)didClickDeleteInnings:(id)sender
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
        UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"DO You Want To Revert Follow on" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        [objAlter show];
        objAlter.tag = 102;
        //[self.delegate RedirectFollowOnPage];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if(alertView.tag==100)
        {
            [self UpdateFollowOn:self.compitionCode :self.matchCode :self.inningsno :TEAMCODE :self.strickerCode :self.nonStrickerCode :self.bowlingPlayercode];
            UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"Follow on has been enforced successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [objAlter show];
            objAlter.tag = 101;
        }
        else if (alertView.tag==101)
        {
            [self.delegate RedirectFollowOnPage];
        }
        else if(alertView.tag==102)
        {
            bool revertstatus = [self DeleteFollowOn:self.compitionCode :self.matchCode :TEAMCODE :self.inningsno];
            if(revertstatus)
            {
                UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"Follow on has been reverted successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [objAlter show];
                objAlter.tag = 103;
            }
            else
            {
                UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"Revert Innings is not possible when the data exist for future Innings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [objAlter show];
            }
        }
        else if (alertView.tag==103)
        {
           [self.delegate RedirectFollowOnPage];
        }

    }
    else if (buttonIndex == 1)
    {
       
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
    
    if(IsBowler==YES)
    {
        BowlerEvent *objBowlerEventRecords=(BowlerEvent *)[CommonArry objectAtIndex:indexPath.row];
        
        cell.textLabel.text = objBowlerEventRecords.BowlerName;
    }
    else
    {
    FollowOnRecords *objFollowOnRecords=(FollowOnRecords *)[CommonArry objectAtIndex:indexPath.row];
    
    cell.textLabel.text = objFollowOnRecords.PLAYERNAME;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.Tbl_Followon.hidden=YES;
    
    if(IsStricker== YES)
    {
        FollowOnRecords* objFollowOnRecords=[CommonArry objectAtIndex:indexPath.row];
        if(![self.lbl_nonStriker.text isEqualToString:objFollowOnRecords.PLAYERNAME])
        {
            self.lbl_Striker.text=objFollowOnRecords.PLAYERNAME;
            self.strickerCode=objFollowOnRecords.PLAYERCODE;
        }
        else{
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Striker and Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];

    }
    }
    else if(IsNonStricker== YES)
    {
        FollowOnRecords* objFollowOnRecords=[CommonArry objectAtIndex:indexPath.row];
        if(![self.lbl_Striker.text isEqualToString:objFollowOnRecords.PLAYERNAME])
        {
            self.lbl_nonStriker.text=objFollowOnRecords.PLAYERNAME;
            self.nonStrickerCode=objFollowOnRecords.PLAYERCODE;
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
        
        BowlerEvent *objBowlerEventRecords=(BowlerEvent *)[CommonArry objectAtIndex:indexPath.row];
            
        self.lbl_Bowler.text = objBowlerEventRecords.BowlerName;
        self.bowlingPlayercode=objBowlerEventRecords.BowlerCode;
    }
 
}
-(IBAction)didClickBackBtn:(id)sender
{
    [self.delegate ChangeVCBackBtnAction];
}
//SP_UPDATEFOLLOWON
-(void) UpdateFollowOn:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) INNINGSNO :(NSString *) TEAMNAME : (NSString *) STRIKER : (NSString *) NONSTRIKER : (NSString *) BOWLER

{
    
    if([INNINGSNO isEqualToString:@"2"])
    {
        if([dbFollowOn GetBallCodeForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO ])
        {
            TOTALRUNS=[dbFollowOn GetTotalRunsForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO];
            
            OVERNO=[dbFollowOn GetOverNoForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO];
            
            BALLNO=[dbFollowOn GetBallNoForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO : OVERNO];
            
            
            OVERSTATUS=[dbFollowOn GetOverStatusForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO: OVERNO];
            
            BOWLINGTEAMCODE=[dbFollowOn GetBowlingTeamCodeForUpdateFollowOn: COMPETITIONCODE:TEAMNAME :  MATCHCODE];
            
            
            if([OVERSTATUS isEqualToString: @"1"])
                OVERBALLNO=  [NSString stringWithFormat:@"%d",OVERNO.intValue +1];
            else
                OVERBALLNO = [NSString stringWithFormat:@"%@.%@" ,OVERNO,BALLNO];
            
            WICKETS=[dbFollowOn GetWicketForUpdateFollowOn:COMPETITIONCODE :MATCHCODE :TEAMNAME :INNINGSNO];
            
         
            [dbFollowOn UpdateInningsEventForInsertScoreBoard:TEAMNAME :TOTALRUNS :OVERNO :WICKETS :@"1" :@"0" :COMPETITIONCODE :MATCHCODE :INNINGSNO];
            
            if(![dbFollowOn GetTeamCodeForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME :INNINGSNO])
            {
                
                [dbFollowOn InsertInningsEventForInsertScoreBoard : COMPETITIONCODE : MATCHCODE :TEAMNAME :INNINGSNO :STRIKER :NONSTRIKER :BOWLER];
                
                INNINGSSCORECARD = [NSString stringWithFormat:@"%d",INNINGSNO.intValue +1];
                
                
                //EXEC SP_INITIALIZEINNINGSSCOREBOARD
                [InitializeInningsScoreBoardRecord InitializeInningsScoreBoard : COMPETITIONCODE : MATCHCODE :TEAMNAME :BOWLINGTEAMCODE :INNINGSSCORECARD :STRIKER :NONSTRIKER : BOWLER : [NSNumber numberWithInt:0]];
            }else{
                    [dbFollowOn UpdateInningsEventInStrickerForInsertScoreBoard: COMPETITIONCODE : MATCHCODE : TEAMNAME : INNINGSNO : STRIKER : NONSTRIKER : BOWLER];
                
            }
           
        }
        
    }
    
}
//SP_DELETEREVERTFOLLOWON


-(bool) DeleteFollowOn:(NSString *) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMNAME:(NSNumber*)INNINGSNO
{
    if(INNINGSNO.intValue ==3)
    {
        if([dbFollowOn GetBallCodeForDeleteFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO].length <= 0)
        {
            [dbFollowOn UpdateInningsEventForDeleteFollowOn: COMPETITIONCODE:  MATCHCODE: INNINGSNO ];
            
            [dbFollowOn DeleteInningsEventForDeleteFollowOn: COMPETITIONCODE:  MATCHCODE: INNINGSNO ];
            //EXEC SP_INITIALIZEINNINGSSCOREBOARD
            [InitializeInningsScoreBoardRecord InitializeInningsScoreBoard : COMPETITIONCODE : MATCHCODE :@"" :@"" :INNINGSNO :@"" :@"" : @"" : [NSNumber numberWithInt:1]];
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    return NO;
}

@end
