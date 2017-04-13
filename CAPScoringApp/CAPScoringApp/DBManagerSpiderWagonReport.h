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


//Spider Wagon Wheel
-(NSMutableArray *)getSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE:(NSString*)RUNS:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)ISONSIDE;

//Sector Wagon Wheel
-(NSMutableArray *)getSectorWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE:(NSString*)RUNS:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)ISONSIDE;

-(NSMutableArray *) getStrickerdetail :(NSString *) matchCode :(NSString * )Teamcode;


-(NSMutableArray *) getBowlerdetail :(NSString *) matchCode :(NSString * )Teamcode:(NSString * )InningsNo;

-(NSString *) getTeamBCode:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE;

-(NSString *) getTotalRuns:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO;

-(NSString *) getBowlingTeamCode:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE;


@end
