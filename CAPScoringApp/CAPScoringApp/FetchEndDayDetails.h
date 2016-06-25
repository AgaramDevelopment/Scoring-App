//
//  FetchEndDayDetails.h
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchEndDayDetails : NSObject
@property(strong,nonatomic)NSString *STARTDATE;
@property(strong,nonatomic)NSString *DAYNIGHT;
@property(strong,nonatomic) NSMutableArray *FetchEndDayArray;
@property(strong,nonatomic)NSNumber *DAYNO;
@property(strong,nonatomic)NSString *TEAMNAME;
@property(strong,nonatomic)NSString *RUNS;
@property(strong,nonatomic)NSString *OVERBALLNO;

@property(strong,nonatomic)NSString *WICKETS;



-(void) FetchEndDay:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSNumber*)INNINGSNO;
@end
