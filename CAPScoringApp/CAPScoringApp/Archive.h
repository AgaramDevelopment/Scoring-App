//
//  Archive.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 10/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwipeableCellDelegate <NSObject>
- (void)buttonOneActionForItemText:(NSString *)itemText;
- (void)buttonTwoActionForItemText:(NSString *)itemText;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface Archive : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel * lbl_teamname;
@property(nonatomic,strong) IBOutlet UILabel * lbl_groundName;
@property(nonatomic,strong) IBOutlet UILabel * lbl_cityname;
@property(nonatomic,strong) IBOutlet UIButton * Btn_swipebutton;
@property(nonatomic,strong) IBOutlet UILabel * lbl_date;
@property(nonatomic,strong) IBOutlet UILabel * lbl_displaydate;

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
@property (nonatomic, strong) NSString *itemText;

- (void)openCell;

@end
