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
#import "SessionReportVC.h"
#import "SectorWagonReportVC.h"
#import "BatsmanVsBowlerVC.h"
#import "BowlerVsBatsmanVC.h"
#import "Manhattan.h"
#import "BowlingKPIVC.h"
#import "BatsmanKPIVC.h"
#import "WormReportVC.h"
#import "PartnershipVC.h"
#import "FieldingReportVC.h"
#import "SpellReportVC.h"
#import "ReportCell.h"
#import "PlayerWormChartVC.h"

@interface ReportVC ()<UIScrollViewDelegate>
{
    CustomNavigationVC * objCustomNavigation;
    PitchmapVC * objPitchview;
    CommentaryVC *cmntryView;
    SpiderWagonReportVC *spiderView;
    SectorWagonReportVC *sectorView;
    BatsmanVsBowlerVC *batsmanVsBowlerVC;
    BowlerVsBatsmanVC *bowlerVsBatsmanVC;
    SessionReportVC * SessionReportvc;
    Manhattan * objManhattan;
    BowlingKPIVC * bowlingKpiView;
    BatsmanKPIVC * batsmanKpiView;
    WormReportVC *wormReportVC;
    PartnershipVC * objPartnershipvc;
    FieldingReportVC * FieldingReport;
    SpellReportVC * SpellReport;
    PlayerWormChartVC *playerWormChartVC;
    UILabel * sep_lbl;
}
@property (nonatomic) BOOL subViewLayoutCalled;


