//
//  FetchLastBowler.h
//  CAPScoringApp
//
//  Created by APPLE on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchLastBowler : NSObject

@property(strong,nonatomic)NSMutableArray *GetLastBolwerDetails;
-(void)LastBowlerDetails:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*) INNINGSNO: (NSNumber*) OVERNO : (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT;
@end
