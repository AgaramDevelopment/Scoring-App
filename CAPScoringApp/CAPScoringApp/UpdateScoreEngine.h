//
//  UpdateScoreEngine.h
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateScoreEngine : NSObject




@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *TEAMCODE;
@property(nonatomic,assign)NSNumber *INNINGSNO;

@property(nonatomic,assign)NSNumber *OVERNO;
@property(nonatomic,assign)NSNumber *BALLNO;
@property(nonatomic,assign)NSNumber *BALLCOUNT;
@property(nonatomic,assign)NSNumber *SESSIONNO;

@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *NONSTRIKERCODE;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *WICKETKEEPERCODE;
@property(strong,nonatomic)NSString *UMPIRE1CODE;
@property(strong,nonatomic)NSString *UMPIRE2CODE;
@property(strong,nonatomic)NSString *ATWOROTW;
@property(strong,nonatomic)NSString *BOWLINGEND;
@property(strong,nonatomic)NSString *BOWLTYPE;
@property(strong,nonatomic)NSString *SHOTTYPE;
@property(strong,nonatomic)NSString *SHOTTYPECATEGORY;
@property(strong,nonatomic)NSString *ISLEGALBALL;
@property(strong,nonatomic)NSString *ISFOUR;
@property(strong,nonatomic)NSString *ISSIX;

@property(nonatomic,assign)NSNumber *RUNS;
@property(nonatomic,assign)NSNumber *OVERTHROW;
@property(nonatomic,assign)NSNumber *TOTALRUNS;
@property(nonatomic,assign)NSNumber *WIDE;
@property(nonatomic,assign)NSNumber *NOBALL;
@property(nonatomic,assign)NSNumber *BYES;
@property(nonatomic,assign)NSNumber *LEGBYES;
@property(nonatomic,assign)NSNumber *PENALTY;
@property(nonatomic,assign)NSNumber *TOTALEXTRAS;
@property(nonatomic,assign)NSNumber *GRANDTOTAL;
@property(nonatomic,assign)NSNumber *RBW;

@property(strong,nonatomic)NSString *PMLINECODE;
@property(strong,nonatomic)NSString *PMLENGTHCODE;
@property(strong,nonatomic)NSString *PMSTRIKEPOINT;
@property(strong,nonatomic)NSString *PMSTRIKEPOINTLINECODE;

@property(nonatomic,assign)NSNumber *PMX1;
@property(nonatomic,assign)NSNumber *PMY1;
@property(nonatomic,assign)NSNumber *PMX2;
@property(nonatomic,assign)NSNumber *PMY2;
@property(nonatomic,assign)NSNumber *PMX3;
@property(nonatomic,assign)NSNumber *PMY3;

@property(strong,nonatomic)NSString *WWREGION;

@property(nonatomic,assign)NSNumber *WWX1;
@property(nonatomic,assign)NSNumber *WWY1;
@property(nonatomic,assign)NSNumber *WWX2;
@property(nonatomic,assign)NSNumber *WWY2;
@property(nonatomic,assign)NSNumber *BALLDURATION;

@property(strong,nonatomic)NSString *ISAPPEAL;
@property(strong,nonatomic)NSString *ISBEATEN;
@property(strong,nonatomic)NSString *ISUNCOMFORT;
@property(strong,nonatomic)NSString *ISWTB;
@property(strong,nonatomic)NSString *ISRELEASESHOT;
@property(strong,nonatomic)NSString *MARKEDFOREDIT;

@property(strong,nonatomic)NSString *REMARKS;

@property(nonatomic,assign)NSNumber *ISWICKET;

@property(strong,nonatomic)NSString *WICKETTYPE;
@property(strong,nonatomic)NSString *WICKETPLAYER;
@property(strong,nonatomic)NSString *FIELDINGPLAYER	;

@property(nonatomic,assign)NSNumber *ISWICKETUNDO;

@property(strong,nonatomic)NSString *AWARDEDTOTEAMCODE;

@property(nonatomic,assign)NSNumber *PENALTYRUNS;

