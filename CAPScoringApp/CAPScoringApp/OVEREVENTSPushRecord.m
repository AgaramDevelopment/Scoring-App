//
//  OVEREVENTSPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "OVEREVENTSPushRecord.h"

@implementation OVEREVENTSPushRecord

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize OVERNO;
@synthesize OVERSTATUS;
@synthesize ISSYNC;

-(NSDictionary *)OVEREVENTSPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", TEAMCODE,@"TEAMCODE",INNINGSNO,@"INNINGSNO", OVERNO,@"OVERNO", OVERSTATUS,@"OVERSTATUS",ISSYNC,@"ISSYNC",nil];
}

@end
