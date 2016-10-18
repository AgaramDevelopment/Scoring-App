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
#import "FixtureReportRecord.h"
#import "LiveReportRecord.h"
#import "FixtureReportRecord.h"

@interface FixtureAndResultsVC ()
{
     CustomNavigationVC *objCustomNavigation;
    
    BOOL isLive;
    BOOL isResult;
    BOOL isFixture;
    DBManagerReports *objDBManagerReports;
    
}

@property (nonatomic,strong) NSMutableArray *fixturesResultArray;


@end

@implementation FixtureAndResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)viewWillAppear:(BOOL)animated

{
     self.sepratorYposition.constant = self.view.frame.size.width/2.5;
    self.CommonArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    isLive =YES;
    [self.matchListview .layer setBorderWidth:2.0];
    [self.matchListview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.matchListview .layer setMasksToBounds:YES];
    

    [self customnavigationmethod];
   

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
        
        
        return cell;
    }
    else if (isFixture ==YES)
    {
        FixtureTVC *cell = (FixtureTVC *)[tableView dequeueReusableCellWithIdentifier:FixtureMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"FixtureCell" owner:self options:nil];
            cell = self.fixtureCell;
            
        }
        
        FixtureReportRecord *objFixtureRecord=(FixtureReportRecord*)[_fixturesResultArray objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:objFixtureRecord.matchDate];
        [formatter setDateFormat:@"dd"];
        cell.day_no_txt.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM"];
        cell.month_txt.text=[formatter stringFromDate:date];
        
        [formatter setDateFormat:@"EEEE"];
        cell.day_txt.text=[formatter stringFromDate:date];
        
        
            cell.teamA_txt.text = objFixtureRecord.teamAname;
            cell.teamB_txt.text = objFixtureRecord.teamBname;
            cell.match_type.text = objFixtureRecord.matchName;
            cell.venu_txt.text = [NSString stringWithFormat:@"%@ , %@", objFixtureRecord.groundName,objFixtureRecord.city];
            
      
        
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }


    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 160;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    Yourstring=[catagorry objectAtIndex:indexPath.row];
//    
//    //Pushing next view
//    cntrSecondViewController *cntrinnerService = [[cntrSecondViewController alloc] initWithNibName:@"cntrSecondViewController" bundle:nil];
//    [self.navigationController pushViewController:cntrinnerService animated:YES];
    
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

    
    isLive = NO;
    isResult = NO;
    isFixture = YES;
    [self.FixResult_Tbl reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setImage:(NSString *)teamCode:(UIImageView *)teamLogoImg {
    
    
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
