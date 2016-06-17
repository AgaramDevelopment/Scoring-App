//
//  RightSlideVC.m
//  CAPScoringApp
//
//  Created by mac on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "RightSlideVC.h"

@interface RightSlideVC ()<UITableViewDelegate,UITableViewDataSource>


@end



@implementation RightSlideVC
@synthesize rightSlideTableView;
@synthesize rightSlideArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   rightSlideArray = [[NSMutableArray alloc]initWithObjects:@"BREAK",@"CHANGE TEAM", @"DECLARE INNINGS",@"END DAY",@"END INNINGS",@"END SESSION",@"FOLLOW ON",@"PLAYING XI EDIT",@"MATCH RESULT",@"OTHER WICKETS",@"PENALTY",@"POWER PLAY",@"REVISED OVERS",@"REVISED TARGET",nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
           return [rightSlideArray count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(tableView == rightSlideTableView){
        
        cell.textLabel.text = [rightSlideArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
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

@end
