//
//  MatchOfficalsVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 5/27/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "MatchOfficalsVC.h"
#import "DBManager.h"
#import "OfficialMasterRecord.h"

@interface MatchOfficalsVC ()
@property (nonatomic,strong)NSMutableArray *FetchOfficalMasterArray;

@end

@implementation MatchOfficalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_FetchOfficalMasterArray=[[NSMutableArray alloc]init];
    _FetchOfficalMasterArray =[DBManager RetrieveOfficalMasterData];
    
    
    [self.view_umpire.layer setBorderColor:[UIColor colorWithRed:75 green:95 blue:114 alpha:0.5].CGColor];
    self.view_umpire.layer.borderWidth = 2;
    
    
    [self.view_umpier1.layer setBorderColor:[UIColor colorWithRed:75 green:95 blue:114 alpha:0.5].CGColor];
    self.view_umpier1.layer.borderWidth = 2;
    
    [self.view_umpier2.layer setBorderColor:[UIColor colorWithRed:75 green:95 blue:114 alpha:0.5].CGColor];
    self.view_umpier2.layer.borderWidth = 2;
    
    
    [self.view_matchrefree.layer setBorderColor:[UIColor colorWithRed:75 green:95 blue:114 alpha:0.5].CGColor];
    self.view_matchrefree.layer.borderWidth = 2;
    
    [self.view_scorer1.layer setBorderColor:[UIColor colorWithRed:75 green:95 blue:114 alpha:0.5].CGColor];
    self.view_scorer1.layer.borderWidth = 2;
    
    [self.view_scorer2.layer setBorderColor:[UIColor colorWithRed:75 green:95 blue:114 alpha:0.5].CGColor];
    self.view_scorer2.layer.borderWidth = 2;
    
    
    if([self.FetchOfficalMasterArray count]>0){
        
        OfficialMasterRecord *objMatchofficalRecord = [self.FetchOfficalMasterArray objectAtIndex:0];
        
        self.lbl_umpire1.text=objMatchofficalRecord.umpire1name;
        self.lbl_umpire2.text=objMatchofficalRecord.umpire2name;
        self.lbl_umpire3.text=objMatchofficalRecord.umpire3name;
        self.lbl_matchreferee.text=objMatchofficalRecord.matchrefereename;
        //self.lbl_scorer1.text=objMatchofficalRecord.umpire1name;
        //self.lbl_scorer2.text=objMatchofficalRecord.umpire1name;
    }
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

- (IBAction)btn_proceed:(id)sender {
}
@end
