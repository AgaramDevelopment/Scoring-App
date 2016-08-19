//
//  FETCHSELASTINSTANCEDTLS.h
//  CAPScoringApp
//
//  Created by Mac on 16/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FETCHSELASTINSTANCEDTLS : NSObject
-(void) FetchLastinstance:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)ISDEFAULTORLAST;
@property(nonatomic,strong) NSMutableArray *ballEventsArray;
@end
