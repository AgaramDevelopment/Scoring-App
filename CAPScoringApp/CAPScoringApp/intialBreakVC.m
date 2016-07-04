//
//  intialBreakVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 18/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "intialBreakVC.h"
#import "AddBreakVC.h"
@interface intialBreakVC ()

@end

@implementation intialBreakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Firsttouch_btn:(id)sender {
    
     AddBreakVC*add = [[AddBreakVC alloc]initWithNibName:@"AddBreakVC" bundle:nil];
    
    add.COMPETITIONCODE=self.COMPETITIONCODE;
    add.MATCHCODE=self.MATCHCODE;
    add.INNINGSNO=self.INNINGSNO;
    
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
