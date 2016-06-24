//
//  DeleteEndDay.m
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DeleteEndDay.h"
#import "DBManagerEndDay.h"

@implementation DeleteEndDay
//SP_DELETEENDDAY
-(void) DeleteEndDay:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)DAYNO
{
    // int R_INNINGSNO;
    if(![DBManagerEndDay GetBallCodeForDeleteEndDay : COMPETITIONCODE : MATCHCODE : DAYNO] && ![DBManagerEndDay GetDayEventsForDeleteEndDay : COMPETITIONCODE : MATCHCODE : DAYNO])
    {
        [DBManagerEndDay DeleteDayEventsForDeleteEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO];
    }
    NSMutableArray *DeleteEndDayArray=[DBManagerEndDay GetDeleteEndDay : COMPETITIONCODE : MATCHCODE];
}


@end
