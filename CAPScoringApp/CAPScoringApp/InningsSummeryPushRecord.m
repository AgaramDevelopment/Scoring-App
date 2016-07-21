//
//  InningsSummeryPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "InningsSummeryPushRecord.h"

@implementation InningsSummeryPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize BATTINGTEAMCODE;
@synthesize INNINGSNO;
@synthesize BYES;
@synthesize LEGBYES;
@synthesize NOBALLS;
@synthesize WIDES;
@synthesize PENALTIES;
@synthesize INNINGSTOTAL;
@synthesize INNINGSTOTALWICKETS;
@synthesize ISSYNC;


-(NSDictionary *)InningsSummeryPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", BATTINGTEAMCODE,@"BATTINGTEAMCODE",INNINGSNO,@"INNINGSNO", BYES,@"BYES", LEGBYES,@"LEGBYES",NOBALLS,@"NOBALLS",WIDES,@"WIDES", PENALTIES,@"PENALTIES",INNINGSTOTAL,@"INNINGSTOTAL",INNINGSTOTALWICKETS,@"INNINGSTOTALWICKETS", ISSYNC,@"ISSYNC",nil];
}

@end
