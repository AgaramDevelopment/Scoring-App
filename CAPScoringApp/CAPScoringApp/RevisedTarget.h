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

- (void) ChangeVCBackBtnAction;
@end



@interface RevisedTarget : UIViewController


@property(nonatomic,strong) id <RevisedTargetDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *txt_overs;
@property (strong, nonatomic) IBOutlet UITextField *txt_target;

@property (strong, nonatomic) IBOutlet UITextView *txt_commentss;


@property (strong, nonatomic) IBOutlet UIButton *btn_targetok;
@property(strong,nonatomic)NSString *matchTypeCode;


- (IBAction)btn_targetok:(id)sender;




@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
@property(nonatomic,strong) NSString *teamCode;
@property(nonatomic,strong) NSNumber *inningsno;


@end
