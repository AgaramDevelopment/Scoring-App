//
//  SessionEventPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SessionEventPushRecord.h"

@implementation SessionEventPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize DAYNO;
@synthesize SESSIONNO;
@synthesize SESSIONSTARTTIME;
@synthesize SESSIONENDTIME;
@synthesize BATTINGTEAMCODE;
@synthesize STARTOVER;
@synthesize ENDOVER;
@synthesize TOTALRUNS;
@synthesize TOTALWICKETS;
@synthesize DOMINANTTEAMCODE;
@synthesize SESSIONSTATUS;
@synthesize ISSYNC;


-(NSDictionary *)SessionEventPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",DAYNO,@"DAYNO", SESSIONNO,@"SESSIONNO", SESSIONSTARTTIME,@"SESSIONSTARTTIME",SESSIONENDTIME,@"SESSIONENDTIME",BATTINGTEAMCODE,@"BATTINGTEAMCODE", STARTOVER,@"STARTOVER",ENDOVER,@"ENDOVER", TOTALRUNS,@"TOTALRUNS", TOTALWICKETS,@"TOTALWICKETS",DOMINANTTEAMCODE,@"DOMINANTTEAMCODE", SESSIONSTATUS,@"SESSIONSTATUS", ISSYNC,@"ISSYNC", nil];
}


@end
