//
//  FollowOnRecords.m
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FollowOnRecords.h"
#import "DBManagerFollowOn.h"

@implementation FollowOnRecords

@synthesize TEAMCODE;
@synthesize TEAMNAME;

@synthesize PLAYERCODE;
@synthesize PLAYERNAME;

@synthesize getTeamArray;

@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize BOWLERCODE;

@synthesize OPPOSITETEAMCODE;


@synthesize GetBattingteamDetail;
@synthesize GetOppositeBattingteamDetails;
@synthesize GetStrickerNonStrickerDetails;

@synthesize TOTALRUNS;
@synthesize OVERNO;
@synthesize BALLNO;
@synthesize OVERBALLNO;
@synthesize TOTALRUN;
@synthesize WICKETS;
@synthesize OVERSTATUS;
@synthesize BOWLINGTEAMCODE;
@synthesize INNINGSSCORECARD;

//SP_FETCHFOLLOWON
-(void) FetchFollowOn:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMNAME:(NSNumber*)INNINGSNO

{
    
    getTeamArray = [[NSMutableArray alloc]init];
    getTeamArray = [DBManagerFollowOn GetteamDetailsForFetchFollowOn :  COMPETITIONCODE :  TEAMCODE];
    
    [DBManagerFollowOn GetFollowonForFetchFollowOn : MATCHCODE : INNINGSNO];
}

//SP_FETCHTEAMNAMESELECTIONCHANGED


-(void) Fetchteamnameselectionchanged:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMNAME:(NSNumber*)INNINGSNO
{
    
    
    

    OPPOSITETEAMCODE=[DBManagerFollowOn  GetOppositeTeamCodeForFetchTeamNameSelectionChanged : MATCHCODE : TEAMNAME];
		  
    
    GetBattingteamDetail = [[NSMutableArray alloc]init];
  GetBattingteamDetail=[DBManagerFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged :  COMPETITIONCODE :  TEAMNAME ];
    
    
    
    GetOppositeBattingteamDetails = [[NSMutableArray alloc]init];
    GetOppositeBattingteamDetails=[DBManagerFollowOn GetOppositeBowlingTeamForFetchTeamNameSelectionChanged :  COMPETITIONCODE :  TEAMNAME ];
    
   GetStrickerNonStrickerDetails = [[NSMutableArray alloc]init];
    
     GetStrickerNonStrickerDetails=[DBManagerFollowOn GetStrickerDetailForFetchTeamNameSelectionChanged :  COMPETITIONCODE :MATCHCODE :  TEAMNAME: INNINGSNO ];
    
    
}

////SP_UPDATEFOLLOWON
//-(void) UpdateFollowOn:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSNumber*)INNINGSNO:(NSString*)TEAMNAME : (NSString*)STRIKER : (NSString*)NONSTRIKER : (NSString*)BOWLER
//
//{
//    
//    if(INNINGSNO = @2)
//    {
//        if([DBManagerFollowOn GetBallCodeForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO ]!=0)
//        {
//            
//            TEAMCODE=[DBManagerFollowOn GetTeamNamesForUpdateFollowOn:    TEAMNAME ];
//            
//            TOTALRUNS=[DBManagerFollowOn GetTotalRunsForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO];
//            
//            OVERNO=[DBManagerFollowOn GetOverNoForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO];
//            
//            BALLNO=[DBManagerFollowOn GetBallNoForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : OVERNO :INNINGSNO];
//            
//            
//            OVERSTATUS=[DBManagerFollowOn GetOverStatusForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMNAME : INNINGSNO: OVERNO];
//            
//            BOWLINGTEAMCODE=[DBManagerFollowOn GetBowlingTeamCodeForUpdateFollowOn: TEAMNAME: COMPETITIONCODE:  MATCHCODE];
//            
//            
//            if(OVERSTATUS = @"1")
//            {
//                
//                OVERBALLNO=  [NSString stringWithFormat:@"%d",OVERNO.intValue +1];
//            }
//            else
//            {
//                
//                OVERBALLNO = [NSString stringWithFormat:@"%@.%@" ,OVERNO,BALLNO];
//              
//            }
//            
//            WICKETS=[DBManagerFollowOn GetWicketForUpdateFollowOn : COMPETITIONCODE:  MATCHCODE: TEAMCODE INNINGSNO: OVERNO];
//            
//            [DBManagerFollowOn UpdateInningsEventForInsertScoreBoard:TEAMNAME: TOTALRUN : OVERBALLNO: WICKETS : COMPETITIONCODE: MATCHCODE: INNINGSNO: TEAMCODE];
//            
//            if([DBManagerFollowOn GetTeamCodeForUpdateFollowOn: COMPETITIONCODE:  MATCHCODE: TEAMCODE :INNINGSNO ])
//            {
//                
//                [DBManagerFollowOn InsertInningsEventForInsertScoreBoard : COMPETITIONCODE : MATCHCODE :TEAMCODE :INNINGSNO :STRIKER :NONSTRIKER :BOWLER];
//                
//                INNINGSSCORECARD = [NSString stringWithFormat:@"%d",INNINGSNO.intValue +1];
//            }
//            EXEC SP_INITIALIZEINNINGSSCOREBOARD
//            else
//            {
//                [DBManagerFollowOn UpdateInningsEventInStrickerForInsertScoreBoard: COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : STRIKER : NONSTRIKER : BOWLER];
//                
//            }
//        } 
//        
//    }
//    
//    
//    
//}





@end
