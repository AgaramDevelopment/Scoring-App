//
//  InningsBowlerDetailsRecord.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InningsBowlerDetailsRecord : NSObject
@property (strong,nonatomic) NSString * BowlerCode;
@property (strong,nonatomic) NSString * Playername;
@property (strong,nonatomic) NSString * Striker;
@property (strong,nonatomic) NSString * nonStriker;
@property (strong,nonatomic) NSString * bowlerType;
@property (strong,nonatomic) NSString * shorType;
@property (strong,nonatomic) NSString * totalRuns;
@property (strong,nonatomic) NSString * totalExtras;

@property (strong,nonatomic) NSString * OverNo;
@property (strong,nonatomic) NSString * ballNo;
@property (strong,nonatomic) NSString * BallCount;
@property (strong,nonatomic) NSString * islegalBall;
@property (strong,nonatomic) NSString * isFour;
@property (strong,nonatomic) NSString * isSix;
@property (strong,nonatomic) NSString * Runs;
@property (strong,nonatomic) NSString * overThrow;
@property (strong,nonatomic) NSString * Wide;
@property (strong,nonatomic) NSString * noBall;
@property (strong,nonatomic) NSString * Byes;
@property (strong,nonatomic) NSString * Legbyes;
@property (strong,nonatomic) NSString * WicketNo;
@property (strong,nonatomic) NSString * WicketType;
@property (strong,nonatomic) NSString * penaltyRuns;
@property (strong,nonatomic) NSString * penaltytypeCode;

@property (strong,nonatomic) NSString * ballCode;
@property(strong,nonatomic)NSString*ismarkforedit;

@property (strong,nonatomic) NSString * OverballCount;

@property (strong,nonatomic) NSString * grandTotal;
@property (strong,nonatomic) NSNumber * rowId;







@end
