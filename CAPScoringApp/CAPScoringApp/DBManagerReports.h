//
//  DBManagerReports.h
//  CAPScoringApp
//
//  Created by Raja sssss on 18/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerReports : NSObject

-(NSMutableArray *)fetchResultsMatches:(NSString*)competitionCode :(NSString*)userCode ;
-(NSMutableArray *)fetchLiveMatches:(NSString*)competitionCode :(NSString*)userCode ;
-(NSMutableArray *)FixturesData:(NSString*)competitionCode :(NSString*)userCode;
-(NSMutableArray *)retrieveTorunamentData: (NSString *) userCode;

-(NSMutableArray *)fetchPlayers:(NSString*)matchCode :(NSString*)teamCode;
-(NSMutableArray *)retrieveCommentaryData: (NSString *) matchCode : (NSString *) inningsNo ;
-(NSMutableArray *)retrieveBatVsBowlBowlersList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo;
-(NSMutableArray *)retrieveBatVsBowlBatsmanList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo;
-(NSMutableArray *)retrieveBowVsBatsBowlersList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo;
-(NSMutableArray *)retrieveBowVsBatsBatsmanList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo;
-(NSMutableArray *)retrieveWormChartDetails: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo;
-(NSMutableArray *)retrieveWormWicketDetails: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo;
@end
