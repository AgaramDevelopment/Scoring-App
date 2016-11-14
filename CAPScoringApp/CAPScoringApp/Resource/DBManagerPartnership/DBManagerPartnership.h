//
//  DBManagerPartnership.h
//  CAPScoringApp
//
//  Created by APPLE on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerPartnership : NSObject

-(NSMutableArray *) getPartnershipdetail :(NSString *) COMPETITIONCODES :(NSString *) MATCHCODES:(NSString *) TEAMCODES :(NSString *) INNINGS;

@end
