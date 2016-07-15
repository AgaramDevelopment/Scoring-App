//
//  DeclareInnings.m
//  CAPScoringApp
//
//  Created by mac on 27/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DeclareInnings.h"
#import "DBManagerDeclareInnings.h"
#import "ScorEnginVC.h"
#import "FetchSEPageLoadRecord.h"

@interface DeclareInnings ()
{
    NSInteger overNo;
    NSInteger ballNo;
}

@end

@implementation DeclareInnings
@synthesize TEAMNAME;
@synthesize OVERNO;
@synthesize BALLNO;
@synthesize OVERBALLNO;
@synthesize TOTALRUN;
@synthesize WICKETS;
@synthesize OVERSTATUS;

@synthesize  COMPETITIONCODE;
@synthesize  MATCHCODE;
@synthesize  TEAMCODE;
@synthesize  BOWLINGTEAMCODE;
@synthesize  INNINGSNO;
@synthesize  ISDECLARE;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
[self.btn_revert addTarget:self action:@selector(btn_revert:) forControlEvents:UIControlEventTouchUpInside];
[self.btn_yes addTarget:self action:@selector(btn_yes:) forControlEvents:UIControlEventTouchUpInside];
    
    
     OVERNO=[DBManagerDeclareInnings  GetOverNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
   
     BALLNO=[DBManagerDeclareInnings GetBallNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
    
    
   ballNo = [BALLNO integerValue];
    
    if (ballNo > 0) {
        
        self.btn_revert.backgroundColor=[UIColor colorWithRed:(112/255.0f) green:(94/255.0f) blue:(54/255.0f) alpha:1.0f];
        [_btn_revert setUserInteractionEnabled:NO];
        
        self.btn_yes.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(210/255.0f) blue:(158/255.0f) alpha:1.0f];
        [_btn_yes setUserInteractionEnabled:YES];
        
    }else{
    
        
    self.btn_yes.backgroundColor=[UIColor colorWithRed:(2/255.0f) green:(104/255.0f) blue:(88/255.0f) alpha:1.0f];
        [_btn_yes setUserInteractionEnabled:NO];
        
        self.btn_revert.backgroundColor=[UIColor colorWithRed:(227/255.0f) green:(177/255.0f) blue:(7/255.0f) alpha:1.0f];
        [_btn_revert setUserInteractionEnabled:YES];

    
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

- (IBAction)btn_revert:(id)sender {
    
    [self UpdateDeclareInnings:COMPETITIONCODE :MATCHCODE :TEAMCODE :BOWLINGTEAMCODE :INNINGSNO :@"0"];
    [self.delegate declareRevertBtnAction];
    
}

- (IBAction)btn_back:(id)sender {
    
    [self.delegate declareBackBtnAction];
}

- (IBAction)btn_yes:(id)sender {
    
    
   
    [self UpdateDeclareInnings:COMPETITIONCODE :MATCHCODE :TEAMCODE :BOWLINGTEAMCODE :INNINGSNO :@"1"];
      [self.delegate declareSaveBtnAction];

    

}





-(void) UpdateDeclareInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)TEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)INNINGSNO:(NSString*)ISDECLARE

{
    
    if(ISDECLARE.intValue == 1)
    {
        
        if([DBManagerDeclareInnings GetBallCodeForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO])
        {
            TEAMNAME=[DBManagerDeclareInnings GetTeamNameForUpdateDeclareInnings : TEAMCODE];
            
            TOTALRUN=[DBManagerDeclareInnings GetTotalRunForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            OVERNO=[DBManagerDeclareInnings  GetOverNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            BALLNO=[DBManagerDeclareInnings GetBallNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
            
            OVERSTATUS=[DBManagerDeclareInnings GetOverStatusForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
            
            if(OVERSTATUS.intValue == 1)
            {
                
                 overNo = [OVERNO integerValue];
                
                OVERBALLNO = [NSString stringWithFormat:@"%d",overNo +1];
                
            }
            else
            {
                //OVERBALLNO = (OVERNO(".")BALLNO);
                
                OVERBALLNO = [NSString stringWithFormat:@"%d.@%d" ,overNo,BALLNO];
            }
            
            WICKETS=[DBManagerDeclareInnings GetWicketForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            [DBManagerDeclareInnings UpdateInningsEventForUpdateDeclareInnings:TEAMCODE :TOTALRUN :OVERBALLNO :WICKETS :ISDECLARE :COMPETITIONCODE :MATCHCODE :INNINGSNO];
        }
    }
    
    else
    {
        if(![DBManagerDeclareInnings GetBallCodeInRevertInningsForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO])
   
    {
        [DBManagerDeclareInnings UpdateInningsEventInRevertInningsForUpdateDeclareInnings: ISDECLARE: COMPETITIONCODE: MATCHCODE : INNINGSNO];
        
        [DBManagerDeclareInnings DeleteInningsEventForUpdateDeclareInnings: COMPETITIONCODE: MATCHCODE : INNINGSNO];
        
        [DBManagerDeclareInnings DeleteMatchResultForUpdateDeclareInnings: COMPETITIONCODE: MATCHCODE];
    }
    
    
}
    
}



@end
