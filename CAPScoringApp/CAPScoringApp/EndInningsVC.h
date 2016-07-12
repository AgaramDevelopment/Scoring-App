//
//  EndInningsVC.h
//  CAPScoringApp
//
//  Created by mac on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EndInningsVCDelagate <NSObject>
@required

- (void) EndInningsBackBtnAction;
- (void) EndInningsSaveBtnAction;

@end

@interface EndInningsVC : UIViewController

{
    UIDatePicker *datePicker;
}

@property(nonatomic,strong) id <EndInningsVCDelagate> delegate;

@property (strong,nonatomic) NSString *MATCHCODE;

@property (weak, nonatomic) IBOutlet UIView *view_allControls;

@property (weak, nonatomic) IBOutlet UIView *view_startInnings;
@property (weak, nonatomic) IBOutlet UIView *view_endInnings;
@property (weak, nonatomic) IBOutlet UIView *view_duration;
@property (weak, nonatomic) IBOutlet UIView *view_teamName;
@property (weak, nonatomic) IBOutlet UIView *view_runScored;

@property (weak, nonatomic) IBOutlet UIView *view_OverPlayed;
@property (weak, nonatomic) IBOutlet UIView *view_wkts;
@property (weak, nonatomic) IBOutlet UIView *view_innings;


@property (weak, nonatomic) IBOutlet UILabel *lbl_startInnings;

@property (weak, nonatomic) IBOutlet UILabel *lbl_endInnings;

@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;

@property (weak, nonatomic) IBOutlet UILabel *lbl_teamName;

@property (weak, nonatomic) IBOutlet UILabel *lbl_runScored;
@property (weak, nonatomic) IBOutlet UILabel *lbl_overPlayed;

@property (weak, nonatomic) IBOutlet UILabel *lbl_wktLost;
@property (weak, nonatomic) IBOutlet UILabel *lbl_innings;

@property (weak, nonatomic) IBOutlet UILabel *lbl_testInnings;

@property (weak, nonatomic) IBOutlet UITextField *txt_startInnings;

@property (weak, nonatomic) IBOutlet UITextField *txt_endInnings;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_endInnings;

@property (strong,nonatomic)IBOutlet NSLayoutConstraint *saveHeight;
//@property (weak, nonatomic) IBOutlet UIButton *btn_addInnings;
@property (weak, nonatomic) IBOutlet UILabel *lbl_thirdnFourthInnings;

- (IBAction)btn_addInnings:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tbl_endInnings;

@property (strong, nonatomic) IBOutlet EndInningsVC *GridRowCell;

- (IBAction)btn_save:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_save;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;

- (IBAction)btn_back:(id)sender;

- (IBAction)btn_delete:(id)sender;

-(void)fetchPageload:(NSObject*)fetchRecord:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE;





@end
