//
//  ChanceTeamRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerChanceTeam : NSObject


-(NSString*)  GetMatchmaxInningsForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE ;

-(NSString*)  GetBattingTeamCodeForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) MATCHMAXINNINGS;

-(NSString*)  GetBowlingTeamCodeForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES;

-(NSString*)  GetLastOverForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS;

-(NSString*)  GetLastBallForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS: (NSString*) LASTOVER;

-(NSString*)  GetLastBallCountForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS: (NSString*) LASTOVER : (NSString*) LASTBALL;

-(NSMutableArray*)  GetFullDetailsForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS: (NSString*) LASTOVER : (NSString*) LASTBALL : (NSString*) LASTBALLCOUNT;

-(NSMutableArray*) GetBattingteamAndBowlteamForFetchChangeTeam: (NSString*) BATTINGTEAMCODES ;

-(NSMutableArray*) GetStickerNonStrickerNamesdetailsDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS;

-(NSMutableArray*)  GetBowlingTeamNamesdetailsDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BOWLINGTEAMCODE : (NSString*) MATCHMAXINNINGS;




@end
