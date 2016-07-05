//
//  ChanceTossVC.m
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ChangeTossVC.h"
#import "FetchBattingTeamTossRecord.h"
#import "DBManagerChangeToss.h"
#import "TossDetailRecord.h"
#import "TossTeamDetailRecord.h"
#import "InitializeInningsScoreBoardRecord.h"
#import "DBManager.h"


@interface ChangeTossVC ()
{
    NSMutableArray * catagory;
    //DBManagerChangeToss * objDBManagerChangeToss;
    NSMutableArray * TossDetailArray;
   // NSMutableArray *TeamDetailToss;
    
     BOOL isTossWon;
     BOOL isElectedTo;
     BOOL isStricker;
     BOOL isNonStricker;
     BOOL isBowler;
    
    
    NSString *selectTeam;
    NSString *selectTeamcode;
    
    NSString * selectedElected;
    NSString *electedcode;
    
    NSString *selectStriker;
    NSString *StrikerCode;
    
    NSString *selectNonStriker;
    NSString *NonStrikerCode;
    
    NSString *selectBowler;
    NSString*selectBowlerCode;
    
    NSString *teamaCode;
    NSString *teambCode;
    
    NSString * BOWLCOMPUTESHOW;
    int selectTeamindex;
    
    NSString* BowlingEnd;
    
    
    NSMutableArray *TeamDetailTossWon;
    NSMutableArray *objElectedTodetailArray;
    NSMutableArray *objStrickerdetail;
    NSMutableArray *objNonStrikerdetail;
    NSMutableArray *objBowlingTeamdetail;

}

@end

@implementation ChangeTossVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view_TossWon.layer.borderWidth = 1.0;
    self.view_TossWon.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_TossWon .layer.cornerRadius =5.0;
    self.view_TossWon.layer .masksToBounds =YES;
    
    
    self.view_ElectedTo.layer.borderWidth = 1.0;
    self.view_ElectedTo.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_ElectedTo .layer.cornerRadius =5.0;
    self.view_ElectedTo.layer .masksToBounds =YES;
    
    self.view_Stricker.layer.borderWidth = 1.0;
    self.view_Stricker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_Stricker .layer.cornerRadius =5.0;
    self.view_Stricker.layer .masksToBounds =YES;
    
    self.view_NonStricker.layer.borderWidth = 1.0;
    self.view_NonStricker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_NonStricker .layer.cornerRadius =5.0;
    self.view_NonStricker.layer .masksToBounds =YES;
    
    self.view_Bowler.layer.borderWidth = 1.0;
    self.view_Bowler.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_Bowler .layer.cornerRadius =5.0;
    self.view_Bowler.layer .masksToBounds =YES;

     self.Tbl_toss.hidden=YES;
    catagory =[[NSMutableArray alloc]init];
    TeamDetailTossWon =[[NSMutableArray alloc]init];
    objElectedTodetailArray=[[NSMutableArray alloc]init];
    objStrickerdetail =[[NSMutableArray alloc]init];
    objNonStrikerdetail=[[NSMutableArray alloc]init];
    objBowlingTeamdetail =[[NSMutableArray alloc]init];
    TossDetailArray=[[NSMutableArray alloc]init];
    TossDetailArray=[DBManagerChangeToss GetTossDetails];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.Btn_Nearend setTag:0];
    [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
    
    
    
    
   // [self.Btn_Nearend setBackgroundImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
    BowlingEnd=@"MSC150";
    [self.Btn_Nearend addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_FairEnd setTag:1];
    [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
   // [self.Btn_FairEnd setBackgroundImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];[self.Btn_FairEnd setBackgroundImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateSelected];
    [self.Btn_FairEnd addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)radiobuttonSelected:(id)sender{
    switch ([sender tag]) {
        case 0:
            if([self.Btn_Nearend isSelected]==YES)
                
            {   BowlingEnd=@"MSC151";
                [self.Btn_Nearend setSelected:NO];
                [self.Btn_FairEnd setSelected:YES];
            }
            else{
                BowlingEnd=@"MSC150";
                [self.Btn_Nearend setSelected:YES];
                [self.Btn_FairEnd setSelected:NO];
            }
            
            break;
        case 1:
            if([self.Btn_FairEnd isSelected]==YES)
                
            {   BowlingEnd=@"MSC150";
                [self.Btn_FairEnd setSelected:NO];
                [self.Btn_Nearend setSelected:YES];
                
            }
            else{
                BowlingEnd=@"MSC151";
                [self.Btn_FairEnd setSelected:YES];
                [self.Btn_Nearend setSelected:NO];
            }
            
            break;
        default:
            break;
    }
    
}

-(IBAction)didClickTossWonSelection:(id)sender
{
     isTossWon=YES;
     isElectedTo=NO;
     isStricker=NO;
     isNonStricker=NO;
     isBowler=NO;
    TeamDetailTossWon=[DBManagerChangeToss GetTeamDetailsForToss:self.matchCode];
    catagory =TeamDetailTossWon;
    
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_TossWon.frame.origin.y-30;
    [self.Tbl_toss reloadData];
    
}
-(IBAction)didClickElectedToSelection:(id)sender
{
    isTossWon=NO;
    isElectedTo=YES;
    isStricker=NO;
    isNonStricker=NO;
    isBowler=NO;
    objElectedTodetailArray =[DBManagerChangeToss GetTossDetails ];
    catagory =objElectedTodetailArray;
    
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_ElectedTo.frame.origin.y-30;
    [self.Tbl_toss reloadData];
}

-(IBAction)didClickStrikerSelection:(id)sender
{
    
    isTossWon=NO;
    isElectedTo=NO;
    isStricker=YES;
    isNonStricker=NO;
    isBowler=NO;
     FetchBattingTeamTossRecord * objFetchBattingTeamTossRecord ;
    if([selectedElected isEqualToString:@"Bat"])
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex];

     teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
    }
    else if(selectTeamindex==0)
    {
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex+1];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
    }
    if(selectTeamindex==1)
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex-1];
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
    }

   objStrickerdetail =[DBManagerChangeToss StrikerNonstriker:self.matchCode :teamaCode ];

    catagory=objStrickerdetail;
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_Stricker.frame.origin.y-30;
    [self.Tbl_toss reloadData];
}

