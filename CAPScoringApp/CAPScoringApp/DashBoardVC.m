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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)btn_syn_Data:(id)sender {
    
    _img_synData.image = [UIImage imageNamed:@"ico-sync-data02.png"];
    
    _view_syn_data.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
    
}

- (IBAction)btn_new_Match:(id)sender {
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach02.png"];
    
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
    [self tournmentView];
}

- (IBAction)btn_archives:(id)sender {
    
    _img_archives.image = [UIImage imageNamed:@"ico-archives02.png"];
    _view_archives.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
}

- (IBAction)btn_reports:(id)sender {
    
    
    _img_reports.image = [UIImage imageNamed:@"ico-reports02.png"];
    
    _view_reports.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
}

- (IBAction)btn_signOut:(id)sender {
    
//    [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
//    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
    

    NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
    [removeUD removeObjectForKey:@"isUserLoggedin"];
    [[NSUserDefaults standardUserDefaults]synchronize ];
    
//    NSUserDefaults * removeUDCode = [NSUserDefaults standardUserDefaults];
//    [removeUDCode removeObjectForKey:@"userCode"];
//    [[NSUserDefaults standardUserDefaults]synchronize ];
    
    LoginVC *loginVC = [[LoginVC alloc]init];
    
    loginVC =  (LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"login_sbid"];
    [self.navigationController pushViewController:loginVC animated:YES];
    
    
    
}



-(void) tournmentView{
    
    TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
    
    tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
 [self.navigationController pushViewController:tournmentVc animated:YES];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//      TorunamentVC*tournmentVc =(TorunamentVC*) [storyBoard instantiateViewControllerWithIdentifier:@"tornmentid"];
//    [tournmentVc setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:tournmentVc animated:NO completion:nil];
    
}
@end