@property(strong,nonatomic)NSString *PENALTYTYPECODE;
@property(strong,nonatomic)NSString *PENALTYREASONCODE;
@property(strong,nonatomic)NSString *BALLSPEED;
@property(strong,nonatomic)NSString *UNCOMFORTCLASSIFCATION;
@property(strong,nonatomic)NSString *WICKETEVENT;



@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;

@property(strong,nonatomic)NSString *BATTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BOWLTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BATTEAMNAME;
@property(strong,nonatomic)NSString *BOWLTEAMNAME;

@property(nonatomic,assign)NSNumber *MATCHOVERS;

@property(strong,nonatomic)NSString *BATTEAMLOGO;
@property(strong,nonatomic)NSString *BOWLTEAMLOGO;
@property(strong,nonatomic)NSString *MATCHTYPE;

@property(nonatomic,assign)NSNumber *OLDISLEGALBALL;
@property(strong,nonatomic)NSString *OLDBOWLERCODE;
@property(strong,nonatomic)NSString *OLDSTRIKERCODE;
@property(strong,nonatomic)NSString *OLDNONSTRIKERCODE;


@property(nonatomic,assign)NSNumber *F_ISWICKET;
@property(nonatomic,assign)NSNumber *F_ISWICKETCOUNTABLE;
@property(strong,nonatomic)NSString *F_WICKETTYPE;
@property(nonatomic,assign)NSNumber *WICKETNO;
@property(strong,nonatomic)NSString *MAXID;
@property(strong,nonatomic)NSString *PENALTYCODE;
@property(strong,nonatomic)NSString *LASTBALLCODE;
@property(strong,nonatomic)NSString *T_STRIKERCODE;
@property(strong,nonatomic)NSString *T_NONSTRIKERCODE;
@property(nonatomic,assign)NSNumber *T_TOTALRUNS;

@property(nonatomic,assign)NSNumber *OTHERBOWLEROVERBALLCNT;
@property(strong,nonatomic)NSString *OTHERBOWLER;
@property(nonatomic,assign)NSNumber *U_BOWLERMAIDENS;
@property(nonatomic,assign)NSNumber *ISMAIDENOVER;

@property(nonatomic,assign)NSNumber *ISOVERCOMPLETE;


@property(strong,nonatomic)NSString *OVERSTATUS;

@property(strong,nonatomic)NSString *CURRENTSTRIKERCODE;
@property(strong,nonatomic)NSString *CURRENTNONSTRIKERCODE;
@property(strong,nonatomic)NSString *CURRENTBOWLERCODE;



//SCOREBOARD

@property(strong,nonatomic)NSString* F_STRIKERCODE;
@property(strong,nonatomic)NSString* F_BOWLERCODE;
@property(nonatomic,assign)NSNumber* F_ISLEGALBALL;
@property(nonatomic,assign)NSNumber* F_OVERS;
@property(nonatomic,assign)NSNumber* F_BALLS;
@property(nonatomic,assign)NSNumber* F_RUNS;
@property(nonatomic,assign)NSNumber* F_OVERTHROW;
@property(nonatomic,assign)NSNumber* F_ISFOUR;
@property(nonatomic,assign)NSNumber* F_ISSIX;
@property(nonatomic,assign)NSNumber* F_WIDE;
@property(nonatomic,assign)NSNumber* F_NOBALL;
@property(nonatomic,assign)NSNumber* F_BYES;
@property(nonatomic,assign)NSNumber* F_LEGBYES;
@property(nonatomic,assign)NSNumber* F_PENALTY;
@property(nonatomic,assign)NSNumber* F_WICKETNO;
@property(strong,nonatomic)NSString* F_WICKETPLAYER;
@property(strong,nonatomic)NSString* F_FIELDINGPLAYER;

@property(strong,nonatomic)NSString* O_RUNS;
@property(strong,nonatomic)NSString* N_RUNS;


@property(strong,nonatomic)NSString *BATSMANCODE;
@property(nonatomic,assign)NSNumber *ISDELETE;


