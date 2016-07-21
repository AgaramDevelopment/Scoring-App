//
//  PlayerInOutPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerInOutPushRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSString *TEAMCODE;
@property(nonatomic,strong)NSString *PLAYERCODE;
@property(nonatomic,strong)NSString *INTIME;
@property(nonatomic,strong)NSString *OUTTIME;
@property(nonatomic,strong)NSString *ISSYNC;

-(NSDictionary *)PlayerInOutPushRecordDictionary ;
@end
