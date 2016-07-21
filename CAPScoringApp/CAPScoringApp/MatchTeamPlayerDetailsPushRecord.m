//
//  MatchTeamPlayerDetailsPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "MatchTeamPlayerDetailsPushRecord.h"

@implementation MatchTeamPlayerDetailsPushRecord
@synthesize MATCHTEAMPLAYERCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize PLAYERCODE;
@synthesize PLAYINGORDER;
@synthesize RECORDSTATUS;
@synthesize ISSYNC;


-(NSDictionary *)MatchTeamPlayerDetailsPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:MATCHTEAMPLAYERCODE,@"MATCHTEAMPLAYERCODE",MATCHCODE,@"MATCHCODE", TEAMCODE,@"TEAMCODE",PLAYERCODE,@"PLAYERCODE", PLAYINGORDER,@"PLAYINGORDER", RECORDSTATUS,@"RECORDSTATUS",ISSYNC,@"ISSYNC",nil];
}

@end
