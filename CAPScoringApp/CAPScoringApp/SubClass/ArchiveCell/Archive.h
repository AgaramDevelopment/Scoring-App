//
//  Archive.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 10/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwipeableCellDelegate <NSObject>
- (void)RightSideEditBtnAction;
- (void)RightsideResumeBtnAction:(UIButton*)sender;
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



@property(nonatomic,strong) IBOutlet UIButton * Btn_Resume;
@property(strong,nonatomic) IBOutlet UILabel * innings1teamname1;
@property(strong,nonatomic) IBOutlet UILabel * innings1teamname2;
@property(strong,nonatomic) IBOutlet UILabel * innings1team1runs;
@property(strong,nonatomic) IBOutlet UILabel * innings1team2runs;
@property(strong,nonatomic) IBOutlet UILabel * innings1team1overs;
@property(strong,nonatomic) IBOutlet UILabel * innings1team2overs;

@property(strong,nonatomic) IBOutlet UILabel * innings2teamname1;
@property(strong,nonatomic) IBOutlet UILabel * innings2teamname2;
@property(strong,nonatomic) IBOutlet UILabel * innings2team1runs;
@property(strong,nonatomic) IBOutlet UILabel * innings2team2runs;
@property(strong,nonatomic) IBOutlet UILabel * innings2team1overs;
@property(strong,nonatomic) IBOutlet UILabel * innings2team2overs;
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
@property (nonatomic, strong) NSString *itemText;

- (void)openCell;

@end
