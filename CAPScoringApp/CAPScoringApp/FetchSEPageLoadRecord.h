//
//  FetchSEPageLoadRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FetchSEPageLoadRecord : NSObject

@property(strong,nonatomic)NSString *S_ATWOROTW;
@property(strong,nonatomic)NSString *INNINGSPROGRESS;
@property(strong,nonatomic)NSString *TEAMACODE;
@property(strong,nonatomic)NSString *TEAMBCODE;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *INNINGSSTATUS;
@property(strong,nonatomic)NSString *SESSIONNO;
@property(strong,nonatomic)NSString *DAYNO;
@property(strong,nonatomic)NSString *BATTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BOWLTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BATTEAMNAME;
@property(strong,nonatomic)NSString *BOWLTEAMNAME;
@property(strong,nonatomic)NSString *MATCHOVERS;
@property(strong,nonatomic)NSString *BATTEAMLOGO;
@property(strong,nonatomic)NSString *BOWLTEAMLOGO;
@property(strong,nonatomic)NSString *MATCHTYPE;
@property(strong,nonatomic)NSString *ISOTHERSMATCHTYPE;
@property(strong,nonatomic)NSString *REQRUNRATE;
@property(strong,nonatomic)NSNumber *TARGETRUNS;
@property(strong,nonatomic)NSNumber *REMBALLS;




@property(strong,nonatomic)NSNumber *T_TARGETRUNS;
@property(strong,nonatomic)NSNumber *T_TARGETOVERS;



@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *TEAMAWICKETKEEPER;
@property(strong,nonatomic)NSString *TEAMBWICKETKEEPER;
@property(strong,nonatomic)NSString *TEAMACAPTAIN;
@property(strong,nonatomic)NSString *TEAMBCAPTAIN;
@property(strong,nonatomic)NSString *ISDEFAULTORLASTINSTANCE;
@property(nonatomic,strong)NSMutableArray *teamAndoverArray;






@property(strong,nonatomic)NSString *BOWLTYPECODE;
@property(strong,nonatomic)NSString *BOWLTYPE;
@property(strong,nonatomic)NSString *METASUBCODEDESCRIPTION;
@property(strong,nonatomic)NSString *METASUBCODE;


@property(strong,nonatomic)NSString *SHOTCODE;
@property(strong,nonatomic)NSString *SHOTNAME;
@property(strong,nonatomic)NSString *SHOTTYPE;


//@property(nonatomic,strong)NSString *teamAcode;
//@property(nonatomic,strong)NSString *teamBcode;


@property(strong,nonatomic)NSString *TEAMCODE;

@property(nonatomic,assign)NSInteger BATTEAMRUNS;
@property(nonatomic,assign) NSInteger ISOVERCOMPLETE;
@property(nonatomic,strong) NSNumber *ISFREEHIT;
@property(nonatomic,assign)NSNumber *RUNSREQUIRED;




-(void) fetchSEPageLoadDetails :(NSString*) COMPETITIONCODE :(NSString *)MATCHCODE;


@property (nonatomic,strong) NSString * ExtrasRuns;


//Stricker Details
@property(strong,nonatomic)NSString *strickerPlayerCode ;
@property(strong,nonatomic)NSString *strickerPlayerName;
@property(strong,nonatomic)NSString *strickerTotalRuns;
@property(strong,nonatomic)NSString *strickerFours;
@property(strong,nonatomic)NSString *strickerSixes ;
@property(strong,nonatomic)NSString *strickerTotalBalls;
@property(strong,nonatomic)NSString *strickerStrickRate ;
@property(strong,nonatomic)NSString *strickerBattingStyle;



//Non Stricker Details
@property(strong,nonatomic)NSString *nonstrickerPlayerCode ;
@property(strong,nonatomic)NSString *nonstrickerPlayerName;
@property(strong,nonatomic)NSString *nonstrickerTotalRuns;
@property(strong,nonatomic)NSString *nonstrickerFours;
@property(strong,nonatomic)NSString *nonstrickerSixes ;
@property(strong,nonatomic)NSString *nonstrickerTotalBalls;
@property(strong,nonatomic)NSString *nonstrickerStrickRate ;
@property(strong,nonatomic)NSString *nonstrickerBattingStyle;



