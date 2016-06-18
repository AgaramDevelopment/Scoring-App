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

@interface BreakVC ()

@end

@implementation BreakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.view.frame =CGRectMake(100,350, [[UIScreen mainScreen] bounds].size.width/2, 500);
    

    
  
    
//    UINib *nib = [UINib nibWithNibName:@"BreakTableViewCell" bundle:nil];
//    [[self tablView] registerNib:nib forCellReuseIdentifier:@"BreakTableViewCell"];
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
    
    return [_resultarray count];    //count number of row from counting array hear cataGorry is An Array
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
    
    
    cell.test.text=veb.BREAKSTARTTIME;
    return cell;
}


  






- (IBAction)addbreak_btn:(id)sender {
    
    AddBreakVC *add = [[AddBreakVC alloc]initWithNibName:@"AddBreakVC" bundle:nil];
    
    
    
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:add];
    add.view.frame =CGRectMake(300, 500, add.view.frame.size.width, add.view.frame.size.height);
    [self.view addSubview:add.view];
    add.view.alpha = 0;
    [add didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         add.view.alpha = 1;
     }
                     completion:nil];
    

}
@end
