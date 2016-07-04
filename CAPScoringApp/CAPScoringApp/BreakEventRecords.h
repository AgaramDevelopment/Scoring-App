//
//  BreakEventRecords.h
//  CAPScoringApp
//
//  Created by Lexicon on 18/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BreakEventRecords : NSObject
@property(strong,nonatomic)NSString *BREAKNO;
@property(strong,nonatomic)NSString *BREAKSTARTTIME;
@property(strong,nonatomic)NSString *BREAKENDTIME;
@property(strong,nonatomic)NSString *ISINCLUDEINPLAYERDURATION;
@property(strong,nonatomic)NSString *BREAKCOMMENTS;
@property(strong,nonatomic)NSString *DURATION;

@end
