//
//  PlayerWormChart.m
//  CAPScoringApp
//
//  Created by Raja sssss on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerWormChart.h"
#import "DBManagerPlayerWormChart.h"
#import "PlayerWormChartRecords.h"

@implementation PlayerWormChart

@synthesize MAXINN;
@synthesize ICOUNT;
@synthesize LOOPCOUNT;
@synthesize PERFORMANCELOOPCOUNT;

@synthesize MAXOVERSTRIKER;
@synthesize MINOVERSTRIKER;
@synthesize MAXOVERSTRIKERBALL;
@synthesize MINOVERSTRIKERBALL;
@synthesize STRIKERCODE;
@synthesize TEAMCODE;
@synthesize playerWormList;


@synthesize TEAMNAME;
@synthesize INNINGSNO;
@synthesize ACTUALOVER;
@synthesize OVERBYOVER;
@synthesize BALLNO;
@synthesize BALLCOUNT;


@synthesize MAXBALLCOUNT;

@synthesize STRIKERNAME;
@synthesize BOWLERCODE;
@synthesize BOWLERNAME;
@synthesize WICKETNO;
@synthesize BALLCODE;
@synthesize WICKERDESCRIPTION;

@synthesize WICKETPLAYER;
@synthesize STRIKERRUNS;
@synthesize BOWLERRUNS;

int TEAMTOTALPLAYERS;


-(void)fetchPlayerWormChart: (NSString*) COMPETITIONCODE :(NSString*)MATCHCODE   {
    
    
    DBManagerPlayerWormChart *dbPlayer = [[DBManagerPlayerWormChart alloc]init];
    
    playerWormList = [[NSMutableArray alloc]init];
    MAXINN = 1;
    ICOUNT = 1;
    
    STRIKERCODE = @"";
    TEAMCODE = @"";
    
    MAXINN =  [dbPlayer fetchMaxInnsNo: MATCHCODE].integerValue;
    
    while (MAXINN>=ICOUNT) {
        
        TEAMCODE = [dbPlayer FetchTeamCode:COMPETITIONCODE :MATCHCODE :ICOUNT];
        
        NSString *teamCount = [dbPlayer FetchTeamCount:TEAMCODE :MATCHCODE];
        
        TEAMTOTALPLAYERS = [teamCount integerValue];
        
        NSString *performanceCount = [dbPlayer FetchMinBatNo:MATCHCODE :ICOUNT];
        
        PERFORMANCELOOPCOUNT = [performanceCount integerValue];
        
        LOOPCOUNT =	PERFORMANCELOOPCOUNT;
        
        
        while (LOOPCOUNT <= TEAMTOTALPLAYERS) {
            
            STRIKERCODE = [dbPlayer FetchStrikerCode:MATCHCODE :ICOUNT :LOOPCOUNT];
            
            if (STRIKERCODE != nil && ![STRIKERCODE isEqualToString:@""]) {
                
                
                NSMutableArray *overArray = [dbPlayer fetchMinAndMaxOver:COMPETITIONCODE :MATCHCODE :ICOUNT :STRIKERCODE];
                if(overArray.count>0){
                    
                    PlayerWormChartRecords *fetchminAndMax =[overArray objectAtIndex:0];
                    MINOVERSTRIKER = fetchminAndMax.MINOVERSTRIKER;
                    MAXOVERSTRIKER = fetchminAndMax.MAXOVERSTRIKER;
                    
                }
                
                
                if (MINOVERSTRIKER == nil || [MINOVERSTRIKER isEqualToString:@""]) {
                    
                    NSMutableArray *overNotEqualArray = [dbPlayer fetchMinAndMaxOverNotEqual:COMPETITIONCODE :MATCHCODE :ICOUNT :STRIKERCODE];
                    if(overNotEqualArray.count>0){
                        PlayerWormChartRecords *fetchminAndMaxNotEqual =[overNotEqualArray objectAtIndex:0];
                        MINOVERSTRIKER = fetchminAndMaxNotEqual.MINOVERSTRIKER;
                        MAXOVERSTRIKER = fetchminAndMaxNotEqual.MAXOVERSTRIKER;
                        
                    }
                    
                }
                
                MINOVERSTRIKERBALL = [dbPlayer FetchMinBall:COMPETITIONCODE :MATCHCODE :ICOUNT :STRIKERCODE :MINOVERSTRIKER];
                
                
                if (MINOVERSTRIKERBALL == nil || [MINOVERSTRIKERBALL isEqualToString:@""]) {
                    
                    MINOVERSTRIKERBALL = [dbPlayer FetchMaxBallEquals:COMPETITIONCODE :MATCHCODE :ICOUNT :STRIKERCODE :MAXOVERSTRIKER];
                }
                
                
                
                
                MAXOVERSTRIKERBALL=[dbPlayer FetchMinBall:COMPETITIONCODE :MATCHCODE :ICOUNT :STRIKERCODE :MAXOVERSTRIKER];
                
                
                if (MAXOVERSTRIKERBALL == nil || [MAXOVERSTRIKERBALL isEqualToString:@""]) {
                    
                    MAXOVERSTRIKERBALL = [dbPlayer FetchMaxBallEquals:COMPETITIONCODE :MATCHCODE :ICOUNT :STRIKERCODE :MAXOVERSTRIKER];
                }
                
                
                
                
                NSMutableArray *overNotEqualArray = [dbPlayer fetchPlayerWormdetails:COMPETITIONCODE :MATCHCODE :STRIKERCODE];
                
                for(int i=0;i<overNotEqualArray.count;i++){
                    
                    [playerWormList addObject:[overNotEqualArray objectAtIndex:i]];
                }
                
//                if(overNotEqualArray.count>0){
//                    
//                    
//                    
//                    
//                    
//                    PlayerWormChartRecords *fetchPlayerDetails =[overNotEqualArray objectAtIndex:0];
//                    
//                    _ISMULTIDAY = fetchPlayerDetails.ISMULTIDAY;
//                    TEAMCODE = fetchPlayerDetails.TEAMCODE;
//                    TEAMNAME = fetchPlayerDetails.TEAMNAME;
//                    INNINGSNO = fetchPlayerDetails.INNINGSNO;
//                    ACTUALOVER = fetchPlayerDetails.ACTUALOVER;
//                    OVERBYOVER = fetchPlayerDetails.OVERBYOVER;
//                    BALLNO = fetchPlayerDetails.BALLNO;
//                    BALLCOUNT = fetchPlayerDetails.BALLCOUNT;
//                    MAXBALLCOUNT = fetchPlayerDetails.MAXBALLCOUNT;
//                    STRIKERCODE = fetchPlayerDetails.STRIKERCODE;
//                    STRIKERNAME = fetchPlayerDetails.STRIKERNAME;
//                    BOWLERCODE = fetchPlayerDetails.BOWLERCODE;
//                    BOWLERNAME = fetchPlayerDetails.BOWLERNAME;
//                    WICKETNO = fetchPlayerDetails.WICKETNO;
//                    BALLCODE = fetchPlayerDetails.BALLNO;
//                    WICKERDESCRIPTION = fetchPlayerDetails.WICKERDESCRIPTION;
//                    WICKETPLAYER = fetchPlayerDetails.WICKETPLAYER;
//                    STRIKERRUNS = fetchPlayerDetails.STRIKERRUNS;
//                    BOWLERRUNS = fetchPlayerDetails.BOWLERRUNS;
//                    
//                    
//                    
//                }
                
                
            }
            
            
            LOOPCOUNT = LOOPCOUNT + 1;
            
        }
        
        ICOUNT = ICOUNT + 1;
    }
    
    
}

@end
