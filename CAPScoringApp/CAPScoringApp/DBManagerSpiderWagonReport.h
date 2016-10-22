//
//  DBManagerSpiderWagonReport.h
//  CAPScoringApp
//
//  Created by Raja sssss on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerSpiderWagonReport : NSObject




-(NSMutableArray *)getSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)DAYS:(NSString*)SESSIONS:(NSString*)STRIKER:(NSString*)NONSTRIKER:(NSString*)BOWLER:(NSString*)SHOT:(NSString*)REGION:(NSString*)RUNS:(NSString*)BOUNFOUR:(NSString*)BOUNSIX:(NSString*)V_FROMOVER:(NSString*)V_TOOVER:(NSString*)WIDE:(NSString*)NOBALL:(NSString*)BYES:(NSString*)LEGBYES:(NSString*)WIDE:(NSString*)NOBALL:(NSString*)BYES:(NSString*)LEGBYES:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISWICKETTAKINGBALL:(NSString*)ISUNCOMFORATABLE:(NSString*)ISRELEASESHOT:(NSString*)ISBEATEN:(NSString*)ISWICKETTAKINGBALL:(NSString*)ISUNCOMFORATABLE:(NSString*)ISRELEASESHOT:(NSString*)BATTINGSTYLE:(NSString*)BOWLINGSTYLE:(NSString*)SHOTTYPECATEGORY:(NSString*)BOWLINGSPEC:(NSString*)STARTDATE:(NSString*)DEFAULT:(NSString*)ENDDATE;


@end
