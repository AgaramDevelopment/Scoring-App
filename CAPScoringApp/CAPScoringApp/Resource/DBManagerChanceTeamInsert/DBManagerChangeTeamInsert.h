//
//  DBManagerChanceTeamInsert.h
//  CAPScoringApp
//
//  Created by APPLE on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerChangeTeamInsert : NSObject

+(BOOL) SetBallCodeForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) CURRENTBATTINGTEAM:(NSNumber*) CURRENTINNINGSNO;

+(BOOL) SetBallCodeForInsertChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) CURRENTINNINGSNO;

+(BOOL) DeleteInningsBreaksEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteBallEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteBattingSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteOverEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteBowlingSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteBowlingMaidenSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteBowlerOverDetailsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteFieldingEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteDayEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteSessionEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteAppealEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteWicketEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeletePowerplayForChangeTeam:(NSString*) MATCHCODE;

+(BOOL) DeletePlayerInOutTimeForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeletePenaltyDetailsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteMatchEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteInningsSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) DeleteInningsEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) UpadateInningsEventsForChangeTeam:(NSString *) STRIKER:(NSString *) NONSTRIKERCODE:(NSString*) BOWLERCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO;

+(BOOL) DeleteInningsEventsForInsertChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO;
@end
