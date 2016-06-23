//
//  EndInnings.h
//  CAPScoringApp
//
//  Created by mac on 16/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BallEventRecord.h"

@interface EndInnings : NSObject
{
    BallEventRecord * objBallEventRecord;
}



@property (strong,nonatomic)NSMutableArray *fetchEndInningsArray;

@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(strong,nonatomic)NSString *OLDTEAMCODE;
@property(nonatomic,assign)NSNumber *OLDINNINGSNO;
@property(strong,nonatomic)NSDateFormatter *INNINGSSTARTTIME;
@property(strong,nonatomic)NSDateFormatter *INNINGSENDTIME;
@property(nonatomic,assign)NSNumber *ENDOVER;
@property(nonatomic,assign)NSNumber *TOTALRUNS;
@property(nonatomic,assign)NSNumber *TOTALWICKETS;
@property(strong,nonatomic)NSString *BUTTONNAME;


@property(strong,nonatomic)NSString *MATCHTYPE;
@property(nonatomic,assign)NSInteger *INNINGSCOUNT;
@property(nonatomic,assign)NSNumber *RUNSSCORED;
@property(nonatomic,assign)NSNumber *STARTOVERNO;
@property(nonatomic,assign)NSNumber *STARTBALLNO;
@property(strong,nonatomic)NSString *STARTOVERBALLNO;
@property(strong,nonatomic)NSString *SESSIONNO;
@property(strong,nonatomic)NSString *DAYNO;

@property(strong,nonatomic)NSString *WICKETLOST;


@property(strong,nonatomic)NSString *LASTBALLCODE;
@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *OVERNO;
@property(strong,nonatomic)NSString *OVERSTATUS;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *NONSTRIKERCODE;
@property(strong,nonatomic)NSString *WICKETKEEPERCODE;
@property(strong,nonatomic)NSString *UMPIRE1CODE;
@property(strong,nonatomic)NSString *UMPIRE2CODE;
@property(strong,nonatomic)NSString *ATWOROTW;
@property(strong,nonatomic)NSString *BOWLINGEND;
@property(strong,nonatomic)NSString *SECONDTEAMCODE;
@property(strong,nonatomic)NSString *THIRDTEAMCODE;
@property(nonatomic,assign)NSNumber *SECONDTHIRDTOTAL;
@property(nonatomic,assign)NSNumber *FIRSTTHIRDTOTAL;
@property(nonatomic,assign)NSNumber *SECONDTOTAL;
@property(nonatomic,assign)NSNumber *WINSTATUS;

@property(strong,nonatomic)NSMutableArray *BallEventArray;


@property(strong,nonatomic)NSString *TEAMNAME;
@property(strong,nonatomic)NSString *BALLNO;
@property(strong,nonatomic)NSString *OVERBALLNO;
@property(strong,nonatomic)NSString *TOTALRUN;
@property(strong,nonatomic)NSString *WICKETS;
@property(nonatomic,assign)NSNumber *PENALITYRUNS;



@property(strong,nonatomic)NSString *STARTTIME;
@property(strong,nonatomic)NSString *ENDTIME;



@property(strong,nonatomic)NSString *TOTALOVERS;

@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *DAYDURATION;
@property(strong,nonatomic)NSString *INNINGSDURATION;
@property(strong,nonatomic)NSString *DURATION;



@property(nonatomic,assign)NSNumber *BATTEAMRUNS;
@property(nonatomic,assign)NSNumber *MAXID;
@property(strong,nonatomic)NSString *BALLCODENO;

@property(nonatomic,assign)NSNumber *BATTEAMOVRWITHEXTRASBALLS;
@property(nonatomic,assign)NSNumber *BATTEAMOVRBALLSCNT;


@property(nonatomic,assign)NSNumber *T_TOTALRUNS;
@property(strong,nonatomic)NSString *T_STRIKERCODE;
@property(strong,nonatomic)NSString *T_NONSTRIKERCODE;

@property(nonatomic,assign)NSNumber *ISMAIDENOVER;
@property(nonatomic,assign)NSNumber *BOWLERCOUNT;
@property(strong,nonatomic)NSString *CURRENTBOWLER;

