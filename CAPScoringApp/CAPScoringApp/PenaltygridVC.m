//
//  PenaltygridVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/18/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PenaltygridVC.h"
#import "PenaltyDetailsRecord.h"
#import "PenalityVC.h"
#import "PenaltyGridTVC.h"
#import "DBManager.h"

@interface PenaltygridVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *sample;

@end

@implementation PenaltygridVC
@synthesize matchCode;
@synthesize competitionCode;
@synthesize teamcode;
@synthesize inningsNo;
@synthesize penaltyCode;




- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultarray =[[NSMutableArray alloc]init];
    DBManager *objDBManager = [[DBManager alloc]init];
    
    _resultarray=[objDBManager SetPenaltyDetailsForInsert:self.competitionCode :self.matchCode :self.inningsNo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_resultarray count];
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *myidentifier = @"penaltygridCell";
    
    
    PenaltyGridTVC *cell = (PenaltyGridTVC *)[tableView dequeueReusableCellWithIdentifier:myidentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PenaltyGridTVC" owner:self options:nil];
        cell = self.penalty_gridCell;
        self.penalty_gridCell = nil;
    }
    PenaltyDetailsRecord *veb=(PenaltyDetailsRecord*)[_resultarray objectAtIndex:indexPath.row];
    
    
    cell.lbl_awardedto.text=veb.penaltytypedescription;
    cell.lbl_penaltyruns.text=veb.penaltyruns;
    cell.lbl_penaltytype.text=veb.penaltyreasondescription;
    

    return cell;
 
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PenalityVC *add = [[PenalityVC alloc]initWithNibName:@"PenalityVC" bundle:nil];
    
    NSDictionary *sample=[[NSDictionary alloc]init];
    sample=[self.resultarray objectAtIndex:indexPath.row];
    PenaltyDetailsRecord *veb=(PenaltyDetailsRecord*)[_resultarray objectAtIndex:indexPath.row];
    
    add.penaltyDetailsRecord=veb;
    add.competitionCode=competitionCode;
    add.matchCode=matchCode;
    add.inningsNo=inningsNo;
    add.penaltyCode = penaltyCode;
    
    
    [self addChildViewController:add];
    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
    [self.view addSubview:add.view];
    add.view.alpha = 0;
    [add didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         add.view.alpha = 1;
     }
                     completion:nil];
    
    
    
}


- (IBAction)btn_addpenalty:(id)sender {
    
    PenalityVC *penaltyvc = [[PenalityVC alloc]init];
    
    penaltyvc.matchCode=self.matchCode;
    penaltyvc.competitionCode=self.competitionCode;
    penaltyvc.inningsNo=self.inningsNo;
    penaltyvc.teamcode =self.teamcode;
    
    
    [self.view addSubview:penaltyvc.view];
    [self addChildViewController:penaltyvc];
    penaltyvc.view.frame =CGRectMake(0, 0, penaltyvc.view.frame.size.width, penaltyvc.view.frame.size.height);
    [self.view addSubview:penaltyvc.view];
    penaltyvc.view.alpha = 0;
    [penaltyvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         penaltyvc.view.alpha = 1;
     }
                     completion:nil];

}
-(IBAction)btn_back:(id)sender
{
    
    [self.delegate ChangeVCBackBtnAction];
}
@end
