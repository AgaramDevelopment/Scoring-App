//
//  EndInnings.h
//  CAPScoringApp
//
//  Created by mac on 16/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndInnings : NSObject

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



//TEAMCODE
//OVERNO
//BOWLERCODE
//STRIKERCODE
//NONSTRIKERCODE
//WICKETKEEPERCODE
//UMPIRE1CODE
//UMPIRE2CODE
//ATWOROTW
//BOWLINGEND




-(void) InsertEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO:(NSString*)INNINGSSTARTTIME:
(NSString*)INNINGSENDTIME:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)BUTTONNAME;

-(void)fetchEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO;


@end
