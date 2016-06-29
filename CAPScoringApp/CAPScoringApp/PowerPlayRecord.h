//
//  PowerPlayRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/22/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerPlayRecord : NSObject
@property(strong,nonatomic)NSString *competitioncode;
@property(strong,nonatomic)NSString *matchcode;
@property(strong,nonatomic)NSString *inningsno;
@property(strong,nonatomic)NSString *startover;
@property(strong,nonatomic)NSString *endover;
@property(strong,nonatomic)NSString *powerplaytype;
@property(strong,nonatomic)NSString *recordstatus;
@property(strong,nonatomic)NSString *createdby;
@property(strong,nonatomic)NSString *crateddate;
@property(strong,nonatomic)NSString *modifyby;
@property(strong,nonatomic)NSString *modifydate;
@property(strong,nonatomic)NSString *powerplaytypecode;
@property(strong,nonatomic)NSString *powerplaytypename;
@property(strong,nonatomic)NSString *issystemreference;
@property(strong,nonatomic)NSString *powerplaycode;
@property(strong,nonatomic)NSString *totalovers;
@end