@property(nonatomic,assign)NSNumber* F_BOWLEROVERS;
@property(nonatomic,assign)NSNumber* F_BOWLERBALLS;
@property(nonatomic,assign)NSNumber* F_BOWLERRUNS;
@property(nonatomic,assign)NSNumber* F_BOWLERPARTIALOVERBALLS;
@property(nonatomic,assign)NSNumber* F_BOWLERMAIDENS;
@property(nonatomic,assign)NSNumber* F_BOWLERWICKETS;
@property(nonatomic,assign)NSNumber* F_BOWLERNOBALLS;
@property(nonatomic,assign)NSNumber* F_BOWLERWIDES;
@property(nonatomic,assign)NSNumber* F_BOWLERDOTBALLS;
@property(nonatomic,assign)NSNumber* F_BOWLERFOURS;
@property(nonatomic,assign)NSNumber* F_BOWLERSIXES;


@property(nonatomic,assign)NSNumber* U_BOWLEROVERS;
@property(nonatomic,assign)NSNumber* U_BOWLERBALLS;
@property(nonatomic,assign)NSNumber* U_BOWLERPARTIALOVERBALLS;
@property(nonatomic,assign)NSNumber* U_BOWLERRUNS;
@property(nonatomic,assign)NSNumber* U_BOWLERWICKETS;
@property(nonatomic,assign)NSNumber* U_BOWLERNOBALLS;
@property(nonatomic,assign)NSNumber* U_BOWLERWIDES;
@property(nonatomic,assign)NSNumber* U_BOWLERDOTBALLS;
@property(nonatomic,assign)NSNumber* U_BOWLERFOURS;
@property(nonatomic,assign)NSNumber* U_BOWLERSIXES;
@property(nonatomic,assign)NSNumber* BOWLERCOUNT;




@property(strong,nonatomic)NSString *F_OVERNO;
@property(strong,nonatomic)NSString *OVERS;
@property(strong,nonatomic)NSString *O_WICKETNO;
@property(strong,nonatomic)NSString *U_BOWLERCODE;

@property(nonatomic,assign)NSNumber* ISBALLEXISTS;
@property(nonatomic,assign)NSNumber* ISBOWLERCHANGED;


@property(strong,nonatomic)NSMutableArray *getDataArray;
@property(strong,nonatomic)NSMutableArray *getPlayerArray;
@property(strong,nonatomic)NSMutableArray *getOverArray;
@property(strong,nonatomic)NSMutableArray *getBowlingArray;
@property(strong,nonatomic)NSString  *SMAIDENOVER;

@property(nonatomic,assign)NSNumber* ISWKTDTLSUPDATE ;
@property(nonatomic,assign)NSNumber* BOWLEROVERBALLCNT ;
@property(nonatomic,assign)NSNumber* BOWLEROVERBALLCN;


@property(strong,nonatomic)NSString *BALLS;
@property(strong,nonatomic)NSString *PARTIALOVERBALLS;
@property(strong,nonatomic)NSString *WICKETS;
@property(strong,nonatomic)NSString *MAIDENS;
@property(strong,nonatomic)NSString *NOBALLS;
@property(strong,nonatomic)NSString *WIDES;
@property(strong,nonatomic)NSString *DOTBALLS;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *SIXES;


-(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT;

-(void) UpdateScoreBoard:(NSString *) BALLCODE:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSNumber*)INNINGSNO :(NSString *)BATSMANCODE:(NSNumber *) ISFOUR:(NSNumber*)ISSIX:(NSNumber*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)ISWICKET :(NSString *)WICKETTYPE:(NSString *)WICKETPLAYER:(NSString*)BOWLERCODE:(NSString*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)WICKETSCORE :(NSNumber *)WIDE:(NSNumber *)NOBALL:(NSNumber*)BYES	:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)ISDELETE :(NSNumber *)ISWICKETUNDO:(NSNumber *)F_ISWICKETCOUNTABLE:(NSNumber*)F_ISWICKET :(NSNumber*)F_WICKETTYPE;

@end
