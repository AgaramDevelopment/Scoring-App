//
//  PlayerOrderLevelVC.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 01/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PlayerOrderLevelVC : UIViewController
{
    NSMutableArray *arrayOfItems;
}
@property(nonatomic,strong) NSMutableArray *objSelectplayerList_Array;

@property (strong,nonatomic) NSString *TeamCode;
//@property (strong,nonatomic) NSString *MatchCode;


@property(strong,nonatomic) NSString *teamA;
@property(strong,nonatomic) NSString *teamB;
@property(strong,nonatomic) NSString *matchType;
@property(strong,nonatomic) NSString *overs;
@property(strong,nonatomic) NSString *date;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *matchVenu;
@property(strong,nonatomic) NSString *month;
@property(strong,nonatomic) NSString *matchCode;
@property(strong,nonatomic) NSString *competitionCode;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *teamAcode;
@property(strong,nonatomic)NSString *teamBcode;

@property(nonatomic,strong) NSString *chooseTeam;


@end
