//
//  Breaks.h
//  CAPScoringApp
//
//  Created by Stephen on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

//SP_INSERTBREAK,SP_UPDATEBREAKS,SP_DELETEBREAKS
@interface BreakDetails : NSObject
@property(strong,nonatomic)NSString *BREAKNO;
@property(strong,nonatomic)NSString *BREAKSTARTTIME;
@property(strong,nonatomic)NSString *BREAKENDTIME;
@property(strong,nonatomic)NSString *ISINCLUDEINPLAYERDURATION;
@property(strong,nonatomic)NSString *BREAKCOMMENTS;
@end