-(IBAction)didClickNonStrikerSelection:(id)sender
{
    isTossWon=NO;
    isElectedTo=NO;
    isStricker=NO;
    isNonStricker=YES;
    isBowler=NO;
    FetchBattingTeamTossRecord * objFetchBattingTeamTossRecord ;
    if([selectedElected isEqualToString:@"Bat"])
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
        //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
    }
    else if(selectTeamindex==0)
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex+1];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
    }
    if(selectTeamindex==1)
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex-1];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
       // teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
    }
    objNonStrikerdetail =[DBManagerChangeToss StrikerNonstriker:self.matchCode :teamaCode];
    catagory=objNonStrikerdetail;
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_NonStricker.frame.origin.y-30;
    [self.Tbl_toss reloadData];
}
-(IBAction)didClickBowlerSelection:(id)sender
{
    
    isTossWon=NO;
    isElectedTo=NO;
    isStricker=NO;
    isNonStricker=NO;
    isBowler=YES;
    FetchBattingTeamTossRecord * objFetchBattingTeamTossRecord ;
    if([selectedElected isEqualToString:@"Bat"])
    {
        
        
        if(selectTeamindex==0)
        {
            objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex+1];
            
            teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
            //teambCode=[[TossDetailArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        }
        if(selectTeamindex==1)
        {
            objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex-1];
            
            teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
            //teambCode=[[TossDetailArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        }
        
        //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
    }
    else{
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teambCode=[[TossDetailArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
       
        
    }

    objBowlingTeamdetail =[DBManagerChangeToss StrikerNonstriker:self.matchCode :teamaCode];
    catagory=objBowlingTeamdetail;
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_Bowler.frame.origin.y-30;
    [self.Tbl_toss reloadData];
}

-(IBAction)didClickChangeToss:(id)sender
{
        if([self.lbl_Tosswon.text isEqualToString:@""] || self.lbl_Tosswon.text==nil)
        {
            [self ShowAlterView:@"Please Select Stricker"];
        }
        else if([self.lbl_ElectedTo.text isEqualToString:@""] || self.lbl_ElectedTo.text==nil)
        {
            [self ShowAlterView:@"Please Select NonStricker"];
        }
        else if([self.lbl_Stricker.text isEqualToString:@""] || self.lbl_Stricker.text==nil)
        {
            [self ShowAlterView:@"Please Select Bowler"];
        }
        else if([self.lbl_NonStricker.text isEqualToString:@""] || self.lbl_NonStricker.text==nil)
        {
            [self ShowAlterView:@"Please Select Bowler"];
        }
        else if([self.lbl_Bowler.text isEqualToString:@""] || self.lbl_Bowler.text==nil)
        {
            [self ShowAlterView:@"Please Select Bowler"];
        }
        else{
            [self InsertTossDetails:self.CompitisonCode :self.matchCode:selectTeamcode :electedcode :StrikerCode :NonStrikerCode :selectBowlerCode :BowlingEnd];
            [self.delegate RedirectScorEngin];
            
        }
    
}

-(IBAction)didClickBackBtnAction:(id)sender
{
    [self.delegate ChangeVCBackBtnAction];
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
    else if (isTossWon==YES)
    {
         return [TeamDetailTossWon count];
    }
    else if (isElectedTo == YES)
    {
         return [objElectedTodetailArray count];
    }
    else if (isStricker == YES)
    {
        return [objStrickerdetail count];
    }
    else if (isNonStricker == YES)
    {
        return [objNonStrikerdetail count];
    }
    else if (isBowler == YES)
    {
        return [objBowlingTeamdetail count];
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
    
    
    if(isTossWon ==YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
      cell.textLabel.text = objChanceTeamRecord.TEAMNAME_TOSSWONBY;
    }
    else if (isElectedTo == YES)
    {
        TossDetailRecord * objTossDetailRecord =(TossDetailRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objTossDetailRecord.METASUBCODEDESCRIPTION;
    }
    else if (isStricker == YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objChanceTeamRecord.playerName;

    }
    else if (isNonStricker == YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objChanceTeamRecord.playerName;
    }
    else if (isBowler ==YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objChanceTeamRecord.playerName;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.Tbl_toss.hidden=YES;
    FetchBattingTeamTossRecord* objChangeTossRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
    if(isTossWon== YES)
    {
        
        self.lbl_Tosswon.text=objChangeTossRecord.TEAMNAME_TOSSWONBY;
        selectTeam= self.lbl_Tosswon.text;
        selectTeamcode=objChangeTossRecord.TEAMCODE_TOSSWONBY;
    }
    else if(isElectedTo== YES)
    {
         TossDetailRecord* objChangeTossRecord=(TossDetailRecord *)[catagory objectAtIndex:indexPath.row];
        self.lbl_ElectedTo.text =objChangeTossRecord.METASUBCODEDESCRIPTION;
        selectedElected=self.lbl_ElectedTo.text;
        electedcode=objChangeTossRecord.METASUBCODE;
    }
    else if(isStricker== YES)
    {
        self.lbl_Stricker.text=objChangeTossRecord.playerName;
        
        selectStriker=self.lbl_Stricker.text;
        StrikerCode=objChangeTossRecord.playerCode;
    }
    else if(isNonStricker== YES)
    {
       
        if(![self.lbl_Stricker.text isEqualToString: objChangeTossRecord.playerName])
        {
            self.lbl_NonStricker.text =objChangeTossRecord.playerName;
            selectNonStriker=self.lbl_NonStricker.text;
            
            NonStrikerCode=objChangeTossRecord.playerCode;
           
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Striker and Non Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];
        }

    }
    else if(isBowler== YES)
    {
        self.lbl_Bowler.text =objChangeTossRecord.playerName;
        selectBowler=self.lbl_Bowler.text;
        
        selectBowlerCode=objChangeTossRecord.playerCode;
       
    }
    
}

-(void) InsertTossDetails:(NSString*) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) TOSSWONTEAMCODE:(NSString *) ELECTEDTO:(NSString *) STRIKERCODE:(NSString *) NONSTRIKERCODE:(NSString *)BOWLERCODE:(NSString *)BOWLINGEND
{
    NSString* BOWLINGTEAMCODE ;
    NSString* BATTINGTEAMCODE ;
    NSString* MAXINNINGSNO ;
    
    if(ELECTEDTO.length>0 && ![ELECTEDTO.uppercaseString isEqual: @"SELECT"])
    {
        if([ELECTEDTO isEqual:@"MSC017"])
        {
            NSMutableArray *TossDetailsArray=[DBManagerChangeToss GetTossDetailsForBattingTeam : TOSSWONTEAMCODE : COMPETITIONCODE : MATCHCODE];
            TossTeamDetailRecord * objTossteam;
            if(TossDetailsArray.count > 0)
            {
                objTossteam=(TossTeamDetailRecord *)[TossDetailsArray objectAtIndex:0];
                BATTINGTEAMCODE=objTossteam.BattingTeamcode;
               
                BOWLINGTEAMCODE=objTossteam.BowlingTeamCode;
            }
        }
        else
        {
            NSMutableArray *TossWonTeamDetailsArray=[DBManagerChangeToss GetTossDetailsForBowlingTeam : TOSSWONTEAMCODE : COMPETITIONCODE : MATCHCODE];
            TossTeamDetailRecord * objTossteam;
            if(TossWonTeamDetailsArray.count>0)
            {
                objTossteam=(TossTeamDetailRecord *)[TossWonTeamDetailsArray objectAtIndex:0];
                BATTINGTEAMCODE=objTossteam.BattingTeamcode;
               
                BOWLINGTEAMCODE=objTossteam.BowlingTeamCode;

            }
        }
    }
    else
    {
        NSMutableArray *TossWonTeamArray=[DBManagerChangeToss GetTossDetailsForTeam : TOSSWONTEAMCODE : COMPETITIONCODE : MATCHCODE];
         TossTeamDetailRecord * objTossteam;
        if(TossWonTeamArray > 0)
        {
            objTossteam=(TossTeamDetailRecord *)[TossWonTeamArray objectAtIndex:0];
            BATTINGTEAMCODE=objTossteam.BattingTeamcode;
            BOWLINGTEAMCODE=objTossteam.BowlingTeamCode;
        }
    }
    if(![DBManagerChangeToss GetMatchEventsForTossDetails : COMPETITIONCODE : MATCHCODE])
    {
        [DBManagerChangeToss SetMatchEventsForToss : COMPETITIONCODE : MATCHCODE : TOSSWONTEAMCODE : ELECTEDTO : BATTINGTEAMCODE : BOWLINGTEAMCODE];
    }
    MAXINNINGSNO = [DBManagerChangeToss GetMaxInningsNoForTossDetails : COMPETITIONCODE : MATCHCODE];
    
    [DBManagerChangeToss SetInningsEventsForToss : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : STRIKERCODE : NONSTRIKERCODE: BOWLERCODE : BOWLINGEND];
    
    [DBManagerChangeToss UpdateMatchStatusForToss : COMPETITIONCODE : MATCHCODE];
    
    //EXEC [SP_INITIALIZEINNINGSSCOREBOARD]
     [self UpdatePlayers:self.CompitisonCode :self.matchCode :MAXINNINGSNO :BATTINGTEAMCODE :BOWLINGTEAMCODE :StrikerCode :NonStrikerCode :selectBowlerCode];
    
}


-(void) UpdatePlayers:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString *)STRIKERCODE:(NSString *)NONSTRIKERCODE:(NSString *)BOWLERCODE
{
    
    if(![DBManager GetBallCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO] && ![DBManager GetWicketTypeForUpdatePlayers:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO])
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
