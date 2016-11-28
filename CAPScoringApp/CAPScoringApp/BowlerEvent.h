//
//  BowlerEvent.h
//  CAPScoringApp
//
//  Created by Lexicon on 28/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BowlerEvent : NSObject
@property(strong,nonatomic)NSString *BowlerName;
@property(strong,nonatomic)NSString *BowlerCode;
@property(strong,nonatomic)NSString *bowlingType;
@property(strong,nonatomic)NSString *bowlingStyle;
@property(strong,nonatomic)NSString *penaltyMate;


//@property(strong,nonatomic)NSString *PlaerNameStrike_nonStrike;
@end
