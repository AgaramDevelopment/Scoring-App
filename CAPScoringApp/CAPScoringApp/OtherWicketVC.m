//
//  OtherWicketVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/18/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "OtherWicketVC.h"
#import "OtherWicketTVC.h"

@interface OtherWicketVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *OtherwicketArray;
@end

@implementation OtherWicketVC
@synthesize matchcode;
@synthesize competitioncode;

NSArray *otherwicketData;

- (void)viewDidLoad {
    [super viewDidLoad];
    otherwicketData = [NSArray arrayWithObjects:@"Mankading",@"Absnce Hurt",@"Timed Out",@"Retired Hurt",@"Retired Out", nil ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

//otherwicket tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [otherwicketData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"OtherwicketCell";
    OtherWicketTVC *cell = (OtherWicketTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OtherWicketTVC" owner:self options:nil];
        cell = self.otherwicet_cell;
        self.otherwicet_cell = nil;
    }
    
    cell.lbl_otherwicketcell.text=[otherwicketData objectAtIndex:indexPath.row];
  
    
    
    
    return cell;
    
}
    


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    selectindexarray=[[NSMutableArray alloc]init];
//    objMetaDataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
//    self.lbl_penaltytype.text =objMetaDataRecord.metasubcodedescription;
//    penaltytypereasons=objMetaDataRecord.metasubcode;
//    [selectindexarray addObject:objMetaDataRecord];
//    self.tbl_penality.hidden=YES;
    
}


@end
