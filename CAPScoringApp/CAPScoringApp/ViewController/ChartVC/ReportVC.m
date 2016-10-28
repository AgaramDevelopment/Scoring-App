//
//  ChartVC.m
//  CAPScoringApp
//
//  Created by APPLE on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ReportVC.h"
#import "CustomNavigationVC.h"
#import "CommentaryVC.h"
#import "PitchmapVC.h"
#import "SpiderWagonReportVC.h"
#import "SectorWagonReportVC.h"
#import "BatsmanVsBowlerVC.h"

@interface ReportVC ()
{
    CustomNavigationVC * objCustomNavigation;
    PitchmapVC * objPitchview;
    CommentaryVC *cmntryView;
    SpiderWagonReportVC *spiderView;
    SectorWagonReportVC *sectorView;
    BatsmanVsBowlerVC *batsmanVsBowlerVC;
}

@end

@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customnavigationmethod];
    [self CreateChartList];
    [self setCommentaryView];
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

    //[ScrollViewer setBackgroundColor:[UIColor redColor]];
    //CGFloat xposition = 0;
    
    NSMutableArray * objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Commentary",@"Partnership Chart",@"Spell Report",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Player Worm Chart",@"Fielding Report", nil];

        
    
        for(int i = 0; i < objhartlistArray.count; i++)
        {
            NSString *dicBallKey = [objhartlistArray objectAtIndex:i];
            
            UIButton *btnborder = [[UIButton alloc] initWithFrame: CGRectMake(i * 200,20,180, 40)];
            btnborder.titleLabel.font = [UIFont fontWithName:@"Rajdhani-Bold" size:20];
            btnborder.tag=i+1;
            [btnborder setTitle:[NSString stringWithFormat:@"%@",dicBallKey] forState:UIControlStateNormal];
            [btnborder addTarget:self action:@selector(didClickreportlistbtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrolllistview addSubview:btnborder];
            

        }
   
     [self.scrolllistview setContentSize:CGSizeMake(13*200,70)];

    [self.scrolllistview setContentSize:CGSizeMake(14*200,70)];
    
}

-(IBAction)didClickreportlistbtn:(id)sender{

    UIButton * objBtn =(UIButton*)sender;
    
     self.sepratoryposition.constant = objBtn.frame.origin.x+15;
    if(objBtn.tag == 1)
    {
        NSLog(@"%d",objBtn.tag);
        [self setCommentaryView];
       
    }
    else if(objBtn.tag == 2)
    {
         NSLog(@"%d",objBtn.tag);
        
        
    }
    else if(objBtn.tag == 3)
    {
         NSLog(@"%d",objBtn.tag);
       
       
        
    }
    else if(objBtn.tag == 4)
    {
         NSLog(@"%d",objBtn.tag);
        objPitchview =[[PitchmapVC alloc] initWithNibName:@"PitchmapVC" bundle:nil];
        
        objPitchview.matchCode =self.matchCode;
        objPitchview.compititionCode =self.competitionCode;
        objPitchview.matchTypecode =self.matchTypeCode;
        objPitchview.fstInnShortName = self.fstInnShortName;
        objPitchview.secInnShortName = self.secInnShortName;
        objPitchview.thrdInnShortName = self.thrdInnShortName;
        objPitchview.frthInnShortName = self.frthInnShortName;
        
        objPitchview.view.frame =CGRectMake(0,self.scrolllistview.frame.origin.y+self.scrolllistview.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
        [self.view addSubview:objPitchview.view];
    }
    else if(objBtn.tag == 5)
    {
         NSLog(@"%d",objBtn.tag);
    }
    else if(objBtn.tag == 6)
    {
         NSLog(@"%d",objBtn.tag);
        [self setSpiderView];
    }
    else if(objBtn.tag == 7)
    {
         NSLog(@"%d",objBtn.tag);
        [self setSectorView];
    }
    else if(objBtn.tag == 8)
    {
         NSLog(@"%d",objBtn.tag);
    }
    else if(objBtn.tag == 9)
    {
         NSLog(@"%d",objBtn.tag);
    }
    else if(objBtn.tag == 10)
    {
         NSLog(@"%d",objBtn.tag);
    }
    else if(objBtn.tag == 11)
    {
        [self setBatsmanVsBowlerView];
        
    }
    else if(objBtn.tag == 12)
    {
         NSLog(@"%d",objBtn.tag);
    }
    else if(objBtn.tag == 13)
    {
         NSLog(@"%d",objBtn.tag);
    }
    

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

-(void) setCommentaryView{
     cmntryView = [[CommentaryVC alloc]initWithNibName:@"CommentaryVC" bundle:nil];
    cmntryView.matchCode = self.matchCode;
    cmntryView.matchTypeCode =self.matchTypeCode;

    cmntryView.fstInnShortName = self.fstInnShortName;
    cmntryView.secInnShortName = self.secInnShortName;
    cmntryView.thrdInnShortName = self.thrdInnShortName;
    cmntryView.frthInnShortName = self.frthInnShortName;
    
    cmntryView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:cmntryView.view];
}



-(void) setBatsmanVsBowlerView{
    batsmanVsBowlerVC = [[BatsmanVsBowlerVC alloc]initWithNibName:@"BatsmanVsBowlerVC" bundle:nil];
    batsmanVsBowlerVC.matchCode = self.matchCode;
    batsmanVsBowlerVC.matchTypeCode =self.matchTypeCode;
    batsmanVsBowlerVC.compititionCode = self.competitionCode;
    batsmanVsBowlerVC.fstInnShortName = self.fstInnShortName;
    batsmanVsBowlerVC.secInnShortName = self.secInnShortName;
    batsmanVsBowlerVC.thrdInnShortName = self.thrdInnShortName;
    batsmanVsBowlerVC.frthInnShortName = self.frthInnShortName;
    
    batsmanVsBowlerVC.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:batsmanVsBowlerVC.view];
}




-(void) setSpiderView{
    
    spiderView = [[SpiderWagonReportVC alloc]initWithNibName:@"SpiderWagonReportVC" bundle:nil];
    spiderView.matchCode = self.matchCode;
    spiderView.compititionCode = self.competitionCode;
    spiderView.matchTypeCode = self.matchTypeCode;
    
    
    spiderView.fstInnShortName = self.fstInnShortName;
    spiderView.secInnShortName = self.secInnShortName;
    spiderView.thrdInnShortName = self.thrdInnShortName;
    spiderView.frthInnShortName = self.frthInnShortName;
    
    spiderView.view.frame =CGRectMake(0,self.scrolllistview.frame.origin.y+self.scrolllistview.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
//    spiderView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:spiderView.view];
    
}



-(void) setSectorView{
    
    sectorView = [[SectorWagonReportVC alloc]initWithNibName:@"SectorWagonReportVC" bundle:nil];
    sectorView.matchCode = self.matchCode;
    sectorView.compititionCode = self.competitionCode;
    sectorView.matchTypeCode = self.matchTypeCode;
    
    
    sectorView.fstInnShortName = self.fstInnShortName;
    sectorView.secInnShortName = self.secInnShortName;
    sectorView.thrdInnShortName = self.thrdInnShortName;
    sectorView.frthInnShortName = self.frthInnShortName;
    
    sectorView.view.frame =CGRectMake(0,self.scrolllistview.frame.origin.y+self.scrolllistview.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
    //    spiderView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:sectorView.view];
    
}
    
    @end


