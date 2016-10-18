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
#import "FixturesCell.h"

@interface FixtureAndResultsVC ()
{
     CustomNavigationVC *objCustomNavigation;
    BOOL isLive;
    BOOL isResult;
    BOOL isFixture;
}

@property (nonatomic,strong) NSMutableArray * CommonArray;

@end

@implementation FixtureAndResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CommonArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    isLive =YES;
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
    
    return [self.CommonArray count];    //count number of row from counting array hear cataGorry is An Array
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
    
    return cell;
    
    }
    else if (isResult ==YES)
    {
        ResultMatchCell *cell = (ResultMatchCell *)[tableView dequeueReusableCellWithIdentifier:ResultMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ResultMatchCell" owner:self options:nil];
            //cell = self.batsManHeaderCell;
            //self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (isFixture ==YES)
    {
        FixturesCell *cell = (FixturesCell *)[tableView dequeueReusableCellWithIdentifier:FixtureMatch];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"FixturesCell" owner:self options:nil];
            //cell = self.batsManHeaderCell;
            //self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }


    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 197;
    
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
    isLive = YES;
    isResult = NO;
    isFixture = NO;
    NSMutableArray * Livematchlist =[[NSMutableArray alloc]init];
    self.CommonArray =Livematchlist;
    [self.FixResult_Tbl reloadData];
}

-(IBAction)didClickResultBtn:(id)sender
{
    isLive = NO;
    isResult = YES;
    isFixture = NO;
    NSMutableArray * Resultmatchlist =[[NSMutableArray alloc]init];
    self.CommonArray =Resultmatchlist;
    [self.FixResult_Tbl reloadData];
}

-(IBAction)didClickFixtureBtn:(id)sender
{
    isLive = NO;
    isResult = NO;
    isFixture = YES;
    NSMutableArray * MatchFixerlist =[[NSMutableArray alloc]init];
    self.CommonArray =MatchFixerlist;
    [self.FixResult_Tbl reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
