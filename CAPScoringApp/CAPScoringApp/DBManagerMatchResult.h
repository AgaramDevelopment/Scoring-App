//
//  DBManagerMatchResult.h
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerMatchResult : NSObject
-(NSMutableArray *) GetMatchResultTypeAndCodeForFetchMatchResult;

-(NSMutableArray *) GetTeamANameDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE;

-(NSMutableArray *) GetTeamBNameDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE;

-(NSMutableArray *) GetManOfTheMatchDetailsForFetchMatchResult :(NSString*) MATCHCODE;

-(NSMutableArray *) GetManOfTheSeriesDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE;

-(NSMutableArray *) GetBestBatsManDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE;

-(NSMutableArray *) GetBestBowlerDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE;

-(NSMutableArray *) GetMatchresultDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE;

-(NSMutableArray *) GetBestPlayerDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE;


@end
