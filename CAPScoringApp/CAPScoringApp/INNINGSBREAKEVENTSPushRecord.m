//
//  INNINGSBREAKEVENTSPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "INNINGSBREAKEVENTSPushRecord.h"

@implementation INNINGSBREAKEVENTSPushRecord


@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize BREAKNO;
@synthesize BREAKSTARTTIME;
@synthesize BREAKENDTIME;
@synthesize ISINCLUDEINPLAYERDURATION;
@synthesize BREAKCOMMENTS;
@synthesize issync;


-(NSDictionary *)INNINGSBREAKEVENTSPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",BREAKNO,@"BREAKNO", BREAKSTARTTIME,@"BREAKSTARTTIME", BREAKENDTIME,@"BREAKENDTIME",ISINCLUDEINPLAYERDURATION,@"ISINCLUDEINPLAYERDURATION",BREAKCOMMENTS,@"BREAKCOMMENTS", issync,@"issync", nil];
}


@end
