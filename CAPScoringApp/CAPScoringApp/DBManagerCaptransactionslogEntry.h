//
//  DBManagerCaptransactionslogEntry.h
//  CAPScoringApp
//
//  Created by APPLE on 05/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerCaptransactionslogEntry : NSObject
-(NSMutableArray *) GetCaptransactionslogentry;
-(BOOL)updateCaptransactionslogentry:(NSString*)SCRIPTSTATUS matchCode:(NSString*) matchCode SEQNO:(NSString*)SEQNO;
-(NSMutableArray *) deactivateCaptransactionslogentry;
-(NSMutableArray *) deactivateCaptransactionsLogEntryByMatchCode : (NSString *) matchCode;
@end
