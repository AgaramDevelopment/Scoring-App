//
//  PowerPlayVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/22/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PowerPlayVC.h"
#import "PowerPlayTVCell.h"
#import "PowerPlayRecord.h"
#import "PowerPlayGridVC.h"
#import "DBManager.h"
#import "Reachability.h"


@interface PowerPlayVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *FetchPowerPlayArray;
@end


NSMutableArray * selectindexarray;
NSArray *PowerPlayData;
NSString *powerplayvalue;
NSString *setpowerplaytype;
NSMutableArray *powerplayarray;

PowerPlayVC *powerplayvc;
PowerPlayRecord *powerplayrecord;
NSString *powerplaytype;
NSString *matchover;



@implementation PowerPlayVC
@synthesize matchCode;
@synthesize competitionCode;
@synthesize inningsNo;
@synthesize txt_endover;
@synthesize txt_startover;
@synthesize powerplaystartover;
@synthesize powerplayendover;
@synthesize powerplaytyp;




- (void)viewDidLoad {
    [super viewDidLoad];
      matchover=[DBManager SetMatchRegistration:self.matchCode];
    if(powerplaystartover != nil){
    
       txt_startover.text = powerplaystartover;
       txt_endover.text = powerplayendover;
       self.lbl_setpowerplay.text = powerplaytyp;
 
    [self.btn_submit setTitle:@"Update" forState:UIControlStateNormal];
    }
    
  
   
    
    [self.txt_startover.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
     self.txt_startover.layer.borderWidth=2;
    
    [self.txt_endover.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
     self.txt_endover.layer.borderWidth=2;
    
    [self.view_powerplaytype.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
     self.view_powerplaytype.layer.borderWidth=2;
    
    self.tbl_powerplaytype.hidden=YES;
    
     PowerPlayData = [DBManager fetchpowerplaytype];
  
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//power play tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [PowerPlayData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"powerplaycell";
    PowerPlayTVCell *cell = (PowerPlayTVCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PowerPlayTVCell" owner:self options:nil];
        cell = self.powerplay_cel;
        self.powerplay_cel = nil;
    }
    
    PowerPlayRecord *objpowerplayRecord=(PowerPlayRecord*)[PowerPlayData objectAtIndex:indexPath.row];
    cell.lbl_powerplaycell.text = objpowerplayRecord.powerplaytypename;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    powerplayvalue=[PowerPlayData objectAtIndex:indexPath.row];
//    self.lbl_setpowerplay.text =powerplayvalue;
//
//    self.tbl_powerplaytype.hidden=YES;
    
    selectindexarray=[[NSMutableArray alloc]init];
    powerplayrecord=(PowerPlayRecord*)[PowerPlayData objectAtIndex:indexPath.row];
    self.lbl_setpowerplay.text =powerplayrecord.powerplaytypename;
    powerplaytype=powerplayrecord.powerplaytypecode;
    [selectindexarray addObject:powerplayrecord];
    self.tbl_powerplaytype.hidden=YES;
    
}



- (IBAction)btn_touch:(id)sender {
    
    self.tbl_powerplaytype.hidden=NO;
    
    
}
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

- (BOOL) formValidation{
    
    NSString *powerplaystartovertxt = self.txt_startover.text;
    NSString *powerplayendovertxt =self.txt_endover.text;
    NSString *powerplaytypetxt = self.lbl_setpowerplay.text;
    
    if([powerplaystartovertxt isEqual:@""]){
        [self showDialog:@"Please enter Start Over." andTitle:@""];
        return NO;
    }else if([powerplayendovertxt isEqual:@""]){
        [self showDialog:@"Please enter End Over." andTitle:@""];
        return NO;
        
    }else if([powerplaytypetxt isEqual:@"Select Power Play"]){
        [self showDialog:@"Please Choose  Power Play Type" andTitle:@""];
        return NO;
    }else if([powerplaystartovertxt intValue]  >= [powerplayendovertxt intValue]){
        [self showDialog:@"End Over Should be greater than Start Over." andTitle:@""];
        return NO;
        
    }else if([matchover intValue] >= [powerplaystartovertxt intValue]){
        [self showDialog:@"check 1." andTitle:@""];
        return NO;
        
    }else if([matchover intValue] >= [powerplayendovertxt intValue]){
        [self showDialog:@"check 2." andTitle:@""];
        return NO;
    }
    
    return YES;
}


- (IBAction)btn_submit:(id)sender {
    
    if(powerplaystartover == nil){
        if([self formValidation]){
       
    PowerPlayRecord *powerplayrecord =[[PowerPlayRecord alloc]init];
    
    powerplayrecord.startover= txt_startover.text;
    powerplayrecord.endover= txt_endover.text;
    powerplayrecord.powerplaytypecode= powerplaytype;

    
    [DBManager SetPowerPlayDetails:@"PPC0000059":self.matchCode :self.inningsNo :powerplayrecord.startover :powerplayrecord.endover :powerplayrecord.powerplaytypecode :@"MSC001" :@"user" :@"2016-06-22 16:37:00":@"user": @"2016-06-22 16:37:00"];
    
    [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
    
    PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
    add.resultarray=powerplayarray;
    
    add.competitionCode=competitionCode;
    add.matchCode=matchCode;
    add.inningsNo=inningsNo;

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
    
    }else
    {
        PowerPlayRecord *powerplayrecord =[[PowerPlayRecord alloc]init];
        
        powerplayrecord.startover= txt_startover.text;
        powerplayrecord.endover= txt_endover.text;
        powerplayrecord.powerplaytype= powerplaytype;
        
        [DBManager UpdatePowerPlay:self.inningsNo :powerplayrecord.startover  :powerplayrecord.endover :@"2016-06-25 16:37:00" :powerplayrecord.powerplaytype :@"MSC001" :@"user" :@"PPC0000059":self.matchCode];

        [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
        
        PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
        add.resultarray=powerplayarray;
        
        add.competitionCode=competitionCode;
        add.matchCode=matchCode;
        add.inningsNo=inningsNo;
        
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

}

- (IBAction)btn_delete:(id)sender {
    PowerPlayRecord *powerplayrecord =[[PowerPlayRecord alloc]init];
    
    powerplayrecord.startover= txt_startover.text;
    powerplayrecord.endover= txt_endover.text;
    powerplayrecord.powerplaytype= powerplaytype;
    
    
    //        [DBManager UpdatePowerPlay:self.inningsNo :powerplayrecord.startover :powerplayrecord.endover : powerplayrecord.powerplaytype  :@"MSC001" :@"user" :@"PPC0000057" :self.matchCode];
    
    [DBManager UpdatePowerPlay:self.inningsNo :powerplayrecord.startover  :powerplayrecord.endover :@"2016-06-25 16:37:00" :powerplayrecord.powerplaytype :@"MSC002" :@"user" :@"PPC0000059":self.matchCode];
    
    [DBManager SetPowerPlayDetailsForInsert:self.matchCode :self.inningsNo];
    
    PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
    add.resultarray=powerplayarray;
    
    add.competitionCode=competitionCode;
    add.matchCode=matchCode;
    add.inningsNo=inningsNo;
    
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


- (IBAction)btn_back:(id)sender {
    PowerPlayGridVC *add = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
    add.resultarray=powerplayarray;
    add.competitionCode=competitionCode;
    add.matchCode=matchCode;
    add.inningsNo=inningsNo;
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