//
//  UpdateBreakVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateBreakVC : UIViewController
@property(strong,nonatomic)NSDictionary *test;

@property(strong,nonatomic)NSMutableArray*resultarray;
@property (strong, nonatomic) IBOutlet UIView *View_BreakStart;
@property (strong, nonatomic) IBOutlet UITextField *Text_BreakStart;
- (IBAction)StartBreack_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *View_EndBreak;
@property (strong, nonatomic) IBOutlet UITextField *text_EndBreak;
- (IBAction)EndBreak_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *View_Duration;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Duration;
@property (strong, nonatomic) IBOutlet UIView *View_Comments;


@property (strong, nonatomic) IBOutlet UIView *view_breakMinutes;
- (IBAction)Switch_minuts:(id)sender;
- (IBAction)Finish_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *datePicker_View;
@property (strong, nonatomic) IBOutlet UIDatePicker *date_picker;
@property (strong, nonatomic) IBOutlet UIDatePicker *date_picker1;


@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSString*INNINGSNO;
@property(strong,nonatomic)NSString*MATCHDATE;

- (IBAction)delete_btn:(id)sender;


- (IBAction)bck_btn:(id)sender;

- (IBAction)hidepickerbtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *text_Comments;
@end
