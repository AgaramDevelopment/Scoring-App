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
#import "Utitliy.h"
@interface RevicedOverVC ()<UITextFieldDelegate>
{
    NSString *strovers;
    NSString * strcomments;
    NSString * OldOvers;
}
@property(nonatomic,strong)NSMutableArray*selectOvers;


@end

@implementation RevicedOverVC
@synthesize btn_submit;
@synthesize txt_overs;
@synthesize txt_commentss;


- (void)viewDidLoad {
    [super viewDidLoad];
    DBManager *objDBManager = [[DBManager alloc]init];

    _selectOvers = [objDBManager RetrieveRevisedOverData:self.matchCode competitionCode:self.competitionCode recordstatus:@"MSC001"];
    
    
    FixturesRecord *objrevisedoverRecord = [self.selectOvers objectAtIndex:0];
    
    [self.txt_commentss.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txt_commentss.layer.borderWidth = 2;

    
    self.txt_overs.text=objrevisedoverRecord.overs;
     OldOvers=_oldoverSE;
    //OldOvers=objrevisedoverRecord.overs;
    self.txt_commentss.text=objrevisedoverRecord.matchovercomments;
    strovers=objrevisedoverRecord.overs;
    strcomments=objrevisedoverRecord.matchovercomments;
    
}
#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing

#define ACCEPTABLE_CHARECTERS @"0123456789."
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    if(textField.tag == 21)
    {
        if (![string isEqualToString:@""])
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            if(![filtered isEqualToString:@""])
            {
                strovers=[textField.text stringByAppendingString:filtered];
                 return YES;
            }
            else
            {
                UIAlertView * objalterview =[[UIAlertView alloc]initWithTitle:@"Revised Overs" message:@"Please Enter No Of Overs" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [objalterview show];
            }
            return NO;
        }
        return YES;//        if (![string isEqualToString:@""]) {
//            strovers=[textField.text stringByAppendingString:string];
//            return YES;
//            
//        }
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



-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

- (BOOL) formValidation{
    
    NSString *oversTxt = self.txt_overs.text;
    
    NSInteger twentyText = [oversTxt intValue];
    NSInteger OdiText = [oversTxt intValue];
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){
        if(twentyText > 20){
            [self showDialog:@"Please Enter Below 20 Overs" andTitle:@"Revised Overs"];
            return NO;
        }
    }
    
    
    if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){
        if(OdiText > 50){
            
            [self showDialog:@"Please Enter Below 50 Overs" andTitle:@"Revised Overs"];
            return NO;
        }
    }
    
    if ([txt_overs.text isEqual:@""] && [txt_commentss.text isEqual:@""])
    {
        [self showDialog:@"Please Enter No Of Overs \n Please enter Comments" andTitle:@"Revised Overs"];
        return NO;
        
    }
    
    
    if([txt_overs.text isEqual:@""]){
        [self showDialog:@"Please Enter No Of Overs" andTitle:@"Revised Overs"];
        return NO;
    }
    if([txt_commentss.text isEqual:@""]){
        [self showDialog:@"Please enter Comments." andTitle:@"Revised Overs"];
        return NO;
    }
    
    
    
    
    if([OldOvers intValue] > [txt_overs.text intValue]){
        [self showDialog:@"The Revised Over is not possible when the data exist for this innings." andTitle:@"Revised Overs"];
        return NO;
        
        //    if([OldOvers intValue] < [txt_overs.text intValue]){
        //        [self showDialog:@"The Revised Over is not possible when the data exist for this innings." andTitle:@"Revised Over"];
        //        return NO;
        //
        //
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
if([self formValidation]){
    DBManager *objDBManager = [[DBManager alloc]init];
    
    [objDBManager updateRevisedOvers:txt_overs.text comments:txt_commentss.text matchCode:self.matchCode competitionCode:self.competitionCode];
    UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Revised Overs" message:@"Revised Over Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];
    alter.tag =100;
    [self startService];
}
   
    

}


-(void) startService{
    if(self.checkInternetConnection){
        NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/REVISEOVER/%@/%@/%@/%@/%@",[Utitliy getIPPORT],self.competitionCode,self.matchCode,self.inningsNo,strovers,strcomments];
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)//OK button pressed
    {
       if(alertView.tag == 100)
       {
           [self.delegate ChangeVCBackBtnAction];
       }
    }
    else if(buttonIndex == 1)//Annul button pressed.
    {
        //do something
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)didClickBackBtnction:(id)sender
{
    [self.delegate ChangeVCBackBtnAction];
}

@end
