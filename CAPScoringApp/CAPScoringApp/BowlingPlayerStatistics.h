//
//  BowlingPlayerStatistics.h
//  CAPScoringApp
//
//  Created by APPLE on 08/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BowlingPlayerStatistics : NSObject


-(NSMutableArray*)  GetFETCHSBBOWLINGPLAYERSTATISTICSWagon :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE;

-(NSMutableArray*)  GetFETCHSBBOWLINGPLAYERSTATISTICSPitch :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE;



@end
