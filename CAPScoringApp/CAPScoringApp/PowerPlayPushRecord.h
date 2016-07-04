//
//  PowerPlayPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerPlayPushRecord : NSObject
@property(nonatomic,strong)NSString *POWERPLAYCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *INNINGSNO;
@property(nonatomic,strong)NSNumber *STARTOVER;
@property(nonatomic,strong)NSNumber *ENDOVER;
@property(nonatomic,strong)NSString *POWERPLAYTYPE;
@property(nonatomic,strong)NSString *RECORDSTATUS;
@property(nonatomic,strong)NSString *CREATEDBY;
@property(nonatomic,strong)NSString *CREATEDDATE;
@property(nonatomic,strong)NSString *MODIFIEDBY;
@property(nonatomic,strong)NSString *MODIFIEDDATE;
@property(nonatomic,strong)NSString *ISSYNC;
@end
