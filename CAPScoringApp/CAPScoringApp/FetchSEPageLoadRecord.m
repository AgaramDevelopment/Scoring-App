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
@synthesize strickerBattingStyle;


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
@synthesize ISOVERCOMPLETE;
@synthesize ISFREEHIT;

//Umpire Details
@synthesize UMPIRE1CODE;
@synthesize UMPIRE2CODE;
@synthesize UMPIRE1NAME;
@synthesize UMPIRE2NAME;


BOOL overNo;
BOOL  getOverStatus;
@synthesize REQRUNRATE;
@synthesize TARGETRUNS;
@synthesize REMBALLS;
@synthesize BallGridDetails;


-(void) fetchSEPageLoadDetails :(NSString*) COMPETITIONCODE :(NSString *)MATCHCODE{
    DBManager *db = [[DBManager alloc]init];

    NSNumber *TOTALBATTEAMRUNS;
    NSNumber *TOTALBOWLTEAMRUNS;
    
    //NSNumber *REMBALLS;
    NSString *T_ATWOROTW;
    NSString *T_BOWLINGEND;
    NSNumber *COMPLETEDINNINGS;
   // NSNumber *TARGETRUNS;
    
    NSString *selectedNRS;
    NSInteger TEMPBATTEAMPENALTY;
    NSInteger BATTEAMPENALTY;
    NSInteger BOWLTEAMPENALTY;
    
    
    NSInteger BATTEAMOVRWITHEXTRASBALLS;
    NSInteger PREVOVRBALLS;
    NSInteger PREVOVRWITHEXTRASBALLS;
    NSInteger PREVOVRBALLSCNT;
    
    NSInteger ISPREVIOUSLEGALBALL;
    NSString *LASTBALLCODE;
    NSNumber *TOTALBALLS;
    NSInteger *INNINGSNUM;
    //============================================================================
    //Deepak
    
    
   // NSString *isOverComplete = [NSString stringWithFormat:@"%d",ISOVERCOMPLETE];
    NSString *batTeamOver = [NSString stringWithFormat:@"%d",BATTEAMOVERS];
    NSString *preOverWithExtraBalls = [NSString stringWithFormat:@"%d",PREVOVRWITHEXTRASBALLS];
  
    NSString *preOverBallcnt = [NSString stringWithFormat:@"%d",PREVOVRBALLSCNT];
    
    
    
    _teamAndoverArray = [[NSMutableArray alloc]init];
    _teamAndoverArray =[db getTeamCodeAndMatchOver:COMPETITIONCODE :MATCHCODE];
    
    FetchSEPageLoadRecord *spteam = (FetchSEPageLoadRecord*)[_teamAndoverArray objectAtIndex:0];
    TEAMACODE= spteam.TEAMACODE;
    TEAMBCODE = spteam.TEAMBCODE;
    MATCHOVERS = spteam.MATCHOVERS;
    
    
    NSMutableArray *matchCodeDetailsArray = [db getMatchTypeAndIso:COMPETITIONCODE];
    if(matchCodeDetailsArray.count>0){
        FetchSEPageLoadRecord *fetchsePg =[matchCodeDetailsArray objectAtIndex:0];
        MATCHTYPE = fetchsePg.MATCHTYPE;
        ISOTHERSMATCHTYPE = fetchsePg.ISOTHERSMATCHTYPE;
        
    }
    
    
    NSUInteger inningsNo;
    //    //getInningsNo
    //    NSMutableArray *innArray = [db getInningsNo:COMPETITIONCODE :MATCHCODE];
    //    FetchSEPageLoadRecord *inns = [[FetchSEPageLoadRecord alloc]init];
    //
    //    if(innArray.count>0){
    //    inns = (FetchSEPageLoadRecord*)[innArray objectAtIndex:0];
    //    NSString *teamInns = inns.INNINGSNO;
    //
    //        INNINGSNO = [@(inningsNo) stringValue];
    //    }else{
    //        INNINGSNO = @"0";
    //        inningsNo = 0;
    //    }
    //    NSLog(@"%@",INNINGSNO);
    
    //Procedure Start
    NSMutableArray *countTeam = [db getCountOver:COMPETITIONCODE :MATCHCODE];
    if(countTeam.count>0){
        FetchSEPageLoadRecord *fetchSEPageLoadRecord = (FetchSEPageLoadRecord*)[countTeam objectAtIndex:0];
        INNINGSPROGRESS = fetchSEPageLoadRecord.INNINGSPROGRESS;
    }else{
        INNINGSPROGRESS = 0;
    }
    
    if ([INNINGSPROGRESS intValue]>0) {
        
        INNINGSNO = [db InningsNo: MATCHCODE :COMPETITIONCODE];
        
        inningsNo = [INNINGSNO integerValue];
        
        BATTINGTEAMCODE = [db batsManteamCode:MATCHCODE :COMPETITIONCODE];
        
        
        BOWLINGTEAMCODE = ([TEAMACODE isEqual: BATTINGTEAMCODE]) ?TEAMBCODE: TEAMACODE ;
        
    }else{
        NSMutableArray *dataInnings= [db getMaxInningsNo: COMPETITIONCODE :MATCHCODE];
        
        if(dataInnings.count>0){
            FetchSEPageLoadRecord *spinngs = (FetchSEPageLoadRecord*)[dataInnings objectAtIndex:0];
            
            INNINGSNO = spinngs.INNINGSNO;
            inningsNo = [INNINGSNO integerValue];
        }
        
        if ([self.MATCHTYPE isEqualToString: @"MSC023"]||[self.MATCHTYPE isEqualToString: @"MSC114"]) {
            
            if ([INNINGSNO intValue]>4) {
                
                INNINGSNO = [NSString stringWithFormat:@"4"];
                inningsNo = [INNINGSNO integerValue];
            }else{
                if ([INNINGSNO intValue]>2) {
                    INNINGSNO = [NSString stringWithFormat:@"2"];
                    inningsNo = [INNINGSNO integerValue];
                    
                }
                
                
                BOWLINGTEAMCODE = [db getTeamCode:COMPETITIONCODE :MATCHCODE :INNINGSNO];
                
                BATTINGTEAMCODE = ([TEAMACODE isEqual: BOWLINGTEAMCODE]) ? TEAMBCODE : TEAMACODE;
            }
        }
    }
    
    //    //batting team code
    //    BATTINGTEAMCODE =  [db getBattingTeamCode:COMPETITIONCODE :MATCHCODE];
    //
    //
    //    //bowling team code
    //    BOWLINGTEAMCODE = [db getBowlteamCode:MATCHCODE :COMPETITIONCODE :TEAMACODE :TEAMBCODE];
    
    //get batting over number exits
    NSString *teamBallCountExist = [db getOverNumberExits:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE: INNINGSNO:batTeamOver];
    NSInteger teamBallCntExts = [teamBallCountExist integerValue];
    
    
    
    //    BATTEAMOVERS = teamOvers;
    //
    //    NSString *BATTEAMOVERSDATA = [NSString stringWithFormat:@"%d",BATTEAMOVERS];
    //
    //
    //    NSString *penaltyBowlerCode = [db getPENULTIMATEBOWLERCODE:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA ISOVERCOMPLETE:isOverComplete BATTEAMOVERS:batTeamOver];//OVERS
    //
    //    BOOL  getBowlingTeamPlayers = [db GETBOWLINGTEAMPLAYERS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:inns.INNINGSNO TEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA PENULTIMATEBOWLERCODE:penaltyBowlerCode BATTINGTEAMCODE:BATTINGTEAMCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE];
    //
    
    //max innings
    
    DAYNO = [db dayNO:MATCHCODE :COMPETITIONCODE];
    
    INNINGSSTATUS = [db inningsStatus:MATCHCODE :COMPETITIONCODE :INNINGSNO];
    
    SESSIONNO = [db sessionNo:MATCHCODE :COMPETITIONCODE :DAYNO];
    
    
    if (BATTINGTEAMCODE == nil || [BATTINGTEAMCODE isEqual:@""] || [BOWLINGTEAMCODE isEqual:@""] ||  BOWLINGTEAMCODE == nil) {
        
        
        BATTINGTEAMCODE = [db getBowlteamCode:MATCHCODE :COMPETITIONCODE :TEAMACODE :TEAMBCODE];
        ;
        
        
        BOWLINGTEAMCODE =  ([TEAMACODE isEqual: BATTINGTEAMCODE]) ? TEAMBCODE : TEAMACODE;
        
    }
    
    
    //Match details
    NSMutableArray *matchDetailsArray = [db getMatchType : COMPETITIONCODE :MATCHCODE];
    if(matchDetailsArray.count>0){
        FetchSEPageLoadRecord *fsePg =  [matchDetailsArray objectAtIndex:0];
        
        TEAMAWICKETKEEPER = fsePg.TEAMAWICKETKEEPER;
        TEAMBWICKETKEEPER= fsePg.TEAMBWICKETKEEPER;
        TEAMACAPTAIN= fsePg.TEAMACAPTAIN;
        TEAMBCAPTAIN= fsePg.TEAMBCAPTAIN;
        ISDEFAULTORLASTINSTANCE= fsePg.ISDEFAULTORLASTINSTANCE;
        TEAMACODE = fsePg.TEAMACODE;
        TEAMBCODE = fsePg.TEAMBCODE;
        
    }
    
    
    //batting team name
    NSMutableArray *battingTeamName = [db getBattingTeamName:BATTINGTEAMCODE];
    if(battingTeamName.count > 0)
    {
    FetchSEPageLoadRecord *battingTeam =[battingTeamName objectAtIndex:0];
    BATTEAMNAME = battingTeam.BATTEAMNAME;
    BATTEAMSHORTNAME = battingTeam.BATTEAMSHORTNAME;
    }
    
    //bowling team name
    NSMutableArray *bowlingTeamName = [db getBowlingTeamName:BOWLINGTEAMCODE];
    if(bowlingTeamName.count > 0)
    {
      FetchSEPageLoadRecord *bowlingTeam =  [bowlingTeamName objectAtIndex:0];
      BOWLTEAMNAME = bowlingTeam.BOWLTEAMNAME;
      BOWLTEAMSHORTNAME = bowlingTeam.BOWLTEAMSHORTNAME;
    }
    
    //total runs and total overs
    NSMutableArray *totalOvers = [db getTargetRunsOvers:COMPETITIONCODE :MATCHCODE];
    
    if(totalOvers.count >0)
    {
    FetchSEPageLoadRecord *totRun =(FetchSEPageLoadRecord*)[totalOvers objectAtIndex:0];
    
//    if (T_TARGETRUNS == nil) {
//        
//        T_TARGETRUNS = [NSNumber numberWithInt:0];
//        T_TARGETOVERS = [NSNumber numberWithInt:0];
//    }else{
//        
//        T_TARGETRUNS = totRun.T_TARGETRUNS;
//        T_TARGETOVERS = totRun.T_TARGETOVERS;
//         MATCHOVERS  = T_TARGETRUNS.intValue > 0 ? [T_TARGETOVERS stringValue] : MATCHOVERS;
//    }
        T_TARGETRUNS = totRun.T_TARGETRUNS;
        T_TARGETOVERS = totRun.T_TARGETOVERS;
        MATCHOVERS  = T_TARGETRUNS.intValue > 0 ? [T_TARGETOVERS stringValue] : MATCHOVERS;
   
    
    //Batting team player
    getBattingTeamPlayers =[db GETWICKETDETAILS:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE COMPETITIONCODE:COMPETITIONCODE INNINGSNO:INNINGSNO];
    
    //follow on
    NSString *followOnArray = [db getFollowOn:COMPETITIONCODE :MATCHCODE : INNINGSNO];
    NSUInteger followon = [followOnArray integerValue];
    
    //Previous Innings follow on
    NSString *previousFollowOnArray = [db getFollowOn:COMPETITIONCODE :MATCHCODE : [NSString stringWithFormat:@"%i", (INNINGSNO.intValue) - 1]];
    NSUInteger previousFollowOn = [previousFollowOnArray integerValue];
    if (inningsNo == 3 && followon == 1){
        
        TEMPBATTEAMPENALTY = 0;
        
    }else if (inningsNo == 4 && previousFollowOn == 1){
        
        //penalty
        NSString *penaltyInt = [db getPenalty:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
        NSInteger penalty = [penaltyInt integerValue];
        
        TEMPBATTEAMPENALTY = penalty;
        
    }else{
        //penalty score
        NSString *penaltyScore = [db getPenaltyScore:COMPETITIONCODE :MATCHCODE :INNINGSNO :BATTINGTEAMCODE];
        NSInteger penaltyS = [penaltyScore integerValue];
        
        TEMPBATTEAMPENALTY = penaltyS;
    }
    //grand total
    NSString *grandTotal = [db getGrandTotal:COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    NSInteger grandscore = [grandTotal integerValue];
    BATTEAMRUNS = grandscore;
    int tempBatteamRuns = (BATTEAMRUNS == nil ? 0: (int)BATTEAMRUNS);
    
    int tempBatTeamPenalty =  (TEMPBATTEAMPENALTY == nil ? 0 :(int)TEMPBATTEAMPENALTY);
    
    BATTEAMRUNS = tempBatteamRuns + tempBatTeamPenalty;
    
    
    if (inningsNo == 1) {
        NSString *batTeamPenalty = [db getBatTeamPenalty:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
        NSInteger batPenalty = [batTeamPenalty integerValue];
        BATTEAMPENALTY = batPenalty;
        BOWLTEAMPENALTY = 0;
        
    }else if (inningsNo == 2){
        //penalty details
        NSString *penaltyDetails = [db getPenaltyDetails:COMPETITIONCODE :MATCHCODE : INNINGSNO :BATTINGTEAMCODE];
        NSInteger penaltyDts = [penaltyDetails integerValue];
        BATTEAMPENALTY = penaltyDts;
        
        if ([self.MATCHTYPE isEqualToString: @"MSC023"] || [self.MATCHTYPE isEqualToString: @"MSC114"]) {
            //penalty details bowler
            NSString *b = [db getPenaltyDetailsBowling:COMPETITIONCODE :MATCHCODE : INNINGSNO :BOWLINGTEAMCODE];
            NSInteger penaltyBowl = [b integerValue];
            BOWLTEAMPENALTY = penaltyBowl;
            
        }else{
            //penalty innings
            NSString *penaltyInnings = [db getPenaltyInnings:COMPETITIONCODE :MATCHCODE : INNINGSNO :BOWLINGTEAMCODE];
            NSInteger penaltyInns = [penaltyInnings integerValue];
            BOWLTEAMPENALTY = penaltyInns;
        }
        
    }
    else if (inningsNo == 3) {
        
        if (followon == 1 ) {
            //penalty innings two
            NSString *penaltyInningsTwo = [db getPenaltyInningsTwo:COMPETITIONCODE :MATCHCODE : INNINGSNO :BATTINGTEAMCODE];
            NSInteger penaltyInnsTwo = [penaltyInningsTwo integerValue];
            BATTEAMPENALTY = penaltyInnsTwo;
            
        }else
        {
            //penalty innings three
            NSString *penaltyInnsThree = [db getPenaltyInningsThree:COMPETITIONCODE :MATCHCODE : INNINGSNO :BATTINGTEAMCODE];
            NSInteger penaltyInThre = [penaltyInnsThree integerValue];
            BATTEAMPENALTY = penaltyInThre;
        }
        //bowling penalty inns
        NSString *Bowlingpenalty = [db getBowlingPenaltyInnings:COMPETITIONCODE :MATCHCODE : INNINGSNO :BOWLINGTEAMCODE];
        NSInteger BowlingPnty = [Bowlingpenalty integerValue];
        BOWLTEAMPENALTY = BowlingPnty;
    }
    if (inningsNo == 4) {
        if (previousFollowOn == 1) {
            // batting penalty
            NSString *batPnty = [db getBattingPenalty:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE];
            NSInteger batpty = [batPnty integerValue];
            BATTEAMPENALTY = batpty;
        }else{
            //penalty innings three
            NSString *penaltyInnsThree = [db getPenaltyInningsThree:COMPETITIONCODE :MATCHCODE : INNINGSNO :BATTINGTEAMCODE];
            NSInteger penaltyInThre = [penaltyInnsThree integerValue];
            BATTEAMPENALTY = penaltyInThre;
        }
        // getBowlPnty
        NSString *bowlPntyInnings = [db getBowlPnty:COMPETITIONCODE :MATCHCODE:BOWLINGTEAMCODE: INNINGSNO];
        NSInteger bowlPtyInnings = [bowlPntyInnings integerValue];
        BOWLTEAMPENALTY = bowlPtyInnings;
    }
    
    //batting wkts
    NSString *battingwkts = [db getBattingWkt:COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
    NSInteger battingsWickets = [battingwkts integerValue];
    //team over
    NSString *teamOver = [db getTeamOver:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
    
    NSInteger teamOvers = [teamOver intValue];
    
    batTeamOver = [NSString stringWithFormat:@"%d",teamOvers];
    
    NSString *teamOverBall = [db getTeamOverBall:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE : INNINGSNO :batTeamOver];
    
    //BATTEAMOVERS
    NSInteger teamOvsBall = [teamOverBall integerValue];
    
    //team over extra ball
    NSString *teamExtraBall = [db getTeamExtraBall :COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE: INNINGSNO:batTeamOver];
    NSInteger teamExtBall = [teamOverBall integerValue];
    
    
    BATTEAMWICKETS = battingsWickets;
    BATTEAMOVERS = teamOvers;
    BATTEAMOVRBALLS = teamOvsBall;
    BATTEAMOVRWITHEXTRASBALLS = [teamExtraBall integerValue];
        
          NSString *batTeamOvrwithExtrasBalls = [NSString stringWithFormat:@"%d",BATTEAMOVRWITHEXTRASBALLS];
    
    if (BATTEAMOVRBALLS == 0) {
        //get previous ball
        NSString *prevball = [db getPrevOverBall:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE: INNINGSNO:batTeamOver];
        NSInteger preBall = [prevball integerValue];
        
        //get previous over extra ball
        NSString *prevExtball = [db getPrevOverExtBall:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE: INNINGSNO:batTeamOver];
        NSInteger preExtBall = [prevExtball integerValue];
        
        //get previous over ball count
        NSString *prevOverballCnt = [db getPrevOvrBallCnt:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE: INNINGSNO:batTeamOver:preOverWithExtraBalls];
        NSInteger preCntBall = [prevOverballCnt integerValue];
        
        PREVOVRBALLS = preBall;
        PREVOVRWITHEXTRASBALLS = preExtBall;
        PREVOVRBALLSCNT = preCntBall;
    }
    
    //get batting team over ball count
    NSString *batTeamBalCnt = [db getbatTeamOvrBallCnt:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE : INNINGSNO :batTeamOver :batTeamOvrwithExtrasBalls];
    NSInteger batBallCnt = [batTeamBalCnt integerValue];
    
    _BATTEAMOVRBALLSCNT = batBallCnt;
        NSString *batTeamOverBallsCnt = [NSString stringWithFormat:@"%d",_BATTEAMOVRBALLSCNT];
        
    
    NSString *getLastBallCode = [db getLastBallCode :COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE: INNINGSNO:batTeamOver:batTeamOvrwithExtrasBalls:batTeamOverBallsCnt];
        
    NSString *lastBallCode = getLastBallCode;
    
    if (lastBallCode.length>0) {
        
        LASTBALLCODE = lastBallCode;
        
    }else{
        if (BATTEAMOVRWITHEXTRASBALLS == 0) {
            //get last ball code minus
            NSString *getLastBallCodeMinus = [db getLastBallCodeMinus:COMPETITIONCODE :MATCHCODE:BATTINGTEAMCODE: INNINGSNO:batTeamOver:[NSString stringWithFormat:@"%d", PREVOVRWITHEXTRASBALLS]:[NSString stringWithFormat:@"%d", PREVOVRBALLSCNT]];
            //BATTEAMOVERS PREVOVRWITHEXTRASBALLS PREVOVRBALLSCNT;
            NSString *lastBallCodeMinus = getLastBallCodeMinus;
            LASTBALLCODE = lastBallCodeMinus;
            
        }
    }
    overNo = [db GETOVERNUMBERBYOVEREVENTS:COMPETITIONCODE :MATCHCODE : INNINGSNO :BATTINGTEAMCODE :batTeamOver];
    
    getOverStatus = [db GETOVERNUMBERBYOVERSTATUS0 : COMPETITIONCODE MATCHCODE :MATCHCODE INNINGSNO : INNINGSNO BATTINGTEAMCODE :BATTINGTEAMCODE BATTEAMOVERS :[NSString stringWithFormat:@"%d", teamOvers]];
    
    NSString *legalBall = [db getLegalBall :getLastBallCode];
    NSInteger legalBalls = [legalBall integerValue];
    if (overNo ) {
        if (getOverStatus) {
            ISOVERCOMPLETE = 0;
            
        }else{
            ISOVERCOMPLETE = (int)1;
            BATTEAMOVRBALLS = 0;
            
        }
        
    }else{
        ISOVERCOMPLETE = (int)-1;
    }
    
    if (ISOVERCOMPLETE == 1) {
        
        ISPREVIOUSLEGALBALL = 1;
    }else{
        ISPREVIOUSLEGALBALL = legalBalls;
        
    }
    int totalBallData = (((int)ISOVERCOMPLETE == 1 ? (int)BATTEAMOVERS + 1 : (int)BATTEAMOVERS) * 6) + ((int)BATTEAMOVRBALLS > 6 ? 6: (int)BATTEAMOVRBALLS);
    
    TOTALBALLS = [NSNumber numberWithInt:totalBallData];
    
    
    float batteamRunRateData = (TOTALBALLS.intValue == 0) ? 0 :((float)((int)BATTEAMRUNS)/(float)TOTALBALLS.intValue)*6;
        batteamRunRateData =  round(100 * batteamRunRateData) / 100;

    BATTEAMRUNRATE  = [NSString  stringWithFormat:@"%f",batteamRunRateData];
    
    BATTEAMOVERS = teamOvers;
    
    NSString *BATTEAMOVERSDATA = [NSString stringWithFormat:@"%d",BATTEAMOVERS];
    
    
    
    NSString *penaltyBowlerCode = [db getPENULTIMATEBOWLERCODE:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO: INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE OVERNO:BATTEAMOVERSDATA ISOVERCOMPLETE:[NSString stringWithFormat:@"%d", ISOVERCOMPLETE] BATTEAMOVERS:batTeamOver];//OVERS
    
        
    getBowlingTeamPlayers = [db GETBOWLINGTEAMPLAYERS:penaltyBowlerCode MATCHCODE:MATCHCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE COMPETITIONCODE:COMPETITIONCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:[NSString stringWithFormat:@"%d", ISOVERCOMPLETE] BATTEAMOVERS:batTeamOver];
        
       
    
       
        
        
    
    //=============================================================================
    //Sathishbb
    
    
    TOTALBATTEAMRUNS = [[NSNumber alloc] init];
    TOTALBATTEAMRUNS = [NSNumber numberWithInt:0];
    
    TOTALBOWLTEAMRUNS = [[NSNumber alloc] init];
    TOTALBOWLTEAMRUNS =[NSNumber numberWithInt:0];
    
        REQRUNRATE = @"0";
//    REQRUNRATE = [[NSNumber alloc] init];
//    REQRUNRATE = [NSNumber numberWithInt:0];
    
    RUNSREQUIRED = [[NSNumber alloc] init];
    RUNSREQUIRED = [NSNumber numberWithInt:0];
    
    
    REMBALLS = [[NSNumber alloc] init];
    REMBALLS = [NSNumber numberWithInt:0];
    
    T_ATWOROTW = [[NSString alloc] init];
    T_BOWLINGEND = [[NSString alloc] init];
    
    TARGETRUNS = [[NSNumber alloc] init];
    TARGETRUNS = [NSNumber numberWithInt:0];
    
    COMPLETEDINNINGS = [db getComletedInnings:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    if(COMPLETEDINNINGS.intValue > 0){
        TOTALBATTEAMRUNS = [db getTotalBatTeamRuns:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE ];
        
        TOTALBOWLTEAMRUNS = [db getTOTALBOWLTEAMRUNS:COMPETITIONCODE MATCHCODE:MATCHCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE];
        
        NSNumber *TEMPBOWLPENALTY;
        TEMPBOWLPENALTY = [[NSNumber alloc] init];
        TEMPBOWLPENALTY = [NSNumber numberWithInt:0];
        
        NSNumber *TEMPBATPENALTY;
        TEMPBATPENALTY = [[NSNumber alloc] init];
        TEMPBATPENALTY = [NSNumber numberWithInt:0];
        
        
        if(([INNINGSNO isEqual: @"4" ]&&
            ([MATCHTYPE isEqual: @"MSC023"] || [MATCHTYPE isEqual: @"MSC114"]))
           ||
           ([INNINGSNO isEqual: @"2"] && (![MATCHTYPE isEqual: @"MSC023"] || ![MATCHTYPE isEqual: @"MSC114"]))){
            
            
            
            TEMPBOWLPENALTY = [NSNumber numberWithInt: [db getTEMPBOWLPENALTY:COMPETITIONCODE MATCHCODE:MATCHCODE BOWLINGTEAMCODE:BOWLINGTEAMCODE INNINGSNO:INNINGSNO].intValue];
            TEMPBATPENALTY = [NSNumber numberWithInt: [db getTEMPBATPENALTY:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO].intValue];
            
            
        }
        
        
        
        
        
        TARGETRUNS =[ NSNumber numberWithInt:
                     (TOTALBOWLTEAMRUNS.intValue + TEMPBOWLPENALTY.intValue)
                     -[db getTARGETRUNS:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO].intValue
                     + TEMPBATPENALTY.intValue];
        
        if (TARGETRUNS.intValue > 0)
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
        }
//        else{
//            TOTALBOWLTEAMRUNS = TOTALBOWLTEAMRUNS;
//        }
        
        TARGETRUNS = T_TARGETRUNS.intValue > 0 ? T_TARGETRUNS : TARGETRUNS;
        
        TOTALBOWLTEAMRUNS =  T_TARGETRUNS.intValue > 0 ? T_TARGETRUNS : TOTALBOWLTEAMRUNS;
        
        TOTALBOWLTEAMRUNS = (TOTALBOWLTEAMRUNS.intValue == 0 ?  [NSNumber numberWithInt:1] : TOTALBOWLTEAMRUNS);
        
        int runReq = TOTALBOWLTEAMRUNS.intValue - TOTALBATTEAMRUNS.intValue;
        
        RUNSREQUIRED = [NSNumber numberWithInt:runReq];
        
        int  remBallsData = (MATCHOVERS.intValue * 6) - (((int)ISOVERCOMPLETE == 1 ? (int)BATTEAMOVERS + 1 : (int)BATTEAMOVERS)  * 6 + (int)BATTEAMOVRBALLS);
        
        
        REMBALLS = [NSNumber numberWithInt:remBallsData];
        
        float reqRunRateData = REMBALLS.intValue == 0 ? 0 :
        (RUNSREQUIRED.floatValue / REMBALLS.floatValue) * (REMBALLS.intValue < 6 ? 1 : 6);
        
        
        
        REQRUNRATE = [NSString  stringWithFormat:@"%f",reqRunRateData];
    }
    
    NSString *lastvalueData = LASTBALLCODE;
    
    //TO GET LAST BALL ATWOROTW AND BOWLING END DETAILS.
    NSMutableArray *atwRtw = [db getT_BOWLINGEND : COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:[NSString stringWithFormat:@"%d", ISOVERCOMPLETE] LASTBALLCODE:lastvalueData:[NSString stringWithFormat:@"%d",BATTEAMOVERS]];
    if([atwRtw count]>0){
        self.S_ATWOROTW = [atwRtw objectAtIndex:0];
        T_BOWLINGEND =[atwRtw objectAtIndex:1];
        
        //ISOVERCOMPLETE =[atwRtw objectAtIndex:1];
        
    }
    //FREE HIT
    ISFREEHIT =[NSNumber numberWithInt:0];
    
    if(ISPREVIOUSLEGALBALL == 1){
        ISFREEHIT =[NSNumber numberWithInt:0];
    }else{
        
        NSString *BATTEAMOVERSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVERS];
        NSString *BATTEAMOVRWITHEXTRASBALLSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVRWITHEXTRASBALLS];
        
        
        NSNumber *noBall = [db getNOBALL:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO BATTEAMOVERS:BATTEAMOVERSDATA  BATTEAMOVRWITHEXTRASBALLS:BATTEAMOVRWITHEXTRASBALLSDATA];
        
        if(noBall.intValue > 0){
            ISFREEHIT = [NSNumber numberWithInt:1];
        }
        
    }
    
    NSString *STRIKERCODE;
    NSString *NONSTRIKERCODE;
    NSNumber *STRIKERBALLS = [NSNumber numberWithInt:0];
    NSNumber *NONSTRIKERBALLS = [NSNumber numberWithInt:0];
    NSString *T_STRIKERCODE;
    NSString *T_NONSTRIKERCODE;
    NSString *T_TOTALRUNS;
    NSString *T_OVERSTATUS;
    NSString *T_WICKETPLAYER;
    NSString *T_WICKETTYPE;
    NSString *BOWLERCODE;
    
    NSString *ISOVERCOMPLETEDATA = [NSString stringWithFormat: @"%d", (long)ISOVERCOMPLETE];
    
    NSMutableArray *battsmanDetails = [db getBATSMANDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:ISOVERCOMPLETEDATA T_BOWLINGEND:T_BOWLINGEND];
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
    
    if(ISOVERCOMPLETE == 1){
        BATTEAMOVERS = BATTEAMOVERS+1;
    }
    
//    [db getScoreingDetails : BATTEAMSHORTNAME BOWLTEAMSHORTNAME:BOWLTEAMSHORTNAME BATTEAMNAME:BATTEAMNAME BOWLTEAMNAME:BOWLTEAMNAME BATTEAMLOGO:BATTEAMLOGO BOWLTEAMLOGO:BOWLTEAMLOGO BATTEAMRUNS:BATTEAMRUNSDATA BATTEAMWICKETS:BATTEAMWICKETSDATA ISOVERCOMPLETE:ISOVERCOMPLETEDATA BATTEAMOVERS:BATTEAMOVERSDATA BATTEAMOVRBALLS:BATTEAMOVRBALLSDATA BATTEAMRUNRATE:BATTEAMRUNRATE  TARGETRUNS:TARGETRUNS REQRUNRATE:REQRUNRATE RUNSREQUIRED:RUNSREQUIRED REMBALLS:REMBALLS ISPREVIOUSLEGALBALL:ISPREVIOUSLEGALBALLDATA T_ATWOROTW:T_ATWOROTW T_BOWLINGEND:T_BOWLINGEND ISFREEHIT:ISFREEHIT];
//        
        
    
    NSNumber *balls = [db getBallEventCount:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
    if(balls > 0)
    {
        
        NSString *LASTBALLCODEDATA = LASTBALLCODE;
        
        NSMutableArray *totalRunsArray = [db getTotalRuns:LASTBALLCODEDATA];
        
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
        
        NSMutableArray *wicketPlayersArray =  [db getWICKETPLAYER :COMPETITIONCODE MATCHCODE :MATCHCODE INNINGSNO :INNINGSNO];
        
        
        STRIKERCODE =  [wicketPlayersArray containsObject:STRIKERCODE] ?@"":STRIKERCODE;
        NONSTRIKERCODE = [wicketPlayersArray containsObject:NONSTRIKERCODE]?@"":NONSTRIKERCODE;
//        STRIKERCODE =  [STRIKERCODE isEqual:WICKETPLAYER] ?@"":STRIKERCODE;
//        NONSTRIKERCODE = [NONSTRIKERCODE isEqual:WICKETPLAYER] ?@"":NONSTRIKERCODE;
        
    }
    
    STRIKERBALLS = [db getSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:STRIKERCODE];
    
    //Striker details
    NSMutableArray *strickerDetaailsArray;
    if([db hasSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:STRIKERCODE]){
        strickerDetaailsArray = [db getStrickerCode:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO: INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:STRIKERCODE STRIKERBALLS:STRIKERBALLS];
    }else{
        strickerDetaailsArray =  [db getStrickerDetails:STRIKERCODE];
    }
    
    if(strickerDetaailsArray.count>0){
        
        strickerPlayerCode = [strickerDetaailsArray objectAtIndex:0];
        strickerPlayerName = [strickerDetaailsArray objectAtIndex:1];
        strickerTotalRuns = [strickerDetaailsArray objectAtIndex:2];
        strickerFours = [strickerDetaailsArray objectAtIndex:3];
        strickerSixes = [strickerDetaailsArray objectAtIndex:4];
        strickerTotalBalls = [strickerDetaailsArray objectAtIndex:5];
        strickerStrickRate = [strickerDetaailsArray objectAtIndex:6];
        strickerBattingStyle = [strickerDetaailsArray objectAtIndex:7];
        
    }
    
    NONSTRIKERBALLS = [db getBALLCODECOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE NONSTRIKERCODE:NONSTRIKERCODE];
    
    
    //NONSTRIKER DETAILS
    NSMutableArray *nonstrickerDetaailsArray;
    if([db hasSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:NONSTRIKERCODE]){
        nonstrickerDetaailsArray = [db getStrickerCode:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO: INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:NONSTRIKERCODE STRIKERBALLS:NONSTRIKERBALLS];
    }else{
        nonstrickerDetaailsArray =  [db getStrickerDetails:NONSTRIKERCODE];
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
    
    NSNumber *WICKETS = [NSNumber numberWithInt:0];
    
    WICKETS = [db getWicket:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    NSNumber *LASTBOWLEROVERNO;
    NSNumber *LASTBOWLEROVERBALLNO;
    NSNumber *LASTBOWLEROVERBALLNOWITHEXTRAS;
    NSNumber *LASTBOWLEROVERBALLCOUNT;
    
    
    LASTBOWLEROVERNO = [db getLASTBOWLEROVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    NSNumber *LASTBOWLEROVERSTATUS = [db getLASTBOWLEROVERSTATUS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO];
    
    if(LASTBOWLEROVERNO != nil){
        
        LASTBOWLEROVERBALLNO = [db getLASTBOWLEROVERBALLNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE];
        
        LASTBOWLEROVERBALLNOWITHEXTRAS = [db getLASTBOWLEROVERBALLNOWITHEXTRAS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE];
        
        LASTBOWLEROVERBALLCOUNT = [db getLASTBOWLEROVERBALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:LASTBOWLEROVERBALLNOWITHEXTRAS];
        
    }else{
        LASTBOWLEROVERBALLNO = [NSNumber numberWithInt:0];
        LASTBOWLEROVERBALLNOWITHEXTRAS = [NSNumber numberWithInt:0];
        LASTBOWLEROVERBALLCOUNT = [NSNumber numberWithInt:0];
    }
    
        NSString   *S_ATWOROTW_TEMP = [db getS_ATWOROTW:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:LASTBOWLEROVERBALLNOWITHEXTRAS LASTBOWLEROVERBALLCOUNT:LASTBOWLEROVERBALLCOUNT];
    
        if(![S_ATWOROTW_TEMP isEqual:@""]){
            self.S_ATWOROTW = S_ATWOROTW_TEMP;
        }
    //NSString *BATTEAMOVERSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVERS];
    
    
    NSNumber *TOTALBALLSBOWL;
    NSNumber *MAIDENS;
    NSNumber *BOWLERRUNS;
    NSNumber *ISPARTIALOVER = [db getISPARTIALOVER:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE BATTEAMOVERS:BATTEAMOVERSDATA];
    
    if(ISPARTIALOVER.intValue == 0){
        ISPARTIALOVER = [db getISPARTIALOVERWHEN0:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE BATTEAMOVERS:BATTEAMOVERSDATA];
    }
    NSMutableArray *getBowlerBasedDetails = [db getTOTALBALLSBOWL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    if([getBowlerBasedDetails count]>0){
        TOTALBALLSBOWL = [getBowlerBasedDetails objectAtIndex:0];
        MAIDENS = [getBowlerBasedDetails objectAtIndex:1];
        BOWLERRUNS = [getBowlerBasedDetails objectAtIndex:2];
        
    }
    
    
    LASTBOWLEROVERBALLNO = LASTBOWLEROVERSTATUS.intValue == 1 ? [NSNumber numberWithInt:0] : LASTBOWLEROVERBALLNO;
    
    
    NSNumber *BOWLERSPELL  = [NSNumber numberWithInt: 0];
    NSNumber *V_SPELLNO = [NSNumber numberWithInt: 0];
    
    BOWLERSPELL = [db getBOWLERSPELL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE BATTEAMOVERS:BATTEAMOVERSDATA V_SPELLNO:V_SPELLNO];
    
     int BOWLERSPELLDATA = (int)BATTEAMOVERS - (int)LASTBOWLEROVERNO > 2 && (int)LASTBOWLEROVERSTATUS == 1 ? (int)BOWLERSPELL + 1 : (int)BOWLERSPELL;
    
    BOWLERSPELL = [NSNumber numberWithInt:BOWLERSPELLDATA];
    
    
    
    
    //BOWLER DETAILS
    NSMutableArray *curentBowlerDetaailsArray;
    
    if([db GETBOLWERDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE]){
        
        curentBowlerDetaailsArray =[db GETBOLWLINGDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BOWLERCODE:BOWLERCODE BOWLERSPELL:BOWLERSPELL BOWLERRUNS:BOWLERRUNS S_ATWOROTW:self.S_ATWOROTW TOTALBALLSBOWL:TOTALBALLSBOWL WICKETS:WICKETS MAIDENS:MAIDENS ISPARTIALOVER:ISPARTIALOVER LASTBOWLEROVERBALLNO:LASTBOWLEROVERBALLNO];
        
        
    }else{
        
        curentBowlerDetaailsArray =[db GETPLAYERDETAIL:BOWLERCODE];
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
    
    
    NSString *LASTBALLCODEDATA = LASTBALLCODE;
    
    
    if([db GETBALLDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO LASTBALLCODE:LASTBALLCODEDATA TEAMCODE:BATTINGTEAMCODE BALLCODE:LASTBALLCODEDATA]){
        
        NSString *ISOVERCOMPLETEDATA = [NSString stringWithFormat: @"%d", (long)ISOVERCOMPLETE];
        
        
        NSMutableArray *umpires = [db GETUMPIREBYBALLEVENT:COMPETITIONCODE MATCHCODE:MATCHCODE BATTINGTEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO UMPIRE1CODE:UMPIRE1CODE ISOVERCOMPLETE:ISOVERCOMPLETEDATA UMPIRE2CODE:UMPIRE2CODE LASTBALLCODE:LASTBALLCODEDATA];
        if([umpires count]>1){
            UMPIRE1CODE = [umpires objectAtIndex:0];
            UMPIRE2CODE = [umpires objectAtIndex:1];
        }
    }else{
        
        NSMutableArray *umpires = [db GETUMPIREBYMATCHREGISTRATION:COMPETITIONCODE MATCHCODE:MATCHCODE UMPIRE1CODE:UMPIRE1CODE UMPIRE2CODE:UMPIRE2CODE];
        if([umpires count]>1){
            UMPIRE1CODE = [umpires objectAtIndex:0];
            UMPIRE2CODE = [umpires objectAtIndex:1];
        }
        int inningsNoData =[INNINGSNO integerValue]  <= 1? 1 : [INNINGSNO integerValue] - 1;
        
        NSNumber *U_INNINGSNO  =[NSNumber numberWithInt:inningsNoData];
        
        NSNumber *U_OVERNO  =[db getU_OVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO];
        
        
        
        NSNumber *U_BALLNO =[db getU_BALLNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:U_OVERNO];
        
        NSNumber *U_BALLCOUNT =[db getU_BALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:U_OVERNO BALLNO:U_BALLNO];
        
        
        if([db GETUMPIREBYBALLEVENT:COMPETITIONCODE MATCHCODE:MATCHCODE BALLNO:U_BALLNO INNINGSNO:INNINGSNO  BALLCOUNT:U_BALLCOUNT  OVERNO:U_OVERNO]){
            NSMutableArray *umpiresByMatchReg  = [db GETUMBIREBYBALLEVENT:COMPETITIONCODE MATCHCODE:MATCHCODE UMPIRE1CODE:UMPIRE1CODE UMPIRE2CODE:UMPIRE2CODE INNINGSNO:INNINGSNO OVERNO:U_OVERNO BALLNO:U_BALLNO BALLCOUNT:U_BALLCOUNT];
            if([umpiresByMatchReg count]>0){
                UMPIRE1CODE=[umpiresByMatchReg objectAtIndex:0];
                UMPIRE2CODE=[umpiresByMatchReg objectAtIndex:1];
            }
        }
        
        
    }
    
    
    //MATCH UMPIRE DETAILS
    
    NSMutableArray *umpiresByMatchReg  = [db GETMATCHUMPIREDETAILS:UMPIRE1CODE UMPIRE2CODE:UMPIRE2CODE];
    
    if ([umpiresByMatchReg count]>0) {
        
        UMPIRE1CODE = [umpiresByMatchReg objectAtIndex:0];
        UMPIRE2CODE = [umpiresByMatchReg objectAtIndex:1];
        UMPIRE1NAME = [umpiresByMatchReg objectAtIndex:2];
        UMPIRE2NAME = [umpiresByMatchReg objectAtIndex:3];
        
    }
    //
    NSNumber *ISINNINGSLASTOVER;
    
    ISINNINGSLASTOVER = [db getISINNINGSLASTOVER:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:BATTEAMOVERSDATA ISINNINGSLASTOVER:ISINNINGSLASTOVER TEAMCODE:BATTINGTEAMCODE];
    
    //BALL GRID DETAILS
    
    
    BallGridDetails = [db GetBallGridDetails:COMPETITIONCODE MATCHCODE:MATCHCODE ISINNINGSLASTOVER:ISINNINGSLASTOVER TEAMCODE:BATTINGTEAMCODE INNINGSNO:INNINGSNO ISOVERCOMPLETE:ISOVERCOMPLETEDATA BATTEAMOVERS:BATTEAMOVERSDATA];
    
    
    //TEAM DETAILS
    [db getTeamDetails:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    
    //UMPIRE DETAILS
    [db getUmpireDetails];
    
    // EXEC SP_FETCHSEFIELDINGEVENTSPAGELOAD @COMPETITIONCODE,@MATCHCODE,@BOWLINGTEAMCODE;
    
    [db GETFIELDINGEVENTSDETAILS:MATCHCODE TEAMCODE:BOWLINGTEAMCODE COMPETITIONCODE:COMPETITIONCODE];
    
    [db GETBOWLINGTEAMPLAYERS:MATCHCODE TEAMCODE:BOWLINGTEAMCODE];
    
    [db GETFIELDINGFACTORSDETAILS];
    
    
    //ALL INNINGS SCORE DETAILS
    NSMutableArray *inningsArray = [[NSMutableArray alloc]init];
    inningsArray = [db FETCHSEALLINNINGSSCOREDETAILS :COMPETITIONCODE MATCHCODE :MATCHCODE];
    
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
    [db getSPINSPEEDBALLS];
    
    //FASTSPEEDBALLS DETAILS
    [db getFASTSPEEDBALLS];
    
    //UNCOMFORT DETAILS
    [db getUNCOMFORT];
    
    //LAST BALL STATUS IN MAX INNINGS BECAUSE BELOW DATA'S USED TO
    NSNumber *MAXINNINGS =[db getMAXINNINGS:COMPETITIONCODE MATCHCODE:MATCHCODE ];
    NSNumber *MAXOVER =[db getMAXOVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE MAXINNINGS:MAXINNINGS
                        ];
    NSNumber *MAXBALL =[db getMAXBALL:COMPETITIONCODE MATCHCODE:MATCHCODE MAXINNINGS:MAXINNINGS MAXOVER:MAXOVER ];
    NSNumber *MAXBALLCOUNT =[db getBALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE MAXINNINGS:MAXINNINGS MAXOVER:MAXOVER MAXBALL:MAXBALL];
    NSString *MATCHRESULTSTATUS = [db getMATCHRESULTSTATUS:COMPETITIONCODE MATCHCODE:MATCHCODE];
    
    
}
}
    @end