@end
NSMutableArray * objhartlistArray;
@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customnavigationmethod];
    [self CreateChartList];
    
    [self setCommentaryView];
    
    sep_lbl =[[UILabel alloc]initWithFrame:CGRectMake(15,75,140, 3)];
    [sep_lbl setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f]];
    [self.Tittle_scroll addSubview:sep_lbl];

   
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

    
    
    if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){
    
//    objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Commentary",@"Partnership Chart",@"Spell Report",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Player Worm Chart",@"Fielding Report",@"Session", nil];
        
         objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Commentary",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Fielding Report",@"Spell Report",@"Partnership Chart",@"Session", nil];

    }else{
        
//         objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Commentary",@"Partnership Chart",@"Spell Report",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Player Worm Chart",@"Fielding Report", nil];
        
    objhartlistArray=[[NSMutableArray alloc]initWithObjects:@"Commentary",@"Pitch Map",@"Manhattan",@"Spider",@"Sector",@"Worm",@"Batsman KPI",@"Bowler KPI",@"Batsman Vs Bowler",@"Bowler Vs Batsman",@"Fielding Report",@"Spell Report",@"Partnership Chart",@"Player Worm Chart", nil];
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [objhartlistArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ReportCell";
    ReportCell *cell = (ReportCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    
    
   cell.tittl_lbl.text =[objhartlistArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReportCell * cell =(ReportCell *)[self.Tittle_scroll  cellForItemAtIndexPath:indexPath];
    
    
    if(sep_lbl != nil)
    {
        
        [sep_lbl removeFromSuperview];
    }
    
    //cell.seprator_lbl .backgroundColor =[UIColor clearColor];
    
    if(objPitchview!= nil)
    {
        [objPitchview.view removeFromSuperview];
        
    }
    
    if(SessionReportvc !=nil)
    {
        [SessionReportvc.view removeFromSuperview];
    }
    
    if(cmntryView !=nil)
    {
        [cmntryView.view removeFromSuperview];
    }
    
    if(spiderView != nil)
    {
        [spiderView.view removeFromSuperview];
    }
    
    if(objManhattan != nil)
    {
        [objManhattan.view removeFromSuperview];
    }
    if(sectorView != nil)
    {
        [sectorView.view removeFromSuperview];
    }
    
    // cell.sepratorXposition .constant = indexPath.row*150;
    if(indexPath.row == 0)
    {
       
        [self setCommentaryView];
        
        
        
    }
    else if(indexPath.row == 1)
    {
        
        
        //  [self setBowlerVsBatsmanView];
        [self setPitchMap];

       
        
    }
    else if(indexPath.row == 2)
    {
        
        [self setManhattan];
        
        //  [self.scrolllistview setContentSize:CGSizeMake(2800, 80)];
        //  [self.view addSubview:SpellReport.view];
        
        
    }
    else if(indexPath.row == 3)
    {
        
        [self setSpiderView];
        
    }
    else if(indexPath.row == 4)
    {
        
        [self setSectorView];
        
        
    }
    else if(indexPath.row == 5)
    {
        
        [self setWormChartView];
    }
    else if(indexPath.row == 6)
    {
        
        [self setBatsmanKpi];
    }
    else if(indexPath.row == 7)
    {
        
        [self setBowlingKpi];
        
        
    }
    else if(indexPath.row == 8)
    {
       
        [self setBatsmanVsBowlerView];
    }
    else if(indexPath.row == 9)
    {
        
        
        [self setBowlerVsBatsmanView];
    }
    else if(indexPath.row== 10)
    {
        FieldingReport = [[FieldingReportVC alloc]initWithNibName:@"FieldingReportVC" bundle:nil];
        FieldingReport.matchCode = self.matchCode;
        FieldingReport.matchTypeCode =self.matchTypeCode;
        FieldingReport.compitionCode =self.competitionCode;
        FieldingReport.Teamcode      = self.teamcode;
        FieldingReport.fstInnShortName = self.fstInnShortName;
        FieldingReport.secInnShortName = self.secInnShortName;
        FieldingReport.thrdInnShortName = self.thrdInnShortName;
        FieldingReport.frthInnShortName = self.frthInnShortName;
        
        FieldingReport.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
        [self.view addSubview:FieldingReport.view];
        
        
    }
    else if(indexPath.row == 11)
    {
        
        
        SpellReport = [[SpellReportVC alloc]initWithNibName:@"SpellReportVC" bundle:nil];
        SpellReport.matchCode = self.matchCode;
        SpellReport.matchTypeCode =self.matchTypeCode;
        SpellReport.compitionCode =self.competitionCode;
        SpellReport.Teamcode      = self.teamcode;
        SpellReport.fstInnShortName = self.fstInnShortName;
        SpellReport.secInnShortName = self.secInnShortName;
        SpellReport.thrdInnShortName = self.thrdInnShortName;
        SpellReport.frthInnShortName = self.frthInnShortName;
        
        SpellReport.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
        
         [self.view addSubview:SpellReport.view];
        
    }
    else if(indexPath.row == 12)
    {
        
        [self setPartnership];
    }
    
    else if(indexPath.row == 13)
    {
        
       // NSLog(@"%d",objBtn.tag);
        if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){
            
            [self setSession];
        }else{
            [self setPlayerWormChartView];
        }

    }
    else if(indexPath.row == 14)
    {
    
    }
     sep_lbl =[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+15,75,140, 3)];
    [sep_lbl setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f]];
    [self.Tittle_scroll addSubview:sep_lbl];

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

-(void) setPitchMap{
    
    objPitchview =[[PitchmapVC alloc] initWithNibName:@"PitchmapVC" bundle:nil];
    
    objPitchview.matchCode =self.matchCode;
    objPitchview.compititionCode =self.competitionCode;
    objPitchview.matchTypecode =self.matchTypeCode;
    objPitchview.fstInnShortName = self.fstInnShortName;
    objPitchview.secInnShortName = self.secInnShortName;
    objPitchview.thrdInnShortName = self.thrdInnShortName;
    objPitchview.frthInnShortName = self.frthInnShortName;
    
    objPitchview.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
    [self.view addSubview:objPitchview.view];
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
    
    batsmanVsBowlerVC.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:batsmanVsBowlerVC.view];
}

-(void) setBowlerVsBatsmanView{
    bowlerVsBatsmanVC = [[BowlerVsBatsmanVC alloc]initWithNibName:@"BowlerVsBatsmanVC" bundle:nil];
    bowlerVsBatsmanVC.matchCode = self.matchCode;
    bowlerVsBatsmanVC.matchTypeCode =self.matchTypeCode;
    bowlerVsBatsmanVC.compititionCode = self.competitionCode;
    bowlerVsBatsmanVC.fstInnShortName = self.fstInnShortName;
    bowlerVsBatsmanVC.secInnShortName = self.secInnShortName;
    bowlerVsBatsmanVC.thrdInnShortName = self.thrdInnShortName;
    bowlerVsBatsmanVC.frthInnShortName = self.frthInnShortName;
    
    bowlerVsBatsmanVC.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:bowlerVsBatsmanVC.view];
}

-(void) setWormChartView{
    wormReportVC = [[WormReportVC alloc]initWithNibName:@"WormReportVC" bundle:nil];
    wormReportVC.matchCode = self.matchCode;
    wormReportVC.matchTypeCode =self.matchTypeCode;
    wormReportVC.compititionCode = self.competitionCode;
    wormReportVC.fstInnShortName = self.fstInnShortName;
    wormReportVC.secInnShortName = self.secInnShortName;
    wormReportVC.thrdInnShortName = self.thrdInnShortName;
    wormReportVC.frthInnShortName = self.frthInnShortName;
    
    wormReportVC.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:wormReportVC.view];
}

