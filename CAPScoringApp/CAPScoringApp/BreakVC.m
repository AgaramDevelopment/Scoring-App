//
//  BreakVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BreakVC.h"
#import "BreakTableViewCell.h"
#import "DBManager.h"
#import "BreakEventRecords.h"
#import "AddBreakVC.h"
#import "UpdateBreakVC.h"

@interface BreakVC ()

@end

@implementation BreakVC

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
   // self.view.frame =CGRectMake(100,350, [[UIScreen mainScreen] bounds].size.width/2, 500);
    

    
       
//    UINib *nib = [UINib nibWithNibName:@"BreakTableViewCell" bundle:nil];
//    [[self tablView] registerNib:nib forCellReuseIdentifier:@"BreakTableViewCell"];
    
    //[self.tablView reloadData];
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
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *breakidentifier = @"BreakCell";
    
    
    BreakTableViewCell *cell = (BreakTableViewCell *)[tableView dequeueReusableCellWithIdentifier:breakidentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BreakTableViewCell" owner:self options:nil];
        cell = self.GridBreakcell;
        self.GridBreakcell = nil;
    }
    BreakEventRecords *veb=(BreakEventRecords*)[_resultarray objectAtIndex:indexPath.row];
    
    
    cell.test.text=veb.BREAKCOMMENTS;
    
    cell.Starttime_lbl.text=veb.BREAKSTARTTIME;
     cell.Endtime_lbl.text=veb.BREAKENDTIME;
     cell.duration_lbl.text=veb.DURATION;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UpdateBreakVC*add = [[UpdateBreakVC alloc]initWithNibName:@"UpdateBreakVC" bundle:nil];
    
    
   
    
    //vc2 *viewController = [[vc2 alloc]init];
    
    NSDictionary *sample=[self.resultarray objectAtIndex:indexPath.row];
     add.test=sample;
    
    add.COMPETITIONCODE=COMPETITIONCODE;
    add.resultarray=_resultarray;
    add.MATCHCODE=MATCHCODE;
    add.INNINGSNO=INNINGSNO;
    add.MATCHDATE=_MATCHDATE;
    
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
    

    
    // //destViewController = [CategoryVC.destViewController objectAtIndex:0];
    

}




- (IBAction)addbreak_btn:(id)sender {
    
    AddBreakVC*add = [[AddBreakVC alloc]initWithNibName:@"AddBreakVC" bundle:nil];
    
    add.COMPETITIONCODE=self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
    add.MATCHDATE=self.MATCHDATE;
    add.delegate =self.delegate;
    //vc2 *viewController = [[vc2 alloc]init];
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

- (IBAction)backbtn:(id)sender {
    
     [self.delegate ChangeVCBackBtnAction];
}
@end
