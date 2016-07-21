//
//  BOWLINGMAIDENSUMMARYPushRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/4/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOWLINGMAIDENSUMMARYPushRecord : NSObject
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSNumber *INNINGSNO;
@property(nonatomic,strong)NSString *BOWLERCODE;
@property(nonatomic,strong)NSNumber *OVERS;
@property(nonatomic,strong)NSString *ISSYNC;
-(NSDictionary *)BOWLINGMAIDENSUMMARYPushRecordDictionary;
@end
