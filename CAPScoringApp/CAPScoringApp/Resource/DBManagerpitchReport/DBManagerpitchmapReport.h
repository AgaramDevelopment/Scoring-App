//
//  DBManagerpitchmapReport.h
//  CAPScoringApp
//
//  Created by APPLE on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerpitchmapReport : NSObject

-(void)getPitchmapReport:(NSString *)MATCHTYPECODE:(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE :(NSString *)INNINGSNO:(NSString *)SESSIONS:(NSString *)DAYS:(NSString *)STRIKER:(NSString *)NONSTRIKER:(NSString *)BOWLER :(NSString *)SHOT:(NSString *)REGION:(NSString *)RUNS:(NSString *)BOUNFOUR:(NSString *)BOUNSIX:(NSString *)WIDE:(NSString *)NOBALL:(NSString *)BYES:(NSString *)LEGBYES:(NSString *)ISAPPEAL:(NSString *)ISUNCOMFORATABLE:(NSString *)ISBEATEN:(NSString *)ISWICKETTAKINGBALL:(NSString *)ISRELEASESHOT:(NSString *)FROMOVER:(NSString *)TOOVER:(NSString *)SHOTTYPECATEGORY:(NSString *)BATTINGSTYLE:(NSString *)BOWLINGSTYLE:(NSString *)BOWLINGTYPE:(NSString *)WICKETTYPE:(NSString *)BOWLINGSPEC:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)VENUE;


-(NSString *)getPenaltyRuns:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO;
-(NSString *)getTeamCode:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO;


-(NSMutableArray *)getSummaryAndExtras:(NSString *)MATCHTYPECODE:(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE :(NSString *)INNINGSNO:(NSString *)SESSIONS:(NSString *)DAYS:(NSString *)STRIKER:(NSString *)NONSTRIKER:(NSString *)BOWLER :(NSString *)SHOT:(NSString *)REGION:(NSString *)RUNS:(NSString *)BOUNFOUR:(NSString *)BOUNSIX:(NSString *)WIDE:(NSString *)NOBALL:(NSString *)BYES:(NSString *)LEGBYES:(NSString *)ISAPPEAL:(NSString *)ISUNCOMFORATABLE:(NSString *)ISBEATEN:(NSString *)ISWICKETTAKINGBALL:(NSString *)ISRELEASESHOT:(NSString *)FROMOVER:(NSString *)TOOVER:(NSString *)SHOTTYPECATEGORY:(NSString *)BATTINGSTYLE:(NSString *)BOWLINGSTYLE:(NSString *)BOWLINGTYPE:(NSString *)WICKETTYPE:(NSString *)BOWLINGSPEC:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)VENUE:(NSString *)TEAMPENALITYRUNS:(NSString*)DEFAULT;


-(NSMutableArray *)getWicketcount:(NSString *)MATCHTYPECODE:(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE :(NSString *)INNINGSNO:(NSString *)SESSIONS:(NSString *)DAYS:(NSString *)STRIKER:(NSString *)NONSTRIKER:(NSString *)BOWLER :(NSString *)SHOT:(NSString *)REGION:(NSString *)RUNS:(NSString *)BOUNFOUR:(NSString *)BOUNSIX:(NSString *)WIDE:(NSString *)NOBALL:(NSString *)BYES:(NSString *)LEGBYES:(NSString *)ISAPPEAL:(NSString *)ISUNCOMFORATABLE:(NSString *)ISBEATEN:(NSString *)ISWICKETTAKINGBALL:(NSString *)ISRELEASESHOT:(NSString *)FROMOVER:(NSString *)TOOVER:(NSString *)SHOTTYPECATEGORY:(NSString *)BATTINGSTYLE:(NSString *)BOWLINGSTYLE:(NSString *)BOWLINGTYPE:(NSString *)WICKETTYPE:(NSString *)BOWLINGSPEC:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)VENUE:(NSString *)DEFAULT;

-(NSMutableArray *)getPitchmapdetails:(NSString *) MATCHTYPECODE :(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *) TEAMCODE :(NSString *) INNINGSNO:(NSString *) STRIKER:(NSString *) RUNS :(NSString *)lengthcode :(NSString *) linecode:(NSString *)ballWKt;

-(NSMutableArray *) getLine;
-(NSMutableArray *)getLength;
-(NSMutableArray *) getStrickerdetail :(NSString *) matchCode :(NSString * )Teamcode;



@end
