//
//  FETCHSEBALLCODEDETAILS.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FETCHSEBALLCODEDETAILS : NSObject
-(void) FetchSEBallCodeDetails:(NSString *)COMPETITIONCODE :(NSString *)MATCHCODE :(NSString*)BALLCODE;

@property (strong,nonatomic) NSMutableArray *GetBallDetailsForBallEventsArray;
@end
