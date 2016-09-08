//
//  BattingPlayerStatistics.h
//  CAPScoringApp
//
//  Created by APPLE on 08/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BattingPlayerStatistics : NSObject

-(NSMutableArray*)  GetFETCHSBBATTINGPLAYERSTATISTICSWagon :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE;

-(NSMutableArray*)  GetFETCHSBBATTINGPLAYERSTATISTICSPitch :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE;

-(NSMutableArray*) GetBATSMANTIMEDETAILS :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE;

@end
