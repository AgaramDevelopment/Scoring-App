//
//  FixturesCell.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 5/24/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixturesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_teamA;
@property (strong, nonatomic) IBOutlet UILabel *lbl_teamB;
@property (strong, nonatomic) IBOutlet UILabel *lbl_stadium;
@property (strong, nonatomic) IBOutlet UILabel *lbl_state;
@property (strong, nonatomic) IBOutlet UILabel *lbl_date;
@property (strong, nonatomic) IBOutlet UILabel *lbl_monthandyear;
@property(nonatomic,strong) IBOutlet UIButton * btn_info;
- (IBAction)btn_info:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_time;
@property (strong, nonatomic) IBOutlet UIView  *viewborder;
//@property (strong, nonatomic) IBOutlet   *txt_info;
@end
