//
//  BATTINGSUMMARYPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATTINGSUMMARYPushRecord : NSObject
@property(nonatomic,strong) NSString *COMPETITIONCODE;
@property(nonatomic,strong) NSString *MATCHCODE;
@property(nonatomic,strong) NSString *BATTINGTEAMCODE;
@property(nonatomic,strong) NSNumber *INNINGSNO;
@property(nonatomic,strong) NSNumber *BATTINGPOSITIONNO;
@property(nonatomic,strong) NSString *BATSMANCODE;
@property(nonatomic,strong) NSNumber *RUNS;
@property(nonatomic,strong) NSNumber *BALLS;
@property(nonatomic,strong) NSNumber *ONES;
@property(nonatomic,strong) NSNumber *TWOS;
@property(nonatomic,strong) NSNumber *THREES;
@property(nonatomic,strong) NSNumber *FOURS;
@property(nonatomic,strong) NSNumber *SIXES;
@property(nonatomic,strong) NSNumber *DOTBALLS;
@property(nonatomic,strong) NSNumber *WICKETNO;
@property(nonatomic,strong) NSString *WICKETTYPE;
@property(nonatomic,strong) NSString *FIELDERCODE;
@property(nonatomic,strong) NSString *BOWLERCODE;
@property(nonatomic,strong) NSNumber *WICKETOVERNO;
@property(nonatomic,strong) NSNumber *WICKETBALLNO;
@property(nonatomic,strong) NSNumber *WICKETSCORE;
@property(nonatomic,strong)NSString*ISSYNC;
@end
