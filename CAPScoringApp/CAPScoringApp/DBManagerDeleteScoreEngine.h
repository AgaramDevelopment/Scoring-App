//
//  DBManagerDeleteScoreEngine.h
//  CAPScoringApp
//
//  Created by mac on 09/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManagerDeleteScoreEngine : NSObject

-(NSInteger)GetMaxInningsNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE;

-(NSInteger)GetMaxOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS;

-(NSInteger)GetMaxBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER;

-(NSInteger)GetMaxBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL;

-(NSInteger)GetMaxSessionNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL : (NSInteger)MAXBALLCOUNT;

-(NSInteger)GetMaxDayNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL : (NSInteger)MAXBALLCOUNT;

-(NSMutableArray *)GetBallDetailsForDeleteScoreEngine:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BALLCODE:(NSString*)BALLCODE;

-(NSString*) GetBowlingTeamForDeleteScoreEngine:(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE;

-(NSInteger)GetBatteamOversForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)MAXINNINGS;

-(NSInteger)GetBatteamOversWithExtraBallsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)MAXINNINGS : (NSInteger)BATTEAMOVERS;

-(NSInteger)GetBatteamOversBallsCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)MAXINNINGS : (NSInteger)BATTEAMOVERS : (NSInteger)BATTEAMOVRWITHEXTRASBALLS;

-(NSMutableArray *)GetCurrentPlayersDetailsForDeleteScoreEngine : (NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString*)BATTINGTEAMCODE INNINGSNO:(NSNumber*)INNINGSNO BATTEAMOVERS:(NSInteger)BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:(NSInteger)BATTEAMOVRWITHEXTRASBALLS BATTEAMOVRBALLSCNT:(NSInteger)BATTEAMOVRBALLSCNT;

-(BOOL) UpdateInningsEventsWithCurrentValuesForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)CURRENTSTRIKERCODE : (NSString*)CURRENTNONSTRIKERCODE : (NSString*)CURRENTBOWLERCODE : (NSInteger)BATTEAMOVRWITHEXTRASBALLS : (NSInteger)BATTEAMOVRBALLSCNT;

-(BOOL) UpdateInningsEventsWithExistingValuesForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO;

-(NSNumber *)GetWicketsCountableCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(NSNumber *)GetIsWicketCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(NSString *)GetWicketTypeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(NSString*)GetBallCodeInWicketsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(NSMutableArray *)GetWicketPlayerAndNoDetailsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(BOOL) DeleteWicketEventsWithBallCodeForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(BOOL) UpdateWicketEventsWicketNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSNumber*)WICKETNO;

-(BOOL) DeletePenaltyDetailsForDeleteScoreEngine: (NSString*) BALLCODE;

-(BOOL) DeleteAppealDetailsForDeleteScoreEngine: (NSString*) BALLCODE;

-(BOOL) DeleteFieldingDetailsForDeleteScoreEngine: (NSString*) BALLCODE;

-(BOOL) DeleteBallEventDetailsForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE;

-(NSString*)GetBowlerCodeInCurrentOverForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO : (NSString*)BALLCODE;

-(BOOL)  UpdateBowlingOrderDeleteScoreEngine : (NSString*) MATCHCODE :(NSString*) BOWLINGTEAMCODE :(NSString*) BATTINGTEAMCODE : (NSNumber*)INNINGSNO;

-(BOOL)  DeleteRemoveUnusedBatFBSDeleteScoreEngine : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) TEAMCODE : (NSNumber*) INNINGSNO;

-(BOOL)  DeleteRemoveUnusedBowFBSDeleteScoreEngine : (NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSNumber*)INNINGSNO : (NSString*) BOWLINGTEAMCODE;

-(BOOL)  UpdateOverBallCountInBallEventtForInsertScoreEngine : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSString*) OVERNO;

-(NSInteger)GetCurrentOverBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO;

-(NSString*)GetBallCodeCountInFutureOversForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO;

-(BOOL) UpdateOverEventWithOverStatusForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO;

-(BOOL) DeleteOverEventInFutureOverForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO;

-(BOOL) UpdateBowlerOverEventWithOverStatusForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO;

-(BOOL) DeleteBowlerOverEventInFutureOverForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO;

-(BOOL) UpdateBallEventForBallCountWithOldBallCountForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLCOUNT : (NSInteger)BALLNO;

-(BOOL) UpdateBallEventForBallNoWithOldBallNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO;

-(BOOL) UpdateBallEventForBallCountOnlyWithOldBallCountForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLCOUNT : (NSInteger)BALLNO;

-(NSString*)GetBallCodeCountWithCurrentOverBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO;

-(NSString*)GetBallCodeCountWithCurrentOverBallNoAndPreviousBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO : (NSInteger)BALLCOUNT;

-(NSInteger)GetMaxOverBallCountWithCurrentOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO;

-(NSString*)GetBallCodeCountWithCurrentOverBallNoAndPreviousBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO;

-(NSInteger)GetMaxOverBallCountWithCurrentOverBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO;

-(NSInteger)GetMaxOverBallNoWithCurrentOverBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO;

-(NSInteger)GetMaxOverBallNoWithCurrentOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO;

-(NSInteger)GetMaxOverBallCountWithCurrentOverNoAndBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO;

-(NSString*)GetBallCodeWithCurrentOverBallNoAndBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSInteger)BALLNO : (NSInteger)BALLCOUNT;

-(NSString*)GetBallCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSString*)BOWLERCODE;

-(BOOL) DeleteBowlerOverEventForCurrentOverNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSString*)BOWLERCODE;

-(NSString*)GetOtherBowlerCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSString*)BOWLERCODE;

-(NSInteger)GetOtherBowlerOverBallCountWithCurrentOverAndBowlerCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSString*)OTHERBOWLERCODE;

-(NSInteger)GetOtherBowlerOverStatusWithCurrentOverForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO;

-(BOOL) UpdateOtherBowlerBowlingSummaryForCurrentOverNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSString*)OTHERBOWLER : (NSInteger)ISOVERCOMPLETE : (NSInteger)OTHERBOWLEROVERBALLCNT;

-(NSString*)GetBallCodeWithCurrentMatchCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE;

-(BOOL) UpdateMatchStatusBasedOnMatchCodeForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE;

-(NSMutableArray *)GetWicketOverNoAndBallNoAndBallCountWithStrikerAndNonStrikerForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BATSMANCODE;

-(NSInteger)GetBallCodeCountWithWicketBallNoOverNoBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BATSMANCODE : (NSInteger)W_OVERNO : (NSInteger)W_BALLNO : (NSInteger)W_BALLCOUNT;

-(BOOL) UpdateWicketTypeBasedOnMatchCodeBatmanForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BATSMANCODE;

-(NSString*)GetMatchCodeWithMatchCodeAndResultForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE;

-(NSString*)GetTossWonTeamWithMatchCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE;

-(NSString*)GetBallCodeFromBallEventsWithMatchCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE;

-(BOOL) UpdateMatchRegistrationWithMatchResultBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)MATCHRESULT : (NSString*)MATCHSTATUS;

-(BOOL) UpdateMatchResultBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)MATCHRESULT;

-(BOOL) DeleteSessionBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXSESSIONNO : (NSInteger)MAXDAYNO;

-(BOOL) DeleteDayEventsBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXSESSIONNO : (NSInteger)MAXDAYNO;

-(BOOL) UpdateInningsEventsBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS;





@end
