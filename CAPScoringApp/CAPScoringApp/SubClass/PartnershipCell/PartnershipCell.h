//
//  PartnershipCell.h
//  CAPScoringApp
//
//  Created by APPLE on 10/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnershipCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel * strikerName_lbl;

@property (nonatomic,strong) IBOutlet UILabel * nonstrikerName_lbl;

@property (nonatomic,strong) IBOutlet UILabel * comparestriker_lbl;

@property (nonatomic,strong) IBOutlet UIProgressView * striker_progress;

@property (nonatomic,strong) IBOutlet UIProgressView * nonStriker_progress;

@property (nonatomic,strong) IBOutlet UIProgressView * combination_progress;

@property (nonatomic,strong) IBOutlet UIProgressView * combinationnonStriker;

@end
