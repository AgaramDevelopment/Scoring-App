//
//  EndInnings.h
//  CAPScoringApp
//
//  Created by Stephen on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

//SP_INSERTENDINNINGS
@interface InningsDetails : NSObject
@property(strong,nonatomic)NSString *STARTTIME;
@property(strong,nonatomic)NSString *ENDTIME;
@property(strong,nonatomic)NSString *TEAMNAME;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *TOTALOVERS;
@property(strong,nonatomic)NSString *TOTALWICKETS;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *DAYDURATION;
@property(strong,nonatomic)NSString *INNINGSDURATION;
@property(strong,nonatomic)NSString *DURATION;

@end
@interface BallEventForInningsDetails : NSObject
@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *OVERNO;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *NONSTRIKERCODE;
@property(strong,nonatomic)NSString *WICKETKEEPERCODE;
@property(strong,nonatomic)NSString *UMPIRE1CODE;
@property(strong,nonatomic)NSString *UMPIRE2CODE;
@property(strong,nonatomic)NSString *ATWOROTW;
@property(strong,nonatomic)NSString *BOWLINGEND;
@end