//
//  FollowOnRecords.h
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowOnRecords : NSObject

@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *TEAMNAME;

@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *PLAYERCODE;

@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *NONSTRIKERCODE;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *OPPOSITETEAMCODE;

@property(strong,nonatomic)NSMutableArray *getTeamArray;
@property(strong,nonatomic)NSMutableArray *GetBattingteamDetail;
@property(strong,nonatomic)NSMutableArray *GetOppositeBattingteamDetails;
@property(strong,nonatomic)NSMutableArray *GetStrickerNonStrickerDetails;


@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString * OVERNO;
@property(strong,nonatomic)NSString * BALLNO;
@property(strong,nonatomic)NSString * OVERBALLNO;
@property(strong,nonatomic)NSString * TOTALRUN;
@property(strong,nonatomic)NSString * WICKETS;
@property(strong,nonatomic)NSString * OVERSTATUS;
@property(strong,nonatomic)NSString * BOWLINGTEAMCODE;
@property(strong,nonatomic)NSNumber *INNINGSSCORECARD;

@end
