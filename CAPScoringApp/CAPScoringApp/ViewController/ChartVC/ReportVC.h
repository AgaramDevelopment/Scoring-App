//
//  ChartVC.h
//  CAPScoringApp
//
//  Created by APPLE on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportVC : UIViewController
//@property (strong, nonatomic) IBOutlet UIView *commonView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sepratoryposition;
//@property (strong, nonatomic)  UIScrollView *scrolllistview;


@property (nonatomic, weak) IBOutlet UIView *referencedView;

@property(strong,nonatomic)NSString * matchCode;

@property (strong, nonatomic) IBOutlet UICollectionView *Tittle_scroll;
@property(strong,nonatomic)NSString * competitionCode;

@property (strong ,nonatomic) NSString * matchTypeCode;

@property (strong,nonatomic) NSString * teamcode;


@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;

@end
