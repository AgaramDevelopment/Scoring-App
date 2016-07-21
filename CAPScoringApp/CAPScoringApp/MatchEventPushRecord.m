//
//  MatchEventPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "MatchEventPushRecord.h"

@implementation MatchEventPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TOSSWONTEAMCODE;
@synthesize ELECTEDTO;
@synthesize BATTINGTEAMCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize TARGETRUNS;
@synthesize TARGETOVERS;
@synthesize TARGETCOMMENTS;
@synthesize BOWLCOMPUTESHOW;
@synthesize ISSYNC;


-(NSDictionary *)MatchEventPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", TOSSWONTEAMCODE,@"TOSSWONTEAMCODE",ELECTEDTO,@"ELECTEDTO", BATTINGTEAMCODE,@"BATTINGTEAMCODE", BOWLINGTEAMCODE,@"BOWLINGTEAMCODE",TARGETRUNS,@"TARGETRUNS",TARGETOVERS,@"TARGETOVERS", TARGETCOMMENTS,@"TARGETCOMMENTS",BOWLCOMPUTESHOW,@"BOWLCOMPUTESHOW", ISSYNC,@"ISSYNC",nil];
}
@end
