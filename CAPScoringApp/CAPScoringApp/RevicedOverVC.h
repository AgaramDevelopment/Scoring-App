//
//  RevicedOverVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/13/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RevisedoverDelegate <NSObject>
@required

- (void) ChangeVCBackBtnAction;
@end


@interface RevicedOverVC : UIViewController

@property(nonatomic,strong) id <RevisedoverDelegate> delegate;


@property (strong, nonatomic) IBOutlet UITextField *txt_overs;
//@property (strong, nonatomic) IBOutlet UITextField *txt_comments;
@property(strong,nonatomic) IBOutlet UIButton * btn_submit;

@property (strong, nonatomic) IBOutlet UITextView *txt_commentss;


@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
@property(nonatomic,strong) NSString *inningsNo;


- (IBAction)btn_submit:(id)sender;
-(BOOL) checkInternetConnection;

@end
