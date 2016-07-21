//
//  BowlingSummeryPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BowlingSummeryPushRecord.h"

@implementation BowlingSummeryPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize INNINGSNO;
@synthesize BOWLINGPOSITIONNO;
@synthesize BOWLERCODE;
@synthesize OVERS;
@synthesize BALLS;
@synthesize PARTIALOVERBALLS;
@synthesize MAIDENS;
@synthesize RUNS;
@synthesize WICKETS;
@synthesize NOBALLS;
@synthesize WIDES;
@synthesize DOTBALLS;
@synthesize FOURS;
@synthesize SIXES;
@synthesize ISSYNC;


-(NSDictionary *)BowlingSummeryPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", BOWLINGTEAMCODE,@"BOWLINGTEAMCODE",INNINGSNO,@"INNINGSNO", BOWLINGPOSITIONNO,@"BOWLINGPOSITIONNO", BOWLERCODE,@"BOWLERCODE",OVERS,@"OVERS",BALLS,@"BALLS", PARTIALOVERBALLS,@"PARTIALOVERBALLS",MAIDENS,@"MAIDENS", RUNS,@"RUNS", WICKETS,@"WICKETS",NOBALLS,@"NOBALLS", WIDES,@"WIDES", DOTBALLS,@"DOTBALLS", FOURS,@"FOURS", SIXES,@"SIXES", ISSYNC,@"ISSYNC", nil];
}
@end
