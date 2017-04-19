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
    NSString* SB_BOWLERCODE = BOWLERCODE;
    NSString* SB_NONSTRIKERCODE;
    NSInteger MAXINNINGS;
    NSInteger MAXOVER;
    NSInteger MAXBALL;
    NSInteger MAXBALLCOUNT;
    NSInteger MAXSESSIONNO;
    NSInteger MAXDAYNO;
    
    DBManagerDeleteScoreEngine * objDBManagerDeleteScoreEngine = [[DBManagerDeleteScoreEngine alloc]init];
    
    if([REVERT isEqualToString:@"YES"]){
        MAXINNINGS = [objDBManagerDeleteScoreEngine GetMaxInningsNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
        MAXOVER   = [objDBManagerDeleteScoreEngine GetMaxOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS];
    
        MAXBALL  = [objDBManagerDeleteScoreEngine GetMaxBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER];
    
        MAXBALLCOUNT = [objDBManagerDeleteScoreEngine GetMaxBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER :MAXBALL];
    
        MAXSESSIONNO = [objDBManagerDeleteScoreEngine GetMaxSessionNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER :MAXBALL :MAXBALLCOUNT];
    
        MAXDAYNO   = [objDBManagerDeleteScoreEngine GetMaxDayNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXOVER :MAXBALL :MAXBALLCOUNT];
    }
    
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
        SB_BOWLERCODE   = objRecord.bowlerCode;
        SB_NONSTRIKERCODE =objRecord.NonStrikerCode;
        S_BALLCOUNT       =[NSNumber numberWithInt:objRecord.ballCount.intValue];
        S_NOBALL          = [NSNumber numberWithInt:objRecord.NoBall.intValue];
        S_WIDE           = [NSNumber numberWithInt:objRecord.Wide.intValue];
    }
    
    
    BOWLINGTEAMCODE = [objDBManagerDeleteScoreEngine GetBowlingTeamForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
    
    
    
     NSInteger BATTEAMOVERS = 0;
    
    NSInteger BATTEAMOVRWITHEXTRASBALLS = 0;
    
    NSInteger BATTEAMOVRBALLSCNT = 0;
    BATTEAMOVERS = [objDBManagerDeleteScoreEngine GetBatteamOversForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
    
    BATTEAMOVRWITHEXTRASBALLS =[objDBManagerDeleteScoreEngine GetBatteamOversWithExtraBallsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BATTEAMOVERS];
    
    BATTEAMOVRBALLSCNT = [objDBManagerDeleteScoreEngine GetBatteamOversBallsCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BATTEAMOVERS :BATTEAMOVRWITHEXTRASBALLS];
    
   
    
    if(S_OVERNO.integerValue == BATTEAMOVERS  && S_BALLNO.integerValue ==  BATTEAMOVRWITHEXTRASBALLS && S_BALLCOUNT.integerValue == BATTEAMOVRBALLSCNT ){
    
        NSString* CURRENTSTRIKERCODE = @"";
        NSString* CURRENTNONSTRIKERCODE =@"";
        NSString* CURRENTBOWLERCODE=@"";
        
        if(BATTEAMOVERS != 0  ){
    
            NSMutableArray * currentplayerDetail = [objDBManagerDeleteScoreEngine GetCurrentPlayersDetailsForDeleteScoreEngine :COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO BATTEAMOVERS:BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:BATTEAMOVRWITHEXTRASBALLS BATTEAMOVRBALLSCNT:BATTEAMOVRBALLSCNT];
            if(currentplayerDetail.count>0)
            {
                DeleteBallRecord*objRecord =[currentplayerDetail objectAtIndex:0];
                CURRENTSTRIKERCODE =objRecord.CurrentStrikercode;
                CURRENTNONSTRIKERCODE = objRecord.CurrentNonStrikerCode;
                CURRENTBOWLERCODE     = objRecord.CurrenBowlerCode;
            }
    
            BOOL UpdateInningsEventsWithCurrentValues =[objDBManagerDeleteScoreEngine UpdateInningsEventsWithCurrentValuesForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :CURRENTSTRIKERCODE :CURRENTNONSTRIKERCODE :CURRENTBOWLERCODE :BATTEAMOVRWITHEXTRASBALLS :BATTEAMOVRBALLSCNT];
         }else{
    
            BOOL UpdateInningsEventsWithExistingValues = [objDBManagerDeleteScoreEngine UpdateInningsEventsWithExistingValuesForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
        }
    
    }
    
    NSNumber * F_ISWICKET = 0;
    NSNumber * F_ISWICKETCOUNTABLE = 0;
    NSString * F_WICKETTYPE = @"";
    
    
    F_ISWICKETCOUNTABLE =[objDBManagerDeleteScoreEngine GetWicketsCountableCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];

    F_ISWICKET =[objDBManagerDeleteScoreEngine GetIsWicketCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    F_WICKETTYPE = [objDBManagerDeleteScoreEngine GetWicketTypeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    
    
    NSString * BallCodeInWickets =[objDBManagerDeleteScoreEngine GetBallCodeInWicketsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
    if(![BallCodeInWickets isEqualToString:@""]){//Exist
    
        NSMutableArray * WicketPlayerAndNoDetails =[objDBManagerDeleteScoreEngine GetWicketPlayerAndNoDetailsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
        BOOL DeleteWicketEventsWithBallCode = [objDBManagerDeleteScoreEngine DeleteWicketEventsWithBallCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];
    
        BOOL UpdateWicketEventsWicketNo =[objDBManagerDeleteScoreEngine UpdateWicketEventsWicketNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :F_ISWICKET];
        
        ISWICKETUNDO = [NSNumber numberWithInt:1];
    
    }
    
    BOOL DeletePenaltyDetails = [objDBManagerDeleteScoreEngine DeletePenaltyDetailsForDeleteScoreEngine:BALLCODE:MATCHCODE];
    
    BOOL DeleteAppealDetails = [objDBManagerDeleteScoreEngine DeleteAppealDetailsForDeleteScoreEngine:BALLCODE:MATCHCODE];
    
    BOOL DeleteFieldingDetails = [objDBManagerDeleteScoreEngine DeleteFieldingDetailsForDeleteScoreEngine:BALLCODE:MATCHCODE];
    
    UpdateScoreEngine * objupdateScoreEngine = [[UpdateScoreEngine alloc]init];
        

    
    [objupdateScoreEngine UpdateScoreBoard : BALLCODE :COMPETITIONCODE :MATCHCODE : BATTINGTEAMCODE :BOWLINGTEAMCODE :INNINGSNO :SB_STRIKERCODE :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSString stringWithFormat:@""] :WICKETPLAYER :SB_BOWLERCODE :S_OVERNO :[NSNumber numberWithInt:0] : [NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:0] :[NSNumber numberWithInt:1] :ISWICKETUNDO :F_ISWICKETCOUNTABLE :F_ISWICKET :[NSNumber numberWithInteger: [F_WICKETTYPE integerValue]]];
    
    
    BOOL DeleteBallEventDetails = [objDBManagerDeleteScoreEngine DeleteBallEventDetailsForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :BALLCODE];


     NSString * BowlerCodeInCurrentOver =[objDBManagerDeleteScoreEngine GetBowlerCodeInCurrentOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO :SB_BOWLERCODE];
    
    
    if([BowlerCodeInCurrentOver isEqualToString:@""])
    {
    
        BOOL UpdateBowlingOrder = [objDBManagerDeleteScoreEngine UpdateBowlingOrderDeleteScoreEngine:MATCHCODE :BOWLINGTEAMCODE :BATTINGTEAMCODE :INNINGSNO];
    }
    
    BOOL DeleteRemoveUnusedBatFB =[objDBManagerDeleteScoreEngine DeleteRemoveUnusedBatFBSDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
    
    BOOL DeleteRemoveUnusedBowFBS = [objDBManagerDeleteScoreEngine DeleteRemoveUnusedBowFBSDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BOWLINGTEAMCODE];
    
    
    BOOL UpdateOverBallCountInBallEvent= [objDBManagerDeleteScoreEngine UpdateOverBallCountInBallEventtForInsertScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];

    NSInteger CurrentOverBallCount =[objDBManagerDeleteScoreEngine GetCurrentOverBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
    
    if(CurrentOverBallCount == 0){
    
        NSString * BallCodeCountInFutureOvers =[objDBManagerDeleteScoreEngine GetBallCodeCountInFutureOversForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
        if([BallCodeCountInFutureOvers isEqualToString:@""]){
            BOOL UpdateOverEventWithOverStatus =[objDBManagerDeleteScoreEngine UpdateOverEventWithOverStatusForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
            BOOL DeleteOverEventInFutureOver =[objDBManagerDeleteScoreEngine DeleteOverEventInFutureOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
            BOOL UpdateBowlerOverEventWithOverStatus =[objDBManagerDeleteScoreEngine UpdateBowlerOverEventWithOverStatusForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
    
            BOOL DeleteBowlerOverEventInFutureOver =[objDBManagerDeleteScoreEngine DeleteBowlerOverEventInFutureOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
        }
    }
    
    
   // NSString* OTHERBOWLER = @"";
    
  //  NSInteger OTHERBOWLEROVERBALLCNT = 0;
    
  //  NSInteger ISOVERCOMPLETE = 0;
    
  //  NSInteger W_OVERNO = 0;
   // NSInteger W_BALLNO = 0;
   // NSInteger W_BALLCOUNT = 0;
    
    if(S_WIDE.intValue == 0 && S_NOBALL.intValue == 0 ){

      
        
        BOOL UpdateBallEventForBallCountWithOldBallCount =[objDBManagerDeleteScoreEngine UpdateBallEventForBallCountWithOldBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLCOUNT :S_BALLNO];
    
        
        //ballno is change
        
        BOOL UpdateBallEventForBallNoWithOldBallNo =[objDBManagerDeleteScoreEngine UpdateBallEventForBallNoWithOldBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLNO];
    }else{
    
    BOOL UpdateBallEventForBallCountOnlyWithOldBallCount =[objDBManagerDeleteScoreEngine UpdateBallEventForBallCountOnlyWithOldBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLCOUNT :S_BALLNO];
    }
    
    
    NSInteger BC_BALLNO = 0;
    NSInteger BC_BALLCOUNT = 0;

    
    NSString * BallCodeCountWithCurrentOverBallNo =[objDBManagerDeleteScoreEngine GetBallCodeCountWithCurrentOverBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLNO];
    
    
    if(![BallCodeCountWithCurrentOverBallNo isEqualToString:@""]){
        
        BC_BALLNO = S_BALLNO.intValue;
    
        NSString * BallCodeCountWithCurrentOverBallNoAndPreviousBallCount =[objDBManagerDeleteScoreEngine GetBallCodeCountWithCurrentOverBallNoAndPreviousBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLNO :S_BALLCOUNT];
        
        if(![BallCodeCountWithCurrentOverBallNoAndPreviousBallCount isEqualToString:@""]){
        
    
            BC_BALLCOUNT = S_BALLCOUNT.intValue-1;
        }else{
        
            BC_BALLCOUNT =[objDBManagerDeleteScoreEngine GetMaxOverBallCountWithCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLNO];
        }
    }else{
        NSString * BallCodeCountWithCurrentOverBallNoAndPreviousBallNo =[objDBManagerDeleteScoreEngine GetBallCodeCountWithCurrentOverBallNoAndPreviousBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :S_BALLNO];
        
        if(![BallCodeCountWithCurrentOverBallNoAndPreviousBallNo isEqualToString:@""]){
            
            BC_BALLNO = S_BALLNO.intValue-1;
    
            BC_BALLCOUNT =[objDBManagerDeleteScoreEngine GetMaxOverBallCountWithCurrentOverBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :BC_BALLNO];
        }else{
            
    
            BC_BALLNO =[objDBManagerDeleteScoreEngine GetMaxOverBallNoWithCurrentOverBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO];
            
    
            //NSInteger MaxOverBallNoWithCurrentOverNo =[objDBManagerDeleteScoreEngine GetMaxOverBallNoWithCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :W_OVERNO];
    
            BC_BALLCOUNT =[objDBManagerDeleteScoreEngine GetMaxOverBallCountWithCurrentOverNoAndBallNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :BC_BALLNO];
        }
    }
    
        
    BALLCODE =[objDBManagerDeleteScoreEngine GetBallCodeWithCurrentOverBallNoAndBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :S_OVERNO :BC_BALLNO :BC_BALLCOUNT];
        
    
    NSString * BallCodeWithCurrentOverAndBowlerCode = [objDBManagerDeleteScoreEngine GetBallCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine :COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO :SB_BOWLERCODE];
        
    if([BallCodeWithCurrentOverAndBowlerCode isEqualToString:@""]){
    
        BOOL DeleteBowlerOverEventForCurrentOverNo =[objDBManagerDeleteScoreEngine DeleteBowlerOverEventForCurrentOverNoForDeleteScoreEngine :COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO :SB_BOWLERCODE];
    
        NSInteger  OTHERBOWLERCNT =[objDBManagerDeleteScoreEngine GetOtherBowlerCodeWithCurrentOverAndBowlerForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO];
        
        NSString * OTHERBOWLER =[objDBManagerDeleteScoreEngine GetOtherBowlerCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO :SB_BOWLERCODE];

    
        NSInteger OTHERBOWLEROVERBALLCNT =[objDBManagerDeleteScoreEngine GetOtherBowlerOverBallCountWithCurrentOverAndBowlerCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO :OTHERBOWLER];
            
        if(OTHERBOWLEROVERBALLCNT > 0 && OTHERBOWLERCNT ==1){
    
            NSInteger ISOVERCOMPLETE =[objDBManagerDeleteScoreEngine GetOtherBowlerOverStatusWithCurrentOverForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :S_OVERNO];
    
            BOOL UpdateOtherBowlerBowlingSummaryForCurrentOverNo =[objDBManagerDeleteScoreEngine UpdateOtherBowlerBowlingSummaryForCurrentOverNoForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :0 :OTHERBOWLER :ISOVERCOMPLETE :OTHERBOWLEROVERBALLCNT];
        }
            
    }
        
    NSString * BallCodeWithCurrentMatchCode =[objDBManagerDeleteScoreEngine GetBallCodeWithCurrentMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
        
    if([BallCodeWithCurrentMatchCode isEqualToString:@""]){
        BOOL UpdateMatchStatusBasedOnMatchCode =[objDBManagerDeleteScoreEngine UpdateMatchStatusBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    }
    

    
    // Stricker Update
    NSInteger W_OVERNO = 0;
    NSInteger W_BALLNO = 0;
    NSInteger W_BALLCOUNT = 0;

        
    
    NSMutableArray * WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker =[objDBManagerDeleteScoreEngine GetWicketOverNoAndBallNoAndBallCountWithStrikerAndNonStrikerForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE];
        
        
    if(WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker.count>=3){
        W_OVERNO = [[WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker objectAtIndex:0] integerValue];
        W_BALLNO = [[WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker objectAtIndex:1] integerValue];
        W_BALLCOUNT = [[WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker objectAtIndex:2] integerValue];
    }
    
NSInteger BallCodeCountWithWicketBallNoOverNoBallCount =[objDBManagerDeleteScoreEngine  GetBallCodeCountWithWicketBallNoOverNoBallCountForDeleteScoreEngine:COMPETITIONCODE : MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE :  SB_NONSTRIKERCODE: W_OVERNO :W_BALLNO :W_BALLCOUNT];
    
    
    
    if(BallCodeCountWithWicketBallNoOverNoBallCount<=0){
        BOOL UpdateWicketTypeBasedOnMatchCodeBatman =[objDBManagerDeleteScoreEngine UpdateWicketTypeBasedOnMatchCodeBatmanForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE];
        
    }
    
    //Non Stricker Update
    W_OVERNO = 0;
    W_BALLNO = 0;
    W_BALLCOUNT = 0;
    
    
    WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker =[objDBManagerDeleteScoreEngine GetWicketOverNoAndBallNoAndBallCountWithStrikerAndNonStrikerForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_NONSTRIKERCODE];
    
    
    
    if(WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker.count>=3){
        W_OVERNO = [[WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker objectAtIndex:0] integerValue];
        W_BALLNO = [[WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker objectAtIndex:1] integerValue];
        W_BALLCOUNT = [[WicketOverNoAndBallNoAndBallCountWithStrikerAndNonStriker objectAtIndex:2] integerValue];
    }
    
    
    // BallCodeCountWithWicketBallNoOverNoBallCount =[objDBManagerDeleteScoreEngine GetBallCodeCountWithWicketBallNoOverNoBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_NONSTRIKERCODE :W_OVERNO :W_BALLNO :W_BALLCOUNT];
    
    BallCodeCountWithWicketBallNoOverNoBallCount= [objDBManagerDeleteScoreEngine GetBallCodeCountWithWicketBallNoOverNoBallCountForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_STRIKERCODE :SB_NONSTRIKERCODE:W_OVERNO :W_BALLNO :W_BALLCOUNT];
    
    if(BallCodeCountWithWicketBallNoOverNoBallCount<=0){
        BOOL UpdateWicketTypeBasedOnMatchCodeBatman =[objDBManagerDeleteScoreEngine UpdateWicketTypeBasedOnMatchCodeBatmanForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :SB_NONSTRIKERCODE];
        
    }
    
    //LAST BALL DELETE GIVEN OPTION MATCH RESULT REVERT MEANS
    
    NSString* MATCHSTATUS = @"";
    NSString* MATCHRESULT = @"Select";
    
    //AFTER LAST BALL DELETE THESE EVENT REVERTED
    
    
    NSString * MatchCodeWithMatchCodeAndResult =[objDBManagerDeleteScoreEngine GetMatchCodeWithMatchCodeAndResultForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
    
    if(![MatchCodeWithMatchCodeAndResult isEqualToString:@""]){
        if([REVERT isEqualToString:@"YES"]){
            
            if([MATCHRESULT isEqualToString:@"Select"]){
                NSString * TossWonTeamWithMatchCode =[objDBManagerDeleteScoreEngine GetTossWonTeamWithMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];
                NSString * BallCodeFromBallEventsWithMatchCode=[objDBManagerDeleteScoreEngine GetBallCodeFromBallEventsWithMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE];


                if([TossWonTeamWithMatchCode isEqualToString:@""]){
                    MATCHSTATUS = @"MSC123"; //TOSS
                }else if([BallCodeFromBallEventsWithMatchCode isEqualToString:@""]){
                    MATCHSTATUS = @"MSC240"; //START
                }else{
                    MATCHSTATUS = @"MSC124"; //RESUME
                }
            }
            
            
            
            
            BOOL UpdateMatchRegistrationWithMatchResultBasedOnMatchCode=[objDBManagerDeleteScoreEngine UpdateMatchRegistrationWithMatchResultBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MATCHRESULT :MATCHSTATUS];
            BOOL UpdateMatchResultBasedOnMatchCode =[objDBManagerDeleteScoreEngine UpdateMatchResultBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MATCHRESULT];

            BOOL DeleteSessionBasedOnMatchCode =[objDBManagerDeleteScoreEngine DeleteSessionBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS : MAXSESSIONNO : MAXDAYNO];
            
            BOOL DeleteDayEventsBasedOnMatchCode =[objDBManagerDeleteScoreEngine DeleteDayEventsBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS :MAXSESSIONNO :MAXDAYNO];
            
            BOOL UpdateInningsEventsBasedOnMatchCode =[objDBManagerDeleteScoreEngine UpdateInningsEventsBasedOnMatchCodeForDeleteScoreEngine:COMPETITIONCODE :MATCHCODE :MAXINNINGS];
        }
    }
    
    //scorecard update
    
    BOOL scoreBoardUpdate =[objDBManagerDeleteScoreEngine ScoreboardUpdate:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    
    
  
    
    
}
@end
