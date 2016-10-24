//
//  SpiderWagonReports.m
//  CAPScoringApp
//
//  Created by Raja sssss on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SpiderWagonReports.h"
#import "DBManagerSpiderWagonReport.h"

@implementation SpiderWagonReports

@synthesize MATCHTYPECODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize SESSIONS;
@synthesize DAYS;
@synthesize STRIKER;
@synthesize NONSTRIKER;
@synthesize BOWLER;
@synthesize SHOT;
@synthesize REGION;
@synthesize RUNS;
@synthesize BOUNFOUR;
@synthesize BOUNSIX;
@synthesize WIDE;
@synthesize NOBALL;
@synthesize BYES;
@synthesize LEGBYES;
@synthesize ISAPPEAL;
@synthesize ISUNCOMFORATABLE;
@synthesize ISBEATEN;
@synthesize ISWICKETTAKINGBALL;
@synthesize ISRELEASESHOT;
@synthesize FROMOVER;
@synthesize TOOVER;
@synthesize SHOTTYPECATEGORY;
@synthesize BATTINGSTYLE;
@synthesize BOWLINGSTYLE;
@synthesize BOWLINGTYPE;
@synthesize WICKETTYPE;
@synthesize BOWLINGSPEC;
@synthesize STARTDATE;
@synthesize ENDDATE;
@synthesize VENUE;

@synthesize V_FROMOVER;
@synthesize V_TOOVER;
@synthesize DEFAULT;

//Fetch Spider Wagon details


-(void)fetchSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)DAYS:(NSString*)SESSIONS:(NSString*)STRIKER:(NSString*)NONSTRIKER:(NSString*)BOWLER:(NSString*)SHOT:(NSString*)REGION:(NSString*)RUNS:(NSString*)BOUNFOUR:(NSString*)BOUNSIX:(NSString*)V_FROMOVER:(NSString*)V_TOOVER:(NSString*)WIDE:(NSString*)NOBALL:(NSString*)BYES:(NSString*)LEGBYES:(NSString*)WIDE:(NSString*)NOBALL:(NSString*)BYES:(NSString*)LEGBYES:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISWICKETTAKINGBALL:(NSString*)ISUNCOMFORATABLE:(NSString*)ISRELEASESHOT:(NSString*)ISBEATEN:(NSString*)ISWICKETTAKINGBALL:(NSString*)ISUNCOMFORATABLE:(NSString*)ISRELEASESHOT:(NSString*)BATTINGSTYLE:(NSString*)BOWLINGSTYLE:(NSString*)SHOTTYPECATEGORY:(NSString*)BOWLINGSPEC:(NSString*)STARTDATE:(NSString*)DEFAULT:(NSString*)ENDDATE;


{
    
    DBManagerSpiderWagonReport *dbSpiderWagon = [[DBManagerSpiderWagonReport alloc]init];

    
    
//   [dbSpiderWagon getSpiderWagon:MATCHTYPECODE :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :STRIKERCODE :NONSTRIKERCODE :BOWLERCODE :RUNS :ISFOUR :ISSIX];
    
    
    
    
 

    
    
}














@end
