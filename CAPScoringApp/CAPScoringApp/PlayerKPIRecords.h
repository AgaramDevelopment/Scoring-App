//
//  PlayerKPIRecords.h
//  CAPScoringApp
//
//  Created by Raja sssss on 01/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerKPIRecords : NSObject

@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *BOWLERNAME;
@property(strong,nonatomic)NSString *MAIDEN;
@property(strong,nonatomic)NSString *RUNS;
@property(strong,nonatomic)NSString *BALLS;
@property(strong,nonatomic)NSString *DOTBALL;
@property(strong,nonatomic)NSString *SB;
@property(strong,nonatomic)NSString *ONES;
@property(strong,nonatomic)NSString *TWOS;
@property(strong,nonatomic)NSString *THREES;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *FIVES;
@property(strong,nonatomic)NSString *SIXES;
@property(strong,nonatomic)NSString *WIDES;
@property(strong,nonatomic)NSString *NOBALL;
@property(strong,nonatomic)NSString *WICKETS;
@property(strong,nonatomic)NSString *BOUNDARY4S;
@property(strong,nonatomic)NSString *BOUNDARY6S;
@property(strong,nonatomic)NSString *SBPERCENTAGE;
@property(strong,nonatomic)NSString *ECONOMYRATE;
@property(strong,nonatomic)NSString *STRIKERATE;
@property(strong,nonatomic)NSString *AVERAGE;
@property(strong,nonatomic)NSString *DOTBALLPERCENTAGE;
@property(strong,nonatomic)NSString *ONESPERCENTAGE;
@property(strong,nonatomic)NSString *TWOSPERCENTAGE;
@property(strong,nonatomic)NSString *THREESPERCENTAGE;
@property(strong,nonatomic)NSString *FOURSPERCENTAGE;
@property(strong,nonatomic)NSString *FIVESPERCENAGE;
@property(strong,nonatomic)NSString *SIXESPERCENTAGE;
@property(strong,nonatomic)NSString *BOUNDARY4SPERCENTAGE;
@property(strong,nonatomic)NSString *BOUNDART6SPERCENTAGE;
@property(strong,nonatomic)NSString *OVERS;


//BATSMAN KPI
@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *STRIKERNAME;
@property(strong,nonatomic)NSString *SHOTTYPEAGGRESSIVE;
@property(strong,nonatomic)NSString *SHOTTYPEDEFENSIVE;
@property(strong,nonatomic)NSString *RPSS;
@property(strong,nonatomic)NSString *SHOTTYPEAGGRESSIVEPER;
@property(strong,nonatomic)NSString *SHOTTYPEDEFENSIVEPER;

@end
