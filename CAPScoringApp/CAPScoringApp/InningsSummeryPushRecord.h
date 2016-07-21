//
//  InningsSummeryPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InningsSummeryPushRecord : NSObject

@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *BATTINGTEAMCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSNumber *BYES;
@property(nonatomic,strong)NSNumber *LEGBYES;
@property(nonatomic,strong)NSNumber *NOBALLS;
@property(nonatomic,strong)NSNumber *WIDES;
@property(nonatomic,strong)NSNumber *PENALTIES;
@property(nonatomic,strong)NSNumber *INNINGSTOTAL;
@property(nonatomic,strong)NSNumber *INNINGSTOTALWICKETS;
@property(nonatomic,strong)NSString *ISSYNC;

-(NSDictionary *)InningsSummeryPushRecordDictionary;
@end
