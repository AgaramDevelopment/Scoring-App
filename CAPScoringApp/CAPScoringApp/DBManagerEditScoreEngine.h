//
//  DBManagerEditScoreEngine.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManagerEditScoreEngine : NSObject


//SP_FETCHSEBALLCODEDETAILS

+(NSMutableArray *) GetTeamDetailsForMatchRegistration:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE;

+(NSMutableArray *) GetTeamDetailsForCompetition:(NSString*) COMPETITIONCODE;

//+(NSMutableArray *) GetTeamDetailsForBallEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BALLCODE;
+(NSMutableArray *) GetTeamDetailsForBallEvents:(NSString*) TEAMACODE: (NSString*) BATTINGTEAMCODE: (NSString*) TEAMBCODE: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BALLCODE;

+(NSString*) GetSessionNoForSessionEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSString*) GetDayNoForSEDayEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSString*) GetInningsStatusForSEInningsEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSMutableArray *) GetBattingTeamNamesForTeamMaster:(NSString*) BATTINGTEAMCODE;

+(NSMutableArray *) GetBowlingTeamNamesForTeamMaster:(NSString*) BOWLINGTEAMCODE;

+(NSMutableArray *) GetRevisedTargetForMatchEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSMutableArray *) GetMatchDetailsForSEMatchRegistration:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSMutableArray *) GetBowlTypeForBallCodeDetails;

+(NSMutableArray *) GetShotTypeForBallCodeDetails;

+(NSMutableArray *) GetBallCodeForBallEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSString*) BALLCODE;

+(NSMutableArray *) GetRetiredHurtChangesForBallevents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO;

+(NSMutableArray *) GetBattingTeamPlayersForMatchRegistration:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetSEGrandTotalForBallEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetPenaltyRunsForBallCodeDetails:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE;

+(NSString*) GetWicketNoForBallCodeDetails:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSMutableArray *) GetBowlingTeamPlayersForMatchRegistration:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS;

+(NSString*) GetTotalBatTeamOversForGrandTotal:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO;

+(NSString*) GetTotalBowlTeamOversForGrandTotal:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSNumber*) INNINGSNO;

+(NSString*) GetFreeHitDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetStrikerBallForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) STRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetStrikerDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) STRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSMutableArray *) GetStrikerDetailsForSEBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT:(NSString*) STRIKERCODE: (NSString *)STRIKERBALLS;

+(NSMutableArray *) GetStrikerDetailsForPlayerMaster:(NSString*) STRIKERCODE;

+(NSString*) GetNonStrikerBallForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) NONSTRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetNonStrikerDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) NONSTRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT;

+(NSMutableArray *) GetNonStrikerDetailsForSEBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT:(NSString*) NONSTRIKERCODE:(NSString *)STRIKERBALLS;

+(NSMutableArray *) GetNonStrikerDetailsForPlayerMaster:(NSString*) NONSTRIKERCODE;

+(NSMutableArray *) GetPartnershipDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetWicketsDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT:(NSNumber*) BOWLERCODE;

+(NSString*) GetBowlerCodeForBowlerOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BOWLERCODE:(NSNumber*) BATTEAMOVERS;

+(NSString*) GetIsPartialOverForBowlerOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS:(NSNumber*) BOWLERCODE;

+(NSMutableArray *) GetBallCountForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BOWLERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT;

+(NSString*) GetBowlerSpellForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSNumber*) BOWLERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT;

+(NSMutableArray *) GetBowlerDetailsForBallEventsDetails:(NSNumber*) ISPARTIALOVER:(NSNumber *) TOTALBALLSBOWL:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BOWLERRUNS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT;

+(NSMutableArray *) GetMatchUmpireDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BALLCODE;

+(NSString*) GetIsInningsLastOverForBallevents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) BATTINGTEAMCODE:(NSNumber*) BATTEAMOVERS;

+(NSMutableArray *) GetBallCodeDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS;

+(NSMutableArray *) GetSETeamDetailsForBallEventsBE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSMutableArray *) GetBallDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) BALLCODE;

+(NSMutableArray *) GetWicketEventDetailsForWicketEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BALLCODE;

+(NSMutableArray *) GetAppealDetailsForAppealEvents:(NSNumber*) BALLCODE;

+(NSMutableArray *) GetPenaltyDetailsForPenaltyEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSNumber*) BALLCODE;

+(NSMutableArray *) GetSpinSpeedBallDetailsForMetadata;

+(NSMutableArray *) GetFastSpeedBallDetailsForMetadata;
+(NSMutableArray *) getFieldingFactorDetails:(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) BALLCODE;


@end
