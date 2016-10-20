//
//  CommentaryVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "CommentaryVC.h"

@interface CommentaryVC ()

@end

@implementation CommentaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame =CGRectMake(0,180, [[UIScreen mainScreen] bounds].size.width, 1000);

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





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==_commentary_tableview){
        static NSString * commentaryCell = @"commentry_cell";
        
        
        
        
        CommentaryTVC *cell = (CommentaryTVC *)[tableView dequeueReusableCellWithIdentifier:commentaryCell];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CommentaryTVC" owner:self options:nil];
            cell = self.commentry_tvc;
        }
        
        
        //  [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
        
        return cell;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 200;
    
}


@end
