//
//  DAYEVENTSPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/4/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAYEVENTSPushRecord : NSObject

@property(nonatomic,strong) NSString *COMPETITIONCODE;
@property(nonatomic,strong) NSString *MATCHCODE;
@property(nonatomic,strong) NSNumber *INNINGSNO;
@property(nonatomic,strong) NSNumber *DAYNO;
@property(nonatomic,strong) NSString *STARTTIME;
@property(nonatomic,strong) NSString *ENDTIME;
@property(nonatomic,strong) NSString *BATTINGTEAMCODE;
@property(nonatomic,strong) NSNumber *TOTALOVERS;
@property(nonatomic,strong) NSNumber *TOTALRUNS;
@property(nonatomic,strong) NSNumber *TOTALWICKETS;
@property(nonatomic,strong) NSString *COMMENTS;
@property(nonatomic,strong) NSNumber *DAYSTATUS;
@property(nonatomic,strong) NSString *ISSYNC;



@end
