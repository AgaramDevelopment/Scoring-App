//
//  SessionReportRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 27/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionReportRecord : NSObject

@property (nonatomic,strong) NSString * dayno;

@property (nonatomic,strong) NSString * sessionno;

@property (nonatomic,strong) NSString * Teamcode;

@property (nonatomic,strong) NSString * TeamName;

@property (nonatomic,strong) NSString * Runs;

@property (nonatomic,strong) NSString * overs;

@property (nonatomic,strong) NSString * wickets;

@property (nonatomic,strong) NSString * fours;

@property (nonatomic,strong) NSString * sixes;

@property (nonatomic,strong) NSString * RunRate;

@property (nonatomic,strong) NSString * BDRY;

@end
