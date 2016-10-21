//
//  SpiderWagonReports.m
//  CAPScoringApp
//
//  Created by Raja sssss on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SpiderWagonReports.h"

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


//Fetch Spider Wagon details

-(void)fetchSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)SESSIONS:(NSString*)DAYS:(NSString*)STRIKER:(NSString*)NONSTRIKER:(NSString*)BOWLER:(NSString*)SHOT:(NSString*)REGION:(NSString*)RUNS:(NSString*)BOUNFOUR:(NSString*)BOUNSIX:(NSString*)WIDE:(NSString*)NOBALL:(NSString*)BYES:(NSString*)LEGBYES:(NSString*)ISAPPEAL:(NSString*)ISUNCOMFORATABLE:(NSString*)ISBEATEN:(NSString*)ISWICKETTAKINGBALL:(NSString*)ISRELEASESHOT:(NSString*)FROMOVER:(NSString*)TOOVER:(NSString*)SHOTTYPECATEGORY:(NSString*)BATTINGSTYLE:(NSString*)BOWLINGSTYLE:(NSString*)BOWLINGTYPE:(NSString*)WICKETTYPE:(NSString*)BOWLINGSPEC:(NSString*)STARTDATE:(NSString*)ENDDATE:(NSString*)VENUE
{
    
    
    V_FROMOVER = [NSNumber numberWithInt:0];
    V_TOOVER = [NSNumber numberWithInt:0];
    
    
    if ([FROMOVER isEqualToString:nil] || [FROMOVER isEqualToString:@""]) {
        
        V_FROMOVER = [NSNumber numberWithInt: -1];
    }else{
        V_FROMOVER = [NSNumber numberWithInt: FROMOVER.intValue];
    }
    
    
    if ([TOOVER isEqualToString:nil] || [TOOVER isEqualToString:@""]) {
        
    V_TOOVER = [NSNumber numberWithInt: -1];
        
    }else{
        V_TOOVER = [NSNumber numberWithInt: TOOVER.intValue];
    }
    
    
    NSString *DEFAULT = @"0001-01-01";
    
    if ([STARTDATE isEqualToString:@""]) {
        
        STARTDATE = [NSString stringWithFormat:@"%@",DEFAULT];
        
    }
        
    if ([ENDDATE isEqualToString:@""]) {
        
        ENDDATE = [NSString stringWithFormat:@"%@",DEFAULT];
    }
    

    
    
    
    
}














@end
