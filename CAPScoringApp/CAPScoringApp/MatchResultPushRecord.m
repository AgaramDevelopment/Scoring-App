//
//  MatchResultPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "MatchResultPushRecord.h"

@implementation MatchResultPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize MATCHRESULTCODE;
@synthesize MATCHWONTEAMCODE;
@synthesize TEAMAPOINTS;
@synthesize TEAMBPOINTS;
@synthesize MANOFTHEMATCHCODE;
@synthesize COMMENTS;
@synthesize ISSYNC;

-(NSDictionary *)MatchResultPushRecordDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", MATCHRESULTCODE,@"MATCHRESULTCODE",MATCHWONTEAMCODE,@"MATCHWONTEAMCODE",TEAMAPOINTS,@"TEAMAPOINTS", TEAMBPOINTS,@"TEAMBPOINTS",MANOFTHEMATCHCODE,@"MANOFTHEMATCHCODE",COMMENTS,@"COMMENTS", ISSYNC,@"ISSYNC",nil];
}


@end
