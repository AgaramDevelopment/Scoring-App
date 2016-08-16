//
//  FETCHSELASTINSTANCEDTLS.m
//  CAPScoringApp
//
//  Created by Mac on 16/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FETCHSELASTINSTANCEDTLS.h"
#import "DBManagerLastInstance.h"


@implementation FETCHSELASTINSTANCEDTLS

-(void) FetchLastinstance:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)ISDEFAULTORLAST
{
    DBManagerLastInstance *dbMgr = [[DBManagerLastInstance alloc]init];
    
    NSString* BATTEAMOVERS = [[NSString alloc] init];
    NSString* BATTEAMOVRBALLS = [[NSString alloc] init];
    NSString* BATTEAMOVRBALLSCNT = [[NSString alloc] init];
    
    [dbMgr UpdateMatchRegistration :ISDEFAULTORLAST: COMPETITIONCODE :MATCHCODE];
    
    BATTEAMOVERS=[ dbMgr GetBattingTeamOversFromOverEvents :COMPETITIONCODE :MATCHCODE:INNINGSNO];
    BATTEAMOVRBALLS=[ dbMgr GetBattingTeamOversFromBallEvents :COMPETITIONCODE :MATCHCODE:INNINGSNO:BATTEAMOVERS];
    
    if([BATTEAMOVRBALLS isEqual:@"0"])
    {
        BATTEAMOVERS= [NSString stringWithFormat:@"%d",BATTEAMOVERS.intValue -1];
        BATTEAMOVRBALLS=[ dbMgr GetBattingTeamOversFromBallEvents :COMPETITIONCODE :MATCHCODE:INNINGSNO:BATTEAMOVERS];
    }
    
    BATTEAMOVRBALLSCNT=[ dbMgr GetBattingTeamOverBallsFromBallEvetns :COMPETITIONCODE :MATCHCODE:INNINGSNO:BATTEAMOVERS:BATTEAMOVRBALLS];
   NSString *LASTBALLCODE=[ dbMgr GetLastBallCodeFromBallEvents :COMPETITIONCODE :MATCHCODE:INNINGSNO:BATTEAMOVERS:BATTEAMOVRBALLS:BATTEAMOVRBALLSCNT];
    
    self.ballEventsArray = [dbMgr GetLastinstancedetailsFromBallevents :COMPETITIONCODE: MATCHCODE :LASTBALLCODE];
    
}

@end
