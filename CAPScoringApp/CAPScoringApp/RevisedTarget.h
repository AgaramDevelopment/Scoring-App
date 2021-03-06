//
//  RevisedTarget.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/15/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RevisedTargetDelegate <NSObject>
@required

- (void) ChangeVCRevisedBackBtnAction;

- (void) _selectOvers;
@end



@interface RevisedTarget : UIViewController


@property(nonatomic,strong) id <RevisedTargetDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *txt_overs;
@property (strong, nonatomic) IBOutlet UITextField *txt_target;

@property (strong, nonatomic) IBOutlet UITextView *txt_commentss;


@property (strong, nonatomic) IBOutlet UIButton *btn_targetok;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSNumber *targetruns;

- (IBAction)btn_targetok:(id)sender;


- (IBAction)didClickBackbtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *didClickBackbtnAction;

@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
@property(nonatomic,strong) NSString *teamCode;
@property(nonatomic,strong) NSNumber *inningsno;
@property(nonatomic,strong) NSNumber *currentOver;




@end
