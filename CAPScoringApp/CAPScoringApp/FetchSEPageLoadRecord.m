//
//  FetchSEPageLoadRecord.m
//  CAPScoringApp
//
//  Created by APPLE on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchSEPageLoadRecord.h"
#import "DBManager.h"
#import "AddBreakVC.h"
@implementation FetchSEPageLoadRecord

@synthesize INNINGSPROGRESS;
@synthesize TEAMACODE;
@synthesize TEAMBCODE;
@synthesize BATTINGTEAMCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize INNINGSNO;
@synthesize INNINGSSTATUS;
@synthesize SESSIONNO;
@synthesize DAYNO;
@synthesize BATTEAMSHORTNAME;
@synthesize BOWLTEAMSHORTNAME;
@synthesize BATTEAMNAME;
@synthesize BOWLTEAMNAME;
@synthesize MATCHOVERS;
@synthesize BATTEAMLOGO;
@synthesize BOWLTEAMLOGO;
@synthesize MATCHTYPE;
@synthesize ISOTHERSMATCHTYPE;

@synthesize T_TARGETRUNS;
@synthesize T_TARGETOVERS;
@synthesize BATTEAMRUNS;
@synthesize BATTEAMWICKETS;
@synthesize BATTEAMOVERS;
@synthesize BATTEAMOVRBALLS;
@synthesize BATTEAMRUNRATE;



@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMAWICKETKEEPER;
@synthesize TEAMBWICKETKEEPER;
@synthesize TEAMACAPTAIN;
@synthesize TEAMBCAPTAIN;
@synthesize ISDEFAULTORLASTINSTANCE;



@synthesize BOWLTYPECODE;
@synthesize BOWLTYPE;
@synthesize METASUBCODEDESCRIPTION;
@synthesize METASUBCODE;


@synthesize SHOTCODE;
@synthesize SHOTNAME;
@synthesize SHOTTYPE;
@synthesize getBowlingTeamPlayers;
@synthesize getBattingTeamPlayers;


//Stricker
@synthesize strickerPlayerCode ;
@synthesize strickerPlayerName;
@synthesize strickerTotalRuns;
@synthesize strickerFours;
@synthesize strickerSixes ;
@synthesize strickerTotalBalls;
@synthesize strickerStrickRate ;


//Non Stricker Details
@synthesize nonstrickerPlayerCode ;
@synthesize nonstrickerPlayerName;
@synthesize nonstrickerTotalRuns;
@synthesize nonstrickerFours;
@synthesize nonstrickerSixes ;
@synthesize nonstrickerTotalBalls;
@synthesize nonstrickerStrickRate ;
@synthesize RUNSREQUIRED;

//Current Bowler
@synthesize currentBowlerPlayerCode ;
@synthesize currentBowlerPlayerName;
@synthesize currentBowlerOver;
@synthesize currentBowlerMaidan;
@synthesize currentBowlerRuns;
@synthesize currentBowlerWicket;
@synthesize currentBowlerEcoRate;


//Last Bowler
@synthesize lastBowlerPlayerCode ;
@synthesize lastBowlerPlayerName;
@synthesize lastBowlerOver;
@synthesize lastBowlerMaidan;
@synthesize lastBowlerRuns;
@synthesize lastBowlerWicket;
@synthesize lastBowlerEcoRate;



//@synthesize TEAMCODE;




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


BOOL overNo;
BOOL  getOverStatus;


