//
//  InitializeInningsScoreBoardRecord.m
//  CAPScoringApp
//
//  Created by mac on 14/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "InitializeInningsScoreBoardRecord.h"
#import "DBManager.h"

@implementation InitializeInningsScoreBoardRecord

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize BATTINGTEAMCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize INNINGSNO;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize BOWLERCODE;
@synthesize ISINNINGSREVERT;
@synthesize STRIKERPOSITIONNO;
@synthesize NONSTRIKERPOSITIONNO;
@synthesize BOWLERPOSITIONNO;





-(void) UpdatePlayers:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString *)STRIKERCODE:(NSString *)NONSTRIKERCODE:(NSString *)BOWLERCODE
{
    
   if(![DBManager GetBallCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO] && ![DBManager GetWicketTypeForUpdatePlayers:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO])
   {
       [DBManager deleteBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
       
       [DBManager deleteInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
       
       [DBManager deleteBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
       
       
       if (ISINNINGSREVERT == 0) {
           
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
        
        
        if(![DBManager GetStrikerDetailBallCodeForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: STRIKERCODE])
        {
            
            STRIKERPOSITIONNO = [DBManager GetStrikerDetailsBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
            
          [DBManager InsertBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERPOSITIONNO :STRIKERCODE];
            
            
        }else{
            
            if ([DBManager GetBatsmanCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE]) {
                
                [DBManager UpdateBattingSummaryInStrickerDetailsForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERCODE : NONSTRIKERCODE ];
            }
            
        }
        
        
        if([DBManager GetBatsmanCodeInUpdateBattingSummaryForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE])
        {
            [DBManager UpdateBattingSummaryAndWicketEventInStrickerDetailsForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERCODE : NONSTRIKERCODE];
            
        }
        
        if(![DBManager GetNonStrikerDetailsForBallCode:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: NONSTRIKERCODE])
        {
        NONSTRIKERPOSITIONNO=[DBManager GetNonStrikerDetailsForBattingSummary:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
            
        [DBManager InsertBattingSummaryForPlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : NONSTRIKERPOSITIONNO: NONSTRIKERCODE];
        }
        if(![DBManager GetBowlerDetailsForBallCode:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: BOWLERCODE ])
        {
        BOWLERPOSITIONNO=[DBManager GetBowlerDetailsForBowlingSummary:COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO];
            
        [DBManager InsertBowlingSummaryForPlayers :COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO : BOWLERPOSITIONNO: BOWLERCODE];
            
        }
        
        
    }
    
[DBManager UpdateInningsEventsForPlayers :STRIKERCODE : NONSTRIKERCODE : BOWLERCODE: COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    
}

@end
