//
//  DAYEVENTSPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/4/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DAYEVENTSPushRecord.h"

@implementation DAYEVENTSPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize DAYNO;
@synthesize STARTTIME;
@synthesize ENDTIME;
@synthesize BATTINGTEAMCODE;
@synthesize TOTALOVERS;
@synthesize TOTALRUNS;
@synthesize TOTALWICKETS;
@synthesize COMMENTS;
@synthesize DAYSTATUS;
@synthesize ISSYNC;

-(NSDictionary *)DAYEVENTSPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",DAYNO,@"DAYNO", STARTTIME,@"STARTTIME", ENDTIME,@"ENDTIME",BATTINGTEAMCODE,@"BATTINGTEAMCODE",TOTALOVERS,@"TOTALOVERS", TOTALRUNS,@"TOTALRUNS",TOTALWICKETS,@"TOTALWICKETS", COMMENTS,@"COMMENTS", DAYSTATUS,@"DAYSTATUS",ISSYNC,@"ISSYNC",nil];
}

@end
