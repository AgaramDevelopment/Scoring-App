//
//  AddBreakVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBreakVC : UIViewController

{
    UIDatePicker * datepicker;
    UIDatePicker * datepicker1;
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

@property (strong, nonatomic) IBOutlet UITextField *text_Comments;
@property (strong, nonatomic) IBOutlet UIView *view_breakMinutes;
- (IBAction)Switch_minuts:(id)sender;
- (IBAction)Finish_btn:(id)sender;
@end
