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
-(void) FetchFollowOn:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) TEAMCODE:(NSNumber*)INNINGSNO

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






@end
