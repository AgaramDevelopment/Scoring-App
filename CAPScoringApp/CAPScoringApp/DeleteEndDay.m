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
    DBManagerEndDay *objDBManagerEndDay = [[DBManagerEndDay alloc] init];
    // int R_INNINGSNO;
    if([[objDBManagerEndDay GetBallCodeForDeleteEndDay : COMPETITIONCODE : MATCHCODE : DAYNO] isEqual:@""] && ![objDBManagerEndDay GetDayEventsForDeleteEndDay : COMPETITIONCODE : MATCHCODE : DAYNO])
    {
        [objDBManagerEndDay DeleteDayEventsForDeleteEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO];
    }
    NSMutableArray *DeleteEndDayArray=[objDBManagerEndDay GetDeleteEndDay : COMPETITIONCODE : MATCHCODE];
}


@end
