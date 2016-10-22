//
//  SpiderWagonReports.h
//  CAPScoringApp
//
//  Created by Raja sssss on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpiderWagonReports : NSObject



@property(strong,nonatomic)NSString *MATCHTYPECODE;
@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *SESSIONS;
@property(strong,nonatomic)NSString *DAYS;
@property(strong,nonatomic)NSString *STRIKER;
@property(strong,nonatomic)NSString *NONSTRIKER;
@property(strong,nonatomic)NSString *BOWLER;
@property(strong,nonatomic)NSString *SHOT;
@property(strong,nonatomic)NSString *REGION;
@property(strong,nonatomic)NSString *RUNS;
@property(strong,nonatomic)NSString *BOUNFOUR;
@property(strong,nonatomic)NSString *BOUNSIX;
@property(strong,nonatomic)NSString *WIDE;
@property(strong,nonatomic)NSString *NOBALL;
@property(strong,nonatomic)NSString *BYES;
@property(strong,nonatomic)NSString *LEGBYES;
@property(strong,nonatomic)NSString *ISAPPEAL;
@property(strong,nonatomic)NSString *ISUNCOMFORATABLE;
@property(strong,nonatomic)NSString *ISBEATEN;
@property(strong,nonatomic)NSString *ISWICKETTAKINGBALL;
@property(strong,nonatomic)NSString *ISRELEASESHOT;
@property(strong,nonatomic)NSString *FROMOVER;
@property(strong,nonatomic)NSString *TOOVER;
@property(strong,nonatomic)NSString *SHOTTYPECATEGORY;
@property(strong,nonatomic)NSString *BATTINGSTYLE;
@property(strong,nonatomic)NSString *BOWLINGSTYLE;
@property(strong,nonatomic)NSString *BOWLINGTYPE;
@property(strong,nonatomic)NSString *WICKETTYPE;
@property(strong,nonatomic)NSString *BOWLINGSPEC;
@property(strong,nonatomic)NSString *STARTDATE;
@property(strong,nonatomic)NSString *ENDDATE;
@property(strong,nonatomic)NSString *VENUE;


@property(nonatomic,assign)NSNumber *V_FROMOVER;
@property(nonatomic,assign)NSNumber *V_TOOVER;

@property(strong,nonatomic)NSString *DEFAULT;



-(void)fetchSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)SESSIONS:(NSString*)DAYS:(NSString*)STRIKER:(NSString*)NONSTRIKER:(NSString*)BOWLER:(NSString*)SHOT:(NSString*)REGION:(NSString*)RUNS:(NSString*)BOUNFOUR:(NSString*)BOUNSIX:(NSString*)WIDE:(NSString*)NOBALL:(NSString*)BYES:(NSString*)LEGBYES:(NSString*)ISAPPEAL:(NSString*)ISUNCOMFORATABLE:(NSString*)ISBEATEN:(NSString*)ISWICKETTAKINGBALL:(NSString*)ISRELEASESHOT:(NSString*)FROMOVER:(NSString*)TOOVER:(NSString*)SHOTTYPECATEGORY:(NSString*)BATTINGSTYLE:(NSString*)BOWLINGSTYLE:(NSString*)BOWLINGTYPE:(NSString*)WICKETTYPE:(NSString*)BOWLINGSPEC:(NSString*)STARTDATE:(NSString*)ENDDATE:(NSString*)VENUE;





@end
