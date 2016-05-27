//
//  LoginVC.h
//  CAPScoringApp
//
//  Created by Sathish on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txt_user_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UIView *view_user_name;
@property (weak, nonatomic) IBOutlet UIView *view_password;

- (IBAction)btn_login:(id)sender;
- (IBAction)btn_show_pwd:(id)sender;

-(BOOL) formValidation;
-(void) showDialog:(NSString*) message andTitle:(NSString*) title;
-(BOOL) checkInternetConnection;
@end
