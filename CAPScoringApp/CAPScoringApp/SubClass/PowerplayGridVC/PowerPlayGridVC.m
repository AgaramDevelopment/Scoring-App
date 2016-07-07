//
//  PowerPlayGridVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/25/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PowerPlayGridVC.h"
#import "PowerPlayRecord.h"
#import "PowerPlayVC.h"
#import "PowerPlayGridTVC.h"
#import "DBManager.h"


@interface PowerPlayGridVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *sample;


@end

@implementation PowerPlayGridVC
@synthesize matchCode;
@synthesize competitionCode;
@synthesize inningsNo;
@synthesize powerplaystartover;
@synthesize powerplayendover;
@synthesize powerplaytyp;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultarray =[[NSMutableArray alloc]init];
    
    _resultarray= [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    static NSString *myidentifier = @"powerplaygridcell";
    
    
    PowerPlayGridTVC *cell = (PowerPlayGridTVC *)[tableView dequeueReusableCellWithIdentifier:myidentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PowerPlayGridTVC" owner:self options:nil];
        
        cell=self.powerplay_cell;
        self.powerplay_cell=nil;
    }
    PowerPlayRecord *veb=(PowerPlayRecord*)[_resultarray objectAtIndex:indexPath.row];
    
    
    cell.LBL_STARTOVER.text=veb.startover;
    cell.LBL_ENDOVER.text=veb.endover;
    cell.TOTAL_OVER.text=veb.totalovers;
    cell.LBL_POWERPLAYTYPENAME.text=veb.powerplaytypename;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    return cell;
    
    
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PowerPlayVC *add = [[PowerPlayVC alloc]initWithNibName:@"PowerPlayVC" bundle:nil];
    
    NSDictionary *sample=[[NSDictionary alloc]init];
    sample=[self.resultarray objectAtIndex:indexPath.row];
    PowerPlayRecord *veb=(PowerPlayRecord*)[_resultarray objectAtIndex:indexPath.row];
    
    add.competitionCode=competitionCode;
    add.matchCode=matchCode;
    add.inningsNo=inningsNo;
    add.powerplaystartover=veb.startover;
    add.powerplayendover=veb.endover;
    add.powerplaytyp=veb.powerplaytypename;
    add.powerplaycode=veb.powerplaycode;
    

    
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

- (IBAction)btn_addppowerplay:(id)sender {
    
    PowerPlayVC *powerplayvc = [[PowerPlayVC alloc]init];
    
    powerplayvc.matchCode=self.matchCode;
    powerplayvc.competitionCode=self.competitionCode;
    powerplayvc.inningsNo=self.inningsNo;
    
    
    [self.view addSubview:powerplayvc.view];
    [self addChildViewController:powerplayvc];
    powerplayvc.view.frame =CGRectMake(0, 0, powerplayvc.view.frame.size.width, powerplayvc.view.frame.size.height);
    [self.view addSubview:powerplayvc.view];
    powerplayvc.view.alpha = 0;
    [powerplayvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         powerplayvc.view.alpha = 1;
     }
                     completion:nil];
}
@end
