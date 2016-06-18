//
//  PenalityVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/16/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PenalityVC.h"
#import "PenalityTVC.h"
#import "DBManager.h"
#import "MetaDataRecord.h"
#import "PenaltyDetailsRecord.h"

@interface PenalityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * selectindexarray;
}
@property (nonatomic,strong)NSMutableArray *FetchPenalityArray;
@end

NSString *btnbatting;
NSString *penaltytypereasons;

@implementation PenalityVC
@synthesize metadatatypecode;
@synthesize matchcode;
@synthesize metasubcode;
@synthesize competitioncode;
@synthesize txt_penalityruns;

PenaltyDetailsRecord *penaltyrecord;
MetaDataRecord *objMetaDataRecord;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DBManager GetPenaltyDetailsForPageLoadPenalty:self.competitioncode :self.matchcode :@"2"];
    
    
    [self.txt_penalityruns.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txt_penalityruns.layer.borderWidth=2;
    
    [self.view_batting.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_batting.layer.borderWidth=2;
    
    [self.view_bowling.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_bowling.layer.borderWidth=2;
    
    [self.view_penalityreason.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_penalityreason.layer.borderWidth=2;
    
     self.tbl_penality.hidden=YES;
    
    [super viewWillAppear:YES];
    
    
}


//penality tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_FetchPenalityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
   {
    static NSString *MyIdentifier = @"Penalitycell";
    PenalityTVC *cell = (PenalityTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PenalityTVC" owner:self options:nil];
        cell = self.penality_cell;
        self.penality_cell = nil;
    }
    
     MetaDataRecord *objmetaRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
    
     cell.lbl_penalitycell.text = objmetaRecord.metasubcodedescription;
      
     [cell setBackgroundColor:[UIColor clearColor]];

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    selectindexarray=[[NSMutableArray alloc]init];
    objMetaDataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:indexPath.row];
    self.lbl_penaltytype.text =objMetaDataRecord.metasubcodedescription;
     penaltytypereasons=objMetaDataRecord.metasubcode;
    [selectindexarray addObject:objMetaDataRecord];
    self.tbl_penality.hidden=YES;

}

//batting button
-(IBAction)didClickBatting:(id)sender
{
    btnbatting=@"MSC134";
  
        self.lbl_penaltytype.text=@"Choose Penalty Type";
    self.tbl_penality.hidden=YES;
        _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT030"];
        for(int i=0; i < [_FetchPenalityArray count]; i++)
        {
            MetaDataRecord *objmetadataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:i];
            NSLog(@"%@",objmetadataRecord.metasubcodedescription);
            NSString *metastatus=objmetadataRecord.metasubcodedescription;
            if([metastatus isEqualToString:@"MDT030"])
            {
                [_FetchPenalityArray addObject:objmetadataRecord];
            }
           penaltyrecord.penaltytypedescription=@"MSC134";

        }
        [self.tbl_penality reloadData];
    
}

//bowling button
-(IBAction)didClickBowling:(id)sender
{
 btnbatting=@"MSC135";
    self.lbl_penaltytype.text=@"Choose Penalty Type";
    self.tbl_penality.hidden=YES;
    _FetchPenalityArray=[DBManager GetPenaltyReasonForPenalty:metadatatypecode=@"MDT031"];
    for(int i=0; i < [_FetchPenalityArray count]; i++)
    {
        
        MetaDataRecord *objmetadataRecord=(MetaDataRecord*)[_FetchPenalityArray objectAtIndex:i];
        NSLog(@"%@",objmetadataRecord.metasubcodedescription);
        NSString *metastatus=objmetadataRecord.metasubcodedescription;
        if([metastatus isEqualToString:@"MDT031"])
        {
            [_FetchPenalityArray addObject:objmetadataRecord];
        }
        
    }
   penaltyrecord.penaltytypedescription=@"MSC135";
    
    [self.tbl_penality reloadData];
}



//drop down button
-(IBAction)didclicktouch:(id)sender{
    
   self.tbl_penality.hidden=NO;
    
}


-(IBAction)didclicksubmit:(id)sender{
    
    PenaltyDetailsRecord *penaltyrecord = [[PenaltyDetailsRecord alloc]init];
    objMetaDataRecord=[[MetaDataRecord alloc]init];
    penaltyrecord.penaltyruns=txt_penalityruns.text;
    penaltyrecord.penaltytypecode=btnbatting;
    penaltyrecord.penaltyreasoncode=penaltytypereasons;

   
   
[DBManager SetPenaltyDetails:self.competitioncode :self.matchcode :@"2" :@"17258" :@"PNT0000004" :@"TEA0000006" :penaltyrecord.penaltyruns :penaltyrecord.penaltytypecode :penaltyrecord.penaltyreasoncode];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
