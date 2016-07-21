//
//  MatchRegistrationPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchRegistrationPushRecord : NSObject

@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *MATCHNAME;
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHOVERS;
@property(nonatomic,strong)NSString *MATCHOVERCOMMENTS;
@property(nonatomic,strong)NSString *MATCHDATE;
@property(nonatomic,strong)NSString *ISDAYNIGHT;
@property(nonatomic,strong)NSString *ISNEUTRALVENUE;
@property(nonatomic,strong)NSString *GROUNDCODE;
@property(nonatomic,strong)NSString *TEAMACODE;
@property(nonatomic,strong)NSString *TEAMBCODE;
@property(nonatomic,strong)NSString *TEAMACAPTAIN;
@property(nonatomic,strong)NSString *TEAMAWICKETKEEPER;
@property(nonatomic,strong)NSString *TEAMBCAPTAIN;
@property(nonatomic,strong)NSString *TEAMBWICKETKEEPER;
@property(nonatomic,strong)NSString *UMPIRE1CODE;
@property(nonatomic,strong)NSString *UMPIRE2CODE;
@property(nonatomic,strong)NSString *UMPIRE3CODE;
@property(nonatomic,strong)NSString *MATCHREFEREECODE;
@property(nonatomic,strong)NSString *VIDEOLOCATION;
@property(nonatomic,strong)NSString *MATCHRESULT;
@property(nonatomic,strong)NSString *MATCHRESULTTEAMCODE;
@property(nonatomic,strong)NSString *TEAMAPOINTS;
@property(nonatomic,strong)NSString *TEAMBPOINTS;
@property(nonatomic,strong)NSString *MATCHSTATUS;
@property(nonatomic,strong)NSString *RECORDSTATUS;
@property(nonatomic,strong)NSString *CREATEDBY;
@property(nonatomic,strong)NSString *CREATEDDATE;
@property(nonatomic,strong)NSString *MODIFIEDBY;
@property(nonatomic,strong)NSString *MODIFIEDDATE;
@property(nonatomic,strong)NSString *ISDEFAULTORLASTINSTANCE;
@property(nonatomic,strong)NSString *ISSYNC;
-(NSDictionary *)MatchRegistrationPushRecordDictionary;
@end
