//
//  InningsEventPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InningsEventPushRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *TEAMCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSString *INNINGSSTARTTIME;
@property(nonatomic,strong)NSString *INNINGSENDTIME;
@property(nonatomic,strong)NSString *STRIKERCODE;
@property(nonatomic,strong)NSString *NONSTRIKERCODE;
@property(nonatomic,strong)NSString *BOWLERCODE;
@property(nonatomic,strong)NSString *BATTINGTEAMCODE;
@property(nonatomic,strong)NSString *CURRENTSTRIKERCODE;
@property(nonatomic,strong)NSString *CURRENTNONSTRIKERCODE;
@property(nonatomic,strong)NSString *CURRENTBOWLERCODE;
@property(nonatomic,strong)NSNumber *TOTALRUNS;
@property(nonatomic,strong)NSNumber *TOTALOVERS;
@property(nonatomic,strong)NSNumber *TOTALWICKETS;
@property(nonatomic,strong)NSNumber *ISDECLARE;
@property(nonatomic,strong)NSNumber *ISFOLLOWON;
@property(nonatomic,strong)NSNumber *INNINGSSTATUS;
@property(nonatomic,strong)NSString *BOWLINGEND;
@property(nonatomic,strong)NSString *issync;

-(NSDictionary *)InningsEventPushRecordDictionary ;
@end
