//
//  PlayerLevelCell.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 02/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerOrderLevelVC.h"
@interface PlayerLevelCell : UITableViewCell

@property(nonatomic,strong)  UIView *mainview;
@property(nonatomic,strong)  UILabel *Lbl_playerordernumber;
@property(nonatomic,strong)  UILabel * lbl_playerName;
@property(nonatomic,strong)  UIImageView * Img_drag;
@property(nonatomic,strong)  UIButton *Btn_drag;
@property(nonatomic,strong)  UIImageView *Img_wktkeeper;
@property(nonatomic,strong)  UIImageView * IMg_captain;
@property(nonatomic,strong)  UIButton   * Btn_Captain;
@property(nonatomic,strong)  UIButton  * Btn_WktKeeper;

@end
