//
//  RevisedTarget.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/15/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "RevisedTarget.h"
#import "CustomNavigationVC.h"
#import "DBManager.h"
#import "MatcheventRecord.h"

@interface RevisedTarget ()
@property(nonatomic,strong)NSMutableArray*selecttargets;

@end

@implementation RevisedTarget
@synthesize txt_overs,txt_target,txt_comments,btn_targetok;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _selecttargets =[DBManager RetrieveRevisedTargetData:self.matchCode competitionCode:self.competitionCode];
    
    MatcheventRecord *objrevisedtarget =[self.selecttargets objectAtIndex:0];
    self.txt_overs.text=objrevisedtarget.targetovers;
    self.txt_target.text=objrevisedtarget.targetruns;
    self.txt_comments.text=objrevisedtarget.targetcomments;
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    if (textField.tag == 23) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:3];
        [passwordTextField becomeFirstResponder];
    }
    else if(textField.tag== 24){
        [textField resignFirstResponder];
    }
    else if(textField.tag==25){
       [textField resignFirstResponder];
    }
    return YES;
}




- (IBAction)btn_targetok:(id)sender {
}
@end
