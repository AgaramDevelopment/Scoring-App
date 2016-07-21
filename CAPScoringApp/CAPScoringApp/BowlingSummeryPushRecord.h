//
//  BowlingSummeryPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BowlingSummeryPushRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *BOWLINGTEAMCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSNumber *BOWLINGPOSITIONNO;
@property(nonatomic,strong)NSString *BOWLERCODE;
@property(nonatomic,strong)NSNumber *OVERS;
@property(nonatomic,strong)NSNumber *BALLS;
@property(nonatomic,strong)NSNumber *PARTIALOVERBALLS;
@property(nonatomic,strong)NSNumber *MAIDENS;
@property(nonatomic,strong)NSNumber *RUNS;
@property(nonatomic,strong)NSNumber *WICKETS;
@property(nonatomic,strong)NSNumber *NOBALLS;
@property(nonatomic,strong)NSNumber *WIDES;
@property(nonatomic,strong)NSNumber *DOTBALLS;
@property(nonatomic,strong)NSNumber *FOURS;
@property(nonatomic,strong)NSNumber *SIXES;
@property(nonatomic,strong)NSString *ISSYNC;

-(NSDictionary *)BowlingSummeryPushRecordDictionary;
@end
