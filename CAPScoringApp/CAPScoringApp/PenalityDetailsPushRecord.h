//
//  PenalityDetailsPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PenalityDetailsPushRecord : NSObject

@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSString *BALLCODE;
@property(nonatomic,strong)NSString *PENALTYCODE;
@property(nonatomic,strong)NSString *AWARDEDTOTEAMCODE;
@property(nonatomic,strong)NSNumber *PENALTYRUNS;
@property(nonatomic,strong)NSString *PENALTYTYPECODE;
@property(nonatomic,strong)NSString *PENALTYREASONCODE;
@property(nonatomic,strong)NSString *ISSYNC;
-(NSDictionary *)PenalityDetailsPushRecordDictionary;
@end
