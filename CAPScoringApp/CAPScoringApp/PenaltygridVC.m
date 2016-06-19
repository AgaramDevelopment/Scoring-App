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

@end

@implementation PenaltygridVC
@synthesize matchcode;
@synthesize competitioncode;




- (void)viewDidLoad {
    [super viewDidLoad];

    _resultarray=[DBManager SetPenaltyDetailsForInsert:self.competitioncode :self.matchcode :@"2"];
    
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
    
    NSDictionary *sample=[self.resultarray objectAtIndex:indexPath.row];
    add.test=sample;
    
    add.competitioncode=competitioncode;
    add.matchcode=matchcode;
    
    
    [self addChildViewController:add];
    add.view.frame =CGRectMake(-200, -200, add.view.frame.size.width, add.view.frame.size.height);
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
    
    penaltyvc.matchcode=self.matchcode;
    penaltyvc.competitioncode=self.competitioncode;
    
    [self.view addSubview:penaltyvc.view];
    [self addChildViewController:penaltyvc];
    penaltyvc.view.frame =CGRectMake(0, 0, penaltyvc.view.frame.size.width-50, penaltyvc.view.frame.size.height);
    [self.view addSubview:penaltyvc.view];
    penaltyvc.view.alpha = 0;
    [penaltyvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         penaltyvc.view.alpha = 1;
     }
                     completion:nil];

}
@end
