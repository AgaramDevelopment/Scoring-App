//
//  OtherWicketPlayerlistVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/18/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "OtherWicketPlayerlistVC.h"
#import "OtherWicketPlayerlistTVC.h"

@interface OtherWicketPlayerlistVC ()
@property (nonatomic,strong)NSMutableArray *resultArray;

@end

@implementation OtherWicketPlayerlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//penality tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"otherwicketplayerCell";
    OtherWicketPlayerlistTVC *cell = (OtherWicketPlayerlistTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OtherWicketPlayerlistTVC" owner:self options:nil];
        cell = self.playerdetailscell;
        self.playerdetailscell = nil;
    }
    
   // MetaDataRecord *objmetaRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
    
    //cell.lbl_playercell.text = objmetaRecord.metasubcodedescription;
    
    
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
