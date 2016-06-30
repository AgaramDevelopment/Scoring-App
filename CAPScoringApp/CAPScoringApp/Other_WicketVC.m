//
//  Other_WicketVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Other_WicketVC.h"
#import "DbManager_OtherWicket.h"
#import "WicketTypeRecord.h"

@interface Other_WicketVC ()
{
    WicketTypeRecord*objEventRecord;
    NSMutableArray *Wicketselectindexarray;
    BOOL isEnableTbl;
}
@property(nonatomic,strong)NSMutableArray *WICKETARRAY;
@property(nonatomic,strong)NSString *METASUBCODE;



@end

@implementation Other_WicketVC

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize TEAMCODE;
@synthesize Wicket_lbl;
@synthesize Wicket_tableview;
@synthesize WICKETARRAY;
@synthesize METASUBCODE;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //    NSMutableArray *GetPlayerDeatilsFetchWicket=[DbManager_OtherWicket GetPlayerDetailForFetchOtherwicket:COMPETITIONCODE:MATCHCODE:TEAMCODE];
    //
    //    NSMutableArray *GetWicketEvenUpadteOtherWicket=[DbManager_OtherWicket GetWicketEventDetailsForFetchOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO];
    //
    //    [DbManager_OtherWicket GetWicketNoForFetchOtherwicket :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO];
    //
    //    NSMutableArray *GetNotOutAndOutBats=[DbManager_OtherWicket GetNotOutAndOutBatsManForFetchOtherwicket:MATCHCODE:TEAMCODE];
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
{  if (tableView == self.Wicket_tableview)
{
    return 1;
}//count of section
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.Wicket_tableview)
    {
        return [WICKETARRAY count];
    }
    
    if (tableView == self.Wicket_tableview)
    {
        return [WICKETARRAY count];
    }
    
    else
        return 1;
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.Wicket_tableview)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objEventRecord=(WicketTypeRecord*)[WICKETARRAY objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objEventRecord.metasubcodedescription;
        METASUBCODE=objEventRecord.metasubcode;
        
        return cell;
    }
    
    
    if (tableView == self.Wicket_tableview)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objEventRecord=(WicketTypeRecord*)[WICKETARRAY objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objEventRecord.metasubcodedescription;
        METASUBCODE=objEventRecord.metasubcode;
        
        return cell;
    }
    

    
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.Wicket_tableview)
    {
        
        
        Wicketselectindexarray=[[NSMutableArray alloc]init];
        objEventRecord=(WicketTypeRecord*)[WICKETARRAY objectAtIndex:indexPath.row];
        self.Wicket_lbl.text =objEventRecord.metasubcodedescription;
        METASUBCODE=self.Wicket_lbl.text;
        METASUBCODE=objEventRecord.metasubcode;
        [Wicketselectindexarray addObject:objEventRecord];
        
        self.Wicket_tableview.hidden=YES;
        isEnableTbl=YES;
    }
    if (tableView == self.Wicket_tableview)
    {
        
        
//        Wicketselectindexarray=[[NSMutableArray alloc]init];
//        objEventRecord=(WicketTypeRecord*)[WICKETARRAY objectAtIndex:indexPath.row];
//        self.Wicket_lbl.text =objEventRecord.metasubcodedescription;
//        METASUBCODE=self.Wicket_lbl.text;
//        METASUBCODE=objEventRecord.metasubcode;
//        [Wicketselectindexarray addObject:objEventRecord];
//        
//        self.Wicket_tableview.hidden=YES;
//        isEnableTbl=YES;
    }

    
}


- (IBAction)Wicket_btn:(id)sender {
    
}
- (IBAction)add_btn:(id)sender {
}

- (IBAction)back_btn:(id)sender {
}




-(IBAction)didclicktouchplayer:(id)sender{
    self.tbl_playername.hidden=YES;
    
}



-(IBAction)didclicktouch:(id)sender{
    
   
        WICKETARRAY=[[NSMutableArray alloc]init];
        NSMutableArray * FetchWicketArray =[DbManager_OtherWicket RetrieveOtherWicketType];
        for(int i=0; i < [FetchWicketArray count]; i++)
        {
            
            objEventRecord=(WicketTypeRecord*)[FetchWicketArray objectAtIndex:i];
            
            [WICKETARRAY addObject:objEventRecord];
            

        
        [self.Wicket_tableview reloadData];
        self.Wicket_tableview.hidden=NO;
        isEnableTbl=NO;
    }
    
    
}

@end
