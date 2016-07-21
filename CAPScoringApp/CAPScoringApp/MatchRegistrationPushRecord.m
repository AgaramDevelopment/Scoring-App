//
//  MatchRegistrationPushRecord.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "MatchRegistrationPushRecord.h"

@implementation MatchRegistrationPushRecord



@synthesize MATCHCODE;
@synthesize MATCHNAME;
@synthesize COMPETITIONCODE;
@synthesize MATCHOVERS;
@synthesize MATCHOVERCOMMENTS;
@synthesize MATCHDATE;
@synthesize ISDAYNIGHT;
@synthesize ISNEUTRALVENUE;
@synthesize GROUNDCODE;
@synthesize TEAMACODE;
@synthesize TEAMBCODE;
@synthesize TEAMACAPTAIN;
@synthesize TEAMAWICKETKEEPER;
@synthesize TEAMBCAPTAIN;
@synthesize TEAMBWICKETKEEPER;
@synthesize UMPIRE1CODE;
@synthesize UMPIRE2CODE;
@synthesize UMPIRE3CODE;
@synthesize MATCHREFEREECODE;

@synthesize MATCHRESULT;
@synthesize MATCHRESULTTEAMCODE;
@synthesize TEAMAPOINTS;
@synthesize TEAMBPOINTS;
@synthesize MATCHSTATUS;
@synthesize RECORDSTATUS;
@synthesize CREATEDBY;
@synthesize CREATEDDATE;
@synthesize MODIFIEDBY;
@synthesize MODIFIEDDATE;
@synthesize ISDEFAULTORLASTINSTANCE;
//@synthesize RELATIVEVIDEOLOCATION;


@synthesize ISSYNC;



-(NSDictionary *)MatchRegistrationPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:MATCHCODE,@"MATCHCODE",MATCHNAME,@"MATCHNAME", COMPETITIONCODE,@"COMPETITIONCODE",MATCHOVERS,@"MATCHOVERS", MATCHOVERCOMMENTS,@"MATCHOVERCOMMENTS", MATCHDATE,@"MATCHDATE",ISDAYNIGHT,@"ISDAYNIGHT",ISNEUTRALVENUE,@"ISNEUTRALVENUE", GROUNDCODE,@"GROUNDCODE",TEAMACODE,@"TEAMACODE", TEAMBCODE,@"TEAMBCODE", TEAMACAPTAIN,@"TEAMACAPTAIN",TEAMAWICKETKEEPER,@"TEAMAWICKETKEEPER", TEAMBCAPTAIN,@"TEAMBCAPTAIN", TEAMBWICKETKEEPER,@"TEAMBWICKETKEEPER", UMPIRE1CODE,@"UMPIRE1CODE", UMPIRE2CODE,@"UMPIRE2CODE", UMPIRE3CODE,@"UMPIRE3CODE", MATCHREFEREECODE,@"MATCHREFEREECODE", MATCHRESULT,@"MATCHRESULT", MATCHRESULTTEAMCODE,@"MATCHRESULTTEAMCODE",TEAMAPOINTS,@"TEAMAPOINTS", TEAMBPOINTS,@"TEAMBPOINTS", MATCHSTATUS,@"MATCHSTATUS", RECORDSTATUS,@"RECORDSTATUS", CREATEDBY,@"CREATEDBY", CREATEDDATE,@"CREATEDDATE", MODIFIEDBY,@"MODIFIEDBY", MODIFIEDDATE,@"MODIFIEDDATE", ISDEFAULTORLASTINSTANCE,@"ISDEFAULTORLASTINSTANCE", nil];
}

@end
