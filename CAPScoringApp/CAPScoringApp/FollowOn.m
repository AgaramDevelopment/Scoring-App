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
}

@end

@implementation FollowOn
@synthesize TEAMCODE,TEAMNAME,TOTALRUN,TOTALRUNS,OVERNO,OVERBALLNO,OVERSTATUS,BALLNO,BOWLINGTEAMCODE,WICKETS,INNINGSSCORECARD;

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
    NSMutableArray *objStrickernonstrickerdetail=[DBManagerFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged:self.matchCode :self.battingTeamCode];
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
    NSMutableArray *objStrickernonstrickerdetail=[DBManagerFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged:self.matchCode :self.battingTeamCode];
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
//    NSMutableArray *objBowlingTeamdetail =[DBManagerFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged:self.matchCode :self.BowlingTeamCode];
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
        [self UpdateFollowOn:self.compitionCode :self.matchCode :self.inningsno :TEAMCODE :self.strickerCode :self.nonStrickerCode :self.bowlingPlayercode];
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
        [self DeleteFollowOn:self.compitionCode :self.matchCode :TEAMCODE :self.inningsno];
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
            UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"Follow on has been Enfourced Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [objAlter show];
            objAlter.tag = 101;
        }
        else if (alertView.tag==101)
        {
            [self.delegate RedirectFollowOnPage];
        }
        else if(alertView.tag==102)
        {
            UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:@"Follow on has been Revert Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [objAlter show];
            objAlter.tag = 103;
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

//SP_UPDATEFOLLOWON
-(void) UpdateFollowOn:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) INNINGSNO :(NSString *) TEAMNAME : (NSString *) STRIKER : (NSString *) NONSTRIKER : (NSString *) BOWLER

{
    
    if([INNINGSNO isEqualToString:@"2"])
    {
        if([DBManagerFollowOn GetBallCodeForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO ])
        {
            
            TEAMCODE=[DBManagerFollowOn GetTeamNamesForUpdateFollowOn:TEAMNAME];
            
            TOTALRUNS=[DBManagerFollowOn GetTotalRunsForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO];
            
            OVERNO=[DBManagerFollowOn GetOverNoForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO];
            
           // BALLNO=[DBManagerFollowOn GetBallNoForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME : OVERNO :INNINGSNO];
            
            
            OVERSTATUS=[DBManagerFollowOn GetOverStatusForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO: OVERNO];
            
            BOWLINGTEAMCODE=[DBManagerFollowOn GetBowlingTeamCodeForUpdateFollowOn: COMPETITIONCODE:TEAMNAME :  MATCHCODE];
            
            
            if([OVERSTATUS isEqualToString: @"1"])
            {
                
                OVERBALLNO=  [NSString stringWithFormat:@"%d",OVERNO.intValue +1];
            }
            else
            {
                
                OVERBALLNO = [NSString stringWithFormat:@"%@.%@" ,OVERNO,BALLNO];
                
            }
            
            WICKETS=[DBManagerFollowOn GetWicketForUpdateFollowOn:COMPETITIONCODE :MATCHCODE :TEAMNAME :INNINGSNO];
            
         
            [DBManagerFollowOn UpdateInningsEventForInsertScoreBoard:TEAMNAME :TOTALRUNS :OVERNO :WICKETS :self.inningsStatus :followon :COMPETITIONCODE :MATCHCODE :INNINGSNO];
            
            if(![DBManagerFollowOn GetTeamCodeForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMNAME :INNINGSNO])
            {
                
                [DBManagerFollowOn InsertInningsEventForInsertScoreBoard : COMPETITIONCODE : MATCHCODE :TEAMCODE :INNINGSNO :STRIKER :NONSTRIKER :BOWLER];
                
                INNINGSSCORECARD = [NSString stringWithFormat:@"%d",INNINGSNO.intValue +1];
                
                
                //EXEC SP_INITIALIZEINNINGSSCOREBOARD
                [InitializeInningsScoreBoardRecord InitializeInningsScoreBoard : COMPETITIONCODE : MATCHCODE :_battingTeamCode :BOWLINGTEAMCODE :INNINGSNO :_strickerCode :_nonStrickerCode : _BowlingTeamCode : [NSNumber numberWithInt:0]];
                

               
                
            }else{
                    [DBManagerFollowOn UpdateInningsEventInStrickerForInsertScoreBoard: COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : STRIKER : NONSTRIKER : BOWLER];
                
            }
//                [self UpdatePlayers:self.compitionCode :self.matchCode :INNINGSNO :self.battingTeamCode :self.BowlingTeamCode :self.strickerCode :self.nonStrickerCode :self.bowlingPlayercode];
           
            
          
           
        }
        
    }
    
}
//SP_DELETEREVERTFOLLOWON


