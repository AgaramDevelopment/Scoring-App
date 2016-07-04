//
//  UpdateScoreEngineRecord.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "UpdateScoreEngineRecord.h"

@implementation UpdateScoreEngineRecord
@synthesize OLDBOWLERCODE,OLDISLEGALBALL,OLDSTRIKERCODE,OLDNONSTRIKERCODE;
@end



@implementation BattingSummaryRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize BATTINGTEAMCODE;
@synthesize INNINGSNO;
@synthesize BATSMANCODE;
@synthesize RUNS;
@synthesize BALLS;
@synthesize ONES;
@synthesize TWOS;
@synthesize THREES;
@synthesize FOURS;
@synthesize SIXES;
@synthesize DOTBALLS;
@synthesize WICKETNO;
@synthesize WICKETTYPE;
@synthesize FIELDERCODE;
@synthesize BOWLERCODE;
@synthesize WICKETOVERNO;
@synthesize WICKETBALLNO;
@synthesize WICKETSCORE;
@synthesize BATTINGPOSITIONNO;
@end

//@implementation BowlingSummaryRecord
//@synthesize BALLCODE;
//@synthesize COMPETITIONCODE;
//@synthesize MATCHCODE;
//@synthesize TEAMCODE;
//@synthesize INNINGSNO;
//@synthesize OVERNO;
//@synthesize BALLNO;
//@synthesize BALLCOUNT;
//@synthesize OVERBALLCOUNT;
//@end
//
//@implementation BowlingSummaryRecord
//@synthesize BALLCODE;
//@synthesize COMPETITIONCODE;
//@synthesize MATCHCODE;
//@synthesize TEAMCODE;
//@synthesize INNINGSNO;
//@synthesize OVERNO;
//@synthesize BALLNO;
//@synthesize BALLCOUNT;
//@synthesize OVERBALLCOUNT;
//@end



@implementation BowlingSummaryRecord
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize INNINGSNO;
@synthesize BOWLERCODE;
@synthesize OVERS;
@synthesize BALLS;
@synthesize PARTIALOVERBALLS;
@synthesize RUNS;
@synthesize WICKETS;
@synthesize NOBALLS;
@synthesize WIDES;
@synthesize DOTBALLS;
@synthesize FOURS;
@synthesize SIXES;
@synthesize BOWLINGPOSITIONNO;
@synthesize MAIDENS;
@end


@implementation BallEventSummaryRecord : NSObject
@synthesize BALLCODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize OVERNO;
@synthesize BALLNO;
@synthesize BALLCOUNT;
@synthesize OVERBALLCOUNT;
@end
