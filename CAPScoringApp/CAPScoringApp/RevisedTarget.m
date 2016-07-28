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
   // NSString *setover;
    NSString *OldOvers;
    DBManager *objDBManager;

}

@property(nonatomic,strong)NSMutableArray*selecttargets;

@end

@implementation RevisedTarget
@synthesize txt_overs,txt_target,txt_commentss,btn_targetok;
@synthesize competitionCode;
@synthesize matchCode;
@synthesize teamCode;
@synthesize inningsno;


- (void)viewDidLoad {
    [super viewDidLoad];
    
objDBManager = [[DBManager alloc]init];
   // setover= [DBManager SetMatchRegistrationTarget:self.matchCode competitionCode:self.competitionCode];
  //  [DBManager RetrieveRevisedTargetData:self.matchCode competitionCode:self.competitionCode];
    
    [self.txt_commentss.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txt_commentss.layer.borderWidth = 2;
    
   _selecttargets =[objDBManager RetrieveRevisedTargetData:self.matchCode competitionCode:self.competitionCode];
    
    MatcheventRecord *objrevisedtarget =[self.selecttargets objectAtIndex:0];
    

    
    strovers=objrevisedtarget.targetovers;
    OldOvers=objrevisedtarget.targetovers;
    strruns=objrevisedtarget.targetruns;
    strcomments=objrevisedtarget.targetcomments;
    
        self.txt_overs.text =strovers;
        self.txt_target.text =objrevisedtarget.targetruns;
        self.txt_commentss.text=objrevisedtarget.targetcomments;
    
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
            [self showDialog:@"Please Enter Below 20 Overs" andTitle:@"Revised Target"];
            return NO;
        }
    }
    
    
    else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){
        if(OdiText > 50){
            
            [self showDialog:@"Please Enter Below 50 Overs" andTitle:@"Revised Target"];
            return NO;
        }
    }
    else if([OldOvers intValue] < [txt_overs.text intValue]){
        [self showDialog:@"The Revised Target is not possible when the data exist for this innings." andTitle:@"Revised Target"];
        return NO;
    }else if([txt_overs.text isEqual:@""]){
        [self showDialog:@"Please enter Over." andTitle:@"Revised Target"];
        return NO;
    }else if([txt_target.text isEqual:@""]){
        [self showDialog:@"Please enter Targets." andTitle:@"Revised Target"];
        return NO;
    }else if([txt_commentss.text isEqual:@""]){
        [self showDialog:@"Please enter Comments." andTitle:@"Revised Target"];
        return NO;
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
    
   if([self formValidation]){
    
       [self Insertrevisedtarget:self.competitionCode :self.matchCode :self.teamCode :txt_target.text :txt_overs.text :txt_commentss.text :self.inningsno];
       
       UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Revised Target" message:@"Revised Target Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       [alter show];
       
    if(self.checkInternetConnection){
        NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.49:8079/CAPMobilityService.svc/REVISEOVER/%@/%@/TEA0000013/1/%@/%@",self.competitionCode,self.matchCode,strovers,strcomments];
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
    }
       
    }
}

-(IBAction)didClickBackbtnAction:(id)sender
{
    [self.delegate ChangeVCBackBtnAction];
}

-(void)Insertrevisedtarget:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)TARGETRUNS:(NSString*)TARGETOVERS:(NSString*)TARGETCOMMENTS:(NSString*)INNINGSNO{
    
  //if(INNINGSNO.intValue == 2 || INNINGSNO.intValue == 4){
         [objDBManager updateRevisedTarget:strovers runs:txt_target.text comments:txt_commentss.text matchCode:   self.matchCode competitionCode:self.competitionCode];
        
 // }
    [objDBManager RetrieveRevisedTargetData:self.matchCode competitionCode:self.competitionCode];
}
   

@end
