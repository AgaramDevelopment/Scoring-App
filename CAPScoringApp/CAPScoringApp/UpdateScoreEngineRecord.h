//
//  UpdateScoreEngineRecord.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateScoreEngineRecord : NSObject
@property(nonatomic,strong)NSString *OLDISLEGALBALL;
@property(nonatomic,strong) NSString *OLDBOWLERCODE;
@property(nonatomic,strong) NSString *OLDSTRIKERCODE;
@property(nonatomic,strong) NSString *OLDNONSTRIKERCODE;
@property(nonatomic,strong) NSString *BOWLINGTEAMCODE;
@property(nonatomic,strong) NSString *MATCHOVER;
@end


@interface BattingSummaryRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong) NSString *MATCHCODE;
@property(nonatomic,strong) NSString *BATTINGTEAMCODE;
@property(nonatomic,strong) NSString *INNINGSNO;
@property(nonatomic,strong) NSString *BATSMANCODE;
@property(nonatomic,strong) NSString *RUNS;
@property(nonatomic,strong) NSString *BALLS;
@property(nonatomic,strong) NSString *ONES;
@property(nonatomic,strong) NSString *TWOS;
@property(nonatomic,strong) NSString *THREES;
@property(nonatomic,strong) NSString *FOURS;
@property(nonatomic,strong) NSString *SIXES;
@property(nonatomic,strong) NSString *DOTBALLS;
@property(nonatomic,strong) NSString *WICKETNO;
@property(nonatomic,strong) NSString *WICKETTYPE;
@property(nonatomic,strong) NSString *FIELDERCODE;
@property(nonatomic,strong) NSString *BOWLERCODE;
@property(nonatomic,strong) NSString *WICKETOVERNO;
@property(nonatomic,strong) NSString *WICKETBALLNO;
@property(nonatomic,strong) NSString *WICKETSCORE;
@property(nonatomic,strong) NSString *BATTINGPOSITIONNO;
@end


@interface BowlingSummaryRecord : NSObject
@property(nonatomic,strong) NSString *COMPETITIONCODE;
@property(nonatomic,strong) NSString *MATCHCODE;
@property(nonatomic,strong) NSString *BOWLINGTEAMCODE;
@property(nonatomic,strong) NSString *INNINGSNO;
@property(nonatomic,strong) NSString *BOWLERCODE;
@property(nonatomic,strong) NSString *OVERS;
@property(nonatomic,strong) NSString *BALLS;
@property(nonatomic,strong) NSString *PARTIALOVERBALLS;
@property(nonatomic,strong) NSString *RUNS;
@property(nonatomic,strong) NSString *WICKETS;
@property(nonatomic,strong) NSString *NOBALLS;
@property(nonatomic,strong) NSString *WIDES;
@property(nonatomic,strong) NSString *DOTBALLS;

@property(nonatomic,strong) NSString *FOURS;
@property(nonatomic,strong) NSString *SIXES;
@property(nonatomic,strong) NSString *BOWLINGPOSITIONNO;
@property(nonatomic,strong) NSString *MAIDENS;


@end


@interface BallEventSummaryRecord : NSObject
@property(nonatomic,strong) NSString *BALLCODE;
@property(nonatomic,strong) NSString *COMPETITIONCODE;
@property(nonatomic,strong) NSString *MATCHCODE;
@property(nonatomic,strong) NSString *TEAMCODE;
@property(nonatomic,strong) NSString *INNINGSNO;
@property(nonatomic,strong) NSString *OVERNO;
@property(nonatomic,strong) NSString *BALLNO;
@property(nonatomic,strong) NSString *BALLCOUNT;
@property(nonatomic,strong) NSString *OVERBALLCOUNT;
@end