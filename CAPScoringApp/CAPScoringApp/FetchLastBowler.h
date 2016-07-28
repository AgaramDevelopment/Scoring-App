//
//  FetchLastBowler.h
//  CAPScoringApp
//
//  Created by APPLE on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchLastBowler : NSObject

@property(strong,nonatomic)NSMutableArray *GetLastBolwerDetails;
-(void)LastBowlerDetails:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*) INNINGSNO: (NSNumber*) OVERNO : (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT;
@end

@interface FetchCurrentBowler : NSObject

@property(strong,nonatomic)NSMutableArray *GetCurrentBolwerDetails;
-(void)CurrentBowlerDetails : (NSString *)COMPETITIONCODE : (NSString*)MATCHCODE :(NSString*) INNINGSNO : (NSNumber*) OVERNO : (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT : (NSString*) BOWLERCODE;
@end

@interface FetchCurrentBatsman : NSObject

@property(strong,nonatomic)NSString * PlayerCode;
@property(strong,nonatomic)NSString * PlayerName;
@property(strong,nonatomic)NSString * TotalRuns;
@property(strong,nonatomic)NSString * Fours;
@property(strong,nonatomic)NSString * Sixes;
@property(strong,nonatomic)NSString * TotalBalls;
@property(strong,nonatomic)NSString * StrickRate;
@property(strong,nonatomic)NSString * BattingStyle;

-(void)CurrentBatsmanDetails : (NSString *)COMPETITIONCODE : (NSString*)MATCHCODE :(NSString*) INNINGSNO : (NSString*) BATTINGTEAMCODE : (NSString*) BATSMANCODE;
@end