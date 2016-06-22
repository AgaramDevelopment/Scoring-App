//
//  FetchMatchResult.h
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FetchMatchResult : NSObject

@property(nonatomic,strong) NSMutableArray *GetMatchResultTypeAndCode;

@property(nonatomic,strong) NSMutableArray * GetTeamANameDetail;

@property(nonatomic,strong)  NSMutableArray * GetTeamBNameDetail;

@property(nonatomic,strong) NSMutableArray * GetManOfTheMatchDetail;

@property(nonatomic,strong)  NSMutableArray * GetManOfTheSeriesDetails;

@property(nonatomic,strong)  NSMutableArray * GetBestBatsManDetails;

@property(nonatomic,strong) NSMutableArray * GetBestBowlerDetails;

@property(nonatomic,strong) NSMutableArray * GetMatchResultDetails;

@property(nonatomic,strong) NSMutableArray * GetBestPlayerDetails;


-(void) getMatchReultsDetails:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)TEAMCODE :(NSNumber*)INNINGSNO;
@end
