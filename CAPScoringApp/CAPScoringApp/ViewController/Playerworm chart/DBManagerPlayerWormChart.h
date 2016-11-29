//
//  DBManagerPlayerWormChart.h
//  CAPScoringApp
//
//  Created by Raja sssss on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManagerPlayerWormChart : NSObject

-(NSString *) fetchMaxInnsNo:(NSString*) MATCHCODE;
-(NSString *) FetchMinBatNo:(NSString*) MATCHCODE :(NSInteger )ICOUNT;
-(NSString *) FetchTeamCode:(NSString*)COMPETITIONCODE : (NSString*) MATCHCODE :(NSInteger )ICOUNT;
-(NSString *) FetchTeamCount:(NSString*)TEAMCODE : (NSString*) MATCHCODE;
-(NSString *) FetchStrikerCode:(NSString*)MATCHCODE : (NSInteger ) ICOUNT : (NSInteger) LOOPCOUNT;
-(NSMutableArray *) fetchMinAndMaxOver :(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE;

-(NSMutableArray *) fetchMinAndMaxOverNotEqual:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE;
-(NSString *) FetchMinBall:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MINOVERSTRIKER;
-(NSString *) FetchMinBallEquals:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MINOVERSTRIKER;
-(NSString *) FetchMaxBall:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MAXOVERSTRIKER;

-(NSString *) FetchMaxBallEquals:(NSString*) COMPETITIONCODE : (NSString*) MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MAXOVERSTRIKER;


-(NSMutableArray *) fetchPlayerWormdetails:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSString *) STRIKERCODE;
@end
