//
//  CaptransactionslogEntryRecord.m
//  CAPScoringApp
//
//  Created by APPLE on 05/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "CaptransactionslogEntryRecord.h"

@implementation CaptransactionslogEntryRecord

@synthesize MATCHCODE;
@synthesize TABLENAME;
@synthesize SCRIPTDATA;
@synthesize SCRIPTSTATUS;
@synthesize SCRIPTTYPE;
@synthesize SEQNO;

-(NSDictionary *)CaptransactionslogEntryRecordDictionary {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:MATCHCODE,@"MATCHCODE",TABLENAME,@"TABLENAME", SCRIPTTYPE,@"SCRIPTTYPE",SCRIPTDATA,@"SCRIPTDATA", SCRIPTSTATUS,@"SCRIPTSTATUS", SEQNO,@"SEQNO", nil];
}
@end
