//
//  FetchScorecard.m
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchScorecard.h"
#import "DBManagerScoreCard.h"
#import "MatchRegistrationDetailsForScoreBoard.h"

@implementation FetchScorecard

@synthesize ISFOLLOWON;

@synthesize CURRENTMATCHCODE;
@synthesize MATCHNAME;
@synthesize MATCHDATE;
@synthesize CURRENTMATCHOVERS;
@synthesize UMPIRE1CODE;
@synthesize UMPIRE1NAME;
@synthesize UMPIRE2CODE;
@synthesize UMPIRE2NAME;
@synthesize MATCHREFEREECODE;
@synthesize MATCHREFEREENAME;
@synthesize TOSSWONTEAMCODE;
@synthesize TOSSWONTEAMNAME;
@synthesize ELECTEDTO;
@synthesize ELECTEDTODESCRIPTION;
@synthesize CURRENTBATTINGTEAMCODE;
@synthesize BATTINGTEAMNAME;
@synthesize BATTINGTEAMLOGO;
@synthesize CURRENTBOWLINGTEAMCODE;
@synthesize BOWLINGTEAMNAME;
@synthesize BOWLINGTEAMLOGO;

@synthesize MatchRegistrationForScoreBoardArray;

-(void ) FetchScoreBoard:(NSString *) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO
{
    NSNumber* ISINNINGSCOMPLETE = [[NSNumber alloc] init];
    NSNumber* MATCHOVERS = [[NSNumber alloc] init];
    NSNumber* MATCHBALLS = [[NSNumber alloc] init];
    NSNumber* FINALINNINGS = [[NSNumber alloc] init];
    NSString* BATTINGTEAMCODE = [[NSString alloc] init];
    NSString* BOWLINGTEAMCODE = [[NSString alloc] init];
    NSString* TEMPBATTEAMPENALTY = [[NSString alloc] init];
    NSString* ISTIMESHOW = [[NSString alloc] init];
    
    MatchRegistrationForScoreBoardArray = [[NSMutableArray alloc]init];
    
    MatchRegistrationForScoreBoardArray = [ DBManagerScoreCard GetMatchRegistrationForScoreBoard :  COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    
    if(MatchRegistrationForScoreBoardArray.count>0)
    {
        
        MatchRegistrationDetailsForScoreBoard *scoreCard = [MatchRegistrationForScoreBoardArray objectAtIndex:0];
        
         CURRENTMATCHCODE = scoreCard.MATCHCODE;
         MATCHNAME = scoreCard.MATCHNAME;
         MATCHDATE = scoreCard.MATCHDATE;
         CURRENTMATCHOVERS = scoreCard.MATCHOVERS;
         UMPIRE1CODE = scoreCard.UMPIRE1CODE;
         UMPIRE1NAME = scoreCard.UMPIRE1NAME;
         UMPIRE2CODE = scoreCard.UMPIRE2CODE;
         UMPIRE2NAME = scoreCard.UMPIRE2NAME;
         MATCHREFEREECODE = scoreCard.MATCHREFEREECODE;
         MATCHREFEREENAME = scoreCard.MATCHREFEREENAME;
         TOSSWONTEAMCODE = scoreCard.TOSSWONTEAMCODE;
         TOSSWONTEAMNAME = scoreCard.TOSSWONTEAMNAME;
         ELECTEDTO = scoreCard.ELECTEDTO;
         ELECTEDTODESCRIPTION = scoreCard.ELECTEDTODESCRIPTION;
         CURRENTBATTINGTEAMCODE = scoreCard.BATTINGTEAMCODE;
         BATTINGTEAMNAME = scoreCard.BATTINGTEAMNAME;
        // BATTINGTEAMLOGO = scoreCard.BATTINGTEAMLOGO;
         CURRENTBOWLINGTEAMCODE = scoreCard.BOWLINGTEAMCODE;
         BOWLINGTEAMNAME = scoreCard.BOWLINGTEAMNAME;
         //BOWLINGTEAMLOGO = scoreCard.BOWLINGTEAMLOGO;

        
    }
    
    
    
    
    
     self.BattingSummaryForScoreBoard=[ DBManagerScoreCard GetBattingSummaryForScoreBoard :  COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    ISINNINGSCOMPLETE = [DBManagerScoreCard GetInningsStatusForScoreBoard : COMPETITIONCODE : MATCHCODE: INNINGSNO];
    
    NSMutableArray *MatchOverandBallForScoreBoard=[DBManagerScoreCard GetMatchOverForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    if([MatchOverandBallForScoreBoard count]>0){
        
        MATCHOVERS=[MatchOverandBallForScoreBoard objectAtIndex:0];
        MATCHBALLS=[MatchOverandBallForScoreBoard objectAtIndex: 1];
        
    }

    
    FINALINNINGS=[DBManagerScoreCard GetFinalInningsForScoreBoard : COMPETITIONCODE : MATCHCODE];
    
    BATTINGTEAMCODE=[DBManagerScoreCard GetBattingteamCodeForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    
    BOWLINGTEAMCODE=[DBManagerScoreCard GetBowlingteamCodeForScoreBoard :BATTINGTEAMCODE:  COMPETITIONCODE : MATCHCODE];
    ISFOLLOWON=[DBManagerScoreCard GetIsFollowOnForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO];
  //  [DBManagerScoreCard GetIsFollowOnInMinusForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO] ;
    if([INNINGSNO isEqual:@"3"] && [ISFOLLOWON isEqual:@"1"])
    {
        TEMPBATTEAMPENALTY=@"0";
        
    }
    else if([INNINGSNO isEqual:@"4"] && [[DBManagerScoreCard GetIsFollowOnInMinusForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO] isEqual:@"1"])
    {
        TEMPBATTEAMPENALTY=[DBManagerScoreCard GetTempBatTeamPenaltyForScoreBoard : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE];
    }
    else
    {
        TEMPBATTEAMPENALTY=[DBManagerScoreCard TempBatTeamPenaltyForScoreBoard : COMPETITIONCODE : MATCHCODE :  INNINGSNO: BATTINGTEAMCODE];
    }
    
    NSMutableArray *InningsSummaryForScoreBoard=[DBManagerScoreCard GetInningsSummaryForScoreBoard :TEMPBATTEAMPENALTY:MATCHOVERS: MATCHBALLS: FINALINNINGS: COMPETITIONCODE: MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    
    NSMutableArray *GetBatPlayerDetailsForScoreBoard=[DBManagerScoreCard GetBatPlayerForScoreBoard :  COMPETITIONCODE : MATCHCODE :BATTINGTEAMCODE: INNINGSNO ];
    
     ISTIMESHOW =[DBManagerScoreCard GetIsTimeShowForScoreBoard: COMPETITIONCODE : MATCHCODE];
    
    if([ISTIMESHOW isEqual:@"1"])
    {
         self.BowlingSummaryForScoreBoard=[DBManagerScoreCard GetBowlingSummaryForScoreBoard:  COMPETITIONCODE : MATCHCODE : INNINGSNO];
        
    }
    else
    {
        self.BowlingSummaryForScoreBoard=[DBManagerScoreCard GetBowlingSummaryInElseForScoreBoard:  COMPETITIONCODE : MATCHCODE : INNINGSNO];
        
    }
    
    
    
}



@end
