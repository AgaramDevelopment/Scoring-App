//
//  DeleteScoreEngine.m
//  CAPScoringApp
//
//  Created by mac on 09/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DeleteScoreEngine.h"
#import "DBManagerDeleteScoreEngine.h"
#import "DeleteBallRecord.h"
#import "UpdateScoreEngine.h"


@implementation DeleteScoreEngine
-(void)DeleteScoreEngineMethod : (NSString*)BALLCODE : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BOWLERCODE : (NSString*)REVERT
{
    NSString* BATTINGTEAMCODE = @"";
    NSString* BOWLINGTEAMCODE = @"";
    
    NSNumber *MATCHOVERS;
    
    NSNumber * INNINGSNO = [NSNumber numberWithInt:0];
    NSString * S_OVERNO = @"";
    NSNumber * S_BALLNO = [NSNumber numberWithInt:0];
    NSNumber * S_BALLCOUNT = [NSNumber numberWithInt:0];
    NSNumber * S_NOBALL = [NSNumber numberWithInt:0];
    NSNumber * S_WIDE = [NSNumber numberWithInt:0];
    NSNumber * S_ISFOUR =[NSNumber numberWithInt:0];
    NSNumber * S_ISSIX =[NSNumber numberWithInt:0];
    NSNumber * S_RUNS   = [NSNumber numberWithInt:0];
    NSNumber * S_OVERTHROW =[NSNumber numberWithInt:0];
    NSNumber * S_BYES =[NSNumber numberWithInt:0];
    NSNumber * S_LEGBYES =[NSNumber numberWithInt:0];
    NSNumber * S_PENALTY =[NSNumber numberWithInt:0];
    NSNumber * S_ISDELETE =[NSNumber numberWithInt:1];
    NSNumber * S_WICKETSCORE =[NSNumber numberWithInt:0];
    NSNumber *ISWICKETUNDO = [NSNumber numberWithInt:0];
    NSString* WICKETPLAYER;
    
    NSString* SB_STRIKERCODE;
   // NSString* SB_BOWLERCODE = BOWLERCODE;
    NSString* SB_NONSTRIKERCODE;
    NSInteger MAXINNINGS;
    NSInteger MAXOVER;
    NSInteger MAXBALL;
    NSInteger MAXBALLCOUNT;
    NSInteger MAXSESSIONNO;
    NSInteger MAXDAYNO;
    
    DBManagerDeleteScoreEngine * objDBManagerDeleteScoreEngine = [[DBManagerDeleteScoreEngine alloc]init];
    
    MAXINNINGS = [objDBManagerDeleteScoreEngine GetMaxInningsNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
    MAXOVER   = [objDBManagerDeleteScoreEngine GetMaxOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE:MAXINNINGS];
    
    MAXBALL  = [objDBManagerDeleteScoreEngine GetMaxBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER];
    
    MAXBALLCOUNT = [objDBManagerDeleteScoreEngine GetMaxBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER :MAXBALL];
    
    MAXSESSIONNO = [objDBManagerDeleteScoreEngine GetMaxSessionNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER :MAXBALL :MAXBALLCOUNT];
    
    MAXDAYNO   = [objDBManagerDeleteScoreEngine GetMaxDayNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER :MAXBALL :MAXBALLCOUNT];
    
    NSMutableArray * BallDetail =[objDBManagerDeleteScoreEngine GetBallDetailsForDeleteScoreEngine:COMPETITIONCODE MATCHCODE:MATCHCODE BALLCODE:BALLCODE];
    
    if(BallDetail.count>0)
    {
        //DeleteBallRecord * objRecord =[[DeleteBallRecord alloc]init];
         DeleteBallRecord * objRecord =[BallDetail objectAtIndex:0];
        BATTINGTEAMCODE =objRecord.battingTeamCode;
        INNINGSNO       =objRecord.inningsno;
        S_OVERNO        = objRecord.overNo;
        S_BALLNO        =objRecord.ballNo;
        SB_STRIKERCODE  =objRecord.StrikerCode;
        S_ISFOUR        =objRecord.isFour;
        S_ISSIX         =objRecord.isSix;
        S_RUNS          =objRecord.Runs;
        S_OVERTHROW     =objRecord.overThrow;
        S_PENALTY       =objRecord.Penalty;
        S_BYES          =objRecord.Byes;
        S_LEGBYES       = objRecord.legByes;
    }
    
    
    BOWLINGTEAMCODE = [objDBManagerDeleteScoreEngine GetBowlingTeamForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
    
    
    
     NSInteger BATTEAMOVERS = 0;
    
    NSInteger BATTEAMOVRWITHEXTRASBALLS = 0;
    
    NSInteger BATTEAMOVRBALLSCNT = 0;
    BATTEAMOVERS = [objDBManagerDeleteScoreEngine GetBatteamOversForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :MAXINNINGS];
    
    BATTEAMOVRWITHEXTRASBALLS =[objDBManagerDeleteScoreEngine GetBatteamOversWithExtraBallsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :MAXINNINGS :BATTEAMOVERS];
    
    BATTEAMOVRBALLSCNT = [objDBManagerDeleteScoreEngine GetBatteamOversBallsCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :MAXINNINGS :BATTEAMOVERS :BATTEAMOVRWITHEXTRASBALLS];
    
   
    
    
    NSString* CURRENTSTRIKERCODE = @"";
    NSString* CURRENTNONSTRIKERCODE =@"";
    NSString* CURRENTBOWLERCODE=@"";
    
    NSMutableArray * currentplayerDetail = [objDBManagerDeleteScoreEngine GetCurrentPlayersDetailsForDeleteScoreEngine:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO BATTEAMOVERS:BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:BATTEAMOVRWITHEXTRASBALLS BATTEAMOVRBALLSCNT:BATTEAMOVRBALLSCNT];
    if(currentplayerDetail.count>0)
    {
        DeleteBallRecord*objRecord =[currentplayerDetail objectAtIndex:0];
        CURRENTSTRIKERCODE =objRecord.CurrentStrikercode;
        CURRENTNONSTRIKERCODE = objRecord.CurrentNonStrikerCode;
        CURRENTBOWLERCODE     = objRecord.CurrenBowlerCode;
    }
    
    BOOL UpdateInningsEventsWithCurrentValues =[objDBManagerDeleteScoreEngine UpdateInningsEventsWithCurrentValuesForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :CURRENTSTRIKERCODE :CURRENTNONSTRIKERCODE :CURRENTBOWLERCODE :BATTEAMOVRWITHEXTRASBALLS :BATTEAMOVRBALLSCNT];
    
    BOOL UpdateInningsEventsWithExistingValues = [objDBManagerDeleteScoreEngine UpdateInningsEventsWithExistingValuesForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
    
    
    NSNumber * F_ISWICKET = 0;
    NSNumber * F_ISWICKETCOUNTABLE = 0;
    NSString * F_WICKETTYPE = @"";
    
    
    F_ISWICKETCOUNTABLE =[objDBManagerDeleteScoreEngine GetWicketsCountableCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];

    F_ISWICKET =[objDBManagerDeleteScoreEngine GetIsWicketCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    F_WICKETTYPE = [objDBManagerDeleteScoreEngine GetWicketTypeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    NSString * BallCodeInWickets =[objDBManagerDeleteScoreEngine GetBallCodeInWicketsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    NSMutableArray * WicketPlayerAndNoDetails =[objDBManagerDeleteScoreEngine GetWicketPlayerAndNoDetailsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    BOOL DeleteWicketEventsWithBallCode = [objDBManagerDeleteScoreEngine DeleteWicketEventsWithBallCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    BOOL UpdateWicketEventsWicketNo =[objDBManagerDeleteScoreEngine UpdateWicketEventsWicketNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :F_ISWICKET];
    
    BOOL DeletePenaltyDetails = [objDBManagerDeleteScoreEngine DeletePenaltyDetailsForDeleteScoreEngine:BALLCODE];
    
    BOOL DeleteAppealDetails = [objDBManagerDeleteScoreEngine DeleteAppealDetailsForDeleteScoreEngine:BALLCODE];
    
    BOOL DeleteFieldingDetails = [objDBManagerDeleteScoreEngine DeleteFieldingDetailsForDeleteScoreEngine:BALLCODE];
    
    UpdateScoreEngine * objupdateScoreEngine = [[UpdateScoreEngine alloc]init];
        

    
    [objupdateScoreEngine UpdateScoreBoard : BALLCODE :COMPETITIONCODE :MATCHCODE : BATTINGTEAMCODE :BOWLINGTEAMCODE :INNINGSNO :SB_STRIKERCODE :S_ISFOUR :S_ISSIX :S_RUNS :S_OVERTHROW :F_ISWICKET :F_WICKETTYPE :WICKETPLAYER :CURRENTBOWLERCODE :S_OVERNO :S_BALLNO : S_WICKETSCORE :S_WIDE :S_NOBALL :S_BYES :S_LEGBYES :S_PENALTY :S_ISDELETE :ISWICKETUNDO :F_ISWICKETCOUNTABLE :F_ISWICKET :[NSNumber numberWithInteger: [F_WICKETTYPE integerValue]]];
    
    
     NSString * BowlerCodeInCurrentOver =[objDBManagerDeleteScoreEngine GetBowlerCodeInCurrentOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO :BALLCODE];
    
    
    BOOL DeleteBallEventDetails = [objDBManagerDeleteScoreEngine DeleteBallEventDetailsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
   
    
    BOOL UpdateBowlingOrder = [objDBManagerDeleteScoreEngine UpdateBowlingOrderDeleteScoreEngine:MATCHCODE :BOWLINGTEAMCODE :BATTINGTEAMCODE :INNINGSNO];
    
    BOOL DeleteRemoveUnusedBatFB =[objDBManagerDeleteScoreEngine DeleteRemoveUnusedBatFBSDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
    
    BOOL DeleteRemoveUnusedBowFBS = [objDBManagerDeleteScoreEngine DeleteRemoveUnusedBowFBSDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BOWLINGTEAMCODE];
    
    BOOL UpdateOverBallCountInBallEvent= [objDBManagerDeleteScoreEngine UpdateOverBallCountInBallEventtForInsertScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];

    NSInteger CurrentOverBallCount =[objDBManagerDeleteScoreEngine GetCurrentOverBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    NSString * BallCodeCountInFutureOvers =[objDBManagerDeleteScoreEngine GetBallCodeCountInFutureOversForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    BOOL UpdateOverEventWithOverStatus =[objDBManagerDeleteScoreEngine UpdateOverEventWithOverStatusForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    BOOL DeleteOverEventInFutureOver =[objDBManagerDeleteScoreEngine DeleteOverEventInFutureOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    BOOL UpdateBowlerOverEventWithOverStatus =[objDBManagerDeleteScoreEngine UpdateBowlerOverEventWithOverStatusForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    BOOL DeleteBowlerOverEventInFutureOver =[objDBManagerDeleteScoreEngine DeleteBowlerOverEventInFutureOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    NSInteger BC_BALLNO = 0;
    NSInteger BC_BALLCOUNT = 0;
    
    NSString* OTHERBOWLER = @"";
    
    NSInteger OTHERBOWLEROVERBALLCNT = 0;
    
    NSInteger ISOVERCOMPLETE = 0;
    
    NSInteger W_OVERNO = 0;
    NSInteger W_BALLNO = 0;
    NSInteger W_BALLCOUNT = 0;

    BOOL UpdateBallEventForBallCountWithOldBallCount =[objDBManagerDeleteScoreEngine UpdateBallEventForBallCountWithOldBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :BC_BALLCOUNT :BC_BALLNO];
    
    BOOL UpdateBallEventForBallNoWithOldBallNo =[objDBManagerDeleteScoreEngine UpdateBallEventForBallNoWithOldBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO];
    
    BOOL UpdateBallEventForBallCountOnlyWithOldBallCount =[objDBManagerDeleteScoreEngine UpdateBallEventForBallCountOnlyWithOldBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLCOUNT :W_BALLNO];
    
    NSString * BallCodeCountWithCurrentOverBallNo =[objDBManagerDeleteScoreEngine GetBallCodeCountWithCurrentOverBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO];
    
    NSString * BallCodeCountWithCurrentOverBallNoAndPreviousBallCount =[objDBManagerDeleteScoreEngine GetBallCodeCountWithCurrentOverBallNoAndPreviousBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO :W_BALLCOUNT];
    
    NSInteger MaxOverBallCountWithCurrentOverNo =[objDBManagerDeleteScoreEngine GetMaxOverBallCountWithCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO];
    
    NSString * BallCodeCountWithCurrentOverBallNoAndPreviousBallNo =[objDBManagerDeleteScoreEngine GetBallCodeCountWithCurrentOverBallNoAndPreviousBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO];
    
    NSInteger MaxOverBallCountWithCurrentOverBallNo =[objDBManagerDeleteScoreEngine GetMaxOverBallCountWithCurrentOverBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO];
    
    NSInteger MaxOverBallNoWithCurrentOverBallNo =[objDBManagerDeleteScoreEngine GetMaxOverBallNoWithCurrentOverBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO];
    
    NSInteger MaxOverBallNoWithCurrentOverNo =[objDBManagerDeleteScoreEngine GetMaxOverBallNoWithCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO];
    
    NSInteger MaxOverBallCountWithCurrentOverNoAndBallNo =[objDBManagerDeleteScoreEngine GetMaxOverBallCountWithCurrentOverNoAndBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO];
    
    NSString * BallCodeWithCurrentOverBallNoAndBallCount =[objDBManagerDeleteScoreEngine GetBallCodeWithCurrentOverBallNoAndBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO :W_BALLNO :W_BALLCOUNT];
    
    NSString * BallCodeWithCurrentOverAndBowlerCode =[objDBManagerDeleteScoreEngine GetBallCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :W_OVERNO :CURRENTBOWLERCODE];
    
    BOOL DeleteBowlerOverEventForCurrentOverNo =[objDBManagerDeleteScoreEngine DeleteBowlerOverEventForCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :W_OVERNO :CURRENTBOWLERCODE];
    
    NSString * OtherBowlerCodeWithCurrentOverAndBowlerCode =[objDBManagerDeleteScoreEngine GetOtherBowlerCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :W_OVERNO :CURRENTBOWLERCODE];
    
    NSInteger OtherBowlerOverBallCountWithCurrentOverAndBowlerCode =[objDBManagerDeleteScoreEngine GetOtherBowlerOverBallCountWithCurrentOverAndBowlerCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :W_OVERNO :OTHERBOWLER];
    
    NSInteger OtherBowlerOverStatusWithCurrentOver =[objDBManagerDeleteScoreEngine GetOtherBowlerOverStatusWithCurrentOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :W_OVERNO];
    
    BOOL UpdateOtherBowlerBowlingSummaryForCurrentOverNo =[objDBManagerDeleteScoreEngine UpdateOtherBowlerBowlingSummaryForCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :W_OVERNO :OTHERBOWLER :ISOVERCOMPLETE :OTHERBOWLEROVERBALLCNT];
    
    NSString * BallCodeWithCurrentMatchCode =[objDBManagerDeleteScoreEngine GetBallCodeWithCurrentMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
    BOOL UpdateMatchStatusBasedOnMatchCode =[objDBManagerDeleteScoreEngine UpdateMatchStatusBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    

    
    NSMutableArray * WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker =[objDBManagerDeleteScoreEngine GetWicketOverNoAndBallNoAndBallCountWithStrikerAndNonStrikerForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE];
    
    NSInteger BallCodeCountWithWicketBallNoOverNoBallCount =[objDBManagerDeleteScoreEngine GetBallCodeCountWithWicketBallNoOverNoBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE :W_OVERNO :W_BALLNO :W_BALLCOUNT];
    
    BOOL UpdateWicketTypeBasedOnMatchCodeBatman =[objDBManagerDeleteScoreEngine UpdateWicketTypeBasedOnMatchCodeBatmanForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE];
    
    NSString * MatchCodeWithMatchCodeAndResult =[objDBManagerDeleteScoreEngine GetMatchCodeWithMatchCodeAndResultForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
    NSString * TossWonTeamWithMatchCode =[objDBManagerDeleteScoreEngine GetTossWonTeamWithMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
    NSString * BallCodeFromBallEventsWithMatchCode=[objDBManagerDeleteScoreEngine GetBallCodeFromBallEventsWithMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
    NSString* MATCHSTATUS = @"";
    NSString* MATCHRESULT = @"Select";
    BOOL UpdateMatchRegistrationWithMatchResultBasedOnMatchCode=[objDBManagerDeleteScoreEngine UpdateMatchRegistrationWithMatchResultBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MATCHRESULT :MATCHSTATUS];
    
    BOOL UpdateMatchResultBasedOnMatchCode =[objDBManagerDeleteScoreEngine UpdateMatchResultBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MATCHRESULT];
    
    BOOL DeleteSessionBasedOnMatchCode =[objDBManagerDeleteScoreEngine DeleteSessionBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXSESSIONNO :MAXDAYNO];
    
    BOOL DeleteDayEventsBasedOnMatchCode =[objDBManagerDeleteScoreEngine DeleteDayEventsBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXSESSIONNO :MAXDAYNO];
    
    BOOL UpdateInningsEventsBasedOnMatchCode =[objDBManagerDeleteScoreEngine UpdateInningsEventsBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS];
    
    
}
@end
