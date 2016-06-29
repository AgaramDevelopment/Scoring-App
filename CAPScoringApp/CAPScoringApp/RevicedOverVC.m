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
#import "Reachability.h"

@interface RevicedOverVC ()<UITextFieldDelegate>
{
    NSString *strovers;
    NSString * strcomments;
}
@property(nonatomic,strong)NSMutableArray*selectOvers;


@end

@implementation RevicedOverVC
@synthesize btn_submit,txt_overs,txt_comments;


- (void)viewDidLoad {
    [super viewDidLoad];

    _selectOvers = [DBManager RetrieveRevisedOverData:self.matchCode competitionCode:self.competitionCode recordstatus:@"MSC001"];
    
    FixturesRecord *objrevisedoverRecord = [self.selectOvers objectAtIndex:0];
    
    self.txt_overs.text=objrevisedoverRecord.overs;
    self.txt_comments.text=objrevisedoverRecord.matchovercomments;
    
    strovers=objrevisedoverRecord.overs;
    strcomments=objrevisedoverRecord.matchovercomments;
    
}
#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    if(textField.tag == 21)
    {
        
        if (![string isEqualToString:@""]) {
            strovers=[textField.text stringByAppendingString:string];
            return YES;
            
        }
    }
    else if (textField.tag == 22)
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
    if (textField.tag == 21) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else if(textField.tag== 22){
        [textField resignFirstResponder];
    }
    return YES;
}

//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

-(IBAction)btn_submit:(id)sender
{
    if(self.checkInternetConnection){
        NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.39:8096/CAPMobilityService.svc/REVISEOVER/%@/%@/%@/%@/%@/%@",self.competitionCode,self.matchCode,self.inningsNo,strovers,strcomments];
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        
    }
    
    [DBManager updateRevisedOvers:strovers comments:strcomments matchCode:self.matchCode competitionCode:self.competitionCode];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
