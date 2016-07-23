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
#import "TossDetailsVC.h"
#import "CustomNavigationVC.h"


@interface MatchOfficalsVC ()
@property (nonatomic,strong)NSMutableArray *FetchOfficalMasterArray;

@end

@implementation MatchOfficalsVC
@synthesize competitionCode;
@synthesize Matchcode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_FetchOfficalMasterArray=[[NSMutableArray alloc]init];
    _FetchOfficalMasterArray =[DBManager RetrieveOfficalMasterData:Matchcode competitionCode:competitionCode];
    
    [self customnavigationmethod];
    
    [self.view_umpire.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_umpire.layer.borderWidth = 2;
    
    
    [self.view_umpier1.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_umpier1.layer.borderWidth = 2;
    
    [self.view_umpier2.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_umpier2.layer.borderWidth = 2;
    
    
    [self.view_matchrefree.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_matchrefree.layer.borderWidth = 2;
    
    [self.view_scorer1.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_scorer1.layer.borderWidth = 2;
    
    [self.view_scorer2.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_scorer2.layer.borderWidth = 2;
    
    
    
    
    
    if([self.FetchOfficalMasterArray count]>0){
          OfficialMasterRecord *objMatchofficalRecord = [self.FetchOfficalMasterArray objectAtIndex:0];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *username=[defaults stringForKey :@"UserFullname"];
        
        NSString *userCode=[defaults stringForKey:@"userCode"];
        NSMutableArray *scorearray=[DBManager RetrieveSCORE2:competitionCode:Matchcode:userCode];
        self.lbl_umpire1.text=objMatchofficalRecord.umpire1name;
        self.lbl_umpire2.text=objMatchofficalRecord.umpire2name;
        self.lbl_umpire3.text=objMatchofficalRecord.umpire3name;
        self.lbl_matchreferee.text=objMatchofficalRecord.matchrefereename;
        self.lbl_scorer1.text=username;
        self.lbl_scorer2.text=objMatchofficalRecord.scorename2;
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

//Navigation bar action
-(void)customnavigationmethod
{
    CustomNavigationVC *objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"MATCH OFFICIALS";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btn_proceed:(id)sender {
    
    
       // UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       TossDetailsVC *tossvc =[[TossDetailsVC alloc]init];
        tossvc =  (TossDetailsVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"TossDetails"];
    tossvc.matchSetUp = self.matchSetUp;
    tossvc.MATCHCODE = Matchcode;
    tossvc.CompetitionCode=competitionCode;
    tossvc.matchTypeCode = self.matchTypeCode;
     [self.navigationController pushViewController:tossvc animated:YES];
       // [tossvc setModalPresentationStyle:UIModalPresentationFullScreen];
        //[self presentViewController:tossvc animated:NO completion:nil];
    
}
@end
