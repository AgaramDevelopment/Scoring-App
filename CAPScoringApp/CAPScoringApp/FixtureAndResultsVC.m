//
//  FixtureAndResultsVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 17/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FixtureAndResultsVC.h"
#import "CustomNavigationVC.h"
#import "LiveMatchCell.h"
#import "FixtureTVC.h"
#import "DBManagerReports.h"
#import "DBManager.h"
#import "FixtureReportRecord.h"
#import "LiveReportRecord.h"
#import "FixtureReportRecord.h"
#import "ReportVC.h"
#import "DBManager.h"
#import "FetchSEPageLoadRecord.h"
#import "EventRecord.h"
#import "ResultReportRecord.h"
#import "DBManager.h"
#import "FetchSEPageLoadRecord.h"
#import "ReportVC.h"
#import "PlayingSquadRecords.h"
#import "PlayingSquadVC.h"
#import "EventRecord.h"

@interface FixtureAndResultsVC ()
{
    CustomNavigationVC *objCustomNavigation;
    
    BOOL isLive;
    BOOL isResult;
    BOOL isFixture;
    BOOL isFilter;
    NSString *comptnCode;
    DBManagerReports *objDBManagerReports;
    NSArray *MuliteDayMatchtype;
    UITableView* tournamentTableview;
}

@property (nonatomic,strong) NSMutableArray *fixturesResultArray;
@property (nonatomic,strong) NSMutableArray *torunamentArray;


@end

@implementation FixtureAndResultsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    MuliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];
    comptnCode= @"";
    self.lbl_compition.text = @"All";

    //self.CommonArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    isLive =YES;
    [self.matchListview .layer setBorderWidth:2.0];
    [self.matchListview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.matchListview .layer setMasksToBounds:YES];
    

    [self customnavigationmethod];
    
    
    [self didClickLiveBtn:0];
    self.sepratorYposition.constant =self.view.frame.size.width/2.5;

}

