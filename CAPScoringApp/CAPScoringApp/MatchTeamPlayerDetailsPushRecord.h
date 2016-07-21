//
//  MatchTeamPlayerDetailsPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchTeamPlayerDetailsPushRecord : NSObject

@property(nonatomic,strong)NSString *MATCHTEAMPLAYERCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *TEAMCODE;
@property(nonatomic,strong)NSString *PLAYERCODE;
@property(nonatomic,strong)NSNumber *PLAYINGORDER;
@property(nonatomic,strong)NSString *RECORDSTATUS;
@property(nonatomic,strong)NSString *ISSYNC;
-(NSDictionary *)MatchTeamPlayerDetailsPushRecordDictionary ;
@end
