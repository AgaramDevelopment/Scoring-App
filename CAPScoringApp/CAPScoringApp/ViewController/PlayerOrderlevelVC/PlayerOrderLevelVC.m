//
//  PlayerOrderLevelVC.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 01/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerOrderLevelVC.h"
#import "CustomNavigationVC.h"
@interface PlayerOrderLevelVC ()
{
    CustomNavigationVC *objCustomNavigation;
}

@end

@implementation PlayerOrderLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customnavigationmethod];
    
    UIImageView *bg_img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height,self.view.frame.size.width,self.view.frame.size.height)];
    bg_img.image=[UIImage imageNamed:@"BackgroundImg"];
    [self.view addSubview:bg_img];
    UIView * searchView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,objCustomNavigation.view.frame.origin.y+20,self.view.frame.size.width-20, 100)];
    [bg_img addSubview:searchView];
    [searchView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
                            
   
    // Do any additional setup after loading the view.
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"PLAYING XI";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
