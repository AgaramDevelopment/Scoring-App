//
//  RevicedOverVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/13/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "RevicedOverVC.h"
#import "CustomNavigationVC.h"
#import "DBManager.h"
#import "FixturesRecord.h"

@interface RevicedOverVC ()<UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray*selectOvers;


@end

@implementation RevicedOverVC
@synthesize btn_submit,txt_overs,txt_comments;


- (void)viewDidLoad {
    [super viewDidLoad];

    _selectOvers =[DBManager RetrieveRevisedOverData:self.matchCode competitionCode:self.competitionCode];
    FixturesRecord *objrevisedoverRecord = [self.selectOvers objectAtIndex:0];
    
    self.txt_overs.text=objrevisedoverRecord.overs;
    self.txt_comments.text=objrevisedoverRecord.matchovercomments;

    
}
#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    if ([string isEqualToString:@""]) {
        return NO;
    }
    else {
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 21) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else if(textField.tag== 22){
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
