//
//  SessionEventPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 03/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionEventPushRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSNumber *DAYNO;
@property(nonatomic,strong)NSNumber *SESSIONNO;
@property(nonatomic,strong)NSString *SESSIONSTARTTIME;
@property(nonatomic,strong)NSString *SESSIONENDTIME;
@property(nonatomic,strong)NSString *BATTINGTEAMCODE;
@property(nonatomic,strong)NSNumber *STARTOVER;
@property(nonatomic,strong)NSNumber *ENDOVER;
@property(nonatomic,strong)NSNumber *TOTALRUNS;
@property(nonatomic,strong)NSNumber *TOTALWICKETS;
@property(nonatomic,strong)NSString *DOMINANTTEAMCODE;
@property(nonatomic,strong)NSNumber *SESSIONSTATUS;
@property(nonatomic,strong)NSString *ISSYNC;


@end
