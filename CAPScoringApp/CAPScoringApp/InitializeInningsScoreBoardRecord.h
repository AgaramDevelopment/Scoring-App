//
//  InitializeInningsScoreBoardRecord.h
//  CAPScoringApp
//
//  Created by mac on 14/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InitializeInningsScoreBoardRecord : NSObject


@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(nonatomic,assign)NSNumber *INNINGSNO;
@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *NONSTRIKERCODE;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(nonatomic,assign)NSNumber *ISINNINGSREVERT;
@property(nonatomic,assign)NSNumber *STRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *NONSTRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *BOWLERPOSITIONNO;





-(void) UpdatePlayers:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString *)STRIKERCODE:(NSString *)NONSTRIKERCODE:(NSString *)BOWLERCODE;

@end
