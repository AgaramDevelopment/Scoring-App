//
//  ReportCell.h
//  CAPScoringApp
//
//  Created by APPLE on 29/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UICollectionViewCell

@property (nonatomic,strong) IBOutlet UILabel * tittl_lbl;
@property (strong, nonatomic) IBOutlet UILabel *seprator_lbl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sepratorXposition;

@end
