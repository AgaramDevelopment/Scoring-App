//
//  Other_WicketgridVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/2/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Other_WicketgridVC.h"
#import"GetWicketEventsPlayerDetail.h"
#import "DbManager_OtherWicket.h"

@interface Other_WicketgridVC ()

@end

@implementation Other_WicketgridVC
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize TEAMCODE;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;


@synthesize MAXOVER;
@synthesize MAXBALL;
@synthesize BALLCODE;
@synthesize BALLCOUNT;
@synthesize MAXID;
@synthesize N_WICKETNO;
@synthesize N_WICKETTYPE;
@synthesize N_FIELDERCODE;
@synthesize BATTINGPOSITIONNO;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _GetWicketEventsPlayerDetails=[ DbManager_OtherWicket GetWicketEventDetailsForInsertOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
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
    
    return [_GetWicketEventsPlayerDetails count];

    

}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *breakidentifier = @"otherwicketcell";
    
    
    Other_WicketgridTVC *cell = (Other_WicketgridTVC *)[tableView dequeueReusableCellWithIdentifier:breakidentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"Other_WicketgridTVC" owner:self options:nil];
        cell = self.Other_WicketCell;
        self.Other_WicketCell = nil;
    }
    
    GetWicketEventsPlayerDetail *veb =(GetWicketEventsPlayerDetail*)[_GetWicketEventsPlayerDetails objectAtIndex:indexPath.row];
    
    cell.lbl_wickettype.text=veb.WICKETTYPE;
    cell.lbl_playername.text=veb.WICKETPLAYER;
    cell.lbl_wicketno.text=veb.WICKETNO;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Other_WicketVC*add = [[Other_WicketVC alloc]initWithNibName:@"Other_WicketVC" bundle:nil];
    
    GetWicketEventsPlayerDetail *veb =(GetWicketEventsPlayerDetail*)[_GetWicketEventsPlayerDetails objectAtIndex:indexPath.row];
    
//    cell.lbl_wickettype.text=veb.WICKETTYPE;
//    cell.lbl_playername.text=veb.WICKETPLAYER;
//    cell.lbl_wicketno.text=veb.WICKETNO;

    
    add.COMPETITIONCODE=COMPETITIONCODE;
    add.MATCHCODE=MATCHCODE;
    add.INNINGSNO=INNINGSNO;
    add.WICKETTYPE=veb.WICKETTYPE;
    add.WICKETPLAYER=veb.WICKETPLAYER;
    add.WICKETNO=veb.WICKETNO;
    add.TEAMCODE = TEAMCODE;
    add.ISEDITMODE =YES;
    
    
    
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_addotherwickets:(id)sender {
    
    Other_WicketVC *add = [[Other_WicketVC alloc]initWithNibName:@"Other_WicketVC" bundle:nil];
    
    add.COMPETITIONCODE =self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
    add.TEAMCODE=self.TEAMCODE;
    add.WICKETNO = [NSString stringWithFormat:@"%@",self.N_WICKETNO];
    add.ISEDITMODE=NO;
    
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
@end
