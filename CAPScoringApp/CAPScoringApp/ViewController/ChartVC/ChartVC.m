//
//  ChartVC.m
//  CAPScoringApp
//
//  Created by APPLE on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ChartVC.h"
#import "CustomNavigationVC.h"

@interface ChartVC ()
{
    CustomNavigationVC * objCustomNavigation;
}

@end

@implementation ChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customnavigationmethod];
    [self CreateChartList];
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"Report";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)CreateChartList
{
//    [self.view_BallTicker.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIScrollView *ScrollViewer = [[UIScrollView alloc] initWithFrame:CGRectMake(self.chartList_view.frame.origin.x,5, self.view.frame.size.width,self.chartList_view.frame.size.height)];
    ScrollViewer.showsHorizontalScrollIndicator=NO;
    
    [ScrollViewer setBackgroundColor:[UIColor redColor]];
    CGFloat xposition = 0;
    
    NSMutableArray * objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Partnership Chart",@"Spell Report",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Player Worm Chart",@"Fielding Report", nil];

        
        
        for(int i = 0; i < objhartlistArray.count; i++)
        {
            NSString *dicBallKey = [objhartlistArray objectAtIndex:i];
            
            UIButton *btnborder = [[UIButton alloc] initWithFrame: CGRectMake(i * 100+10, 0,100, 40)];
            
            btnborder.clipsToBounds = NO;
            btnborder.layer.borderWidth = 3.5;
            btnborder.layer.borderColor = [UIColor greenColor].CGColor;
            btnborder.layer.masksToBounds = YES;
            [btnborder setTitle:[NSString stringWithFormat:@"%@",dicBallKey] forState:UIControlStateNormal];
            [ScrollViewer addSubview:btnborder];

        }
    
        //To Create ball tiker for each row.
    
    [ScrollViewer setContentSize:CGSizeMake(xposition, 1000)];
     
       [self.chartList_view addSubview:ScrollViewer];
}

- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
