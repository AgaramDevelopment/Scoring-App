//
//  PenalityDetailsPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PenalityDetailsPushRecord.h"

@implementation PenalityDetailsPushRecord


@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize BALLCODE;
@synthesize PENALTYCODE;
@synthesize AWARDEDTOTEAMCODE;
@synthesize PENALTYRUNS;
@synthesize PENALTYTYPECODE;
@synthesize PENALTYREASONCODE;
@synthesize ISSYNC;



-(NSDictionary *)PenalityDetailsPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",BALLCODE,@"BALLCODE", PENALTYCODE,@"PENALTYCODE", AWARDEDTOTEAMCODE,@"AWARDEDTOTEAMCODE",PENALTYRUNS,@"PENALTYRUNS",PENALTYTYPECODE,@"PENALTYTYPECODE", PENALTYREASONCODE,@"PENALTYREASONCODE",ISSYNC,@"ISSYNC", nil];
}
@end
