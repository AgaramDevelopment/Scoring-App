//
//  BOWLINGMAIDENSUMMARYPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/4/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BOWLINGMAIDENSUMMARYPushRecord.h"

@implementation BOWLINGMAIDENSUMMARYPushRecord




@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize BOWLERCODE;
@synthesize OVERS;
@synthesize ISSYNC;


-(NSDictionary *)BOWLINGMAIDENSUMMARYPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", INNINGSNO,@"INNINGSNO",BOWLERCODE,@"BOWLERCODE",OVERS,@"OVERS",ISSYNC,@"ISSYNC", nil];
}

@end
