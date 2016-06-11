//
//  Archive.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 10/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Archive : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel * lbl_teamname;
@property(nonatomic,strong) IBOutlet UILabel * lbl_groundName;
@property(nonatomic,strong) IBOutlet UILabel * lbl_cityname;
@property(nonatomic,strong) IBOutlet UIButton * Btn_swipebutton;
@property(nonatomic,strong) IBOutlet UILabel * lbl_date;
@property(nonatomic,strong) IBOutlet UILabel * lbl_displaydate;
@end
