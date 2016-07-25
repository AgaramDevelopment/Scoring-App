//
//  FetchMatchResult.m
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchMatchResult.h"
#import "DBManagerMatchResult.h"

@implementation FetchMatchResult

-(void) getMatchReultsDetails:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)TEAMCODE :(NSNumber*)INNINGSNO

{
    
    DBManagerMatchResult *_DBManagerMatchResult = [[DBManagerMatchResult alloc] init];
     _GetMatchResultTypeAndCode=[_DBManagerMatchResult GetMatchResultTypeAndCodeForFetchMatchResult];
    
    _GetTeamANameDetail=[_DBManagerMatchResult GetTeamANameDetailsForFetchMatchResult : COMPETITIONCODE : MATCHCODE];
    
    _GetTeamBNameDetail=[_DBManagerMatchResult GetTeamBNameDetailsForFetchMatchResult : COMPETITIONCODE : MATCHCODE];
    
    _GetManOfTheMatchDetail=[_DBManagerMatchResult GetManOfTheMatchDetailsForFetchMatchResult :  MATCHCODE];
    
    _GetManOfTheSeriesDetails=[_DBManagerMatchResult GetManOfTheSeriesDetailsForFetchMatchResult :  COMPETITIONCODE];
    
    _GetBestBatsManDetails=[_DBManagerMatchResult GetBestBatsManDetailsForFetchMatchResult :  COMPETITIONCODE];
    
    _GetBestBowlerDetails=[_DBManagerMatchResult GetBestBowlerDetailsForFetchMatchResult :  COMPETITIONCODE];
    
    _GetMatchResultDetails=[_DBManagerMatchResult GetMatchresultDetailsForFetchMatchResult : COMPETITIONCODE : MATCHCODE];
    
    
    _GetBestPlayerDetails=[_DBManagerMatchResult GetBestPlayerDetailsForFetchMatchResult : COMPETITIONCODE ];
    
}

@end
