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



@synthesize BYES;
@synthesize LEGBYES;
@synthesize NOBALLS;
@synthesize WIDES;
@synthesize PENALTIES;
@synthesize TOTALEXTRAS;
@synthesize INNINGSTOTAL;
@synthesize INNINGSTOTALWICKETS;
@synthesize INNINGSRUNRATE;
@synthesize FINALINNINGS;
@synthesize ISDECLARE;

@synthesize MatchRegistrationForScoreBoardArray;
@synthesize DidNotBatArray;
DBManagerScoreCard *dbScoreCard;

-(void ) FetchScoreBoard:(NSString *) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO
{
    dbScoreCard = [[DBManagerScoreCard alloc]init];
    
    NSNumber* ISINNINGSCOMPLETE = [[NSNumber alloc] init];
    NSNumber* MATCHOVERS = [[NSNumber alloc] init];
    NSNumber* MATCHBALLS = [[NSNumber alloc] init];
    NSNumber* FINALINNINGS = [[NSNumber alloc] init];
    NSString* BATTINGTEAMCODE = [[NSString alloc] init];
    NSString* BOWLINGTEAMCODE = [[NSString alloc] init];
    NSString* TEMPBATTEAMPENALTY = [[NSString alloc] init];
    NSString* ISTIMESHOW = [[NSString alloc] init];
    
    MatchRegistrationForScoreBoardArray = [[NSMutableArray alloc]init];
    
    MatchRegistrationForScoreBoardArray = [ dbScoreCard GetMatchRegistrationForScoreBoard :  COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    
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
    
    
    
    
    
     self.BattingSummaryForScoreBoard=[ dbScoreCard GetBattingSummaryForScoreBoard :  COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    ISINNINGSCOMPLETE = [dbScoreCard GetInningsStatusForScoreBoard : COMPETITIONCODE : MATCHCODE: INNINGSNO];
    
    NSMutableArray *MatchOverandBallForScoreBoard=[dbScoreCard GetMatchOverForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO ];
    
    if([MatchOverandBallForScoreBoard count]>0){
        
        MATCHOVERS=[MatchOverandBallForScoreBoard objectAtIndex:0];
        MATCHBALLS=[MatchOverandBallForScoreBoard objectAtIndex: 1];
        
    }

    
    FINALINNINGS=[dbScoreCard GetFinalInningsForScoreBoard : COMPETITIONCODE : MATCHCODE];
    
    BATTINGTEAMCODE=[dbScoreCard GetBattingteamCodeForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO];
    
    BOWLINGTEAMCODE=[dbScoreCard GetBowlingteamCodeForScoreBoard :BATTINGTEAMCODE:  COMPETITIONCODE : MATCHCODE];
    ISFOLLOWON=[dbScoreCard GetIsFollowOnForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO];
  //  [dbScoreCard GetIsFollowOnInMinusForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO] ;
    if([INNINGSNO isEqual:@"3"] && [ISFOLLOWON isEqual:@"1"])
    {
        TEMPBATTEAMPENALTY=@"0";
        
    }
    else if([INNINGSNO isEqual:@"4"] && [[dbScoreCard GetIsFollowOnInMinusForScoreBoard : COMPETITIONCODE : MATCHCODE : INNINGSNO] isEqual:@"1"])
    {
        TEMPBATTEAMPENALTY=[dbScoreCard GetTempBatTeamPenaltyForScoreBoard : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE];
    }
    else
    {
        TEMPBATTEAMPENALTY=[dbScoreCard TempBatTeamPenaltyForScoreBoard : COMPETITIONCODE : MATCHCODE :  INNINGSNO: BATTINGTEAMCODE];
    }
    
    NSMutableArray *InningsSummaryForScoreBoard=[dbScoreCard GetInningsSummaryForScoreBoard :TEMPBATTEAMPENALTY:MATCHOVERS: MATCHBALLS: FINALINNINGS: COMPETITIONCODE: MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    
    if (InningsSummaryForScoreBoard.count>0) {
        
        MatchRegistrationDetailsForScoreBoard *scoreCard = [InningsSummaryForScoreBoard objectAtIndex:0];
        
        
        BYES = scoreCard.BYES;
        LEGBYES = scoreCard.LEGBYES;
        NOBALLS = scoreCard.NOBALLS;
        WIDES = scoreCard.WIDES;
        PENALTIES = scoreCard.PENALTIES;
        TOTALEXTRAS = scoreCard.TOTALEXTRAS;
        INNINGSTOTAL = scoreCard.INNINGSTOTAL;
        INNINGSTOTALWICKETS = scoreCard.INNINGSTOTALWICKETS;
        INNINGSRUNRATE = scoreCard.INNINGSRUNRATE;
        FINALINNINGS = scoreCard.FINALINNINGS;
        ISDECLARE = scoreCard.ISDECLARE;
        
    
        
    }
    
    
    DidNotBatArray = [dbScoreCard GetBatPlayerForScoreBoard :  COMPETITIONCODE : MATCHCODE :BATTINGTEAMCODE: INNINGSNO];
    
    
    
     ISTIMESHOW =[dbScoreCard GetIsTimeShowForScoreBoard: COMPETITIONCODE : MATCHCODE];
    
    if([ISTIMESHOW isEqual:@"1"])
    {
         self.BowlingSummaryForScoreBoard=[dbScoreCard GetBowlingSummaryForScoreBoard:  COMPETITIONCODE : MATCHCODE : INNINGSNO];
        
    }
    else
    {
        self.BowlingSummaryForScoreBoard=[dbScoreCard GetBowlingSummaryInElseForScoreBoard:  COMPETITIONCODE : MATCHCODE : INNINGSNO];
        
    }
    
    
    
}



@end
