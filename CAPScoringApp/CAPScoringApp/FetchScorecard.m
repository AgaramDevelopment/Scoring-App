//
//  FetchScorecard.m
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchScorecard.h"
#import "DBManagerScoreCard.h"

@implementation FetchScorecard

@synthesize ISFOLLOWON;

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
    
    NSMutableArray *MatchRegistrationForScoreBoard=[ DBManagerScoreCard GetMatchRegistrationForScoreBoard :  COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    NSMutableArray *BattingSummaryForScoreBoard=[ DBManagerScoreCard GetBattingSummaryForScoreBoard :  COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
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
    
    NSMutableArray *InningsSummaryForScoreBoard=[ DBManagerScoreCard GetInningsSummaryForScoreBoard :TEMPBATTEAMPENALTY:MATCHOVERS: MATCHBALLS: FINALINNINGS: COMPETITIONCODE: MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    
    NSMutableArray *GetBatPlayerDetailsForScoreBoard=[ DBManagerScoreCard GetBatPlayerForScoreBoard :  COMPETITIONCODE : MATCHCODE :BATTINGTEAMCODE: INNINGSNO ];
    
     ISTIMESHOW =[DBManagerScoreCard GetIsTimeShowForScoreBoard: COMPETITIONCODE : MATCHCODE];
    
    if([ISTIMESHOW isEqual:@"1"])
    {
        NSMutableArray *BowlingSummaryForScoreBoard=[ DBManagerScoreCard GetBowlingSummaryForScoreBoard:  COMPETITIONCODE : MATCHCODE : INNINGSNO];
        
    }
    else
    {
        NSMutableArray *BowlingSummaryInElseForScoreBoard=[ DBManagerScoreCard GetBowlingSummaryInElseForScoreBoard:  COMPETITIONCODE : MATCHCODE : INNINGSNO];
        
    }
    
    
    
    
    
    
}



@end
