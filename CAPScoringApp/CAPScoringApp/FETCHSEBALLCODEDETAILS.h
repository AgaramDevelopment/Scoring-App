//
//  FETCHSEBALLCODEDETAILS.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FETCHSEBALLCODEDETAILS : NSObject
-(void) FetchSEBallCodeDetails:(NSString *)COMPETITIONCODE :(NSString *)MATCHCODE :(NSString*)BALLCODE;

@property (strong,nonatomic) NSMutableArray *GetBallDetailsForBallEventsArray;

@property(nonatomic,strong)NSString* TEAMACODE;
@property(nonatomic,strong)NSString* TEAMBCODE;
@property(nonatomic,strong)NSString* BATTINGTEAMCODE;
@property(nonatomic,strong)NSString* BOWLINGTEAMCODE;
@property(nonatomic,strong)NSNumber* INNINGSNO;
@property(nonatomic,strong)NSNumber* INNINGSSTATUS;
@property(nonatomic,strong)NSNumber* SESSIONNO;
@property(nonatomic,strong)NSNumber* DAYNO;
@property(nonatomic,strong)NSString* BATTEAMSHORTNAME;
@property(nonatomic,strong)NSString* BOWLTEAMSHORTNAME;
@property(nonatomic,strong)NSString* BATTEAMNAME;
@property(nonatomic,strong)NSString* BOWLTEAMNAME;
@property(nonatomic,strong)NSNumber* MATCHOVERS;
@property(nonatomic,strong)NSString* BATTEAMLOGO;
@property(nonatomic,strong)NSString* BOWLTEAMLOGO;
@property(nonatomic,strong)NSString* MATCHTYPE;
@property(nonatomic,strong)NSString* ISOTHERSMATCHTYPE;


@property(nonatomic,strong)NSNumber* BATTEAMRUNS;;
@property(nonatomic,strong)NSNumber* BATTEAMWICKETS;
@property(nonatomic,strong)NSNumber* BATTEAMOVERS;
@property(nonatomic,strong)NSNumber* BATTEAMOVRBALLS;
@property(nonatomic,strong)NSNumber* BATTEAMRUNRATE;
@property(nonatomic,strong)NSNumber* ISOVERCOMPLETE;
@property(nonatomic,strong)NSNumber* ISPREVIOUSLEGALBALL;
@property(nonatomic,strong)NSNumber* BATTEAMOVRBALLSCNT;
@property(nonatomic,strong)NSString* BOWLERCODE;
@property(nonatomic,strong)NSNumber* TOTALBATTEAMRUNS;
@property(nonatomic,strong)NSNumber* TOTALBOWLTEAMRUNS;
@property(nonatomic,strong)NSNumber* REQRUNRATE;
@property(nonatomic,strong)NSNumber* RUNSREQUIRED;
@property(nonatomic,strong)NSNumber* REMBALLS;
@property(nonatomic,strong)NSString* T_ATWOROTW;
@property(nonatomic,strong)NSString* T_BOWLINGEND;
@property(nonatomic,strong)NSString* STRIKERCODE;
@property(nonatomic,strong)NSString* NONSTRIKERCODE;
@property(nonatomic,strong)NSNumber* STRIKERBALLS;
@property(nonatomic,strong)NSNumber* NONSTRIKERBALLS;
@property(nonatomic,strong)NSNumber* T_TOTALRUNS;
@property(nonatomic,strong)NSNumber* T_OVERSTATUS	;
@property(nonatomic,strong)NSNumber* T_WICKETPLAYER;
@property(nonatomic,strong)NSNumber* WICKETS;
@property(nonatomic,strong)NSNumber* ISFREEHIT;


@property(nonatomic,strong) NSMutableArray *currentStrickerDetail;
@property(strong,nonatomic) NSMutableArray *currentNonStrickerDetail;
@property(strong,nonatomic) NSMutableArray *currentbowlerDetail;


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
@property(strong,nonatomic)NSNumber* MAIDENS;

@property(strong,nonatomic)NSMutableArray *GetBattingTeamPlayersArray;
@property(strong,nonatomic)NSMutableArray *GetBowlingTeamPlayersArray;

@property(strong,nonatomic)NSMutableArray *GetMatchUmpireDetailsArray;

@property(strong,nonatomic)NSMutableArray *GetWicketEventDetailsArray;

@property(strong,nonatomic)NSMutableArray *GetAppealDetailsForAppealEventsArray;

@property(strong,nonatomic)NSMutableArray *GetPenaltyDetailsForPenaltyEventsArray;

@property(strong,nonatomic)NSMutableArray *getFieldingFactorArray;

@end
