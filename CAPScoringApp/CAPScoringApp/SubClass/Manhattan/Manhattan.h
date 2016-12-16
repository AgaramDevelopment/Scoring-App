//
//  Manhattan.h
//  CAPScoringApp
//
//  Created by APPLE on 28/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Manhattan : UIViewController

@property (nonatomic,strong) NSString * compititionCode;

@property (nonatomic,strong) NSString * matchCode;

@property (nonatomic,strong) NSString * matchTypecode;

@property(strong,nonatomic)NSString *fstInnShortName;

@property(strong,nonatomic)NSString *secInnShortName;

@property(strong,nonatomic)NSString *thrdInnShortName;

@property(strong,nonatomic)NSString *frthInnShortName;



@property (nonatomic,strong) IBOutlet UIImageView * bg_Img;

@property (nonatomic,strong) IBOutlet UIScrollView * manhattan_Scroll;

@end