//Stricker Details
@property(strong,nonatomic)NSString *currentBowlerPlayerCode ;
@property(strong,nonatomic)NSString *currentBowlerPlayerName;
@property(strong,nonatomic)NSString *currentBowlerOver;
@property(strong,nonatomic)NSString *currentBowlerMaidan;
@property(strong,nonatomic)NSString *currentBowlerRuns;
@property(strong,nonatomic)NSString *currentBowlerWicket;
@property(strong,nonatomic)NSString *currentBowlerEcoRate;


//Non Stricker Details
@property(strong,nonatomic)NSString *lastBowlerPlayerCode ;
@property(strong,nonatomic)NSString *lastBowlerPlayerName;
@property(strong,nonatomic)NSString *lastBowlerOver;
@property(strong,nonatomic)NSString *lastBowlerMaidan;
@property(strong,nonatomic)NSString *lastBowlerRuns;
@property(strong,nonatomic)NSString *lastBowlerWicket;
@property(strong,nonatomic)NSString *lastBowlerEcoRate;


@property(nonatomic,assign)NSInteger BATTEAMWICKETS;
@property(nonatomic,assign)NSInteger BATTEAMOVERS;
@property(nonatomic,assign)NSInteger BATTEAMOVRBALLS;
@property(nonatomic,assign)NSString *BATTEAMRUNRATE;

//Bowlers List
@property(retain,nonatomic) NSMutableArray* getBowlingTeamPlayers;
@property(retain,nonatomic) NSMutableArray* getBattingTeamPlayers;





//Innings record for team A and team B

@property(strong,nonatomic)NSString *MATCHDATE;
@property(strong,nonatomic)NSString *FIRSTINNINGSTOTAL;
@property(strong,nonatomic)NSString *SECONDINNINGSTOTAL;
@property(strong,nonatomic)NSString *THIRDINNINGSTOTAL;
@property(strong,nonatomic)NSString *FOURTHINNINGSTOTAL;
@property(strong,nonatomic)NSString *FIRSTINNINGSWICKET;
@property(strong,nonatomic)NSString *SECONDINNINGSWICKET;
@property(strong,nonatomic)NSString *THIRDINNINGSWICKET;
@property(strong,nonatomic)NSString *FOURTHINNINGSWICKET;
@property(strong,nonatomic)NSString *FIRSTINNINGSSCORE;
@property(strong,nonatomic)NSString *SECONDINNINGSSCORE;
@property(strong,nonatomic)NSString *THIRDINNINGSSCORE;
@property(strong,nonatomic)NSString *FOURTHINNINGSSCORE;
@property(strong,nonatomic)NSString *FIRSTINNINGSOVERS;
@property(strong,nonatomic)NSString *SECONDINNINGSOVERS;
@property(strong,nonatomic)NSString *THIRDINNINGSOVERS;
@property(strong,nonatomic)NSString *FOURTHINNINGSOVERS;
@property(strong,nonatomic)NSString *FIRSTINNINGSSHORTNAME;
@property(strong,nonatomic)NSString *SECONDINNINGSSHORTNAME;
@property(strong,nonatomic)NSString *THIRDINNINGSSHORTNAME;
@property(strong,nonatomic)NSString *FOURTHINNINGSSHORTNAME;
@property(strong,nonatomic)NSString *AA;
@property(strong,nonatomic)NSString *BB;
@property(strong,nonatomic)NSString *AAWIC;
@property(strong,nonatomic)NSString *BBWIC;


@property(nonatomic,assign)NSInteger BATTEAMOVRBALLSCNT;

//Umpire Details
@property(strong,nonatomic)NSString *UMPIRE1CODE;
@property(strong,nonatomic)NSString *UMPIRE2CODE;
@property(strong,nonatomic)NSString *UMPIRE1NAME;
@property(strong,nonatomic)NSString *UMPIRE2NAME;

@property(strong,nonatomic)NSMutableArray *BallGridDetails;

@end