-(void ) DeleteFollowOn:(NSString *) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMNAME:(NSNumber*)INNINGSNO
{
    
    
    if(INNINGSNO.intValue ==3)
    {
        if([DBManagerFollowOn GetBallCodeForDeleteFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO ])
        {
            [DBManagerFollowOn UpdateInningsEventForDeleteFollowOn: COMPETITIONCODE:  MATCHCODE: INNINGSNO ];
            
            [DBManagerFollowOn DeleteInningsEventForDeleteFollowOn: COMPETITIONCODE:  MATCHCODE: INNINGSNO ];
            
            
            //EXEC  SP_INITIALIZEINNINGSSCOREBOARD
            
            
            [self UpdatePlayers:self.compitionCode :self.matchCode :self.inningsno :self.battingTeamCode :self.BowlingTeamCode :self.strickerCode :self.nonStrickerCode :self.bowlingPlayercode];
            
        }
        
    }
    
}
-(void) UpdatePlayers:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString *)STRIKERCODE:(NSString *)NONSTRIKERCODE:(NSString *)BOWLERCODE
{
    
    if(![DBManager GetBallCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO] && ![DBManager GetWicketTypeForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO])
    {
        [DBManager deleteBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
        
        [DBManager deleteInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
        
        [DBManager deleteBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
        
        
        if (_ISINNINGSREVERT == 0) {
            
            [DBManager insertBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO STRIKERCODE:STRIKERCODE];
            
            [DBManager insertBattingSummaryNonStricker:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO NONSTRIKERCODE:NONSTRIKERCODE];
            
            
            [DBManager insertInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO];
            
            [DBManager insertBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO BOWLERCODE:BOWLERCODE];
            
        }
        
    }
    else
    {
        [DBManager DeleteBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
        
        [DBManager DeleteBowlingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO];
        
        
        if(![DBManager GetStrikerDetailBallCodeForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: STRIKERCODE: NONSTRIKERCODE])
        {
            
            _STRIKERPOSITIONNO = [DBManager GetStrikerDetailsBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
            
            [DBManager InsertBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : _STRIKERPOSITIONNO :STRIKERCODE];
            
            
        }else{
            
            if ([DBManager GetBatsmanCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE]) {
                
                [DBManager UpdateBattingSummaryInStrickerDetailsForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERCODE : NONSTRIKERCODE ];
            }
            
        }
        
        
        if([DBManager GetBatsmanCodeInUpdateBattingSummaryForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE])
        {
            [DBManager UpdateBattingSummaryAndWicketEventInStrickerDetailsForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERCODE : NONSTRIKERCODE];
            
        }
        
        if(![DBManager GetNonStrikerDetailsForBallCode : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO: NONSTRIKERCODE])
        {
            _NONSTRIKERPOSITIONNO=[DBManager GetNonStrikerDetailsForBattingSummary:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
            
            [DBManager InsertBattingSummaryForPlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : _NONSTRIKERPOSITIONNO: NONSTRIKERCODE];
        }
        if(![DBManager GetBowlerDetailsForBallCode :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: BOWLERCODE ])
        {
            _BOWLERPOSITIONNO=[DBManager GetBowlerDetailsForBowlingSummary:COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO];
            
            [DBManager InsertBowlingSummaryForPlayers :COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO : _BOWLERPOSITIONNO: BOWLERCODE];
            
        }
        
        
    }
    
    [DBManager UpdateInningsEventsForPlayers :STRIKERCODE : NONSTRIKERCODE : BOWLERCODE: COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    
}


@end
