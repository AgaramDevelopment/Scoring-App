//
//  FetchBattingTeamTossRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchBattingTeamTossRecord : NSObject
@property(nonatomic,strong) NSString * playerName;
@property(nonatomic,strong) NSString * playerCode;
@property(nonatomic,strong) NSString * RecordStatus;


@property(strong,nonatomic)NSString *TEAMCODE_TOSSWONBY;
@property(strong,nonatomic)NSString *TEAMNAME_TOSSWONBY;
@end
