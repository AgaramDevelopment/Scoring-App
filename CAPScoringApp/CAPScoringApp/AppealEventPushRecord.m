//
//  AppealEventPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "AppealEventPushRecord.h"

@implementation AppealEventPushRecord
@synthesize BALLCODE;
@synthesize APPEALTYPECODE;
@synthesize APPEALSYSTEMCODE;
@synthesize APPEALCOMPONENTCODE;
@synthesize UMPIRECODE;
@synthesize BATSMANCODE;
@synthesize ISREFERRED;
@synthesize APPEALDECISION;
@synthesize APPEALCOMMENTS;
@synthesize FIELDERCODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize ISSYNC;

-(NSDictionary *)AppealEventPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:BALLCODE,@"BALLCODE",APPEALTYPECODE,@"APPEALTYPECODE", APPEALSYSTEMCODE,@"APPEALSYSTEMCODE",APPEALCOMPONENTCODE,@"APPEALCOMPONENTCODE", UMPIRECODE,@"UMPIRECODE", BATSMANCODE,@"BATSMANCODE",ISREFERRED,@"ISREFERRED",APPEALDECISION,@"APPEALDECISION", APPEALCOMMENTS,@"APPEALCOMMENTS",FIELDERCODE,@"FIELDERCODE", COMPETITIONCODE,@"COMPETITIONCODE", MATCHCODE,@"MATCHCODE",TEAMCODE,@"TEAMCODE", INNINGSNO,@"INNINGSNO", ISSYNC,@"ISSYNC",nil];
}


@end