-(void)viewWillAppear:(BOOL)animated
{
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
    if(tableView == tournamentTableview){
        return self.torunamentArray.count;
    }else{
    return [_fixturesResultArray count];    //count number of row from counting array hear cataGorry is An Array
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * LiveMatch = @"LiveMatch";
    
    
    static NSString * FixtureMatch = @"FixtureMatch";
    
    if(tableView == tournamentTableview){
        //Other Cells
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        EventRecord *evRec = [self.torunamentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = evRec.competitionname;
        return cell;

    }else if(isLive == YES)
    {
        LiveMatchCell *cell = (LiveMatchCell *)[tableView dequeueReusableCellWithIdentifier:LiveMatch];
         if (cell == nil)
         {
            [[NSBundle mainBundle] loadNibNamed:@"LiveMatchCell" owner:self options:nil];
             cell = self.livematchCell;
            //self.batsManHeaderCell = nil;
         }
        
        cell.lbl_team_b_and.text = @"";
        cell.lbl_team_a_and.text = @"";
        cell.lbl_match_status.text = @"";
        cell.lbl_team_a_fst_inn_score.text = @"";
        cell.lbl_team_b_fst_inn_score.text = @"";
        cell.lbl_team_a_sec_inn_score.text = @"";
        cell.lbl_team_b_sec_inn_score.text = @"";
        cell.lbl_team_a_fst_inn_over.text = @"";
        cell.lbl_team_b_fst_inn_over.text = @"";
        cell.lbl_team_a_sec_inn_over.text = @"";
        cell.lbl_team_b_sec_inn_over.text = @"";

        
    [cell setBackgroundColor:[UIColor clearColor]];
    //tableView.allowsSelection = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LiveReportRecord *record = [_fixturesResultArray objectAtIndex:indexPath.row];
        
        
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:record.matchDate];
        [formatter setDateFormat:@"dd"];
        cell.lbl_day.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM yyyy"];
        cell.lbl_month.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.lbl_week_day.text=[formatter stringFromDate:date];
        
        cell.lbl_match_type.text = record.matchTypeName;
        
        [self setImage:record.teamAcode :cell.img_team_a_logo ];
        [self setImage:record.teamBcode :cell.lbl_team_b_logo ];
        
        cell.lbl_team_a_name.text = record.teamAname;
        cell.lbl_team_b_name.text = record.teamBname;
        
        
        NSMutableArray* objInniningsarray=[[[DBManager alloc]init] FETCHSEALLINNINGSSCOREDETAILS :record.competitionCode MATCHCODE :record.matchCode];
        
        if(objInniningsarray.count>0){
            
            
            
            FetchSEPageLoadRecord *objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];
            
            if(![objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:record.teamAshortName]){
                [self setImage:record.teamAcode :cell.lbl_team_b_logo ];
                [self setImage:record.teamBcode :cell.img_team_a_logo ];
                
                cell.lbl_team_a_name.text = record.teamBname;
                cell.lbl_team_b_name.text = record.teamAname;
            }
                
            
            
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
                
                
                if(![objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME]){
                    [self setImage:record.teamAcode :cell.lbl_team_b_logo ];
                    [self setImage:record.teamBcode :cell.img_team_a_logo ];
                    
                    cell.lbl_team_a_name.text = record.teamBname;
                    cell.lbl_team_b_name.text = record.teamAname;
                }

                
                
                if(![objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqual:@""])
                {
                    
                    if(![objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME]){
                        
                        cell.lbl_team_b_and.text=@"&";
                        cell.lbl_team_b_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.THIRDINNINGSTOTAL,objfetchSEPageLoadRecord.THIRDINNINGSWICKET];
                        cell.lbl_team_b_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.THIRDINNINGSOVERS];
                        
                    }else{
                    
                    cell.lbl_team_a_and.text=@"&";
                    cell.lbl_team_a_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.THIRDINNINGSTOTAL,objfetchSEPageLoadRecord.THIRDINNINGSWICKET];
                    cell.lbl_team_a_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.THIRDINNINGSOVERS];
                    }
                }
                else
                {
                    cell.lbl_team_a_sec_inn_score.text=@"";
                    cell.lbl_team_a_sec_inn_over.text=@"";
                }
                
                
                if(![objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME isEqual:@""])
                {
                    
                    if([objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME]){
                        cell.lbl_team_a_and.text=@"&";
                        cell.lbl_team_a_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FOURTHINNINGSTOTAL,objfetchSEPageLoadRecord.FOURTHINNINGSWICKET];
                        cell.lbl_team_a_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FOURTHINNINGSOVERS];
                    }else{
                    
                    cell.lbl_team_b_and.text=@"&";
                    cell.lbl_team_b_sec_inn_score.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FOURTHINNINGSTOTAL,objfetchSEPageLoadRecord.FOURTHINNINGSWICKET];
                    cell.lbl_team_b_sec_inn_over.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FOURTHINNINGSOVERS];
                    }
                }
                else{
                    if(!(![objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqual:@""] && (![objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME])))
                    {
                    cell.lbl_team_b_sec_inn_score.text=@"";
                    cell.lbl_team_b_sec_inn_over.text=@"";
                    }
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
                    
                   
                        
                                  }
                
            }
            
        }
    
    return cell;
    
    }
    else if (isResult ==YES)
    {
        LiveMatchCell *cell = (LiveMatchCell *)[tableView dequeueReusableCellWithIdentifier:LiveMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"LiveMatchCell" owner:self options:nil];
            cell = self.resultmatchCell;
            //self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbl_team_b_and.text = @"";
        cell.lbl_team_a_and.text = @"";
        cell.lbl_match_status.text = @"";
        cell.lbl_team_a_fst_inn_score.text = @"";
        cell.lbl_team_b_fst_inn_score.text = @"";
        cell.lbl_team_a_sec_inn_score.text = @"";
        cell.lbl_team_b_sec_inn_score.text = @"";
        cell.lbl_team_a_fst_inn_over.text = @"";
        cell.lbl_team_b_fst_inn_over.text = @"";
        cell.lbl_team_a_sec_inn_over.text = @"";
        cell.lbl_team_b_sec_inn_over.text = @"";
        ResultReportRecord *record = [_fixturesResultArray objectAtIndex:indexPath.row];
        
         cell.lbl_match_status.text = record.comments;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:record.matchDate];
        [formatter setDateFormat:@"dd"];
        cell.lbl_day.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM yyyy"];
        cell.lbl_month.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.lbl_week_day.text=[formatter stringFromDate:date];
        
        cell.lbl_match_type.text = record.matchTypeName;
        
        cell.lbl_team_a_name.text = record.teamAname;
        cell.lbl_team_b_name.text = record.teamBname;
        
        [self setImage:record.teamAcode :cell.img_team_a_logo ];
        [self setImage:record.teamBcode :cell.lbl_team_b_logo ];
        
        
        NSMutableArray* objInniningsarray=[[[DBManager alloc]init] FETCHSEALLINNINGSSCOREDETAILS:record.competitionCode MATCHCODE:record.matchCode];
        
        if(objInniningsarray.count>0){
            
            FetchSEPageLoadRecord *objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];
            
            if(![objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:record.teamAshortName]){
                [self setImage:record.teamAcode :cell.lbl_team_b_logo ];
                [self setImage:record.teamBcode :cell.img_team_a_logo ];
                
                cell.lbl_team_a_name.text = record.teamBname;
                cell.lbl_team_b_name.text = record.teamAname;
            }
            
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
                    cell.lbl_team_a_and.text=@"&";
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
                    cell.lbl_team_b_and.text=@"&";
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
        LiveMatchCell *cell = (LiveMatchCell *)[tableView dequeueReusableCellWithIdentifier:LiveMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"LiveMatchCell" owner:self options:nil];
            cell = self.livematchCell;
            
        }
        
        cell.lbl_team_b_and.text = @"";
        cell.lbl_team_a_and.text = @"";
        cell.lbl_match_status.text = @"";
        cell.lbl_team_a_fst_inn_score.text = @"";
        cell.lbl_team_b_fst_inn_score.text = @"";
        cell.lbl_team_a_sec_inn_score.text = @"";
        cell.lbl_team_b_sec_inn_score.text = @"";
        cell.lbl_team_a_fst_inn_over.text = @"";
        cell.lbl_team_b_fst_inn_over.text = @"";
        cell.lbl_team_a_sec_inn_over.text = @"";
        cell.lbl_team_b_sec_inn_over.text = @"";
        
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        FixtureReportRecord *objFixtureRecord=(FixtureReportRecord*)[_fixturesResultArray objectAtIndex:indexPath.row];
        
        cell.lbl_team_a_name.text = objFixtureRecord.teamAname;
        cell.lbl_team_b_name.text = objFixtureRecord.teamBname;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:objFixtureRecord.matchDate];
        [formatter setDateFormat:@"dd"];
        cell.lbl_day.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM yyyy"];
        cell.lbl_month.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.lbl_week_day.text=[formatter stringFromDate:date];
        
        cell.lbl_match_type.text = objFixtureRecord.matchTypeName;
        cell.lbl_match_status.text = [NSString stringWithFormat:@"%@,%@",objFixtureRecord.groundName,objFixtureRecord.city];
        
        [self setImage:objFixtureRecord.teamAcode :cell.img_team_a_logo ];
        [self setImage:objFixtureRecord.teamBcode :cell.lbl_team_b_logo ];
        
        
        return cell;
    }


    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(tableView == tournamentTableview){
        return 40;
    }else{
        return 160;
    }
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
    
    NSString *matchCode = objFixtureRecord.matchCode;
    NSString *teamAName = objFixtureRecord.teamAname;
    NSString *teamBName = objFixtureRecord.teamBname;
    NSString *venu = objFixtureRecord.groundName;
    NSString *city = objFixtureRecord.city;
    NSString *matchDate = objFixtureRecord.matchDate;
        NSString *matchType = objFixtureRecord.matchTypeName;
   
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:matchDate];
        
        [formatter setDateFormat:@"dd"];
        NSString *Date=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMM ''yy"];
        NSString *month=[formatter stringFromDate:date];
        
       [formatter setDateFormat:@"hh:mm a"];
        NSString *year=[formatter stringFromDate:date];
        
        detail.matchCode = matchCode;
        detail.teamAname = teamAName;
        detail.teamBname = teamBName;
        detail.venu = venu;
        detail.city = city;
        detail.date = Date;
        detail.month = month;
        detail.year = year;
        detail.teamACode = objFixtureRecord.teamAcode;
        detail.teamBCode = objFixtureRecord.teamBcode;
        detail.matchType = matchType;
    
   // PlayingSquadVC *playing = [[PlayingSquadVC alloc] initWithNibName:@"playingSquadId" bundle:nil];
    [self.navigationController pushViewController:detail animated:NO];
        
    }
    else if(tableView == tournamentTableview){
            isFilter = NO;
            EventRecord *evRec = [self.torunamentArray objectAtIndex:indexPath.row];
            comptnCode =  evRec.competitioncode;
            self.lbl_compition.text = evRec.competitionname;
            
            if(tournamentTableview!=nil){
                [tournamentTableview removeFromSuperview];
            }
            if(isLive){
                [self didClickLiveBtn:0];
            }else if(isResult){
                [self didClickResultBtn:0];
            }else if(isFixture){
                [self didClickFixtureBtn:0];
            }
        
        
    }else{
        
        ReportVC * objReport =  (ReportVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChartVC"];
        NSMutableArray* objInniningsarray;
        NSString *teamA;
        NSString *teamB;
        
        if(isLive == YES){
            LiveReportRecord *record = [_fixturesResultArray objectAtIndex:indexPath.row];
            objReport.matchCode = record.matchCode;
            objReport.competitionCode = record.competitionCode;
            objReport.matchTypeCode =record.matchTypeCode;
            objReport.teamcode  = record.teamAcode;
            
            
            
            teamA = record.teamAshortName;
            teamB = record.teamBshortName;
            
            
            objInniningsarray=[[[DBManager alloc]init] FETCHSEALLINNINGSSCOREDETAILS :record.competitionCode MATCHCODE :record.matchCode];

            
            
        }else if (isResult ==YES)
        {
            ResultReportRecord *record = [_fixturesResultArray objectAtIndex:indexPath.row];
            objReport.matchCode = record.matchCode;
            objReport.competitionCode = record.competitionCode;
            objReport.matchTypeCode =record.matchTypeCode;

         
            
            objInniningsarray=[[[DBManager alloc]init] FETCHSEALLINNINGSSCOREDETAILS :record.competitionCode MATCHCODE :record.matchCode];

        }
        
        objReport.fstInnShortName = teamA;
        objReport.secInnShortName = teamB;
        objReport.thrdInnShortName = teamA;
        objReport.frthInnShortName = teamB;
        
       
        
        if(objInniningsarray.count>0){
            FetchSEPageLoadRecord *objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];

            objReport.fstInnShortName = objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME;
            
            objReport.secInnShortName =  [objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqualToString:@""]?[teamA isEqualToString:objReport.fstInnShortName]?teamB:teamA:objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME;
            
            objReport.thrdInnShortName =  [objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqualToString:@""]?[teamA isEqualToString:objReport.fstInnShortName]?teamA:teamB:objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME;
            
            objReport.frthInnShortName =
                    [objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME isEqualToString:@""]?
                    [objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqualToString:@""]?
                    [teamA isEqualToString:objReport.fstInnShortName]?
                    teamB:teamA
                    :[objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqualToString:objReport.fstInnShortName]?
                    objReport.secInnShortName:objReport.fstInnShortName
                    :objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME;

        }
        
        [self.navigationController pushViewController:objReport animated:NO];
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
    _fixturesResultArray =[objDBManagerReports fetchLiveMatches:comptnCode==nil?@"":comptnCode :userCode];
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
    _fixturesResultArray =[objDBManagerReports fetchResultsMatches:comptnCode==nil?@"": comptnCode :userCode];
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
    _fixturesResultArray =[objDBManagerReports FixturesData :comptnCode==nil?@"":comptnCode:userCode];
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



- (IBAction)torunament_click:(id)sender {
    
    if(isFilter){
        isFilter = NO;
    if(tournamentTableview!=nil){
        [tournamentTableview removeFromSuperview];
    }
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userCode = [defaults objectForKey:@"userCode"];
        
        self.torunamentArray = [objDBManagerReports retrieveTorunamentData:userCode];
        isFilter=YES;
    tournamentTableview =[[UITableView alloc]initWithFrame:CGRectMake(175, 655,self.btn_compitionselect.frame.size.width,250)];
    tournamentTableview.backgroundColor=[UIColor whiteColor];
    tournamentTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tournamentTableview setSeparatorColor:[UIColor whiteColor]];
    
    
    tournamentTableview.dataSource = self;
    tournamentTableview.delegate = self;
    [self.view addSubview:tournamentTableview];
    [tournamentTableview reloadData];
    
    }
    
    int indx=0;
    int selectePosition = -1;
    for (EventRecord *record in self.torunamentArray)
    {
        bool chk = ([[record competitioncode] isEqualToString:comptnCode]);
        if (chk)
        {
            selectePosition = indx;
            break;
        }
        indx ++;
    }
    
    if(selectePosition!=-1){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
        [tournamentTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [tournamentTableview scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
    }
    
}
@end
