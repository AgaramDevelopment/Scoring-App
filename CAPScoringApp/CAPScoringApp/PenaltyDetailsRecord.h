//
//  PenaltyDetailsRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/17/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PenaltyDetailsRecord : NSObject
@property(strong,nonatomic)NSString *competitioncode;
@property(strong,nonatomic)NSString *matchcode;
@property(strong,nonatomic)NSString *inningsno;
@property(strong,nonatomic)NSString *ballcode;
@property(strong,nonatomic)NSString *penaltycode;
@property(strong,nonatomic)NSString *awardedtoteamcode;
@property(strong,nonatomic)NSString *penaltyruns;
@property(strong,nonatomic)NSString *penaltytypecode;
@property(strong,nonatomic)NSString *penaltyreasondescription;
@property(strong,nonatomic)NSString *penaltytypedescription;
@property(strong,nonatomic)NSString *penaltyreasoncode;
@end
