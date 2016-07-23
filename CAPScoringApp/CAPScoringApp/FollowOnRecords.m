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
DBManagerFollowOn *dbFollowOn;

//SP_FETCHFOLLOWON
-(void) FetchFollowOn:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) TEAMCODE:(NSNumber*)INNINGSNO

{
    dbFollowOn = [[DBManagerFollowOn alloc]init];
    getTeamArray = [[NSMutableArray alloc]init];
    getTeamArray = [dbFollowOn GetteamDetailsForFetchFollowOn :  COMPETITIONCODE :  TEAMCODE];
    
    [dbFollowOn GetFollowonForFetchFollowOn : MATCHCODE : INNINGSNO];
}

//SP_FETCHTEAMNAMESELECTIONCHANGED


-(void) Fetchteamnameselectionchanged:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMNAME:(NSNumber*)INNINGSNO
{
    
    
    

    OPPOSITETEAMCODE=[dbFollowOn  GetOppositeTeamCodeForFetchTeamNameSelectionChanged : MATCHCODE : TEAMNAME];
		  
    
    GetBattingteamDetail = [[NSMutableArray alloc]init];
  GetBattingteamDetail=[dbFollowOn GetSelectionBattingTeamForFetchTeamNameSelectionChanged :  COMPETITIONCODE :  TEAMNAME ];
    
    
    
    GetOppositeBattingteamDetails = [[NSMutableArray alloc]init];
    GetOppositeBattingteamDetails=[dbFollowOn GetOppositeBowlingTeamForFetchTeamNameSelectionChanged :  COMPETITIONCODE :  TEAMNAME ];
    
   GetStrickerNonStrickerDetails = [[NSMutableArray alloc]init];
    
     GetStrickerNonStrickerDetails=[dbFollowOn GetStrickerDetailForFetchTeamNameSelectionChanged :  COMPETITIONCODE :MATCHCODE :  TEAMNAME: INNINGSNO ];
    
    
}






@end
