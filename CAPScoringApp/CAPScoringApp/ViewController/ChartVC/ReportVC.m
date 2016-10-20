//
//  ChartVC.m
//  CAPScoringApp
//
//  Created by APPLE on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ReportVC.h"
#import "CustomNavigationVC.h"

@interface ReportVC ()
{
    CustomNavigationVC * objCustomNavigation;
}

@end

@implementation ReportVC

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
   // UIScrollView *ScrollViewer = [[UIScrollView alloc] init ];
   // self.scrolllistview.showsHorizontalScrollIndicator=YES;
    //self.scrolllistview.showsVerticalScrollIndicator=YES;
    


    //[ScrollViewer setBackgroundColor:[UIColor redColor]];
    //CGFloat xposition = 0;
    
    NSMutableArray * objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Partnership Chart",@"Spell Report",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Player Worm Chart",@"Fielding Report", nil];

        
    
        for(int i = 0; i < objhartlistArray.count; i++)
        {
            NSString *dicBallKey = [objhartlistArray objectAtIndex:i];
            
            UIButton *btnborder = [[UIButton alloc] initWithFrame: CGRectMake(i * 200,20,180, 40)];
            
           // btnborder.clipsToBounds = NO;
           // btnborder.layer.borderWidth = 3.5;
           // btnborder.layer.borderColor = [UIColor greenColor].CGColor;
           // btnborder.layer.masksToBounds = YES;
            [btnborder setTitle:[NSString stringWithFormat:@"%@",dicBallKey] forState:UIControlStateNormal];
            [self.scrolllistview addSubview:btnborder];

        }
   // [ScrollViewer layoutIfNeeded];
        //To Create ball tiker for each row.
    //[ScrollViewer setFrame:CGRectMake(0,ScrollViewer.frame.origin.y,405, [ScrollViewer bounds].size.height)];
    //[ScrollViewer setContentOffset:CGPointMake(ScrollViewer.contentSize.width- ScrollViewer.frame.size.width, 0) animated:YES];
   // ScrollViewer.frame = CGRectMake(self.chartList_view.frame.origin.x,400,3000,70);

    [self.scrolllistview setContentSize:CGSizeMake(13*200,70)];

      // [self.view addSubview:ScrollViewer];
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