-(void) fetchSEPageLoadDetails :(NSString*) COMPETITIONCODE :(NSString *)MATCHCODE{
    
    NSNumber *TOTALBATTEAMRUNS;
    NSNumber *TOTALBOWLTEAMRUNS;
    NSNumber *REQRUNRATE;
    
    NSNumber *REMBALLS;
    NSString *T_ATWOROTW;
    NSString *T_BOWLINGEND;
    NSNumber *COMPLETEDINNINGS;
    NSNumber *TARGETRUNS;
    
    NSString *selectedNRS;
    NSInteger *TEMPBATTEAMPENALTY;
    NSInteger *BATTEAMPENALTY;
    NSInteger *BOWLTEAMPENALTY;


    NSInteger *BATTEAMOVRWITHEXTRASBALLS;
    NSInteger *PREVOVRBALLS;
    NSInteger *PREVOVRWITHEXTRASBALLS;
    NSInteger *PREVOVRBALLSCNT;
    NSInteger *ISOVERCOMPLETE;
    NSInteger *ISPREVIOUSLEGALBALL;
    NSInteger *LASTBALLCODE;
    NSNumber *TOTALBALLS;
    NSInteger *INNINGSNUM;
  
    //============================================================================
    //Deepak
    
    
    NSString *isOverComplete = [NSString stringWithFormat:@"%d",ISOVERCOMPLETE];
    NSString *batTeamOver = [NSString stringWithFormat:@"%d",BATTEAMOVERS];
    NSString *preOverWithExtraBalls = [NSString stringWithFormat:@"%d",PREVOVRWITHEXTRASBALLS];
    NSString *batTeamOvrwithExtrasBalls = [NSString stringWithFormat:@"%d",BATTEAMOVRWITHEXTRASBALLS];
    NSString *batTeamOverBallsCnt = [NSString stringWithFormat:@"%d",_BATTEAMOVRBALLSCNT];
    NSString *preOverBallcnt = [NSString stringWithFormat:@"%d",PREVOVRBALLSCNT];
    
    
    
    _teamAndoverArray = [[NSMutableArray alloc]init];
    _teamAndoverArray =[DBManager getTeamCodeAndMatchOver:COMPETITIONCODE :MATCHCODE];
    
    FetchSEPageLoadRecord *spteam = (FetchSEPageLoadRecord*)[_teamAndoverArray objectAtIndex:0];
    TEAMACODE= spteam.TEAMACODE;
    TEAMBCODE = spteam.TEAMBCODE;
    MATCHOVERS = spteam.MATCHOVERS;
    
    
    
    
    NSMutableArray *countTeam = [DBManager getCountOver:COMPETITIONCODE :MATCHCODE];
    if(countTeam.count>0){
    FetchSEPageLoadRecord *fetchSEPageLoadRecord = (FetchSEPageLoadRecord*)[countTeam objectAtIndex:0];
    INNINGSPROGRESS = fetchSEPageLoadRecord.INNINGSPROGRESS;
    }else{
        INNINGSPROGRESS = 0;
    }
    //getInningsNo
    NSMutableArray *innArray = [DBManager getInningsNo:COMPETITIONCODE :MATCHCODE];
    FetchSEPageLoadRecord *inns = [[FetchSEPageLoadRecord alloc]init];
    NSUInteger inningsNo;
    if(innArray.count>0){
    inns = (FetchSEPageLoadRecord*)[innArray objectAtIndex:0];
    NSString *teamInns = inns.INNINGSNO;
     inningsNo = [teamInns integerValue];
    INNINGSNO = [@(inningsNo) stringValue];
    }else{
        INNINGSNO = 0;
        inningsNo = 0;
    }
    NSLog(@"%@",INNINGSNO);

    
    //batting team code
    BATTINGTEAMCODE =  [DBManager getBattingTeamCode:COMPETITIONCODE :MATCHCODE];
    
    
    //bowling team code
    BOWLINGTEAMCODE = [DBManager getBowlteamCode:MATCHCODE :COMPETITIONCODE :TEAMACODE :TEAMBCODE];
    
    
    //follow on
    NSString *followOnArray = [DBManager getFollowOn:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO];
    NSUInteger follow = [followOnArray integerValue];
    
    //penalty
    NSString *penaltyInt = [DBManager getPenalty:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
    NSInteger penalty = [penaltyInt integerValue];
    
    
    
    //penalty score
    NSString *penaltyScore = [DBManager getPenaltyScore:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO:BATTINGTEAMCODE];
    NSInteger penaltyS = [penaltyScore integerValue];
    
    //grand total
    NSString *grandTotal = [DBManager getGrandTotal:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO];
    NSInteger grandscore = [grandTotal integerValue];
    
    NSString *batTeamPenalty = [DBManager getBatTeamPenalty:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
    NSInteger batPenalty = [batTeamPenalty integerValue];
    
    
    //penalty details
    NSString *penaltyDetails = [DBManager getPenaltyDetails:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE];
    NSInteger penaltyDts = [penaltyDetails integerValue];
    
    
    //penalty details bowler
    NSString *penaltyBowler = [DBManager getPenaltyDetailsBowling:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE];
    NSInteger penaltyBowl = [penaltyBowler integerValue];
    
    
    //penalty innings
    NSString *penaltyInnings = [DBManager getPenaltyInnings:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE];
    NSInteger penaltyInns = [penaltyInnings integerValue];
    
    
    //penalty innings two
    NSString *penaltyInningsTwo = [DBManager getPenaltyInningsTwo:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE];
    NSInteger penaltyInnsTwo = [penaltyInningsTwo integerValue];
    
    
    //penalty innings three
    NSString *penaltyInnsThree = [DBManager getPenaltyInningsThree:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE];
    NSInteger penaltyInThre = [penaltyInnsThree integerValue];
    
    
    //bowling penalty inns
    NSString *Bowlingpenalty = [DBManager getBowlingPenaltyInnings:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE];
    NSInteger BowlingPnty = [penaltyInnsThree integerValue];
    
    //follow on innings four
    NSString *followInnsFour = [DBManager getFollowOnFour:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO];
    NSUInteger OnFollow = [followInnsFour integerValue];
    
    // batting penalty
    NSString *batPnty = [DBManager getBattingPenalty:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
    NSInteger batpty = [batPnty integerValue];
    
    // getBowlPnty
    NSString *bowlPntyInnings = [DBManager getBowlPnty:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO];
    NSInteger bowlPtyInnings = [bowlPntyInnings integerValue];
    
    //batting wkts
    NSString *battingwkts = [DBManager getBattingWkt:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO];
    NSInteger battingsWickets = [battingwkts integerValue];
    //team over
    NSString *teamOver = [DBManager getTeamOver:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO];
    NSInteger teamOvers = [teamOver integerValue];
    
    
    
    NSString *teamOverBall = [DBManager getTeamOverBall:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver];
    //BATTEAMOVERS
    NSInteger teamOvsBall = [teamOverBall integerValue];
    
    //team over extra ball
    NSString *teamExtraBall = [DBManager getTeamExtraBall:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver];
    NSInteger teamExtBall = [teamOverBall integerValue];
    
    //get previous ball
    
    NSString *prevball = [DBManager getPrevOverBall:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver];
    NSInteger preBall = [prevball integerValue];
    
    //get previous over extra ball
    NSString *prevExtball = [DBManager getPrevOverExtBall:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver];
    NSInteger preExtBall = [prevExtball integerValue];
    
    //get previous over ball count
    NSString *prevOverballCnt = [DBManager getPrevOvrBallCnt:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver:preOverWithExtraBalls];
    NSInteger preCntBall = [prevOverballCnt integerValue];
    
    //get batting team over ball count
    NSString *batTeamBalCnt = [DBManager getbatTeamOvrBallCnt:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :inns.INNINGSNO :batTeamOver :batTeamOvrwithExtrasBalls];
    NSInteger batBallCnt = [batTeamBalCnt integerValue];
    
    
    //get batting team over ball count
    BOOL teamBallCount = [DBManager getOverNumber:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver];
    // NSInteger teamBallCnt = [teamBallCount integerValue];
    
    //get batting over number exits
    NSString *teamBallCountExist = [DBManager getOverNumberExits:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver];
    NSInteger teamBallCntExts = [teamBallCountExist integerValue];
    
    //get last ball code
    NSString *getLastBallCode = [DBManager getLastBallCode:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver:batTeamOvrwithExtrasBalls:batTeamOverBallsCnt];
    NSInteger lastBallCode = [getLastBallCode integerValue];
    
    //get last ball code minus
    NSString *getLastBallCodeMinus = [DBManager getLastBallCodeMinus:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE:inns.INNINGSNO:batTeamOver:preOverWithExtraBalls:prevOverballCnt];
    //BATTEAMOVERS PREVOVRWITHEXTRASBALLS PREVOVRBALLSCNT;
    NSInteger lastBallCodeMinus = [getLastBallCodeMinus integerValue];
    
    
    overNo = [DBManager GETOVERNUMBERBYOVEREVENTS:COMPETITIONCODE :MATCHCODE :inns.INNINGSNO :BATTINGTEAMCODE :batTeamOver];
    
    
    
    getOverStatus = [DBManager GETOVERNUMBERBYOVERSTATUS0:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BATTEAMOVERS:batTeamOver];
    
    NSString *legalBall = [DBManager getLegalBall:getLastBallCode];
    NSInteger legalBalls = [legalBall integerValue];
    
//    BATTEAMOVERS = teamOvers;
//    
//    NSString *BATTEAMOVERSDATA = [NSString stringWithFormat:@"%d",BATTEAMOVERS];
//    
//    
//    NSString *penaltyBowlerCode = [DBManager getPENULTIMATEBOWLERCODE:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA ISOVERCOMPLETE:isOverComplete BATTEAMOVERS:batTeamOver];//OVERS
//    
//    BOOL  getBowlingTeamPlayers = [DBManager GETBOWLINGTEAMPLAYERS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO TEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA PENULTIMATEBOWLERCODE:penaltyBowlerCode BATTINGTEAMCODE:BATTINGTEAMCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE];
//    
    
    //max innings
    
    
    
    
    
    
    if ([INNINGSPROGRESS intValue]>0) {
        
        
        INNINGSNO = [DBManager InningsNo: MATCHCODE:COMPETITIONCODE];
        
        BATTINGTEAMCODE = [DBManager batsManteamCode:MATCHCODE :COMPETITIONCODE];
        
        
        BOWLINGTEAMCODE = TEAMACODE == BATTINGTEAMCODE ? TEAMACODE : TEAMBCODE;
        
    }else{
        NSMutableArray *dataInnings= [DBManager getMaxInningsNo: COMPETITIONCODE :MATCHCODE];
        
        if(dataInnings.count>0){
            FetchSEPageLoadRecord *spinngs = (FetchSEPageLoadRecord*)[dataInnings objectAtIndex:0];
            
            INNINGSNO = spinngs.INNINGSNO;
        }
        
        if ([self.MATCHTYPE isEqualToString: @"MSC023"]||[self.MATCHTYPE isEqualToString: @"MSC0114"]) {
            
            if ([INNINGSNO intValue]>4) {
                
                INNINGSNO = [NSString stringWithFormat:@"4"];
            }else{
                if ([INNINGSNO intValue]>2) {
                    INNINGSNO = [NSString stringWithFormat:@"2"];
                    
                }
                
                
                BOWLINGTEAMCODE = [DBManager getTeamCode:COMPETITIONCODE :MATCHCODE :INNINGSNO];
                
                BATTINGTEAMCODE = TEAMACODE == BOWLINGTEAMCODE ? TEAMBCODE : TEAMACODE;
            }
        }
    }
    
    
    
    DAYNO = [DBManager dayNO:MATCHCODE :COMPETITIONCODE];
    
    INNINGSSTATUS = [DBManager inningsStatus:MATCHCODE :COMPETITIONCODE :INNINGSNO];
    
    SESSIONNO = [DBManager sessionNo:MATCHCODE :COMPETITIONCODE :DAYNO];
    
    
    if (BATTINGTEAMCODE == nil || [BATTINGTEAMCODE isEqual:@""] || [BOWLINGTEAMCODE isEqual:@""] ||  BOWLINGTEAMCODE == nil) {
        
        
        BATTINGTEAMCODE = [DBManager getBowlteamCode:MATCHCODE :COMPETITIONCODE :TEAMACODE :TEAMBCODE];
        ;
        
        
        BOWLINGTEAMCODE =  TEAMACODE == BATTINGTEAMCODE ? TEAMBCODE : TEAMACODE;
        
    }
    
    
    
    //batting team name
    NSMutableArray *battingTeamName = [DBManager getBattingTeamName:BATTINGTEAMCODE];
    FetchSEPageLoadRecord *battingTeam = [battingTeamName objectAtIndex:0];
    BATTEAMNAME = battingTeam.BATTEAMNAME;
    BATTEAMSHORTNAME = battingTeam.BATTEAMSHORTNAME;
    
    
    //bowling team name
    NSMutableArray *bowlingTeamName = [DBManager getBowlingTeamName:BOWLINGTEAMCODE];
    FetchSEPageLoadRecord *bowlingTeam =  [bowlingTeamName objectAtIndex:0];
    BOWLTEAMNAME = bowlingTeam.BOWLTEAMNAME;
    BOWLTEAMSHORTNAME = bowlingTeam.BOWLTEAMSHORTNAME;
    
    
    //total runs and total overs
    NSMutableArray *totalOvers = [DBManager getTargetRunsOvers:COMPETITIONCODE :MATCHCODE];
    
    FetchSEPageLoadRecord *totRun = (FetchSEPageLoadRecord*)[totalOvers objectAtIndex:0];
    
    T_TARGETRUNS = totRun.T_TARGETRUNS;
    T_TARGETOVERS = totRun.T_TARGETOVERS;
    
    MATCHOVERS  = T_TARGETRUNS.intValue > 0 ? [T_TARGETOVERS stringValue] : MATCHOVERS;
    
    //Batting team player
    
 getBattingTeamPlayers =[DBManager GETWICKETDETAILS:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE COMPETITIONCODE:COMPETITIONCODE INNINGSNO:INNINGSNO];
    
    
    if (inningsNo == 3 && follow == 1){
        
        TEMPBATTEAMPENALTY = 0;
        
        
    }else if (inningsNo == 4 && (follow - 1)== 1){
        
        TEMPBATTEAMPENALTY = penalty;
        
    }else{
        TEMPBATTEAMPENALTY = penaltyS;
    }
    
   BATTEAMRUNS = grandscore;
    int tempBatteamRuns = (BATTEAMRUNS == nil ? 0: (int)BATTEAMRUNS);
    
    int tempBatTeamPenalty =  (TEMPBATTEAMPENALTY == nil ? 0 :(int)TEMPBATTEAMPENALTY);
    
    BATTEAMRUNS = tempBatteamRuns + tempBatTeamPenalty;
    
    
    if (inningsNo == 1) {
        BATTEAMPENALTY = batPenalty;
        BOWLTEAMPENALTY = 0;
        
    }else if (inningsNo == 2){
        
        BATTEAMPENALTY = penaltyDts;
        
        if ([self.MATCHTYPE isEqualToString: @"MSC023"] || [self.MATCHTYPE isEqualToString: @"MSC114"]) {
            
            BOWLTEAMPENALTY = penaltyBowl;
            
        }else{
            
            BOWLTEAMPENALTY = penaltyInns;
        }
        
    }
    else if (inningsNo == 3) {
        
        if (follow == 1 ) {
            BATTEAMPENALTY = penaltyInnsTwo;
            
        }else
        {
            BATTEAMPENALTY = penaltyInThre;
        }
        
        BOWLTEAMPENALTY = BowlingPnty;
    }
    if (inningsNo == 4) {
        if (OnFollow == 1) {
            BATTEAMPENALTY = batpty;
        }else{
            BATTEAMPENALTY = penaltyInThre;
        }
        BOWLTEAMPENALTY = bowlPtyInnings;
    }
    
    BATTEAMWICKETS = battingsWickets;
    BATTEAMOVERS = teamOvers;
    BATTEAMOVRBALLS = teamOvsBall;
    
    
    BATTEAMOVRWITHEXTRASBALLS = teamExtBall;
    
    
    
    if (BATTEAMOVRBALLS == 0) {
        PREVOVRBALLS = preBall;
        PREVOVRWITHEXTRASBALLS = preExtBall;
        PREVOVRBALLSCNT = preCntBall;
    }
    _BATTEAMOVRBALLSCNT = batBallCnt;
    
    
    
    if (teamBallCount) {
        
        LASTBALLCODE = lastBallCode;
        
        
    }else{
        if (BATTEAMOVRWITHEXTRASBALLS == 0) {
            
            LASTBALLCODE = lastBallCodeMinus;
            
        }
    }
    
    if (overNo ) {
        if (getOverStatus) {
            ISOVERCOMPLETE =0;
            
        }else{
            ISOVERCOMPLETE = 1;
            BATTEAMOVRBALLS = 0;
            
        }
        
    }else{
        ISOVERCOMPLETE = -1;
    }
    
    if (ISOVERCOMPLETE == 1) {
        
        ISPREVIOUSLEGALBALL = 1;
    }else{
        ISPREVIOUSLEGALBALL = legalBalls;
        
    }
    int totalBallData = (((int)ISOVERCOMPLETE == 1 ? (int)BATTEAMOVERS + 1 : (int)BATTEAMOVERS) * 6) + ((int)BATTEAMOVRBALLS > 6 ? 6: (int)BATTEAMOVRBALLS);
    
    TOTALBALLS = [NSNumber numberWithInt:totalBallData];
    
    
    float batteamRunRateData = (TOTALBALLS.intValue == 0) ? 0 :((int)BATTEAMRUNS/TOTALBALLS.intValue)*6;
    
     BATTEAMRUNRATE  = [NSNumber numberWithFloat:batteamRunRateData];
    
      BATTEAMOVERS = teamOvers;
    NSString *BATTEAMOVERSDATA = [NSString stringWithFormat:@"%d",BATTEAMOVERS];

    
    
    NSString *penaltyBowlerCode = [DBManager getPENULTIMATEBOWLERCODE:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA ISOVERCOMPLETE:isOverComplete BATTEAMOVERS:batTeamOver];//OVERS
    
     getBowlingTeamPlayers = [DBManager GETBOWLINGTEAMPLAYERS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO TEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA PENULTIMATEBOWLERCODE:penaltyBowlerCode BATTINGTEAMCODE:BATTINGTEAMCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE];
    
    
    //=============================================================================
    //Sathishbb
    
    
    TOTALBATTEAMRUNS = [[NSNumber alloc] init];
    TOTALBATTEAMRUNS = 0;
    
    TOTALBOWLTEAMRUNS = [[NSNumber alloc] init];
    TOTALBOWLTEAMRUNS = 0;
    
    REQRUNRATE = [[NSNumber alloc] init];
    REQRUNRATE = 0;
    
    RUNSREQUIRED = [[NSNumber alloc] init];
    RUNSREQUIRED = 0;
    
    
    REMBALLS = [[NSNumber alloc] init];
    REMBALLS = 0;
    
    T_ATWOROTW = [[NSString alloc] init];
    T_BOWLINGEND = [[NSString alloc] init];
    
    TARGETRUNS = [[NSNumber alloc] init];
    TARGETRUNS = 0;
    
    COMPLETEDINNINGS = [DBManager getComletedInnings:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    if(COMPLETEDINNINGS > 0){
        TOTALBATTEAMRUNS = [DBManager getTotalBatTeamRuns:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE ];
        
        TOTALBOWLTEAMRUNS = [DBManager getTOTALBOWLTEAMRUNS:COMPETITIONCODE MATCHCODE:MATCHCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE];
        
        NSNumber *TEMPBOWLPENALTY;
        TEMPBOWLPENALTY = [[NSNumber alloc] init];
        TEMPBOWLPENALTY = 0;
        
        NSNumber *TEMPBATPENALTY;
        TEMPBATPENALTY = [[NSNumber alloc] init];
        TEMPBATPENALTY = 0;
        
        
        if(([INNINGSNO isEqual: @"4" ]&&
            ([MATCHTYPE isEqual: @"MSC023"] || [MATCHTYPE isEqual: @"MSC114"]))
           ||
           ([INNINGSNO isEqual: @"2"] && (![MATCHTYPE isEqual: @"MSC023"] || ![MATCHTYPE isEqual: @"MSC114"]))){
            
            
            
            NSString *TEMPBOWLPENALTY = [DBManager getTEMPBOWLPENALTY:COMPETITIONCODE MATCHCODE:MATCHCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE];
            NSString *TEMPBATPENALTY = [DBManager getTEMPBATPENALTY:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO];
            
            
        }
        
        
        
        
        
        TARGETRUNS =[ NSNumber numberWithInt:
                     (TOTALBOWLTEAMRUNS.intValue + TEMPBOWLPENALTY.intValue)
                     -[DBManager getTARGETRUNS:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO].intValue
                     + TEMPBATPENALTY.intValue];
        
        if (TARGETRUNS > 0)
        {
            
            TARGETRUNS = [NSNumber numberWithInt: TARGETRUNS.intValue + 1];
        }else{
            
            TARGETRUNS = [NSNumber numberWithInt:  1];
        }
        
        TOTALBATTEAMRUNS = [NSNumber numberWithInt: (TOTALBATTEAMRUNS.intValue + BATTEAMPENALTY)];
        TOTALBOWLTEAMRUNS =  [NSNumber numberWithInt: (TOTALBOWLTEAMRUNS.intValue + BOWLTEAMPENALTY)];
        
        BOOL matchInningsEqual = (([MATCHTYPE isEqual: @"MSC023"]|| [MATCHTYPE isEqual: @"MSC114"])  && [INNINGSNO isEqual: @"4"] && TOTALBOWLTEAMRUNS > 0);
        
        BOOL matchInningsNOTEqual = (![MATCHTYPE isEqual: @"MSC023"]|| ![MATCHTYPE isEqual: @"MSC114"] && [INNINGSNO isEqual: @"2"] && TOTALBOWLTEAMRUNS > 0);
        
        if(matchInningsEqual){
            TOTALBOWLTEAMRUNS =  [NSNumber numberWithInt: TOTALBOWLTEAMRUNS.intValue + 1];
        }else if(matchInningsNOTEqual){
            TOTALBOWLTEAMRUNS =  [NSNumber numberWithInt: TOTALBOWLTEAMRUNS.intValue + 1];
        }else{
            TOTALBATTEAMRUNS = TOTALBOWLTEAMRUNS;
        }
        
        TARGETRUNS = T_TARGETRUNS > 0 ? T_TARGETRUNS : TARGETRUNS;
        
        TOTALBOWLTEAMRUNS =  T_TARGETRUNS > 0 ? T_TARGETRUNS : TOTALBOWLTEAMRUNS;
        
        TOTALBOWLTEAMRUNS = (TOTALBOWLTEAMRUNS.intValue == @0 ?  @1 : TOTALBOWLTEAMRUNS);
        
        int runReq = TOTALBOWLTEAMRUNS.intValue - TOTALBATTEAMRUNS.intValue;
        
        RUNSREQUIRED = [NSNumber numberWithInt:runReq];
        
        int  remBallsData = ([MATCHOVERS integerValue] * 6) - ((int)ISOVERCOMPLETE == 1 ? (int)BATTEAMOVERS + 1 : (int)BATTEAMOVERS  * 6) + (int)BATTEAMOVRBALLS;
        
        
        REMBALLS = [NSNumber numberWithInt:remBallsData];
        
        float reqRunRateData = (int)REMBALLS == 0 ? 0 :((int)RUNSREQUIRED / (int)REMBALLS) * ((int)REMBALLS < 6 ? 1 : 6);
        
        REQRUNRATE = [NSNumber numberWithFloat:reqRunRateData];
    }
    
    NSString *lastvalueData = [NSString stringWithFormat: @"%d", (long)LASTBALLCODE];
    
    //TO GET LAST BALL ATWOROTW AND BOWLING END DETAILS.
    NSMutableArray *atwRtw = [DBManager getT_BOWLINGEND:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:isOverComplete LASTBALLCODE:lastvalueData];
    if([atwRtw count]>0){
        T_BOWLINGEND =[atwRtw objectAtIndex:0];
        //ISOVERCOMPLETE =[atwRtw objectAtIndex:1];
        
    }
    //FREE HIT
    NSNumber *ISFREEHIT = 0;
    
    if(ISPREVIOUSLEGALBALL == 1){
        ISFREEHIT = 0;
    }else{
        
        NSString *BATTEAMOVERSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVERS];
        NSString *BATTEAMOVRWITHEXTRASBALLSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVRWITHEXTRASBALLS];
        
        
        NSNumber *noBall = [DBManager getNOBALL:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO BATTEAMOVERS:BATTEAMOVERSDATA  BATTEAMOVRWITHEXTRASBALLS:BATTEAMOVRWITHEXTRASBALLSDATA];
        
        if(noBall.intValue > 0){
            ISFREEHIT = @1;
        }
        
    }
    
    NSString *STRIKERCODE;
    NSString *NONSTRIKERCODE;
    NSNumber *STRIKERBALLS = 0;
    NSNumber *NONSTRIKERBALLS = 0;
    NSString *T_STRIKERCODE;
    NSString *T_NONSTRIKERCODE;
    NSString *T_TOTALRUNS;
    NSString *T_OVERSTATUS;
    NSString *T_WICKETPLAYER;
    NSString *T_WICKETTYPE;
    NSString *BOWLERCODE;
    NSString *UMPIRE1CODE;
    NSString *UMPIRE2CODE;
    
    NSString *ISOVERCOMPLETEDATA = [NSString stringWithFormat: @"%d", (long)ISOVERCOMPLETE];
    
    NSMutableArray *battsmanDetails = [DBManager getBATSMANDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:ISOVERCOMPLETEDATA T_BOWLINGEND:T_BOWLINGEND];
    if([battsmanDetails count]>0){
        STRIKERCODE = [battsmanDetails objectAtIndex:0];
        NONSTRIKERCODE = [battsmanDetails objectAtIndex:1];
        T_STRIKERCODE = [battsmanDetails objectAtIndex:2];
        T_NONSTRIKERCODE = [battsmanDetails objectAtIndex:3];
        BOWLERCODE = [battsmanDetails objectAtIndex:4];
        T_BOWLINGEND = [battsmanDetails objectAtIndex:5];
        
    }
    
    
    //SCORE DETAILS
    
    NSString *BATTEAMRUNSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMRUNS];
    NSString *BATTEAMWICKETSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMWICKETS];
   // NSString *BATTEAMOVERSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVERS];
    NSString *BATTEAMOVRBALLSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVRBALLS];
    NSString *ISPREVIOUSLEGALBALLDATA = [NSString stringWithFormat: @"%d", (long)ISPREVIOUSLEGALBALL];
    
    [DBManager getScoreingDetails:BATTEAMSHORTNAME BOWLTEAMSHORTNAME:BOWLTEAMSHORTNAME BATTEAMNAME:BATTEAMNAME BOWLTEAMNAME:BOWLTEAMNAME BATTEAMLOGO:BATTEAMLOGO BOWLTEAMLOGO:BOWLTEAMLOGO BATTEAMRUNS:BATTEAMRUNSDATA BATTEAMWICKETS:BATTEAMWICKETSDATA ISOVERCOMPLETE:ISOVERCOMPLETEDATA BATTEAMOVERS:BATTEAMOVERSDATA BATTEAMOVRBALLS:BATTEAMOVRBALLSDATA BATTEAMRUNRATE:BATTEAMRUNRATE  TARGETRUNS:TARGETRUNS REQRUNRATE:REQRUNRATE RUNSREQUIRED:RUNSREQUIRED REMBALLS:REMBALLS ISPREVIOUSLEGALBALL:ISPREVIOUSLEGALBALLDATA T_ATWOROTW:T_ATWOROTW T_BOWLINGEND:T_BOWLINGEND ISFREEHIT:ISFREEHIT];
    
    
    
    
    NSNumber *balls = [DBManager getBallEventCount:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
    if(balls > 0)
    {
        
        NSString *LASTBALLCODEDATA = [NSString stringWithFormat: @"%d", (long)LASTBALLCODE];
        
        NSMutableArray *totalRunsArray = [DBManager getTotalRuns:LASTBALLCODEDATA];
        
        if(totalRunsArray.count >0){
        T_TOTALRUNS = [totalRunsArray objectAtIndex:0];
        T_OVERSTATUS = [totalRunsArray objectAtIndex:1];
        T_WICKETPLAYER = [totalRunsArray objectAtIndex:2];
        T_WICKETTYPE = [totalRunsArray objectAtIndex:3];
        }
        
    }
    
    
    
    if ([T_WICKETTYPE isEqual: @"MSC102"]){//Retired Hurt
        
        STRIKERCODE = [STRIKERCODE isEqual: T_WICKETPLAYER] ? @"" : STRIKERCODE;
        NONSTRIKERCODE =[ NONSTRIKERCODE isEqual: T_WICKETPLAYER] ? @"" : NONSTRIKERCODE;
        
    }else{
        
        NSString *WICKETPLAYER =  [DBManager getWICKETPLAYER:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
        
        
        STRIKERCODE =  [STRIKERCODE isEqual:WICKETPLAYER] ?@"":STRIKERCODE;
        NONSTRIKERCODE = [NONSTRIKERCODE isEqual:WICKETPLAYER] ?@"":NONSTRIKERCODE;
        
    }
    
    STRIKERBALLS = [DBManager getSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:STRIKERCODE];
    
    //Striker details
    NSMutableArray *strickerDetaailsArray;
    if([DBManager hasSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:STRIKERCODE]){
         strickerDetaailsArray = [DBManager getStrickerCode:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO: INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:STRIKERCODE STRIKERBALLS:STRIKERBALLS];
    }else{
       strickerDetaailsArray =  [DBManager getStrickerDetails:STRIKERCODE];
    }
    
    if(strickerDetaailsArray.count>0){
        
        strickerPlayerCode = [strickerDetaailsArray objectAtIndex:0];
        strickerPlayerName = [strickerDetaailsArray objectAtIndex:1];
        strickerTotalRuns = [strickerDetaailsArray objectAtIndex:2];
        strickerFours = [strickerDetaailsArray objectAtIndex:3];
        strickerSixes = [strickerDetaailsArray objectAtIndex:4];
        strickerTotalBalls = [strickerDetaailsArray objectAtIndex:5];
        strickerStrickRate = [strickerDetaailsArray objectAtIndex:6];
      
    }
    
    NONSTRIKERBALLS = [DBManager getBALLCODECOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE NONSTRIKERCODE:NONSTRIKERCODE];
    
    
    //NONSTRIKER DETAILS
    NSMutableArray *nonstrickerDetaailsArray;
    if([DBManager hasSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:NONSTRIKERCODE]){
       nonstrickerDetaailsArray = [DBManager getStrickerCode:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO: INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:NONSTRIKERCODE STRIKERBALLS:NONSTRIKERBALLS];
    }else{
      nonstrickerDetaailsArray =  [DBManager getStrickerDetails:NONSTRIKERCODE];
    }
    
    if(nonstrickerDetaailsArray.count>0){
        
        nonstrickerPlayerCode = [nonstrickerDetaailsArray objectAtIndex:0];
        nonstrickerPlayerName = [nonstrickerDetaailsArray objectAtIndex:1];
        nonstrickerTotalRuns = [nonstrickerDetaailsArray objectAtIndex:2];
        nonstrickerFours = [nonstrickerDetaailsArray objectAtIndex:3];
        nonstrickerSixes = [nonstrickerDetaailsArray objectAtIndex:4];
        nonstrickerTotalBalls = [nonstrickerDetaailsArray objectAtIndex:5];
        nonstrickerStrickRate = [nonstrickerDetaailsArray objectAtIndex:6];
        
    }
    
    //PARTNERSHIP DETAILS
    
    NSNumber *WICKETS = 0;
    
    WICKETS = [DBManager getWicket:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    NSNumber *LASTBOWLEROVERNO;
    NSNumber *LASTBOWLEROVERBALLNO;
    NSNumber *LASTBOWLEROVERBALLNOWITHEXTRAS;
    NSNumber *LASTBOWLEROVERBALLCOUNT;
    
    
    LASTBOWLEROVERNO = [DBManager getLASTBOWLEROVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    NSNumber *LASTBOWLEROVERSTATUS = [DBManager getLASTBOWLEROVERSTATUS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO];
    
    if(LASTBOWLEROVERNO != nil){
        
        LASTBOWLEROVERBALLNO = [DBManager getLASTBOWLEROVERBALLNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE];
        
        LASTBOWLEROVERBALLNOWITHEXTRAS = [DBManager getLASTBOWLEROVERBALLNOWITHEXTRAS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE];
        
        LASTBOWLEROVERBALLCOUNT = [DBManager getLASTBOWLEROVERBALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:LASTBOWLEROVERBALLNOWITHEXTRAS];
        
    }else{
        LASTBOWLEROVERBALLNO = 0;
        LASTBOWLEROVERBALLNOWITHEXTRAS = 0;
        LASTBOWLEROVERBALLCOUNT = 0;
    }
    
    
    NSString *S_ATWOROTW = [DBManager getS_ATWOROTW:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:LASTBOWLEROVERBALLNOWITHEXTRAS LASTBOWLEROVERBALLCOUNT:LASTBOWLEROVERBALLCOUNT];
    
    //NSString *BATTEAMOVERSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVERS];
    
    
    NSNumber *TOTALBALLSBOWL;
    NSNumber *MAIDENS;
    NSNumber *BOWLERRUNS;
    NSNumber *ISPARTIALOVER = [DBManager getISPARTIALOVER:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE BATTEAMOVERS:BATTEAMOVERSDATA];
    
    if(ISPARTIALOVER.intValue == 0){
        ISPARTIALOVER = [DBManager getISPARTIALOVERWHEN0:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE BATTEAMOVERS:BATTEAMOVERSDATA];
    }
    NSMutableArray *getBowlerBasedDetails = [DBManager getTOTALBALLSBOWL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    if([getBowlerBasedDetails count]>0){
        TOTALBALLSBOWL = [getBowlerBasedDetails objectAtIndex:0];
        MAIDENS = [getBowlerBasedDetails objectAtIndex:1];
        BOWLERRUNS = [getBowlerBasedDetails objectAtIndex:2];
        
    }
    
    
    LASTBOWLEROVERBALLNO = LASTBOWLEROVERSTATUS.intValue == 1 ? [NSNumber numberWithInt:0] : LASTBOWLEROVERBALLNO;
    
    
    NSNumber *BOWLERSPELL  = [NSNumber numberWithInt: 0];
    NSNumber *V_SPELLNO = [NSNumber numberWithInt: 0];
    
    BOWLERSPELL = [DBManager getBOWLERSPELL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE BATTEAMOVERS:BATTEAMOVERSDATA V_SPELLNO:V_SPELLNO];
    
    int BOWLERSPELLDATA = (int)BATTEAMOVERS - (int)LASTBOWLEROVERNO > 2 && (int)LASTBOWLEROVERSTATUS == 1 ? (int)BOWLERSPELL + 1 : (int)BOWLERSPELL;
    
    BOWLERSPELL = [NSNumber numberWithInt:BOWLERSPELLDATA];
    
    
    
    
    //BOWLER DETAILS
    NSMutableArray *curentBowlerDetaailsArray;

    if([DBManager GETBOLWERDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE]){
        
        curentBowlerDetaailsArray =[DBManager GETBOLWLINGDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BOWLERCODE:BOWLERCODE BOWLERSPELL:BOWLERSPELL BOWLERRUNS:BOWLERRUNS S_ATWOROTW:S_ATWOROTW TOTALBALLSBOWL:TOTALBALLSBOWL WICKETS:WICKETS MAIDENS:MAIDENS ISPARTIALOVER:ISPARTIALOVER LASTBOWLEROVERBALLNO:LASTBOWLEROVERBALLNO];
        
               
    }else{
        
        curentBowlerDetaailsArray =[DBManager GETPLAYERDETAIL:BOWLERCODE];
    }
    
    if(curentBowlerDetaailsArray.count>0){
        
        currentBowlerPlayerCode = [curentBowlerDetaailsArray objectAtIndex:0];
        currentBowlerPlayerName = [curentBowlerDetaailsArray objectAtIndex:1];
        currentBowlerRuns = [curentBowlerDetaailsArray objectAtIndex:2];
        currentBowlerOver = [curentBowlerDetaailsArray objectAtIndex:3];
        currentBowlerMaidan = [curentBowlerDetaailsArray objectAtIndex:4];
        currentBowlerWicket = [curentBowlerDetaailsArray objectAtIndex:5];
        currentBowlerEcoRate = [curentBowlerDetaailsArray objectAtIndex:6];
        
    }

    
    NSString *LASTBALLCODEDATA = [NSString stringWithFormat: @"%d", (long)LASTBALLCODE];
    
    
    if([DBManager GETBALLDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO LASTBALLCODE:LASTBALLCODEDATA TEAMCODE:BATTINGTEAMCODE BALLCODE:LASTBALLCODEDATA]){
        
        NSString *ISOVERCOMPLETEDATA = [NSString stringWithFormat: @"%d", (long)ISOVERCOMPLETE];
        
        
        NSMutableArray *umpires = [DBManager GETUMPIREBYBALLEVENT:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO UMPIRE1CODE:UMPIRE1CODE ISOVERCOMPLETE:ISOVERCOMPLETEDATA UMPIRE2CODE:UMPIRE2CODE LASTBALLCODE:LASTBALLCODEDATA];
        if([umpires count]>0){
            UMPIRE1CODE = [umpires objectAtIndex:0];
            UMPIRE2CODE = [umpires objectAtIndex:1];
        }
    }else{
        
        NSMutableArray *umpires = [DBManager GETUMPIREBYMATCHREGISTRATION:COMPETITIONCODE MATCHCODE:MATCHCODE UMPIRE1CODE:UMPIRE1CODE UMPIRE2CODE:UMPIRE2CODE];
        if([umpires count]>0){
            UMPIRE1CODE = [umpires objectAtIndex:0];
            UMPIRE2CODE = [umpires objectAtIndex:1];
        }
        int inningsNoData =[INNINGSNO integerValue]  <= 1? 1 : [INNINGSNO integerValue] - 1;
        
        NSNumber *U_INNINGSNO  =[NSNumber numberWithInt:inningsNoData];
        
        NSNumber *U_OVERNO  =[DBManager getU_OVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
        
        
        
        NSNumber *U_BALLNO =[DBManager getU_BALLNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:U_OVERNO];
        
        NSNumber *U_BALLCOUNT =[DBManager getU_BALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:U_OVERNO BALLNO:U_BALLNO];
        
        
        if([DBManager GETUMPIREBYBALLEVENT:COMPETITIONCODE MATCHCODE:MATCHCODE BALLNO:U_BALLNO INNINGSNO:INNINGSNO  BALLCOUNT:U_BALLCOUNT  OVERNO:U_OVERNO]){
            NSMutableArray *umpiresByMatchReg  = [DBManager GETUMBIREBYBALLEVENT:COMPETITIONCODE MATCHCODE:MATCHCODE UMPIRE1CODE:UMPIRE1CODE UMPIRE2CODE:UMPIRE2CODE INNINGSNO:INNINGSNO OVERNO:U_OVERNO BALLNO:U_BALLNO BALLCOUNT:U_BALLCOUNT];
            if([umpiresByMatchReg count]>0){
                UMPIRE1CODE=[umpiresByMatchReg objectAtIndex:0];
                UMPIRE2CODE=[umpiresByMatchReg objectAtIndex:1];
            }
        }
        
        
    }
    
    
    //MATCH UMPIRE DETAILS
    
    NSMutableArray *umpiresByMatchReg  = [DBManager GETMATCHUMPIREDETAILS:UMPIRE1CODE UMPIRE2CODE:UMPIRE2CODE];
    
    if ([umpiresByMatchReg count]>0) {
        
        
        UMPIRE1CODE = [umpiresByMatchReg objectAtIndex:0];
        UMPIRE2CODE = [umpiresByMatchReg objectAtIndex:1];
        
    }
    //
    NSNumber *ISINNINGSLASTOVER;
    
    ISINNINGSLASTOVER = [DBManager getISINNINGSLASTOVER:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:BATTEAMOVERSDATA ISINNINGSLASTOVER:ISINNINGSLASTOVER TEAMCODE:BATTINGTEAMCODE];
    
    //BALL GRID DETAILS
    
    
    [DBManager GetBallGridDetails:COMPETITIONCODE MATCHCODE:MATCHCODE ISINNINGSLASTOVER:ISINNINGSLASTOVER TEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:ISOVERCOMPLETEDATA BATTEAMOVERS:BATTEAMOVERSDATA];
    
    
    //TEAM DETAILS
    [DBManager getTeamDetails:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    
    //UMPIRE DETAILS
    [DBManager getUmpireDetails];
    
    // EXEC SP_FETCHSEFIELDINGEVENTSPAGELOAD @COMPETITIONCODE,@MATCHCODE,@BOWLINGTEAMCODE;
    
    [DBManager GETFIELDINGEVENTSDETAILS:MATCHCODE TEAMCODE:BOWLINGTEAMCODE COMPETITIONCODE:COMPETITIONCODE];
    
    [DBManager GETBOWLINGTEAMPLAYERS:MATCHCODE TEAMCODE:BOWLINGTEAMCODE];
    
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
    
    
    
    //SPINSPEEDBALLS DETAILS
    [DBManager getSPINSPEEDBALLS];
    
    //FASTSPEEDBALLS DETAILS
    [DBManager getFASTSPEEDBALLS];
    
    //UNCOMFORT DETAILS
    [DBManager getUNCOMFORT];
    
    //LAST BALL STATUS IN MAX INNINGS BECAUSE BELOW DATA'S USED TO
    NSNumber *MAXINNINGS =[DBManager getMAXINNINGS:COMPETITIONCODE MATCHCODE:MATCHCODE ];
    NSNumber *MAXOVER =[DBManager getMAXOVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE MAXINNINGS:MAXINNINGS
                        ];
    NSNumber *MAXBALL =[DBManager getMAXBALL:COMPETITIONCODE MATCHCODE:MATCHCODE MAXINNINGS:MAXINNINGS MAXOVER:MAXOVER ];
    NSNumber *MAXBALLCOUNT =[DBManager getBALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE MAXINNINGS:MAXINNINGS MAXOVER:MAXOVER MAXBALL:MAXBALL];
    NSString *MATCHRESULTSTATUS = [DBManager getMATCHRESULTSTATUS:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    
}


@end
