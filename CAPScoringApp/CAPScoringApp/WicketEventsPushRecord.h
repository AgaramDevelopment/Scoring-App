//
//  WicketEventsPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WicketEventsPushRecord : NSObject
@property(nonatomic,strong)NSString *BALLCODE;
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *TEAMCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSNumber *ISWICKET;
@property(nonatomic,strong)NSNumber *WICKETNO;
@property(nonatomic,strong)NSString *WICKETTYPE;
@property(nonatomic,strong)NSString *WICKETPLAYER;
@property(nonatomic,strong)NSString *FIELDINGPLAYER;
@property(nonatomic,strong)NSString *WICKETEVENT;
@property(nonatomic,strong)NSString *ISSYNC;

-(NSDictionary *)WicketEventsPushRecordDictionary;


@end
