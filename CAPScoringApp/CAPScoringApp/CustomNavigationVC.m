//
//  CustomNavigationVC.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 01/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "CustomNavigationVC.h"

@interface CustomNavigationVC ()
{
   
}

@end

@implementation CustomNavigationVC
@synthesize Btn_Back,lbl_titleName,mainView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame =CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 100);
    
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

@end
