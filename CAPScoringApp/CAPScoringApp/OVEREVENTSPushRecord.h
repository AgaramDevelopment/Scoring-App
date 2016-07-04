//
//  OVEREVENTSPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVEREVENTSPushRecord : NSObject
@property (nonatomic,strong) NSString * COMPETITIONCODE;
@property (nonatomic,strong) NSString * MATCHCODE;
@property (nonatomic,strong) NSString * TEAMCODE;
@property (nonatomic,strong) NSNumber * INNINGSNO;
@property (nonatomic,strong) NSNumber * OVERNO;
@property (nonatomic,strong) NSNumber * OVERSTATUS;
@property (nonatomic,strong) NSString * ISSYNC;


@end