@property(strong,nonatomic)NSString *BATTINGPOSITIONNO;
@property(strong,nonatomic)NSString *RUNS;
@property(strong,nonatomic)NSString *BALLS;
@property(strong,nonatomic)NSString *ONES;
@property(strong,nonatomic)NSString *TWOS;
@property(strong,nonatomic)NSString *THREES;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *SIXES;
@property(strong,nonatomic)NSString *DOTBALLS;
@property(strong,nonatomic)NSString *WICKETNO;
@property(strong,nonatomic)NSString *WICKETTYPE;
@property(strong,nonatomic)NSString *FIELDERCODE;

@property(strong,nonatomic)NSString *FIELDINGPLAYER;

@property(strong,nonatomic)NSString *BYES;
@property(strong,nonatomic)NSString *LEGBYES;
@property(strong,nonatomic)NSString *NOBALLS;
@property(strong,nonatomic)NSString *WIDES;
@property(strong,nonatomic)NSString *PENALTIES;
@property(strong,nonatomic)NSString *INNINGSTOTAL;
@property(strong,nonatomic)NSString *INNINGSTOTALWICKETS;


@property(strong,nonatomic)NSString *BOWLINGPOSITIONNO;
@property(strong,nonatomic)NSString *OVERS;
@property(strong,nonatomic)NSString *PARTIALOVERBALLS;
@property(strong,nonatomic)NSString *MAIDENS;


@property(strong,nonatomic)NSString *BATSMANCODE;
@property(strong,nonatomic)NSString *ISFOUR;
@property(strong,nonatomic)NSString *ISSIX;
@property(nonatomic,assign)NSNumber *OVERTHROW;
@property(nonatomic,assign)NSNumber *ISWICKET;
@property(strong,nonatomic)NSString *WICKETPLAYER;
@property(nonatomic,assign)NSNumber *WICKETOVERNO;
@property(nonatomic,assign)NSNumber *WICKETBALLNO;
@property(nonatomic,assign)NSNumber *WICKETSCORE;
@property(nonatomic,assign)NSNumber *WIDE;
@property(nonatomic,assign)NSNumber *NOBALL;
@property(nonatomic,assign)NSNumber *PENALTY;
@property(nonatomic,assign)NSNumber *ISWKTDTLSUPDATE;
@property(nonatomic,assign)NSNumber *ISBOWLERCHANGED;
@property(nonatomic,assign)NSNumber *ISUPDATE;
@property(nonatomic,assign)NSNumber *O_ISLEGALBALL;
@property(nonatomic,assign)NSNumber *UPDATEFLAGBAT;
@property(nonatomic,assign)NSNumber *O_BATTINGPOSITIONNO;
@property(nonatomic,assign)NSNumber *O_RUNS;
@property(nonatomic,assign)NSNumber *O_BALLS;
@property(nonatomic,assign)NSNumber *O_ONES;
@property(nonatomic,assign)NSNumber *O_TWOS;
@property(nonatomic,assign)NSNumber *O_THREES;
@property(nonatomic,assign)NSNumber *O_FOURS;
@property(nonatomic,assign)NSNumber *O_SIXES;
@property(nonatomic,assign)NSNumber *O_DOTBALLS;
@property(nonatomic,assign)NSNumber *O_WICKETNO;
@property(strong,nonatomic)NSString *O_WICKETTYPE;
@property(strong,nonatomic)NSString *O_FIELDERCODE;
@property(strong,nonatomic)NSString *O_BOWLERCODE;
@property(nonatomic,assign)NSNumber *N_BATTINGPOSITIONNO;
@property(nonatomic,assign)NSNumber *N_RUNS;
@property(nonatomic,assign)NSNumber *N_BALLS;
@property(nonatomic,assign)NSNumber *N_ONES;
@property(nonatomic,assign)NSNumber *N_TWOS;
@property(nonatomic,assign)NSNumber *N_THREES;
@property(nonatomic,assign)NSNumber *N_FOURS;
@property(nonatomic,assign)NSNumber *N_SIXES;
@property(nonatomic,assign)NSNumber *N_DOTBALLS;
@property(nonatomic,assign)NSNumber *N_WICKETNO;
@property(strong,nonatomic)NSString *N_WICKETTYPE;
@property(strong,nonatomic)NSString *N_FIELDERCODE;
@property(strong,nonatomic)NSString *N_BOWLERCODE;




