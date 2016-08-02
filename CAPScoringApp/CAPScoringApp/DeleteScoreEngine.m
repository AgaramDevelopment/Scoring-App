//
//  DeleteScoreEngine.m
//  CAPScoringApp
//
//  Created by mac on 09/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DeleteScoreEngine.h"

@implementation DeleteScoreEngine
-(void)DeleteScoreEngineMethod : (NSString*)BALLCODE : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSString*)INNINGSNO : (NSString*)STRIKERCODE : (NSString*)BOWLERCODE : (NSString*)REVERT
{
    NSString* BATTINGTEAMCODE = @"";
    NSString* BOWLINGTEAMCODE = @"";
    
    NSNumber *MATCHOVERS;
    
    NSNumber *S_INNINGSNO = [NSNumber numberWithInt:0];
    NSNumber *S_OVERNO = [NSNumber numberWithInt:0];
    NSNumber *S_BALLNO = [NSNumber numberWithInt:0];
    NSNumber *S_BALLCOUNT = [NSNumber numberWithInt:0];
    NSNumber *S_NOBALL = [NSNumber numberWithInt:0];
    NSNumber *S_WIDE = [NSNumber numberWithInt:0];
    
    NSNumber *ISWICKETUNDO = [NSNumber numberWithInt:0];
    NSString* WICKETPLAYER;
    
    NSString* SB_STRIKERCODE = STRIKERCODE;
    NSString* SB_BOWLERCODE = BOWLERCODE;
    NSString* SB_NONSTRIKERCODE;
    NSInteger MAXINNINGS;
    NSInteger MAXOVER;
    NSInteger MAXBALL;
    NSInteger MAXBALLCOUNT;
    NSInteger MAXSESSIONNO;
    NSInteger MAXDAYNO;
    
    NSInteger BATTEAMOVERS = 0;
    NSInteger BATTEAMOVRWITHEXTRASBALLS = 0;
    NSInteger BATTEAMOVRBALLSCNT = 0;
    
    NSString* CURRENTSTRIKERCODE;
    NSString* CURRENTNONSTRIKERCODE;
    NSString* CURRENTBOWLERCODE;
    
    NSInteger F_ISWICKET = 0;
    NSInteger F_ISWICKETCOUNTABLE = 0;
    NSString* F_WICKETTYPE = @"";
    
    NSInteger BC_BALLNO = 0;
    NSInteger BC_BALLCOUNT = 0;
    
    NSString* OTHERBOWLER = @"";
    
    NSInteger OTHERBOWLEROVERBALLCNT = 0;
}
@end
