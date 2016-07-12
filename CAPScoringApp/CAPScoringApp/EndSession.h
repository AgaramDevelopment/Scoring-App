//
//  EndSession.h
//  CAPScoringApp
//
//  Created by deepak on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EndSessionTVC.h"

@protocol EndSedsessionDelegate <NSObject>
@required

- (void) ChangeVCBackBtnAction;
@end





@interface EndSession : UIViewController{
    UIDatePicker *datePicker;
}


@property(nonatomic,strong) id <EndSedsessionDelegate> delegate;

@property (nonatomic,strong) NSString * compitionCode;
@property (nonatomic,strong) NSString * matchcode;
@property (nonatomic,strong) NSString * bowlingCode;

@property (nonatomic,strong) NSObject * fetchpagedetail;


@property (weak, nonatomic) IBOutlet UIScrollView *scroll_EndSession;

@property (weak, nonatomic) IBOutlet UIView *view_Allcontrols;

@property (weak, nonatomic) IBOutlet UIView *view_StartSession;
@property (weak, nonatomic) IBOutlet UIView *view_EndSession;
@property (weak, nonatomic) IBOutlet UIView *view_duration;
@property (weak, nonatomic) IBOutlet UIView *view_Day;
@property (weak, nonatomic) IBOutlet UIView *view_SessionNo;
@property (weak, nonatomic) IBOutlet UIView *view_InningsNo;

@property (weak, nonatomic) IBOutlet UIView *view_teamBatting;

@property (weak, nonatomic) IBOutlet UIView *view_sessionStartOver;
@property (weak, nonatomic) IBOutlet UIView *view_sessionEndOver;
@property (weak, nonatomic) IBOutlet UIView *view_runScored;
@property (weak, nonatomic) IBOutlet UIView *view_wicketLost;
@property (weak, nonatomic) IBOutlet UIView *view_sessionDominant;



@property (weak, nonatomic) IBOutlet UITextField *txt_startTime;

@property (weak, nonatomic) IBOutlet UITextField *txt_endTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;

@property (weak, nonatomic) IBOutlet UILabel *lbl_day;

@property (weak, nonatomic) IBOutlet UILabel *lbl_sessionNo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_InningsNo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_teamBatting;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sessionStartOver;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sessionEndOver;
@property (weak, nonatomic) IBOutlet UILabel *lbl_runScored;
@property (weak, nonatomic) IBOutlet UILabel *lbl_wicketLost;

@property (weak, nonatomic) IBOutlet UILabel *lbl_sessionDominant;

- (IBAction)btn_addEndSession:(id)sender;

- (IBAction)btn_save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;

@property (strong,nonatomic) IBOutlet UIButton * Btn_back;

- (IBAction)btn_delete:(id)sender;

- (IBAction)btn_dropDown:(id)sender;

-(void)fetchPageEndSession:(NSObject*)fetchRecord:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE;
@property (weak, nonatomic) IBOutlet UITableView *tbl_session;

@property (strong, nonatomic) IBOutlet EndSessionTVC *GridRow;

@property (weak, nonatomic) IBOutlet UIView *view_allControls;
- (IBAction)btn_back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_dropDown;



@end
