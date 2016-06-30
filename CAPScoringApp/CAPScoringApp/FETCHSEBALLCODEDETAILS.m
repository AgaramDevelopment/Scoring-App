//
//  FETCHSEBALLCODEDETAILS.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FETCHSEBALLCODEDETAILS.h"
#import "DBManagerEditScoreEngine.h"
#import "ScoreEnginEditRecord.h"
#import "FetchSEPageLoadRecord.h"
#import "DBManager.h"

@implementation FETCHSEBALLCODEDETAILS

@synthesize   TEAMACODE;
@synthesize   TEAMBCODE;
@synthesize   BATTINGTEAMCODE;
@synthesize   BOWLINGTEAMCODE;
@synthesize   INNINGSNO;
@synthesize   INNINGSSTATUS;
@synthesize   SESSIONNO;
@synthesize   DAYNO;
@synthesize   BATTEAMSHORTNAME;
@synthesize   BOWLTEAMSHORTNAME;
@synthesize   BATTEAMNAME;
@synthesize   BOWLTEAMNAME;
@synthesize   MATCHOVERS;
@synthesize   BATTEAMLOGO;
@synthesize   BOWLTEAMLOGO;
@synthesize   MATCHTYPE;
@synthesize   ISOTHERSMATCHTYPE;


@synthesize   BATTEAMRUNS;;
@synthesize   BATTEAMWICKETS;
@synthesize   BATTEAMOVERS;
@synthesize   BATTEAMOVRBALLS;
@synthesize   BATTEAMRUNRATE;
@synthesize   ISOVERCOMPLETE;
@synthesize   ISPREVIOUSLEGALBALL;
@synthesize   BATTEAMOVRBALLSCNT;
@synthesize   BOWLERCODE;
@synthesize   TOTALBATTEAMRUNS;
@synthesize   TOTALBOWLTEAMRUNS;
@synthesize   REQRUNRATE;
@synthesize   RUNSREQUIRED;
@synthesize   REMBALLS;
@synthesize   T_ATWOROTW;
@synthesize   T_BOWLINGEND;
@synthesize   STRIKERCODE;
@synthesize   NONSTRIKERCODE;
@synthesize   STRIKERBALLS;
@synthesize   NONSTRIKERBALLS;
@synthesize   T_TOTALRUNS;
@synthesize   T_OVERSTATUS	;
@synthesize   T_WICKETPLAYER;
@synthesize   WICKETS;
@synthesize MAIDENS;

//all innings record for team A and team B
@synthesize MATCHDATE;
@synthesize FIRSTINNINGSTOTAL;
@synthesize SECONDINNINGSTOTAL;
@synthesize THIRDINNINGSTOTAL;
@synthesize FOURTHINNINGSTOTAL;
@synthesize FIRSTINNINGSWICKET;
@synthesize SECONDINNINGSWICKET;
@synthesize THIRDINNINGSWICKET;
@synthesize FOURTHINNINGSWICKET;
@synthesize FIRSTINNINGSSCORE;
@synthesize SECONDINNINGSSCORE;
@synthesize THIRDINNINGSSCORE;
@synthesize FOURTHINNINGSSCORE;
@synthesize FIRSTINNINGSOVERS;
@synthesize SECONDINNINGSOVERS;
@synthesize THIRDINNINGSOVERS;
@synthesize FOURTHINNINGSOVERS;
@synthesize FIRSTINNINGSSHORTNAME;
@synthesize SECONDINNINGSSHORTNAME;
@synthesize THIRDINNINGSSHORTNAME;
@synthesize FOURTHINNINGSSHORTNAME;
@synthesize AA;
@synthesize BB;
@synthesize AAWIC;
@synthesize BBWIC;
@synthesize ISFREEHIT;




