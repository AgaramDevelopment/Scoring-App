//
//  DashBoardVC.m
//  CAPScoringApp
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DashBoardVC.h"
#import "TorunamentVC.h"
#import "LoginVC.h"
#import "EndInningsVC.h"
#import "EndInnings.h"
@interface DashBoardVC ()

@end

@implementation DashBoardVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_syn_Data:(id)sender {
    
    _img_synData.image = [UIImage imageNamed:@"ico-sync-data02.png"];
    
    _view_syn_data.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
    
}

- (IBAction)btn_new_Match:(id)sender {
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach02.png"];
    
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
    [self tournmentView:@"Newmatch"];
}

- (IBAction)btn_archives:(id)sender {
    
    _img_archives.image = [UIImage imageNamed:@"ico-archives02.png"];
    _view_archives.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
     [self tournmentView:@"Archives"];


}

- (IBAction)btn_reports:(id)sender {

    _img_reports.image = [UIImage imageNamed:@"ico-reports02.png"];
    
    _view_reports.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    EndInningsVC *endInning = [[EndInningsVC alloc]initWithNibName:@"EndInningsVC" bundle:nil];


    
    
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:endInning];
    endInning.view.frame =CGRectMake(90, 200, endInning.view.frame.size.width, endInning.view.frame.size.height);
    [self.view addSubview:endInning.view];
    endInning.view.alpha = 0;
    [endInning didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         endInning.view.alpha = 1;
     }
                     completion:nil];
    
    
  //  endInnings.view_allControls.hidden = YES;
    
    
    
}



- (IBAction)btn_signOut:(id)sender {
    
        
//    NSUserDefaults * removeUDCode = [NSUserDefaults standardUserDefaults];
//    [removeUDCode removeObjectForKey:@"userCode"];
//    [[NSUserDefaults standardUserDefaults]synchronize ];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert"
                                                   message: @"Are sure you want to signout?"
                                                  delegate: self
                                         cancelButtonTitle:@"Signout"
                                         otherButtonTitles:@"Cancel",nil];
    
    
    [alert show];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (alertView.tag == 1) { // UIAlertView with tag 1 detected
    if (buttonIndex == 0)
    {
        
        NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
        [removeUD removeObjectForKey:@"isUserLoggedin"];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        
        NSLog(@"user pressed Button Indexed 0");
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        
        loginVC =  (LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"login_sbid"];
        [self.navigationController pushViewController:loginVC animated:YES];

    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        
        
        DashBoardVC *dashBoard =(DashBoardVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        [self.navigationController pushViewController:dashBoard animated:YES];
        //Fixvc.CompitionCode=selectindexarray;
            }
}



-(void) tournmentView :(NSString *) selectType{
    
    TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
    
    tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
    tournmentVc.selectDashBoard=selectType;
 [self.navigationController pushViewController:tournmentVc animated:YES];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach01.png"];
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];

    
}
@end
