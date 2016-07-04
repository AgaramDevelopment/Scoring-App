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
@property(nonatomic,strong) NSString *INNINGSNO;
@property(nonatomic,strong) NSString *DAYNO;
@property(nonatomic,strong) NSString *STARTTIME;
@property(nonatomic,strong) NSString *ENDTIME;
@property(nonatomic,strong) NSString *BATTINGTEAMCODE;
@property(nonatomic,strong) NSString *TOTALOVERS;
@property(nonatomic,strong) NSString *TOTALRUNS;
@property(nonatomic,strong) NSString *TOTALWICKETS;
@property(nonatomic,strong) NSString *COMMENTS;
@property(nonatomic,strong) NSString *DAYSTATUS;



@end
