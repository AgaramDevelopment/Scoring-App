//
//  DeleteEventRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteEventRecord : NSObject

@property(strong,nonatomic)NSString *BREAKNO;
@property(strong,nonatomic)NSString *BREAKSTARTTIME;
@property(strong,nonatomic)NSString *BREAKENDTIME;
@property(strong,nonatomic)NSString *DURATION;
@property(strong,nonatomic)NSString *ISINCLUDEINPLAYERDURATION;
@property(strong,nonatomic)NSString *BREAKCOMMENTS;
@end
