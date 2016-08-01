//
//  AddBreakVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreakVC.h"
#import "DBManager.h"

@protocol AddBreakVCDelagate <NSObject>
@required

- (void) ChangeVCBackBtnAction;

@end

@interface AddBreakVC : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

{
    NSMutableArray*UpdateBreaksArray;
    NSMutableArray*DeleteBreaksArray;

    
//    UIDatePicker * datepicker;
//    UIDatePicker * datepicker1;
}
@property (strong, nonatomic) IBOutlet UIView *View_BreakStart;
@property (strong, nonatomic) IBOutlet UITextField *Text_BreakStart;
- (IBAction)StartBreack_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *View_EndBreak;
@property (strong, nonatomic) IBOutlet UITextField *text_EndBreak;
- (IBAction)EndBreak_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *View_Duration;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Duration;
@property (strong, nonatomic) IBOutlet UIView *View_Comments;

@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;
@property (strong, nonatomic) IBOutlet UITextView *text_Comments;
//@property (strong, nonatomic) IBOutlet UITextField *text_Comments;
@property (strong, nonatomic) IBOutlet UIView *view_breakMinutes;
- (IBAction)Switch_minuts:(id)sender;
- (IBAction)Finish_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *datePicker_View;
@property (strong, nonatomic) IBOutlet UIDatePicker *date_picker;
@property (strong, nonatomic) IBOutlet UIDatePicker *date_picker1;

//@property (strong, nonatomic) IBOutlet UIButton *back_btn;
@property(nonatomic,strong) id delegate;

- (IBAction)hidepickerbtn:(id)sender;
- (IBAction)back_btn:(id)sender;

@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSString*INNINGSNO;
@property(strong,nonatomic)NSString*MATCHDATE;
@property(strong,nonatomic)NSString*Duration;
@property(strong,nonatomic)NSDictionary *test;

@property (strong,nonatomic) IBOutlet UIView * view_gridview;
@property (strong,nonatomic) IBOutlet UIButton *btn_Add;
@property (strong,nonatomic) IBOutlet UITableView * tbl_breaklist;
@property (strong, nonatomic) IBOutlet BreakTableViewCell *GridBreakcell;
@property (strong,nonatomic) IBOutlet UIButton *btn_Update;
@property (strong,nonatomic) IBOutlet UIButton * btn_delete;
@property (strong ,nonatomic) IBOutlet UIButton * btn_finish;

@end
