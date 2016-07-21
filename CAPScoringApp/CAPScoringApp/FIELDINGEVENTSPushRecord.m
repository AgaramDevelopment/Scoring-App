//
//  FIELDINGEVENTSPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/4/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FIELDINGEVENTSPushRecord.h"

@implementation FIELDINGEVENTSPushRecord

@synthesize BALLCODE;
@synthesize FIELDERCODE;
@synthesize ISSUBSTITUTE;
@synthesize FIELDINGFACTORCODE;
@synthesize NRS;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize ISSYNC;


-(NSDictionary *)FIELDINGEVENTSPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:BALLCODE,@"BALLCODE",FIELDERCODE,@"FIELDERCODE", ISSUBSTITUTE,@"ISSUBSTITUTE",FIELDINGFACTORCODE,@"FIELDINGFACTORCODE", NRS,@"NRS",COMPETITIONCODE,@"COMPETITIONCODE",MATCHCODE,@"MATCHCODE", TEAMCODE,@"TEAMCODE",INNINGSNO,@"INNINGSNO",ISSYNC,@"ISSYNC", nil];
}

@end
