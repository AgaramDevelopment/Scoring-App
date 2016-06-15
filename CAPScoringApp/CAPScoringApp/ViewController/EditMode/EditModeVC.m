//
//  EditModeVC.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EditModeVC.h"
#import "CustomNavigationVC.h"
#import "DBManager.h"

@interface EditModeVC ()
{
    CustomNavigationVC * objCustomNavigation;
}

@end

@implementation EditModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customnavigationmethod];
    NSMutableArray* inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    // Do any additional setup after loading the view.
}
-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"ARCHIVES";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(IBAction)didClickInnings1team1:(id)sender
{
    self.highlightbtnxposition.constant=0;
}
-(IBAction)didClickInnings1team2:(id)sender
{
    self.highlightbtnxposition.constant=self.Btn_innings1team2.frame.origin.x;
}
-(IBAction)didClickInnings2team1:(id)sender
{
     self.highlightbtnxposition.constant=self.Btn_inning2steam1.frame.origin.x;
}
-(IBAction)didClickInnings2team2:(id)sender
{
     self.highlightbtnxposition.constant=self.Btn_innings2team2.frame.origin.x;
}
-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