@property(nonatomic,assign)NSNumber *UPDATEFLAGINNS;
@property(nonatomic,assign)NSNumber *O_BYES;
@property(nonatomic,assign)NSNumber *O_LEGBYES;
@property(nonatomic,assign)NSNumber *O_NOBALLS;
@property(nonatomic,assign)NSNumber *O_WIDES;
@property(nonatomic,assign)NSNumber *O_PENALTIES;
@property(nonatomic,assign)NSNumber *O_INNINGSTOTAL;
@property(nonatomic,assign)NSNumber *O_INNINGSTOTALWICKETS;

@property(nonatomic,assign)NSNumber *N_BYES;
@property(nonatomic,assign)NSNumber *N_LEGBYES;
@property(nonatomic,assign)NSNumber *N_NOBALLS;
@property(nonatomic,assign)NSNumber *N_WIDES;
@property(nonatomic,assign)NSNumber *N_PENALTIES;
@property(nonatomic,assign)NSNumber *N_INNINGSTOTAL;
@property(nonatomic,assign)NSNumber *N_INNINGSTOTALWICKETS;



@property(nonatomic,assign)NSNumber *UPDATEFLAGBOWL;
@property(nonatomic,assign)NSNumber *O_BOWLINGPOSITIONNO;
@property(nonatomic,assign)NSNumber *O_BOWLEROVERS;
@property(nonatomic,assign)NSNumber *O_BOWLERBALLS;
@property(nonatomic,assign)NSNumber *O_BOWLERPARTIALOVERBALLS;
@property(nonatomic,assign)NSNumber *O_BOWLERMAIDENS;
@property(nonatomic,assign)NSNumber *O_BOWLERRUNS;
@property(nonatomic,assign)NSNumber *O_BOWLERWICKETS;
@property(nonatomic,assign)NSNumber *O_BOWLERNOBALLS;
@property(nonatomic,assign)NSNumber *O_BOWLERWIDES;
@property(nonatomic,assign)NSNumber *O_BOWLERDOTBALLS;
@property(nonatomic,assign)NSNumber *O_BOWLERFOURS;
@property(nonatomic,assign)NSNumber *O_BOWLERSIXES;
@property(nonatomic,assign)NSNumber *N_BOWLINGPOSITIONNO;
@property(nonatomic,assign)NSNumber *N_BOWLEROVERS;
@property(nonatomic,assign)NSNumber *N_BOWLERBALLS;
@property(nonatomic,assign)NSNumber *N_BOWLERPARTIALOVERBALLS;
@property(nonatomic,assign)NSNumber *N_BOWLERMAIDENS;
@property(nonatomic,assign)NSNumber *N_BOWLERRUNS;
@property(nonatomic,assign)NSNumber *N_BOWLERWICKETS;
@property(nonatomic,assign)NSNumber *N_BOWLERNOBALLS;
@property(nonatomic,assign)NSNumber *N_BOWLERWIDES;
@property(nonatomic,assign)NSNumber * N_BOWLERDOTBALLS;
@property(nonatomic,assign)NSNumber *N_BOWLERFOURS;
@property(nonatomic,assign)NSNumber *N_BOWLERSIXES;
@property(nonatomic,assign)NSNumber *ISWICKETCOUNTABLE;
@property(nonatomic,assign)NSNumber *ISOVERCOMPLETE;
@property(strong,nonatomic)NSString *RESULTCODE;
@property(strong,nonatomic)NSString *RESULTTYPE;





-(void) InsertEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO:(NSString*)INNINGSSTARTTIME:(NSString*)INNINGSENDTIME:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString *)BUTTONNAME:(NSString*)STARTOVERNO;

-(void)fetchEndInnings:(NSString *) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO;

-(void) DeleteEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO;

//-(void)manageSeOverDetails:(NSObject *) balleventRecord;

-(void)manageSeOverDetails:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO :(NSObject *) balleventRecord;
@end