-(void) setPlayerWormChartView{
    playerWormChartVC = [[PlayerWormChartVC alloc]initWithNibName:@"PlayerWormChartVC" bundle:nil];
    playerWormChartVC.matchCode = self.matchCode;
    playerWormChartVC.matchTypeCode =self.matchTypeCode;
    playerWormChartVC.compititionCode = self.competitionCode;
    playerWormChartVC.fstInnShortName = self.fstInnShortName;
    playerWormChartVC.secInnShortName = self.secInnShortName;
    playerWormChartVC.thrdInnShortName = self.thrdInnShortName;
    playerWormChartVC.frthInnShortName = self.frthInnShortName;
    
    playerWormChartVC.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:playerWormChartVC.view];
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
    spiderView.scordtoSelectview =NO;
    
    spiderView.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
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
    
    sectorView.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
    //    spiderView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:sectorView.view];
    
}



-(void) setBowlingKpi{
    
    bowlingKpiView = [[BowlingKPIVC alloc]initWithNibName:@"BowlingKPIVC" bundle:nil];
    bowlingKpiView.matchCode = self.matchCode;
    bowlingKpiView.compititionCode = self.competitionCode;
    bowlingKpiView.matchTypeCode = self.matchTypeCode;
    
    
    bowlingKpiView.fstInnShortName = self.fstInnShortName;
    bowlingKpiView.secInnShortName = self.secInnShortName;
    bowlingKpiView.thrdInnShortName = self.thrdInnShortName;
    bowlingKpiView.frthInnShortName = self.frthInnShortName;
    
    bowlingKpiView.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
    //    spiderView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:bowlingKpiView.view];

    
    
}



-(void) setBatsmanKpi{
    
    batsmanKpiView = [[BatsmanKPIVC alloc]initWithNibName:@"BatsmanKPIVC" bundle:nil];
    batsmanKpiView.matchCode = self.matchCode;
    batsmanKpiView.compititionCode = self.competitionCode;
    batsmanKpiView.matchTypeCode = self.matchTypeCode;
    
    
    batsmanKpiView.fstInnShortName = self.fstInnShortName;
    batsmanKpiView.secInnShortName = self.secInnShortName;
    batsmanKpiView.thrdInnShortName = self.thrdInnShortName;
    batsmanKpiView.frthInnShortName = self.frthInnShortName;
    
    batsmanKpiView.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    
    //    spiderView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:batsmanKpiView.view];
    
}


-(void)setManhattan{
    
    objManhattan =[[Manhattan alloc] initWithNibName:@"Manhattan" bundle:nil];
    
    objManhattan.matchCode =self.matchCode;
    objManhattan.compititionCode =self.competitionCode;
    objManhattan.matchTypecode =self.matchTypeCode;
    objManhattan.fstInnShortName = self.fstInnShortName;
    objManhattan.secInnShortName = self.secInnShortName;
    objManhattan.thrdInnShortName = self.thrdInnShortName;
    objManhattan.frthInnShortName = self.frthInnShortName;
    objManhattan.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:objManhattan.view];
}
-(void) setSession{
    SessionReportvc =[[SessionReportVC alloc] initWithNibName:@"SessionReportVC" bundle:nil];
    
    SessionReportvc.matchcode =self.matchCode;
    SessionReportvc.compitioncode =self.competitionCode;
    SessionReportvc.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:SessionReportvc.view];
}


-(void)setPartnership{
    objPartnershipvc =[[PartnershipVC alloc] initWithNibName:@"PartnershipVC" bundle:nil];
    
    objPartnershipvc.matchcode =self.matchCode;
    objPartnershipvc.compitioncode =self.competitionCode;
    objPartnershipvc.matchtypecode =self.matchTypeCode;
    objPartnershipvc.teamcode      = self.teamcode;
    
    objPartnershipvc.fstInnShortName = self.fstInnShortName;
    objPartnershipvc.secInnShortName = self.secInnShortName;
    objPartnershipvc.thrdInnShortName = self.thrdInnShortName;
    objPartnershipvc.frthInnShortName = self.frthInnShortName;
    
    objPartnershipvc.view.frame =CGRectMake(0,self.Tittle_scroll.frame.origin.y+self.Tittle_scroll.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:objPartnershipvc.view];
}
    @end


