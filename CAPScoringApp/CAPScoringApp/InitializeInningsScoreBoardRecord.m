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



//SP_SBUPDATEPLAYERS

+(void) UpdatePlayers:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString *)STRIKERCODE:(NSString *)NONSTRIKERCODE:(NSString *)BOWLERCODE
{
    DBManager *objDBManager=[[DBManager alloc]init];

    
    NSNumber * ISINNINGSREVERT;
    NSNumber *STRIKERPOSITIONNO;
    NSNumber *NONSTRIKERPOSITIONNO;
    NSNumber *BOWLERPOSITIONNO;
     ISINNINGSREVERT = [NSNumber numberWithInt:0];
    
    
   if(![objDBManager GetBallCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO] && ![objDBManager GetWicketTypeForUpdatePlayers:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO])
   {
       [objDBManager deleteBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
       
       [objDBManager deleteInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
       
       [objDBManager deleteBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
       
       
       if ([ISINNINGSREVERT intValue] == 0) {
           
           [objDBManager insertBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO STRIKERCODE:STRIKERCODE];
           
           [objDBManager insertBattingSummaryNonStricker:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO NONSTRIKERCODE:NONSTRIKERCODE];
           
           
           [objDBManager insertInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO];
           
           //BOWLINGTEAMCODE
           [objDBManager insertBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BOWLINGTEAMCODE INNINGSNO:INNINGSNO BOWLERCODE:BOWLERCODE];
           
       }
       
   }
    else
    {
      [objDBManager DeleteBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
        
      [objDBManager DeleteBowlingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO];
        
        
        if(![objDBManager GetStrikerDetailBallCodeForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: STRIKERCODE: NONSTRIKERCODE])
        {
            
            STRIKERPOSITIONNO = [objDBManager GetStrikerDetailsBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
            
          [objDBManager InsertBattingSummaryForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERPOSITIONNO :STRIKERCODE];
            
            
        }else{
            
            if ([objDBManager GetBatsmanCodeForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE]) {
                
                [objDBManager UpdateBattingSummaryInStrickerDetailsForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERCODE : NONSTRIKERCODE ];
            }
            
        }
        
        
        if([objDBManager GetBatsmanCodeInUpdateBattingSummaryForUpdatePlayers:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE])
        {
            [objDBManager UpdateBattingSummaryAndWicketEventInStrickerDetailsForUpdatePlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : STRIKERCODE : NONSTRIKERCODE];
            
        }
        
        if(![objDBManager GetNonStrikerDetailsForBallCode : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO: NONSTRIKERCODE])
        {
        NONSTRIKERPOSITIONNO=[objDBManager GetNonStrikerDetailsForBattingSummary:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
            
        [objDBManager InsertBattingSummaryForPlayers :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO : NONSTRIKERPOSITIONNO: NONSTRIKERCODE];
        }
        if(![objDBManager GetBowlerDetailsForBallCode :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO: BOWLERCODE ])
        {
        BOWLERPOSITIONNO=[objDBManager GetBowlerDetailsForBowlingSummary:COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO];
            
        [objDBManager InsertBowlingSummaryForPlayers :COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO : BOWLERPOSITIONNO: BOWLERCODE];
            
        }
        
        
    }
    
[objDBManager UpdateInningsEventsForPlayers :STRIKERCODE : NONSTRIKERCODE : BOWLERCODE: COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    
}

//SP_INITIALIZEINNINGSSCOREBOARD
+(void) InitializeInningsScoreBoard :(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)BATTINGTEAMCODE :(NSString*)BOWLINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)STRIKERCODE : 	(NSString*)NONSTRIKERCODE :
(NSString*)BOWLERCODE : (NSNumber*) ISINNINGSREVERT
{
    DBManager *objDBManager=[[DBManager alloc]init];

    [objDBManager deleteBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
    
    [objDBManager deleteInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
    
    [objDBManager deleteBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
    
    
    if([ISINNINGSREVERT intValue] == 0  ) {
        
        [objDBManager insertBattingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO STRIKERCODE:STRIKERCODE];
        
        [objDBManager insertBattingSummaryNonStricker:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO NONSTRIKERCODE:NONSTRIKERCODE];
        
        
        [objDBManager insertInningsSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO];
        
        [objDBManager insertBowlingSummary:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BOWLINGTEAMCODE INNINGSNO:INNINGSNO BOWLERCODE:BOWLERCODE];
        
    }
}

@end
