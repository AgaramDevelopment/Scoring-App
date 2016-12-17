//
//  DBManagerBatsmanInOutTime.h
//  CAPScoringApp
//
//  Created by APPLE on 28/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManagerBatsmanInOutTime : NSObject

-(NSMutableArray * )getBATTINGPLAYERSTATISTICS:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *) ININGSNO :(NSString *) TeamCode;

-(NSMutableArray * )getBatsManBreakTime:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *) ININGSNO :(NSString *) TeamCode;



-(BOOL)INSERTPLAYERINOUTTIME :(NSString *) COMPETITIONCODE:(NSString *)INNINGSNO :(NSString *) MATCHCODE:(NSString *) TEAMCODE :(NSString *) PLAYERCODE :(NSString *) INTIME :(NSString *) OUTTIME;

-(BOOL) UPDATEPLAYERINOUT :(NSString *) COMPETITIONCODE :(NSString *)MATCHCODE :(NSString *)TEAMCODE:(NSString *)INNINGSNO:(NSString *)PLAYERCODE :(NSString *)INTIME:(NSString *)OUTTIME :(NSString *) oldplayercode;

-(BOOL) DELETEPLAYERINOUTTIME :(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE:(NSString *)INNINGSNO:(NSString *)PLAYERCODE;

-(BOOL) FETCHBREAKMINUTES :(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO:(NSString *)PLAYERINTIME : (NSString *) PLAYEROUTTIME;

-(NSString *) FETCHDURATION :(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO:(NSString *)PLAYERCODE;

@end
