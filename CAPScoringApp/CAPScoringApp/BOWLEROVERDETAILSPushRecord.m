//
//  BOWLEROVERDETAILSPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/4/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BOWLEROVERDETAILSPushRecord.h"

@implementation BOWLEROVERDETAILSPushRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize OVERNO;
@synthesize BOWLERCODE;
@synthesize STARTTIME;
@synthesize ENDTIME;
@synthesize ISSYNC;


-(NSDictionary *)BOWLEROVERDETAILSPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", TEAMCODE,@"TEAMCODE",INNINGSNO,@"INNINGSNO",OVERNO,@"OVERNO",BOWLERCODE,@"BOWLERCODE",STARTTIME,@"STARTTIME",ENDTIME,@"ENDTIME",ISSYNC,@"ISSYNC", nil];
}

@end
