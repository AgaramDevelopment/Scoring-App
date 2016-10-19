//
//  FixtureAndResultsVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 17/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FixtureAndResultsVC.h"
#import "CustomNavigationVC.h"
#import "ResultMatchCell.h"
#import "LiveMatchCell.h"
#import "FixtureTVC.h"
#import "DBManagerReports.h"
#import "DBManager.h"
#import "FixtureReportRecord.h"
#import "LiveReportRecord.h"
#import "ResultReportRecord.h"
#import "FixtureReportRecord.h"
#import "ResultReportRecord.h"
#import "PlayingSquadRecords.h"
#import "PlayingSquadVC.h"
#import "ChartVC.h"
#import "FetchSEPageLoadRecord.h"

@interface FixtureAndResultsVC ()
{
    CustomNavigationVC *objCustomNavigation;
    
    BOOL isLive;
    BOOL isResult;
    BOOL isFixture;
    DBManagerReports *objDBManagerReports;
    NSArray *MuliteDayMatchtype;
    UITableView* rbwTableview;
}

@property (nonatomic,strong) NSMutableArray *fixturesResultArray;


@end

@implementation FixtureAndResultsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    MuliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];
    
    //self.CommonArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    isLive =YES;
    [self.matchListview .layer setBorderWidth:2.0];
    [self.matchListview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.matchListview .layer setMasksToBounds:YES];
    

    [self customnavigationmethod];
    
    
    [self didClickLiveBtn:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.sepratorYposition.constant =self.view.frame.size.width/2.5;
}
-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"Report";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_fixturesResultArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * LiveMatch = @"LiveMatch";
    
    static NSString * ResultMatch = @"ResultMatch";
    
    static NSString * FixtureMatch = @"FixtureMatch";
    
    if(isLive == YES)
    {
        LiveMatchCell *cell = (LiveMatchCell *)[tableView dequeueReusableCellWithIdentifier:LiveMatch];
         if (cell == nil)
         {
            [[NSBundle mainBundle] loadNibNamed:@"LiveMatchCell" owner:self options:nil];
             cell = self.livematchCell;
            //self.batsManHeaderCell = nil;
         }
    [cell setBackgroundColor:[UIColor clearColor]];
    //tableView.allowsSelection = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LiveReportRecord *record = [_fixturesResultArray objectAtIndex:indexPath.row];
        
        cell.lbl_team_a_name.text = record.teamAname;
        cell.lbl_team_b_name.text = record.teamBname;
        
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:record.matchDate];
        [formatter setDateFormat:@"dd"];
        cell.lbl_day.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM"];
        cell.lbl_month.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.lbl_week_day.text=[formatter stringFromDate:date];
        
        cell.lbl_match_type.text = record.matchTypeName;
        [self setImage:record.teamAcode :cell.img_team_a_logo ];
        [self setImage:record.teamBcode :cell.lbl_team_b_logo ];
        
        
        NSMutableArray* objInniningsarray=[[[DBManager alloc]init] FETCHSEALLINNINGSSCOREDETAILS:record.competitionCode MATCHCODE:record.matchCode];
        
        if(objInniningsarray.count>0){
            
            FetchSEPageLoadRecord *objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];
            
            if([MuliteDayMatchtype containsObject:record.matchTypeCode])
            {
                cell.lbl_team_a_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FIRSTINNINGSTOTAL,objfetchSEPageLoadRecord.FIRSTINNINGSWICKET];
                cell.lbl_team_a_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FIRSTINNINGSOVERS];
                
                if(![objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqual:@""]){
                    cell.lbl_team_b_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.SECONDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
                    cell.lbl_team_b_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.SECONDINNINGSOVERS];
                }else{
                    cell.lbl_team_b_fst_inn_score.text=@"";
                    cell.lbl_team_b_fst_inn_over.text=@"";
                    
                }
                
                
                if(![objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqual:@""])
                {
                    cell.lbl_team_a_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.THIRDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
                    cell.lbl_team_a_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.THIRDINNINGSOVERS];
                }
                else
                {
                    cell.lbl_team_a_sec_inn_score.text=@"";
                    cell.lbl_team_a_sec_inn_over.text=@"";
                }
                if(![objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME isEqual:@""])
                {
                    cell.lbl_team_b_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FOURTHINNINGSTOTAL,objfetchSEPageLoadRecord.FOURTHINNINGSWICKET];
                    cell.lbl_team_b_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FOURTHINNINGSOVERS];
                }
                else{
                    cell.lbl_team_b_sec_inn_score.text=@"";
                    cell.lbl_team_b_sec_inn_over.text=@"";
                }
                
                
            }
            else
            {
                cell.lbl_team_a_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FIRSTINNINGSTOTAL,objfetchSEPageLoadRecord.FIRSTINNINGSWICKET];
                cell.lbl_team_a_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FIRSTINNINGSOVERS];
                
                if(![objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqual:@""]){
                    cell.lbl_team_b_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.SECONDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
                    cell.lbl_team_b_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.SECONDINNINGSOVERS];
                }else{
                    cell.lbl_team_b_fst_inn_score.text=@"";
                    cell.lbl_team_b_fst_inn_over.text=@"";
                    
                }
                
            }
            
        }
    
    return cell;
    
    }
    else if (isResult ==YES)
    {
        ResultMatchCell *cell = (ResultMatchCell *)[tableView dequeueReusableCellWithIdentifier:ResultMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ResultMatchCell" owner:self options:nil];
            cell = self.resultmatchCell;
            //self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        ResultReportRecord *record = [_fixturesResultArray objectAtIndex:indexPath.row];
        
        cell.lbl_team_a_name.text = record.teamAname;
        cell.lbl_team_b_name.text = record.teamBname;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:record.matchDate];
        [formatter setDateFormat:@"dd"];
        cell.lbl_day.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM"];
        cell.lbl_month.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.lbl_week_day.text=[formatter stringFromDate:date];
        
        cell.lbl_match_type.text = record.matchTypeName;
        
        [self setImage:record.teamAcode :cell.img_team_a_logo ];
        [self setImage:record.teamBcode :cell.lbl_team_b_logo ];
        
        
        NSMutableArray* objInniningsarray=[[[DBManager alloc]init] FETCHSEALLINNINGSSCOREDETAILS:record.competitionCode MATCHCODE:record.matchCode];
        
        if(objInniningsarray.count>0){
            
            FetchSEPageLoadRecord *objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];
            
            if([MuliteDayMatchtype containsObject:record.matchTypeCode])
            {
                cell.lbl_team_a_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FIRSTINNINGSTOTAL,objfetchSEPageLoadRecord.FIRSTINNINGSWICKET];
                cell.lbl_team_a_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FIRSTINNINGSOVERS];
                
                if(![objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqual:@""]){
                    cell.lbl_team_b_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.SECONDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
                    cell.lbl_team_b_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.SECONDINNINGSOVERS];
                }else{
                    cell.lbl_team_b_fst_inn_score.text=@"";
                    cell.lbl_team_b_fst_inn_over.text=@"";
                    
                }
                
                
                if(![objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqual:@""])
                {
                    cell.lbl_team_a_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.THIRDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
                    cell.lbl_team_a_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.THIRDINNINGSOVERS];
                }
                else
                {
                    cell.lbl_team_a_sec_inn_score.text=@"";
                    cell.lbl_team_a_sec_inn_over.text=@"";
                }
                if(![objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME isEqual:@""])
                {
                    cell.lbl_team_b_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FOURTHINNINGSTOTAL,objfetchSEPageLoadRecord.FOURTHINNINGSWICKET];
                    cell.lbl_team_b_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FOURTHINNINGSOVERS];
                }
                else{
                    cell.lbl_team_b_sec_inn_score.text=@"";
                    cell.lbl_team_b_sec_inn_over.text=@"";
                }
                
                
            }
            else
            {
                cell.lbl_team_a_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FIRSTINNINGSTOTAL,objfetchSEPageLoadRecord.FIRSTINNINGSWICKET];
                cell.lbl_team_a_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FIRSTINNINGSOVERS];
                
                if(![objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqual:@""]){
                    cell.lbl_team_b_fst_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.SECONDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
                    cell.lbl_team_b_fst_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.SECONDINNINGSOVERS];
                }else{
                    cell.lbl_team_b_fst_inn_score.text=@"";
                    cell.lbl_team_b_fst_inn_over.text=@"";
                    
                }
                
            }
            
        }
        
        return cell;
    }
    else if (isFixture ==YES)
    {
        FixtureTVC *cell = (FixtureTVC *)[tableView dequeueReusableCellWithIdentifier:FixtureMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"FixtureTVC" owner:self options:nil];
            cell = self.fixtureCell;
            
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        FixtureReportRecord *objFixtureRecord=(FixtureReportRecord*)[_fixturesResultArray objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:objFixtureRecord.matchDate];
        [formatter setDateFormat:@"dd"];
       // cell.day_no_txt.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM"];
        cell.month_txt.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.day_txt.text=[formatter stringFromDate:date];
        
        
            cell.teamA_txt.text = objFixtureRecord.teamAname;
            cell.teamB_txt.text = objFixtureRecord.teamBname;
            cell.match_type.text = objFixtureRecord.matchName;
            cell.venu_txt.text = [NSString stringWithFormat:@"%@ , %@", objFixtureRecord.groundName,objFixtureRecord.city];
            
        [self setImage:objFixtureRecord.teamAcode : cell.teamA_img];
        
        [self setImage:objFixtureRecord.teamBcode : cell.teamB_img];
        
        
        return cell;
    }


    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 160;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isFixture ==YES)
    {
    
    NSMutableArray *mSetUp = [[NSMutableArray alloc]init];
    
    FixtureReportRecord *objFixtureRecord=(FixtureReportRecord*)[_fixturesResultArray objectAtIndex:indexPath.row];
    
    [mSetUp addObject:objFixtureRecord];
    
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    
    
    
    PlayingSquadVC*detail = [[PlayingSquadVC alloc]init];
    
    detail =  (PlayingSquadVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"playingSquadID"];
    
    NSString*matchCode = objFixtureRecord.matchCode;
   
    detail.matchCode = matchCode;
    
   // PlayingSquadVC *playing = [[PlayingSquadVC alloc] initWithNibName:@"playingSquadId" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
        
    }else if (isResult ==YES){
    
    ChartVC*TETS =  (ChartVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChartVC"];
    [self.navigationController pushViewController:TETS animated:YES];
    }else if (isLive == YES){
        
        ChartVC*TETS =  (ChartVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChartVC"];
        [self.navigationController pushViewController:TETS animated:YES];
    }
    
}
- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)didClickLiveBtn:(id)sender
{
    
    objDBManagerReports = [[DBManagerReports alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userCode = [defaults objectForKey:@"userCode"];
    _fixturesResultArray =[objDBManagerReports fetchLiveMatches:@"":userCode];
     self.sepratorYposition.constant =self.Live_Btn.frame.origin.x+30;
    isLive = YES;
    isResult = NO;
    isFixture = NO;
    [self.FixResult_Tbl reloadData];
}

-(IBAction)didClickResultBtn:(id)sender
{
    
    objDBManagerReports = [[DBManagerReports alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userCode = [defaults objectForKey:@"userCode"];
    _fixturesResultArray =[objDBManagerReports fetchResultsMatches:@"":userCode];
    self.sepratorYposition.constant =self.Result_Btn.frame.origin.x+30;
    isLive = NO;
    isResult = YES;
    isFixture = NO;
    [self.FixResult_Tbl reloadData];
}

-(IBAction)didClickFixtureBtn:(id)sender
{
    objDBManagerReports = [[DBManagerReports alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userCode = [defaults objectForKey:@"userCode"];
    _fixturesResultArray =[objDBManagerReports FixturesData :@"":userCode];
 self.sepratorYposition.constant =self.Fixture_Btn.frame.origin.x+30;
    
    isLive = NO;
    isResult = NO;
    isFixture = YES;
    
    [self.FixResult_Tbl reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setImage:(NSString *)teamCode :(UIImageView *)teamLogoImg {
 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,teamCode];
    
    
    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
        teamLogoImg.image = img;
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
        teamLogoImg.image = img;
    }
}



@end
