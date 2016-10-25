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



-(NSMutableArray *)getSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE:(NSString*)RUNS:(NSString*)ISFOUR:(NSString*)ISSIX;

-(NSMutableArray *) getStrickerdetail :(NSString *) matchCode :(NSString * )Teamcode;


@end
