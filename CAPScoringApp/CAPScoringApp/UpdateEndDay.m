//
//  UpdateEndDay.m
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "UpdateEndDay.h"
#import "DBManagerEndDay.h"
@implementation UpdateEndDay
//SP_UPDATEENDDAY
-(void) UpdateEndDay:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)STARTTIME:(NSString*)ENDTIME:(NSString*)DAYNO:(NSString*)BATTINGTEAMCODE:(NSString*)COMMENTS:(NSString*)ENDTIMEFORMAT:(NSString*)STARTTIMEFORMAT
{
    if(![DBManagerEndDay GetStartTimeForDayEvents : ENDTIMEFORMAT : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO])
    {
        [DBManagerEndDay UpdateDayEventsForEndDay : STARTTIME : ENDTIME : COMMENTS : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO];
    }
    NSMutableArray *UpdateEndDayArray=[DBManagerEndDay GetDayEventsForUpdateEndDay : COMPETITIONCODE : MATCHCODE];
}
    
    @end
