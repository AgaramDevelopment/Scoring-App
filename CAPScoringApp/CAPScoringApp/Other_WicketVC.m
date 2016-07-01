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
@property(nonatomic,strong)NSString *WICKETTYPE;



@end

@implementation Other_WicketVC

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize TEAMCODE;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize Wicket_lbl;
@synthesize Wicket_tableview;
@synthesize WICKETARRAY;
@synthesize WICKETTYPE;
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
        WICKETTYPE=objEventRecord.metasubcode;
        
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
        WICKETTYPE=objEventRecord.metasubcode;
        
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
        WICKETTYPE=self.Wicket_lbl.text;
        WICKETTYPE=objEventRecord.metasubcode;
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



   -(void)FetchOtherwickets:COMPETITIONCODE: MATCHCODE : TEAMCODE : INNINGSNO :WICKETTYPE: STRIKERCODE :NONSTRIKERCODE;

{
    
    
    if(![ DbManager_OtherWicket GetStrickerNonStrickerCodeForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO])
    {
        if([WICKETTYPE isEqual:@"MSC133"])
        {
            
            NSMutableArray *GetPlayerDetail=[ DbManager_OtherWicket GetPlayerDetailForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE : INNINGSNO];
        }
        else if([WICKETTYPE isEqual:@"MSC101"] || [WICKETTYPE isEqual:@"MSC108"])
        {
            NSMutableArray *GetPlayerDetail=[ DbManager_OtherWicket GetPlayerDetailForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE : INNINGSNO];
        }
        else if([WICKETTYPE isEqual:@"MSC102"])
        {
            NSMutableArray *GetPlayerDetailsOnRetiredHurt=[ DbManager_OtherWicket GetPlayerDetailOnRetiredHurtForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
        }
        
        
    }
    else
    {
        if([WICKETTYPE isEqual:@"MSC133"])
        {
            NSMutableArray *GetPlayerDetailsOnAbsentHurt=[ DbManager_OtherWicket GetPlayerDetailOnAbsentHurtForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
        }
        else if([WICKETTYPE isEqual:@"MSC101"])
        {
            NSMutableArray *GetPlayerDetailsOnTimeOut=[ DbManager_OtherWicket GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
        }
        else if([WICKETTYPE isEqual:@"MSC102"])
        {
            NSMutableArray *GetPlayerDetailOnRetiredHurt2=[ DbManager_OtherWicket GetPlayerDetailOnRetiredHurt2ForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
        }
        else if([WICKETTYPE isEqual:@"MSC108"])
        {
            NSMutableArray *GetPlayerDetailsOnRetiredHurtOnMSC108=[ DbManager_OtherWicket GetPlayerDetailOnRetiredHurtOnMSC108ForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
        }
    }
    
    
}





- (IBAction)didclicktouchplayer:(id)sender {
    
     [self FetchOtherwickets:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : WICKETTYPE:STRIKERCODE:NONSTRIKERCODE];
}
- (IBAction)check:(id)sender {
     [self FetchOtherwickets:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : WICKETTYPE:STRIKERCODE:NONSTRIKERCODE];
}
@end
