//
//  CaptransactionslogEntryRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 05/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaptransactionslogEntryRecord : NSObject

@property (nonatomic,strong) NSString * MATCHCODE;
@property (nonatomic,strong) NSString * TABLENAME;
@property (nonatomic,strong) NSString * SCRIPTTYPE;
@property (nonatomic,strong) NSString * SCRIPTDATA;
@property (nonatomic,strong) NSString * SCRIPTSTATUS;
@property (nonatomic,strong) NSString * SEQNO;


@end
