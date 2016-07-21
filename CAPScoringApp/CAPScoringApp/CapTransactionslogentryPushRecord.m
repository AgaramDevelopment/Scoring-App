//
//  CapTransactionslogentryPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "CapTransactionslogentryPushRecord.h"

@implementation CapTransactionslogentryPushRecord

@synthesize MATCHCODE;
@synthesize TABLENAME;
@synthesize SCRIPTTYPE;
@synthesize SCRIPTDATA;
@synthesize USERID;
@synthesize LOGDATETIME;
@synthesize SCRIPTSTATUS;
@synthesize SEQNO;
@synthesize ISSYNC;


-(NSDictionary *)CapTransactionslogentryPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:MATCHCODE,@"MATCHCODE",TABLENAME,@"TABLENAME", SCRIPTTYPE,@"SCRIPTTYPE",SCRIPTDATA,@"SCRIPTDATA", USERID,@"USERID", LOGDATETIME,@"LOGDATETIME",SCRIPTSTATUS,@"SCRIPTSTATUS", SEQNO,@"SEQNO",ISSYNC,@"ISSYNC", nil];
}
@end
