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
@property(nonatomic,strong)NSString *INNINGSNO;
@property(nonatomic,strong)NSString *BYES;
@property(nonatomic,strong)NSString *LEGBYES;
@property(nonatomic,strong)NSString *NOBALLS;
@property(nonatomic,strong)NSString *WIDES;
@property(nonatomic,strong)NSString *PENALTIES;
@property(nonatomic,strong)NSString *INNINGSTOTAL;
@property(nonatomic,strong)NSString *INNINGSTOTALWICKETS;
@property(nonatomic,strong)NSString *ISSYNC;

@end
