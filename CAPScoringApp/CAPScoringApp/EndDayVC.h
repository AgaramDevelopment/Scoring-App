//
//  EndDayVC.h
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EndDayTVC.h"

@protocol EnddayDelegate <NSObject>
@required

- (void) ChangeVCBackBtnAction;
@end



@interface EndDayVC : UIViewController
{
    UIDatePicker *datePicker;
}

@property(nonatomic,strong) id <EnddayDelegate> delegate;

@property (strong,nonatomic) NSString *MATCHTYPECODE;

@property (strong,nonatomic) NSString *MATCHDATE;

@property (strong,nonatomic) NSString *MATCHCODE;
@property (strong,nonatomic) NSString *COMPETITIONCODE;
@property (strong,nonatomic) NSString *TEAMCODE;
@property (strong,nonatomic) NSNumber *INNINGSNO;

@property (strong, nonatomic) IBOutlet UIView *gridHeaderView;

@property (weak, nonatomic) IBOutlet UIView *view_allControls;

@property (weak, nonatomic) IBOutlet UIView *view_startTime;
@property (weak, nonatomic) IBOutlet UIView *view_endTime;
@property (weak, nonatomic) IBOutlet UIView *view_duration;
@property (weak, nonatomic) IBOutlet UIView *view_teamName;
@property (weak, nonatomic) IBOutlet UIView *view_runScored;

@property (weak, nonatomic) IBOutlet UIView *view_OverPlayed;
@property (weak, nonatomic) IBOutlet UIView *view_wkts;
@property (weak, nonatomic) IBOutlet UIView *view_innings;
@property (strong, nonatomic) IBOutlet UIView *view_day_no;

@property (strong, nonatomic) IBOutlet UILabel *lbl_day_no;

@property (weak, nonatomic) IBOutlet UILabel *lbl_startInnings;

@property (weak, nonatomic) IBOutlet UILabel *lbl_endInnings;

@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;

@property (weak, nonatomic) IBOutlet UILabel *lbl_teamName;

@property (weak, nonatomic) IBOutlet UILabel *lbl_runScored;
@property (weak, nonatomic) IBOutlet UILabel *lbl_overPlayed;

@property (weak, nonatomic) IBOutlet UILabel *lbl_wktLost;
@property (weak, nonatomic) IBOutlet UILabel *lbl_innings;

//@property (weak, nonatomic) IBOutlet UILabel *lbl_testInnings;

@property (weak, nonatomic) IBOutlet UITextField *txt_startTime;

@property (weak, nonatomic) IBOutlet UITextField *txt_endTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_endDay;
@property (strong, nonatomic) IBOutlet UITextField *txt_comments;

//@property (strong,nonatomic)IBOutlet NSLayoutConstraint *saveHeight;

@property (weak, nonatomic) IBOutlet UIView *view_datePicker;

- (IBAction)show_SelectedDate:(id)sender;


- (IBAction)btn_addendday:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tbl_endday;

@property (strong, nonatomic) IBOutlet EndDayTVC *endDayCell;

//@property (strong, nonatomic) IBOutlet EndInningsVC *GridRowCell;

- (IBAction)btn_save:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_save;

- (IBAction)btn_back:(id)sender;

- (IBAction)btn_delete:(id)sender;
@end
