//
//  intialBreakVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 18/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCardVC.h"

@interface intialBreakVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *firsttouch;
- (IBAction)Firsttouch_btn:(id)sender;

@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSString*INNINGSNO;
@end
