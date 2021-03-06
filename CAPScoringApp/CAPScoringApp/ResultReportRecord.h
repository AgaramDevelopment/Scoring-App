//
//  ResultReportRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 18/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultReportRecord : NSObject
@property(strong,nonatomic)NSString *matchCode;
@property(strong,nonatomic)NSString *matchName;
@property(strong,nonatomic)NSString *competitionCode;
@property(strong,nonatomic)NSString *matchOverComments;
@property(strong,nonatomic)NSString *matchDate;
@property(strong,nonatomic)NSString *groundCode;
@property(strong,nonatomic)NSString *groundName;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *teamAcode;
@property(strong,nonatomic)NSString *teamBcode;
@property(strong,nonatomic)NSString *teamAname;
@property(strong,nonatomic)NSString *teamBname;
@property(strong,nonatomic)NSString *teamAshortName;
@property(strong,nonatomic)NSString *teamBshortName;
@property(strong,nonatomic)NSString *matchOvers;
@property(strong,nonatomic)NSString *matchTypeName;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *matchStatus;
@property(strong,nonatomic)NSString *comments;

@end
