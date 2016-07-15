////
////  RightSlideVC.m
////  CAPScoringApp
////
////  Created by mac on 15/06/16.
////  Copyright © 2016 agaram. All rights reserved.
////
//
//#import "RightSlideVC.h"
//
//
//
//#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define IS_IPAD_PRO (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)
//@interface RightSlideVC ()<UITableViewDelegate,UITableViewDataSource>
//
//
//@end
//
//
//
//@implementation RightSlideVC
//@synthesize rightSlideTableView;
//@synthesize rightSlideArray;
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//   rightSlideArray = [[NSMutableArray alloc]initWithObjects:@"BREAK",@"CHANGE TEAM", @"DECLARE INNINGS",@"END DAY",@"END INNINGS",@"END SESSION",@"FOLLOW ON",@"PLAYING XI EDIT",@"MATCH RESULT",@"OTHER WICKETS",@"PENALTY",@"POWER PLAY",@"REVISED OVERS",@"REVISED TARGET",nil];
//    
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    
//           return [rightSlideArray count];
//    
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    
//    if(tableView == rightSlideTableView){
//        
//        cell.textLabel.text = [rightSlideArray objectAtIndex:indexPath.row];
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
//    
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//   
//}
//
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    if (indexPath.row==0) {
//        if (IS_IPAD_PRO) {
//            intialBreakVC *add = [[intialBreakVC alloc]initWithNibName:@"intialBreakVC" bundle:nil];
//            
//            
//            
//            //vc2 *viewController = [[vc2 alloc]init];
//            [self addChildViewController:add];
//            
//            add.view.frame =CGRectMake(250, 500, add.view.frame.size.width, add.view.frame.size.height);
//            [self.view addSubview:add.view];
//            add.view.alpha = 0;
//            [add didMoveToParentViewController:self];
//            
//            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//             {
//                 add.view.alpha = 1;
//             }
//                             completion:nil];
//        }
//        
//        
//        else{
//            intialBreakVC *add = [[intialBreakVC alloc]initWithNibName:@"intialBreakVC" bundle:nil];
//            
//            
//            
//            //vc2 *viewController = [[vc2 alloc]init];
//            [self addChildViewController:add];
//            
//            add.view.frame =CGRectMake(100, 200, add.view.frame.size.width, add.view.frame.size.height);
//            [self.view addSubview:add.view];
//            add.view.alpha = 0;
//            [add didMoveToParentViewController:self];
//            
//            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//             {
//                 add.view.alpha = 1;
//             }
//                             completion:nil];
//        }
//
//    }
//    
//    
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
