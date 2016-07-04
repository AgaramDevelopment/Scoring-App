//
//  INNINGSBREAKEVENTSPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INNINGSBREAKEVENTSPushRecord : NSObject

@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *INNINGSNO;
@property(nonatomic,strong)NSString *BREAKNO;
@property(nonatomic,strong)NSString *BREAKSTARTTIME;
@property(nonatomic,strong)NSString *BREAKENDTIME;
@property(nonatomic,strong)NSString *ISINCLUDEINPLAYERDURATION;
@property(nonatomic,strong)NSString *BREAKCOMMENTS;
@property(nonatomic,strong)NSString *issync;


@end
