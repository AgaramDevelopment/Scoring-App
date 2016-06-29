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
#import "Reachability.h"

@interface RevisedTarget ()<UITextFieldDelegate>
{
    NSString *strovers;
    NSString *strruns;
    NSString *strcomments;
    NSString *setover;
}

@property(nonatomic,strong)NSMutableArray*selecttargets;

@end

@implementation RevisedTarget
@synthesize txt_overs,txt_target,txt_comments,btn_targetok;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    setover= [DBManager SetMatchRegistrationTarget:self.matchCode competitionCode:self.competitionCode];
    
    
    
    _selecttargets =[DBManager RetrieveRevisedTargetData:self.matchCode competitionCode:self.competitionCode];
    
    MatcheventRecord *objrevisedtarget =[self.selecttargets objectAtIndex:0];
    
    self.txt_overs.text =setover;
    self.txt_target.text =objrevisedtarget.targetruns;
    self.txt_comments.text=objrevisedtarget.targetcomments;
    
    strovers=objrevisedtarget.targetovers;
    strruns=objrevisedtarget.targetruns;
    strcomments=objrevisedtarget.targetcomments;
    
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    if(textField.tag == 23)
    {
        
        if (![string isEqualToString:@""]) {
            strovers=[textField.text stringByAppendingString:string];
            return YES;
            
        }
    }
    else if (textField.tag == 24)
    {
        if (![string isEqualToString:@""]) {
            strruns=[textField.text stringByAppendingString:string];
            return YES;
            
        }
        
    }else if (textField.tag == 25)
    {
        if (![string isEqualToString:@""]) {
            strcomments=[textField.text stringByAppendingString:string];
            return YES;
            
        }
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 23) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else if(textField.tag== 24){
        [textField resignFirstResponder];
    }else if(textField.tag == 25){
        [textField resignFirstResponder];
        
    }
    return YES;
}

- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



- (IBAction)btn_targetok:(id)sender {
    
    if(self.checkInternetConnection){
        NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.49:8079/CAPMobilityService.svc/REVISEOVER/%@/%@/TEA0000013/1/%@/%@",self.competitionCode,self.matchCode,strovers,strcomments];
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        
    }
    
    
    [DBManager updateRevisedTarget:strovers runs:strruns comments:strcomments matchCode:   self.matchCode competitionCode:self.competitionCode];

}
@end
