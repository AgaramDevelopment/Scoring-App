//
//  MatchResultPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchResultPushRecord : NSObject

@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *MATCHRESULTCODE;
@property(nonatomic,strong)NSString *MATCHWONTEAMCODE;
@property(nonatomic,strong)NSNumber *TEAMAPOINTS;
@property(nonatomic,strong)NSNumber *TEAMBPOINTS;
@property(nonatomic,strong)NSString *MANOFTHEMATCHCODE;
@property(nonatomic,strong)NSString *COMMENTS;
@property(nonatomic,strong)NSString *ISSYNC;
-(NSDictionary *)MatchResultPushRecordDictionary;
@end
