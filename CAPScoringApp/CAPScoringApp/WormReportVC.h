//
//  WormReportVC.h
//  CAPScoringApp
//
//  Created by Mac on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WormReportVC : UIViewController
@property(strong,nonatomic)NSString *matchCode;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *compititionCode;

@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;
//@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;

@end
