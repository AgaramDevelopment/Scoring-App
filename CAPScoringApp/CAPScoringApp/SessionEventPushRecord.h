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
@property(nonatomic,strong)NSString *INNINGSNO;
@property(nonatomic,strong)NSString *DAYNO;
@property(nonatomic,strong)NSString *SESSIONNO;
@property(nonatomic,strong)NSString *SESSIONSTARTTIME;
@property(nonatomic,strong)NSString *SESSIONENDTIME;
@property(nonatomic,strong)NSString *BATTINGTEAMCODE;
@property(nonatomic,strong)NSString *STARTOVER;
@property(nonatomic,strong)NSString *ENDOVER;
@property(nonatomic,strong)NSString *TOTALRUNS;
@property(nonatomic,strong)NSString *TOTALWICKETS;
@property(nonatomic,strong)NSString *DOMINANTTEAMCODE;
@property(nonatomic,strong)NSString *SESSIONSTATUS;
@property(nonatomic,strong)NSString *ISSYNC;


@end
