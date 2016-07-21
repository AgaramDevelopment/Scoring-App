//
//  CapTransactionslogentryPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CapTransactionslogentryPushRecord : NSObject

@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *TABLENAME;
@property(nonatomic,strong)NSString *SCRIPTTYPE;
@property(nonatomic,strong)NSString *SCRIPTDATA;
@property(nonatomic,strong)NSString *USERID;
@property(nonatomic,strong)NSString *LOGDATETIME;
@property(nonatomic,strong)NSString *SCRIPTSTATUS;
@property(nonatomic,strong)NSNumber *SEQNO;
@property(nonatomic,strong)NSString *ISSYNC;
-(NSDictionary *)CapTransactionslogentryPushRecordDictionary ;
@end
