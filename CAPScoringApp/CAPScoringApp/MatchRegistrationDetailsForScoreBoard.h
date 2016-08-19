//
//  MatchRegistrationDetailsForScoreBoard.h
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchRegistrationDetailsForScoreBoard : NSObject
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *MATCHNAME;
@property(strong,nonatomic)NSString *MATCHDATE;
@property(strong,nonatomic)NSString *MATCHOVERS;
@property(strong,nonatomic)NSString *UMPIRE1CODE;
@property(strong,nonatomic)NSString *UMPIRE1NAME;
@property(strong,nonatomic)NSString *UMPIRE2CODE;
@property(strong,nonatomic)NSString *UMPIRE2NAME;
@property(strong,nonatomic)NSString *MATCHREFEREECODE;
@property(strong,nonatomic)NSString *MATCHREFEREENAME;
@property(strong,nonatomic)NSString *TOSSWONTEAMCODE;
@property(strong,nonatomic)NSString *TOSSWONTEAMNAME;
@property(strong,nonatomic)NSString *ELECTEDTO;
@property(strong,nonatomic)NSString *ELECTEDTODESCRIPTION;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BATTINGTEAMNAME;
@property(strong,nonatomic)NSString *BATTINGTEAMLOGO;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMNAME;
@property(strong,nonatomic)NSString *BOWLINGTEAMLOGO;


@property(strong,nonatomic)NSString *BYES;
@property(strong,nonatomic)NSString *LEGBYES;
@property(strong,nonatomic)NSString *NOBALLS;
@property(strong,nonatomic)NSString *WIDES;
@property(strong,nonatomic)NSString *PENALTIES;
@property(strong,nonatomic)NSString *TOTALEXTRAS;
@property(strong,nonatomic)NSString *INNINGSTOTAL;
@property(strong,nonatomic)NSString *INNINGSTOTALWICKETS;
@property(strong,nonatomic)NSString *INNINGSRUNRATE;
@property(strong,nonatomic)NSString *FINALINNINGS;
@property(strong,nonatomic)NSString *ISDECLARE;
@end
