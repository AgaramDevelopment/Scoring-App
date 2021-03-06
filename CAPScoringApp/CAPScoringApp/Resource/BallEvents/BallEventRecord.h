//
//  BallEventRecord.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 28/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BallEventRecord : NSObject

@property(nonatomic,strong) NSString * objBallcode;

@property(nonatomic,strong) NSString * objcompetitioncode;

@property(nonatomic,strong) NSString * objmatchcode;

@property(nonatomic,strong) NSString * objTeamcode;

@property(nonatomic,strong) NSNumber * objDayno;

@property(nonatomic,strong) NSString * objInningsno;

@property(nonatomic,strong) NSNumber * objOverno;

@property(nonatomic,strong) NSNumber * objBallno;

@property(nonatomic,strong) NSNumber * objBallcount;

@property(nonatomic,strong) NSNumber * objOverBallcount;

@property(nonatomic,strong) NSNumber * objSessionno;

@property(nonatomic,strong) NSString * objStrikercode;

@property(nonatomic,strong) NSString * objNonstrikercode;

@property(nonatomic,strong) NSString * objBowlercode;

@property(nonatomic,strong) NSString * objWicketkeepercode;

@property(nonatomic,strong) NSString * objUmpire1code;

@property(nonatomic,strong) NSString * objUmpire2code;

@property(nonatomic,strong) NSString * objAtworotw;

@property(nonatomic,strong) NSString * objBowlingEnd;

@property(nonatomic,strong) NSString * objBowltype;

@property(nonatomic,strong) NSString * objShottype;

@property(nonatomic,strong) NSNumber * objIslegalball;

@property(nonatomic,strong) NSNumber * objIsFour;

@property(nonatomic,strong) NSNumber * objIssix;

@property(nonatomic,strong) NSNumber * objRuns;

@property(nonatomic,strong) NSNumber * objOverthrow;

@property(nonatomic,strong) NSNumber * objTotalruns;

@property(nonatomic,strong) NSNumber * objWide;

@property(nonatomic,strong) NSNumber * objNoball;

@property(nonatomic,strong) NSNumber * objByes;

@property(nonatomic,strong) NSNumber * objLegByes;

@property(nonatomic,strong) NSNumber * objPenalty;

@property(nonatomic,strong) NSNumber * objTotalextras;

@property(nonatomic,strong) NSNumber * objGrandtotal;

@property(nonatomic,strong) NSNumber * objRbw;

@property(nonatomic,strong) NSString * objPMlinecode;

@property(nonatomic,strong) NSString * objPMlengthcode;

@property(nonatomic,strong) NSNumber * objPMX1;

@property(nonatomic,strong) NSNumber * objPMY1;

@property(nonatomic,strong) NSNumber * objPMX2;

@property(nonatomic,strong) NSNumber * objPMY2;

@property(nonatomic,strong) NSNumber * objPMX3;

@property(nonatomic,strong) NSNumber * objPMY3;

@property(nonatomic,strong) NSString * objWWREGION;

@property(nonatomic,strong) NSNumber * objWWX1;

@property(nonatomic,strong) NSNumber * objWWY1;

@property(nonatomic,strong) NSNumber * objWWX2;

@property(nonatomic,strong) NSNumber * objWWY2;

@property(nonatomic,strong) NSNumber * objballduration;

@property(nonatomic,strong) NSNumber * objIsappeal;

@property(nonatomic,strong) NSNumber * objIsbeaten;

@property(nonatomic,strong) NSNumber * objIsuncomfort;

@property(nonatomic,strong) NSNumber * objIswtb;

@property(nonatomic,strong) NSNumber * objIsreleaseshot;

@property(nonatomic,strong) NSString * objMarkedforedit;

@property(nonatomic,strong) NSString * objRemark;

@property(nonatomic,strong) NSString * objVideoFile;

@property(nonatomic,strong) NSString * objShorttypecategory;

@property(nonatomic,strong) NSString * objPMStrikepoint;

@property(nonatomic,strong) NSString * objPMStrikepointlinecode;

@property(nonatomic,strong) NSString * objBallspeed;

@property(nonatomic,strong) NSString * objUncomfortclassification;

@property(nonatomic,strong) NSNumber * objWicketno;

@property(nonatomic,strong) NSString * objWicketType;

@property(nonatomic,strong) NSString * objPenaltytypecode;

@property(nonatomic,strong) NSString * objPenaltyreasoncode;

@property(nonatomic,strong) NSString * AwardedTeam;
@end
