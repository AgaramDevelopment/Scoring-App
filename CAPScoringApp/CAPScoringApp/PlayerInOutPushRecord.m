//
//  PlayerInOutPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerInOutPushRecord.h"

@implementation PlayerInOutPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize TEAMCODE;
@synthesize PLAYERCODE;
@synthesize INTIME;
@synthesize OUTTIME;
@synthesize ISSYNC;



-(NSDictionary *)PlayerInOutPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",TEAMCODE,@"TEAMCODE", PLAYERCODE,@"PLAYERCODE", INTIME,@"INTIME",OUTTIME,@"OUTTIME",ISSYNC,@"ISSYNC",nil];
}
@end
