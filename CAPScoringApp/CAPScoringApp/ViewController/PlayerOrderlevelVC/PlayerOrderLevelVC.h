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
- (void)updateCurrentLocation:(UILongPressGestureRecognizer *)gesture;

@end
