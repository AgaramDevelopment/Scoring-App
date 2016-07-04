//
//  MatchEventPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchEventPushRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *TOSSWONTEAMCODE;
@property(nonatomic,strong)NSString *ELECTEDTO;
@property(nonatomic,strong)NSString *BATTINGTEAMCODE;
@property(nonatomic,strong)NSString *BOWLINGTEAMCODE;
@property(nonatomic,strong)NSNumber *TARGETRUNS;
@property(nonatomic,strong)NSNumber *TARGETOVERS;
@property(nonatomic,strong)NSString *TARGETCOMMENTS;
@property(nonatomic,strong)NSString *BOWLCOMPUTESHOW;
@property(nonatomic,strong)NSString *ISSYNC;

@end
