//
//  PowerPlayPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PowerPlayPushRecord.h"

@implementation PowerPlayPushRecord
@synthesize POWERPLAYCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize STARTOVER;
@synthesize ENDOVER;
@synthesize POWERPLAYTYPE;
@synthesize RECORDSTATUS;
@synthesize CREATEDBY;
@synthesize CREATEDDATE;
@synthesize MODIFIEDBY;
@synthesize MODIFIEDDATE;
@synthesize ISSYNC;


-(NSDictionary *)PowerPlayPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:POWERPLAYCODE,@"POWERPLAYCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",STARTOVER,@"STARTOVER", ENDOVER,@"ENDOVER", POWERPLAYTYPE,@"POWERPLAYTYPE",RECORDSTATUS,@"RECORDSTATUS",CREATEDBY,@"CREATEDBY", CREATEDDATE,@"CREATEDDATE",MODIFIEDBY,@"MODIFIEDBY", MODIFIEDDATE,@"MODIFIEDDATE", ISSYNC,@"ISSYNC",nil];
}
@end
