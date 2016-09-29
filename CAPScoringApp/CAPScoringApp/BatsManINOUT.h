//
//  OUTViewController.h
//  CAPScoringApp
//
//  Created by APPLE on 27/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatsManINOutTime.h"




@protocol BatsManINOUTDelegate <NSObject>
@required

- (void) ChangeVCBackBtnAction;
@end




@interface BatsManINOUT : UIViewController
{
    UIDatePicker *datePicker;
}


@property(nonatomic,strong) id <BatsManINOUTDelegate> delegate;



@property (strong, nonatomic) IBOutlet BatsManINOutTime *GridRow;



@property (strong,nonatomic) NSString * MATCHCODE;

@property (nonatomic,strong) NSString * compitionCode;

@property (nonatomic,strong) NSString * INNINGSNO;

@property (nonatomic,strong) NSString * TEAMCODE;


@property (weak, nonatomic) IBOutlet UIButton * btn_save;

@property (strong,nonatomic) IBOutlet UIButton * Btn_back;

@property (weak, nonatomic) IBOutlet UIButton * btn_delete;

@property (weak, nonatomic) IBOutlet UITableView * tbl_BatsManTime;

@property (weak, nonatomic) IBOutlet UIView *view_datePicker;

@property (weak, nonatomic) IBOutlet UITextField *txt_startTime;

@property (weak, nonatomic) IBOutlet UITextField *txt_endTime;

@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;

@property (weak,nonatomic) IBOutlet  UILabel * lbl_playerName;

@property (weak, nonatomic) IBOutlet UIView *view_addBtn;

@property (weak, nonatomic) IBOutlet UIView *view_heading;

@property (weak, nonatomic) IBOutlet UIView *view_Allcontrols;

@property (weak,nonatomic) IBOutlet UIView * View_playerlist;

@property (weak,nonatomic) IBOutlet UIView * View_StartTime;

@property (weak,nonatomic) IBOutlet UIView * View_EndTime;

@property (weak,nonatomic) IBOutlet UIView * View_Duration;





@end
