//
//  PlayerWormChart.h
//  CAPScoringApp
//
//  Created by Raja sssss on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerWormChart : NSObject

@property(nonatomic,assign)NSInteger MAXINN;
@property(nonatomic,assign)NSInteger ICOUNT;
@property(nonatomic,assign)NSInteger LOOPCOUNT;
@property(nonatomic,assign)NSInteger PERFORMANCELOOPCOUNT;

@property(strong,nonatomic)NSString *MAXOVERSTRIKER;
@property(strong,nonatomic)NSString *MINOVERSTRIKER;
@property(strong,nonatomic)NSString *MAXOVERSTRIKERBALL;
@property(strong,nonatomic)NSString *MINOVERSTRIKERBALL;
@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *TEAMCODE;


@property(strong,nonatomic)NSString *ISMULTIDAY;

@property(strong,nonatomic)NSString *TEAMNAME;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *ACTUALOVER;
@property(strong,nonatomic)NSString *OVERBYOVER;
@property(strong,nonatomic)NSString *BALLNO;
@property(strong,nonatomic)NSString *BALLCOUNT;


@property(strong,nonatomic)NSString *MAXBALLCOUNT;

@property(strong,nonatomic)NSString *STRIKERNAME;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *BOWLERNAME;
@property(strong,nonatomic)NSString *WICKETNO;
@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *WICKERDESCRIPTION;

@property(strong,nonatomic)NSString *WICKETPLAYER;
@property(strong,nonatomic)NSString *STRIKERRUNS;
@property(strong,nonatomic)NSString *BOWLERRUNS;

@property(strong,nonatomic)NSMutableArray *playerWormList;

-(void)fetchPlayerWormChart: (NSString*) COMPETITIONCODE :(NSString*)MATCHCODE;

@end