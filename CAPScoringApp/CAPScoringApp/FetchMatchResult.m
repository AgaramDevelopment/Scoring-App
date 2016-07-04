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
    
    
     _GetMatchResultTypeAndCode=[DBManagerMatchResult GetMatchResultTypeAndCodeForFetchMatchResult];
    
    _GetTeamANameDetail=[DBManagerMatchResult GetTeamANameDetailsForFetchMatchResult : COMPETITIONCODE : MATCHCODE];
    
    _GetTeamBNameDetail=[DBManagerMatchResult GetTeamBNameDetailsForFetchMatchResult : COMPETITIONCODE : MATCHCODE];
    
    _GetManOfTheMatchDetail=[DBManagerMatchResult GetManOfTheMatchDetailsForFetchMatchResult :  MATCHCODE];
    
    _GetManOfTheSeriesDetails=[DBManagerMatchResult GetManOfTheSeriesDetailsForFetchMatchResult :  COMPETITIONCODE];
    
    _GetBestBatsManDetails=[DBManagerMatchResult GetBestBatsManDetailsForFetchMatchResult :  COMPETITIONCODE];
    
    _GetBestBowlerDetails=[DBManagerMatchResult GetBestBowlerDetailsForFetchMatchResult :  COMPETITIONCODE];
    
    _GetMatchResultDetails=[DBManagerMatchResult GetMatchresultDetailsForFetchMatchResult : COMPETITIONCODE : MATCHCODE];
    
    
    _GetBestPlayerDetails=[DBManagerMatchResult GetBestPlayerDetailsForFetchMatchResult : COMPETITIONCODE ];
    
}

@end
