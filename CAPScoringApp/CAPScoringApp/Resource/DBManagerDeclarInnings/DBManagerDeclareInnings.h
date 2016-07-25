//
//  DBManagerDeclareInnings.h
//  CAPScoringApp
//
//  Created by mac on 27/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerDeclareInnings : NSObject


-(BOOL) GetBallCodeForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO;

-(NSString*) GetTeamNameForUpdateDeclareInnings:(NSString*) TEAMCODE;

-(NSString*) GetTotalRunForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO;
-(NSString*) GetOverNoForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO;

-(NSString*)GetBallNoForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) OVERNO:(NSString*) INNINGSNO;

-(NSString*) GetOverStatusForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) OVERNO:(NSString*) INNINGSNO;

-(NSString*)GetWicketForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO;


-(BOOL) UpdateInningsEventForUpdateDeclareInnings:(NSString*) TEAMCODE:(NSString*) TOTALRUN:(NSString*) OVERBALLNO:(NSString*)WICKETS:(NSString*) ISDECLARE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO;

-(BOOL) GetBallCodeInRevertInningsForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO;

-(BOOL) UpdateInningsEventInRevertInningsForUpdateDeclareInnings:(NSString*) ISDECLARE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO;

-(BOOL) DeleteInningsEventForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO;
-(BOOL) DeleteMatchResultForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
@end

