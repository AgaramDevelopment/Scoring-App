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
#import "InningsBowlerDetailsRecord.h"
#import "EditModeCell.h"
@interface EditModeVC ()
{
    CustomNavigationVC * objCustomNavigation;
    NSMutableArray* inningsDetail;
}

@end

@implementation EditModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customnavigationmethod];
    inningsDetail =[[NSMutableArray alloc]init];
   inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    // Do any additional setup after loading the view.
}
-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"ARCHIVES";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [inningsDetail count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"EditModeCell";
    
    
    //EditModeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    EditModeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier
                                                         forIndexPath:indexPath];
    
    //cell.delegate = self;
    //    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
    //        [cell openCell];
    //    }
    
    
    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexPath.row];
    cell.lbl_playername.text =objInningsBowlerDetailsRecord.Playername;
   
    cell.lbl_overs.text= objInningsBowlerDetailsRecord.OverNo;
    cell.lbl_overcountwkt.text=objInningsBowlerDetailsRecord.totalRuns;
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