//SP_FETCHSEBALLCODEDETAILS
-(void) FetchSEBallCodeDetails:(NSString *)COMPETITIONCODE :(NSString *)MATCHCODE :(NSString*)BALLCODE
{
    
    
    
    NSMutableArray *GetTeamDetailsArray=[DBManagerEditScoreEngine GetTeamDetailsForMatchRegistration :  COMPETITIONCODE:  MATCHCODE ];
    if(GetTeamDetailsArray.count>0)
    {
        
        GetSEDetailsForMatchRegistration *record=[GetTeamDetailsArray objectAtIndex:0];
        
        
        TEAMACODE=record.TEAMACODE;
        TEAMBCODE=record.TEAMBCODE;
        MATCHOVERS= [NSNumber numberWithInt: [record.MATCHOVERS intValue]] ;
        
        
    }
    NSMutableArray *GetTeamDetailsForCompetitionArray=[ DBManagerEditScoreEngine GetTeamDetailsForCompetition :  COMPETITIONCODE ];
    if(GetTeamDetailsForCompetitionArray.count>0)
    {
        
        
        GetSEDetailsForCompetition *record=[GetTeamDetailsForCompetitionArray objectAtIndex:0];
        
        MATCHTYPE=record.MATCHTYPE;
        ISOTHERSMATCHTYPE=record.ISOTHERSMATCHTYPE;
        
        
        
    }
    //BALLCODE
    


    
    NSMutableArray *GetTeamDetailsForBallEventsArray=[ DBManagerEditScoreEngine GetTeamDetailsForBallEvents :  TEAMACODE: BATTINGTEAMCODE:  TEAMBCODE: COMPETITIONCODE:  MATCHCODE: BALLCODE ];
    if(GetTeamDetailsForBallEventsArray.count>0)
    {
        GetSEDetailsForBallEvents *record=[GetTeamDetailsForBallEventsArray objectAtIndex:0];
        
        INNINGSNO=  [NSNumber numberWithInt: [record.INNINGSNO intValue] ];
        BATTINGTEAMCODE = record.BATTINGTEAMCODE;
        BOWLINGTEAMCODE =record.BOWLINGTEAMCODE;
        
    }
    
    
    SESSIONNO=[DBManagerEditScoreEngine GetSessionNoForSessionEvents : COMPETITIONCODE :MATCHCODE : INNINGSNO	];
    
    DAYNO =[DBManagerEditScoreEngine GetDayNoForSEDayEvents : COMPETITIONCODE :MATCHCODE : INNINGSNO	];
    
    INNINGSSTATUS =[DBManagerEditScoreEngine GetInningsStatusForSEInningsEvents : COMPETITIONCODE :MATCHCODE : INNINGSNO	];
    
    NSMutableArray *GetBattingTeamNamesArray=[ DBManagerEditScoreEngine GetBattingTeamNamesForTeamMaster :  BATTINGTEAMCODE ];
    if(GetBattingTeamNamesArray.count>0)
    {
        GetSEDetailsForBattingTeamNames *record=[GetBattingTeamNamesArray objectAtIndex:0];
        
        BATTEAMSHORTNAME=record.SHORTTEAMNAME;
        BATTEAMNAME=record.TEAMNAME;
        BATTEAMLOGO=record.TEAMLOGO;
        
        
        
    }
    NSMutableArray *GetBowlingTeamNamesArray=[ DBManagerEditScoreEngine GetBowlingTeamNamesForTeamMaster :  BOWLINGTEAMCODE ];
    if(GetBowlingTeamNamesArray.count>0)
    {
        GetSEDetailsForBowlingTeamNames *record=[GetBowlingTeamNamesArray objectAtIndex:0];

        
        BOWLTEAMSHORTNAME=record.SHORTTEAMNAME;
        BOWLTEAMNAME=record.TEAMNAME;
        BOWLTEAMLOGO=record.TEAMLOGO;
        
        
        
    }
	   NSNumber* T_TARGETRUNS= [[NSNumber alloc] init];
    NSNumber* T_TARGETOVERS= [[NSNumber alloc] init];
    NSMutableArray *GetRevisedTargetArray=[ DBManagerEditScoreEngine GetRevisedTargetForMatchEvents :  COMPETITIONCODE : MATCHCODE ];
    if(GetRevisedTargetArray.count>0)
    {
        GetSEDetailsForMtachRevisedTarget  *record=[GetRevisedTargetArray objectAtIndex:0];
        T_TARGETRUNS =record.TARGETRUNS;
        T_TARGETOVERS=record.TARGETOVERS;
        
        
        
        
    }
    MATCHOVERS =  T_TARGETOVERS.intValue > 0 ? T_TARGETOVERS : MATCHOVERS;
    
   // NSMutableArray *GetMatchDetailsArray=[ DBManagerEditScoreEngine GetMatchDetailsForSEMatchRegistration :  COMPETITIONCODE : MATCHCODE ];
    
    NSMutableArray *GetBowlTypeArray=[ DBManagerEditScoreEngine GetBowlTypeForBallCodeDetails  ];
    
    
    
    NSMutableArray *GetShotTypeArray=[ DBManagerEditScoreEngine GetShotTypeForBallCodeDetails];
    
   
    
    
	   NSMutableArray *GetBallCodeArray=[ DBManagerEditScoreEngine GetBallCodeForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BALLCODE  ];
    if(GetBallCodeArray.count>0)
    {
        
        GetSEDetailsForBallEventsDetails *record = [GetBallCodeArray objectAtIndex:0];
        
        
        
        
        BATTEAMOVERS=[NSNumber numberWithInt:  record.OVERNO.intValue];
        BATTEAMOVRBALLS=[NSNumber numberWithInt:record.BALLNO.intValue];
        BATTEAMOVRBALLSCNT=[NSNumber numberWithInt:record.BALLCOUNT.intValue];
        BOWLERCODE=record.BOWLERCODE;
        T_ATWOROTW= record.ATWOROTW;
        T_BOWLINGEND=record.BOWLINGEND;
        STRIKERCODE=record.STRIKERCODE;
        NONSTRIKERCODE=record.NONSTRIKERCODE;
        
        
        
    }
    //X =
//    NSMutableArray *GetRetiredHurtChangesArray=[ DBManagerEditScoreEngine GetRetiredHurtChangesForBallevents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO ];
    

    self.GetBattingTeamPlayersArray=[ DBManagerEditScoreEngine GetBattingTeamPlayersForMatchRegistration :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ];
    

    
    
    BATTEAMRUNS =[ DBManagerEditScoreEngine GetSEGrandTotalForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ];
    
    int battingTeamRunsData = BATTEAMRUNS.intValue +[[ DBManagerEditScoreEngine GetPenaltyRunsForBallCodeDetails :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO ] intValue];
    
    BATTEAMRUNS =[NSNumber numberWithInt:battingTeamRunsData];
    
    
    BATTEAMWICKETS =[ DBManagerEditScoreEngine GetWicketNoForBallCodeDetails :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ];
    
    ISOVERCOMPLETE = [NSNumber numberWithInt:1];
    
    NSNumber* TOTALBALLS= [[NSNumber alloc] init];
    
    int totalBallsDataConv =  (BATTEAMOVERS.intValue * 6) + ( BATTEAMOVRBALLS.intValue > 6 ? 6 : BATTEAMOVRBALLS.intValue);
    
    TOTALBALLS = [NSNumber numberWithInt:totalBallsDataConv];
    
    BATTEAMRUNRATE = TOTALBALLS == 0 ? [NSNumber numberWithInt:0]: [NSNumber numberWithInt:(BATTEAMRUNS.intValue / TOTALBALLS.intValue) * 6] ;
    
    
    self.GetBowlingTeamPlayersArray=[ DBManagerEditScoreEngine GetBowlingTeamPlayersForMatchRegistration :  MATCHCODE : BOWLINGTEAMCODE: COMPETITIONCODE : BATTINGTEAMCODE :  INNINGSNO :BATTEAMOVERS];
    
    if(INNINGSNO.intValue > 0 && (INNINGSNO.intValue % 2) == 0 )
    {
        TOTALBATTEAMRUNS =[ DBManagerEditScoreEngine GetTotalBatTeamOversForGrandTotal :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO  ];
        

        
        TOTALBATTEAMRUNS = [NSNumber numberWithInt: TOTALBATTEAMRUNS.intValue + BATTEAMRUNS.intValue ];
        
        TOTALBOWLTEAMRUNS = [ DBManagerEditScoreEngine GetTotalBowlTeamOversForGrandTotal :  COMPETITIONCODE : MATCHCODE: BOWLINGTEAMCODE : INNINGSNO  ];
        
        
//        TOTALBOWLTEAMRUNS =
//        
//        (	CASE	WHEN ( MATCHTYPE IN ('MSC023','MSC114') AND  INNINGSNO = 4 AND  TOTALBOWLTEAMRUNS > 0) THEN
//                             
//                             
//                             TOTALBOWLTEAMRUNS + 1
//                             WHEN
//         
//         ( MATCHTYPE NOT IN ('MSC023','MSC114') AND  INNINGSNO = 2 AND  TOTALBOWLTEAMRUNS > 0) THEN  TOTALBOWLTEAMRUNS + 1
//         
//         
//         ELSE  TOTALBOWLTEAMRUNS END);
        
        
        if (([MATCHTYPE isEqualToString: @"MSC023"]||[MATCHTYPE isEqualToString: @"MSC114"] )&&INNINGSNO.intValue == 4 && TOTALBOWLTEAMRUNS.intValue >0  ) {
            
               TOTALBOWLTEAMRUNS = [NSNumber numberWithInt:TOTALBATTEAMRUNS.intValue+1];
        }else if((![MATCHTYPE isEqualToString: @"MSC023"]&&![MATCHTYPE isEqualToString: @"MSC114"])&&INNINGSNO.intValue == 2 && TOTALBOWLTEAMRUNS.intValue >0 ){
            TOTALBOWLTEAMRUNS = [NSNumber numberWithInt:TOTALBOWLTEAMRUNS.intValue+1];
        }
        
        
        
        
        TOTALBOWLTEAMRUNS = T_TARGETRUNS.intValue > 0 ?  T_TARGETRUNS :  TOTALBOWLTEAMRUNS ;
        
        TOTALBOWLTEAMRUNS =   TOTALBOWLTEAMRUNS == 0 ? [NSNumber numberWithInt:1] :  TOTALBOWLTEAMRUNS ;
        
        RUNSREQUIRED = [NSNumber numberWithInt: (TOTALBOWLTEAMRUNS.intValue -  TOTALBATTEAMRUNS.intValue) ];
        
        REMBALLS = [NSNumber numberWithInt: (MATCHOVERS.intValue * 6) -  TOTALBALLS.intValue ];
        
        REQRUNRATE = REMBALLS.intValue == 0 ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt: (( RUNSREQUIRED.intValue /  REMBALLS.intValue) * (REMBALLS.intValue < 6 ? 1 : 6)) ];
    }
    
        ISFREEHIT= [[NSNumber alloc] init];
        
        if( ![[DBManagerEditScoreEngine GetFreeHitDetailsForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ] isEqual:@""])
        {
            ISFREEHIT = [NSNumber numberWithInt:1];
        }
        
        
        
        STRIKERBALLS = [ DBManagerEditScoreEngine GetStrikerBallForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO :  STRIKERCODE :BATTEAMOVERS :BATTEAMOVRBALLS :   BATTEAMOVRBALLSCNT];
        
        
        
        if(![[ DBManagerEditScoreEngine GetStrikerDetailsForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO :   STRIKERCODE : BATTEAMOVERS:  BATTEAMOVRBALLS:  BATTEAMOVRBALLSCNT ]  isEqual:@""])
        {
            
            

            self.currentStrickerDetail=[ DBManagerEditScoreEngine GetStrikerDetailsForSEBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO :  BATTEAMOVERS :BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT: STRIKERCODE:STRIKERBALLS ];
            
        }
        else
        {
            
           self.currentStrickerDetail=[ DBManagerEditScoreEngine GetStrikerDetailsForPlayerMaster : STRIKERCODE ];
            
            
            
        }
        NONSTRIKERBALLS =[ DBManagerEditScoreEngine GetNonStrikerBallForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE :INNINGSNO: NONSTRIKERCODE :   BATTEAMOVERS :  BATTEAMOVRBALLS :  BATTEAMOVRBALLSCNT];
        
        if(  ![[ DBManagerEditScoreEngine GetNonStrikerDetailsForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE :INNINGSNO :NONSTRIKERCODE :      BATTEAMOVERS :  BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT] isEqual:@""])
        {
            
            self.currentNonStrickerDetail=[ DBManagerEditScoreEngine GetNonStrikerDetailsForSEBallEvents :COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO:BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT: NONSTRIKERCODE:STRIKERBALLS ];
        }
        else
        {
            self.currentNonStrickerDetail=[ DBManagerEditScoreEngine GetNonStrikerDetailsForPlayerMaster :  NONSTRIKERCODE];
            
        }
        
        
        
        [DBManagerEditScoreEngine GetPartnershipDetailsForBallEvents :COMPETITIONCODE: MATCHCODE: INNINGSNO: STRIKERCODE: NONSTRIKERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT] ;
        
       
        
        WICKETS=[ DBManagerEditScoreEngine GetWicketsDetailsForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT: BOWLERCODE];
        
        
        NSNumber* TOTALBALLSBOWL= [[NSNumber alloc] init];
        MAIDENS= [[NSNumber alloc] init];
        NSNumber* BOWLERRUNS= [[NSNumber alloc] init];
        NSNumber* ISPARTIALOVER= [[NSNumber alloc] init];
        
        
        ISPARTIALOVER=[DBManagerEditScoreEngine GetBowlerCodeForBowlerOverDetails : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BOWLERCODE: BATTEAMOVERS];
        
        if(ISPARTIALOVER.intValue == 0)
        {
            
            ISPARTIALOVER =[DBManagerEditScoreEngine GetIsPartialOverForBowlerOverDetails : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BOWLERCODE: BATTEAMOVERS];
        }
        
        NSMutableArray *GetBallCountArray=[ DBManagerEditScoreEngine GetBallCountForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BOWLERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT];
						  if(GetBallCountArray.count>0)
                          {
                              
                              GetSEBallCountForBallEvents *record = [GetBallCountArray objectAtIndex:0];

                              
                              TOTALBALLSBOWL=record.TOTALBALLSBOWL;
                              MAIDENS=record.MAIDENS;
                              BOWLERRUNS=record.BOWLERRUNS;
                              
                              
                              
                          }
        
						  NSNumber* BOWLERSPELL= [[NSNumber alloc] init];
        NSNumber* V_SPELLNO= [[NSNumber alloc] init];
						  
						  BOWLERSPELL=[DBManagerEditScoreEngine GetBowlerSpellForBallEvents :COMPETITIONCODE:MATCHCODE: INNINGSNO: BOWLERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT ];
						  
						  self.currentbowlerDetail=[ DBManagerEditScoreEngine GetBowlerDetailsForBallEventsDetails : ISPARTIALOVER: TOTALBALLSBOWL: BATTEAMOVRBALLS: BOWLERRUNS: COMPETITIONCODE: MATCHCODE: INNINGSNO: BOWLERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT];
    
                            if(self.currentbowlerDetail.count>0){
                                GetSEBowlerDetailsForBallEvents *record = [self.currentbowlerDetail objectAtIndex:0];
                                
                                record.BOWLERSPELL=BOWLERSPELL;
                                record.TOTALRUNS= BOWLERRUNS;
                                record.ATWOROTW=T_ATWOROTW;

                            }
    
    
						  NSMutableArray *GetMatchUmpireDetailsArray=[ DBManagerEditScoreEngine GetMatchUmpireDetailsForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO:BALLCODE];
						  
        NSNumber* ISINNINGSLASTOVER= [[NSNumber alloc] init];
        
        
        ISINNINGSLASTOVER=[ DBManagerEditScoreEngine GetIsInningsLastOverForBallevents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO:BATTEAMOVERS];
						  
						  
						  
						  NSMutableArray *GetBallCodeDetailsArray=[ DBManagerEditScoreEngine GetBallCodeDetailsForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO:BATTEAMOVERS];
						  
						  NSMutableArray *GetSETeamDetailsForBallEventsArray=[ DBManagerEditScoreEngine GetSETeamDetailsForBallEventsBE : COMPETITIONCODE: MATCHCODE];
						  
						   self.GetBallDetailsForBallEventsArray=[ DBManagerEditScoreEngine GetBallDetailsForBallEvents : COMPETITIONCODE: MATCHCODE : BALLCODE];
						  
						  NSMutableArray *GetWicketEventDetailsArray=[ DBManagerEditScoreEngine GetWicketEventDetailsForWicketEvents : COMPETITIONCODE: MATCHCODE :BATTINGTEAMCODE : INNINGSNO: BALLCODE];
						  
						  NSMutableArray *GetAppealDetailsForAppealEventsArray=[ DBManagerEditScoreEngine GetAppealDetailsForAppealEvents :  BALLCODE];
						  
						  NSMutableArray *GetPenaltyDetailsForPenaltyEventsArray=[ DBManagerEditScoreEngine GetPenaltyDetailsForPenaltyEvents :  COMPETITIONCODE: MATCHCODE : INNINGSNO: BALLCODE];
						  
        
        
    [DBManager GETFIELDINGFACTORSDETAILS];
    
    
    //ALL INNINGS SCORE DETAILS
    NSMutableArray *inningsArray = [[NSMutableArray alloc]init];
    inningsArray = [DBManager FETCHSEALLINNINGSSCOREDETAILS:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    if([inningsArray count]>0){
        FetchSEPageLoadRecord *inningsDetails = (FetchSEPageLoadRecord*)[inningsArray objectAtIndex:0];
        MATCHDATE = inningsDetails.MATCHDATE;
        FIRSTINNINGSTOTAL = inningsDetails.FIRSTINNINGSTOTAL;
        SECONDINNINGSTOTAL = inningsDetails.SECONDINNINGSTOTAL;
        THIRDINNINGSTOTAL = inningsDetails.THIRDINNINGSTOTAL;
        FOURTHINNINGSTOTAL = inningsDetails.FOURTHINNINGSTOTAL;
        FIRSTINNINGSWICKET = inningsDetails.FIRSTINNINGSWICKET;
        SECONDINNINGSWICKET = inningsDetails.SECONDINNINGSWICKET;
        THIRDINNINGSWICKET = inningsDetails.THIRDINNINGSWICKET;
        FOURTHINNINGSWICKET = inningsDetails.FOURTHINNINGSWICKET;
        FIRSTINNINGSSCORE = inningsDetails.FIRSTINNINGSOVERS;
        SECONDINNINGSSCORE = inningsDetails.SECONDINNINGSSCORE;
        THIRDINNINGSSCORE = inningsDetails.THIRDINNINGSSCORE;
        FOURTHINNINGSSCORE = inningsDetails.FOURTHINNINGSSCORE;
        FIRSTINNINGSOVERS = inningsDetails.FIRSTINNINGSOVERS;
        SECONDINNINGSOVERS = inningsDetails.SECONDINNINGSOVERS;
        THIRDINNINGSOVERS = inningsDetails.THIRDINNINGSOVERS;
        FOURTHINNINGSOVERS = inningsDetails.FOURTHINNINGSOVERS;
        FIRSTINNINGSSHORTNAME = inningsDetails.FIRSTINNINGSSHORTNAME;
        SECONDINNINGSSHORTNAME = inningsDetails.SECONDINNINGSSHORTNAME;
        THIRDINNINGSSHORTNAME = inningsDetails.THIRDINNINGSSHORTNAME;
        FOURTHINNINGSSHORTNAME = inningsDetails.FOURTHINNINGSSHORTNAME;
        AA = inningsDetails.AA;
        BB = inningsDetails.BB;
        AAWIC = inningsDetails.AAWIC;
        BBWIC = inningsDetails.BBWIC;
        
    }
						  
        NSMutableArray *GetSpinSpeedBallDetailsForMetadataArray=[ DBManagerEditScoreEngine GetSpinSpeedBallDetailsForMetadata];
						  
						  NSMutableArray *GetFastSpeedBallDetailsForMetadataArray=[ DBManagerEditScoreEngine GetFastSpeedBallDetailsForMetadata];
						  
						  
						  
    
    
}

    
    @end
