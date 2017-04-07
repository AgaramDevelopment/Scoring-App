//
//  BowlingSummaryDetailsForScoreBoard.h
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BowlingSummaryDetailsForScoreBoard : NSObject
@property(strong,nonatomic)NSString *BOWLERCODE	;
@property(strong,nonatomic)NSString *BOWLERNAME	;
@property(strong,nonatomic)NSString *TOTALMINUTES;
@property(strong,nonatomic)NSString *OVERS;
@property(strong,nonatomic)NSString *MAIDENS;
@property(strong,nonatomic)NSString *RUNS	;
@property(strong,nonatomic)NSString *WICKETS;
@property(strong,nonatomic)NSString *NOBALLS;
@property(strong,nonatomic)NSString *WIDES	;
@property(strong,nonatomic)NSString *DOTBALLS;
@property(strong,nonatomic)NSString *FOURS	;
@property(strong,nonatomic)NSString *SIXES	;
@property(strong,nonatomic)NSString *ECONOMY;
@property (strong,nonatomic) NSString * BATTINGSTYLE;

@end
