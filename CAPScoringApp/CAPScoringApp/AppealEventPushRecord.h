//
//  AppealEventPushRecord.h
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppealEventPushRecord : NSObject

@property(nonatomic,strong)NSString *BALLCODE;
@property(nonatomic,strong)NSString *APPEALTYPECODE;
@property(nonatomic,strong)NSString *APPEALSYSTEMCODE;
@property(nonatomic,strong)NSString *APPEALCOMPONENTCODE;
@property(nonatomic,strong)NSString *UMPIRECODE;
@property(nonatomic,strong)NSString *BATSMANCODE;
@property(nonatomic,strong)NSString *ISREFERRED;
@property(nonatomic,strong)NSString *APPEALDECISION;
@property(nonatomic,strong)NSString *APPEALCOMMENTS;
@property(nonatomic,strong)NSString *FIELDERCODE;
@property(nonatomic,strong)NSString *COMPETITIONCODE;
@property(nonatomic,strong)NSString *MATCHCODE;
@property(nonatomic,strong)NSString *TEAMCODE;
@property(nonatomic,strong)NSString *INNINGSNO;
@property(nonatomic,strong)NSString *ISSYNC;

@end
