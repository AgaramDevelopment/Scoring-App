//
//  Other_WicketVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Other_WicketVC.h"
#import "DbManager_OtherWicket.h"

@interface Other_WicketVC ()

@end

@implementation Other_WicketVC
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize TEAMCODE;
@synthesize Wicket_lbl;
@synthesize Wicket_tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray *GetPlayerDeatilsFetchWicket=[DbManager_OtherWicket GetPlayerDetailForFetchOtherwicket:COMPETITIONCODE:MATCHCODE:TEAMCODE];
    
    NSMutableArray *GetWicketEvenUpadteOtherWicket=[DbManager_OtherWicket GetWicketEventDetailsForFetchOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO];
    
    [DbManager_OtherWicket GetWicketNoForFetchOtherwicket :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO];
    
    NSMutableArray *GetNotOutAndOutBats=[DbManager_OtherWicket GetNotOutAndOutBatsManForFetchOtherwicket:MATCHCODE:TEAMCODE];
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

- (IBAction)Wicket_btn:(id)sender {
}
- (IBAction)add_btn:(id)sender {
}

- (IBAction)back_btn:(id)sender {
}


  //  (NSString*) PLAYERNAME=[[NSString alloc ]init];
    
    
    

    
    

@end
