//
//  FetchLastBallBowledPlayer.h
//  CAPScoringApp
//
//  Created by APPLE on 14/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchLastBallBowledPlayer : NSObject
//Non Stricker Details
@property(strong,nonatomic)NSString *lastBowlerPlayerCode ;
@property(strong,nonatomic)NSString *lastBowlerPlayerName;
@property(strong,nonatomic)NSString *lastBowlerOver;
@property(strong,nonatomic)NSString *lastBowlerMaidan;
@property(strong,nonatomic)NSString *lastBowlerRuns;
@property(strong,nonatomic)NSString *lastBowlerWicket;
@property(strong,nonatomic)NSString *lastBowlerEcoRate;

-(void) getLastBallBowlerPlayer : (NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO BATTINGTEAMCODE: (NSString*) BATTINGTEAMCODE;
@end
