//
//  DBManagerLastInstance.h
//  CAPScoringApp
//
//  Created by Mac on 16/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerLastInstance : NSObject
-(BOOL)  UpdateMatchRegistration: (NSString*) ISDEFAULTORLAST: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE;
-(NSString *) GetBattingTeamOversFromOverEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;
-(NSString*) GetBattingTeamOversFromBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BATTEAMOVERS;
-(NSString*) GetBattingTeamOverBallsFromBallEvetns:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BATTEAMOVERS:(NSString*) BATTEAMOVRBALLS;
-(NSString *) GetLastBallCodeFromBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BATTEAMOVERS:(NSString*) BATTEAMOVRBALLS:(NSString*) BATTEAMOVRBALLSCNT;
-(NSMutableArray *)  GetLastinstancedetailsFromBallevents: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) LASTBALLCODE;


@end
