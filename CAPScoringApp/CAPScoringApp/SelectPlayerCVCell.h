//
//  SelectPlayerCVCell.h
//  CAPScoringApp
//
//  Created by APPLE on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPlayerCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_player_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_player_code;
@property (weak, nonatomic) IBOutlet UIImageView *img_selector;
@property (weak, nonatomic) IBOutlet UIImageView *img_player;

@end
