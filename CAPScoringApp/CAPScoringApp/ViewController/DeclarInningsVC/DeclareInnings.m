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
    
    
    DBManagerDeclareInnings *objDBManagerDeclareInnings = [[DBManagerDeclareInnings alloc]init];
    int inns =[self.INNINGSNO intValue]-1;
    
    NSString * declearInnsStatus = [objDBManagerDeclareInnings GetDeclareInningsStatus : COMPETITIONCODE : MATCHCODE : [NSString stringWithFormat:@"%d",inns]];
    
    OVERNO=[objDBManagerDeclareInnings  GetOverNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    BALLNO=[objDBManagerDeclareInnings GetBallNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
    
    
    WICKETS=[objDBManagerDeclareInnings GetWicketForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    if([declearInnsStatus isEqualToString:@"1"] && [OVERNO isEqualToString:@"0"] && [BALLNO isEqualToString:@"0"] && [TOTALRUN isEqualToString:@"0"] && [WICKETS isEqualToString:@"0"])
    {
        self.btn_yes.backgroundColor=[UIColor colorWithRed:(2/255.0f) green:(104/255.0f) blue:(88/255.0f) alpha:1.0f];
        [_btn_yes setUserInteractionEnabled:NO];
        
        self.btn_revert.backgroundColor=[UIColor colorWithRed:(227/255.0f) green:(177/255.0f) blue:(7/255.0f) alpha:1.0f];
        [_btn_revert setUserInteractionEnabled:YES];
        
        
    }
    else if(![OVERNO isEqualToString:@"0"] && ![BALLNO isEqualToString:@"0"] && ![TOTALRUN isEqualToString:@"0"] && ![WICKETS isEqualToString:@"0"])
    {
        //            self.btn_revert.backgroundColor=[UIColor colorWithRed:(112/255.0f) green:(94/255.0f) blue:(54/255.0f) alpha:1.0f];
        [_btn_revert setUserInteractionEnabled:NO];
        
        //            self.btn_yes.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(210/255.0f) blue:(158/255.0f) alpha:1.0f];
        [_btn_yes setUserInteractionEnabled:YES];
    }
    
    else
    {
        //       self.btn_revert.backgroundColor=[UIColor colorWithRed:(112/255.0f) green:(94/255.0f) blue:(54/255.0f) alpha:1.0f];
        [_btn_revert setUserInteractionEnabled:NO];
        
        //       self.btn_yes.backgroundColor=[UIColor colorWithRed:(112/255.0f) green:(94/255.0f) blue:(54/255.0f) alpha:1.0f];
        // [_btn_yes setUserInteractionEnabled:NO];
    }
    
    
    
    //   ballNo = [BALLNO integerValue];
    //
    //    if (ballNo > 0) {
    //
    //        self.btn_revert.backgroundColor=[UIColor colorWithRed:(112/255.0f) green:(94/255.0f) blue:(54/255.0f) alpha:1.0f];
    //        [_btn_revert setUserInteractionEnabled:NO];
    //
    //        self.btn_yes.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(210/255.0f) blue:(158/255.0f) alpha:1.0f];
    //        [_btn_yes setUserInteractionEnabled:YES];
    //
    //    }else{
    //
    //
    //    self.btn_yes.backgroundColor=[UIColor colorWithRed:(2/255.0f) green:(104/255.0f) blue:(88/255.0f) alpha:1.0f];
    //        [_btn_yes setUserInteractionEnabled:NO];
    //
    //        self.btn_revert.backgroundColor=[UIColor colorWithRed:(227/255.0f) green:(177/255.0f) blue:(7/255.0f) alpha:1.0f];
    //        [_btn_revert setUserInteractionEnabled:YES];
    //
    //
    //    }
    
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
    
    
    if([OVERNO isEqualToString:@"0"] && [BALLNO isEqualToString:@"0"] && [TOTALRUN isEqualToString:@"0"] && [WICKETS isEqualToString:@"0"])
    {
        
        [self showDialog:@"No legitimate balls have been bowled in this innings" andTitle:@"Declare Innings"];
        
        
    }else{
        
        [self UpdateDeclareInnings:COMPETITIONCODE :MATCHCODE :TEAMCODE :BOWLINGTEAMCODE :INNINGSNO :@"1"];
        [self.delegate declareSaveBtnAction];
        
        
    }
    
    
    
    
    
    
}

/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertDialog show];
}


-(void) getDeclarInnsStatus:(NSString *)competioncode:(NSString *)matchcode :(NSString*)inns
{
    DBManagerDeclareInnings * objDBManagerDeclareInnings = [[DBManagerDeclareInnings alloc]init];
    
    
}


-(void) UpdateDeclareInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)TEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)INNINGSNO:(NSString*)ISDECLARE

{
    DBManagerDeclareInnings *objDBManagerDeclareInnings = [[DBManagerDeclareInnings alloc]init];
    
    if(ISDECLARE.intValue == 1)
    {
        
        if([objDBManagerDeclareInnings GetBallCodeForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO])
        {
            TEAMNAME=[objDBManagerDeclareInnings GetTeamNameForUpdateDeclareInnings : TEAMCODE];
            
            TOTALRUN=[objDBManagerDeclareInnings GetTotalRunForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            OVERNO=[objDBManagerDeclareInnings  GetOverNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            BALLNO=[objDBManagerDeclareInnings GetBallNoForUpdateDeclareInnings  : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
            
            OVERSTATUS=[objDBManagerDeclareInnings GetOverStatusForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
            
            if(OVERSTATUS.intValue == 1)
            {
                
                overNo = [OVERNO integerValue];
                
                OVERBALLNO = [NSString stringWithFormat:@"%d",overNo +1];
                
            }
            else
            {
                //OVERBALLNO = (OVERNO(".")BALLNO);
                
                OVERBALLNO = [NSString stringWithFormat:@"%@.%@" ,OVERNO,BALLNO];
            }
            
           

            WICKETS=[objDBManagerDeclareInnings GetWicketForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            [objDBManagerDeclareInnings UpdateInningsEventForUpdateDeclareInnings:TEAMCODE :TOTALRUN :OVERBALLNO :WICKETS :ISDECLARE :COMPETITIONCODE :MATCHCODE :INNINGSNO];
        }
    }
    
    else
    {
        if(![objDBManagerDeclareInnings GetBallCodeInRevertInningsForUpdateDeclareInnings : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO])
            
        {
            [objDBManagerDeclareInnings UpdateInningsEventInRevertInningsForUpdateDeclareInnings: ISDECLARE: COMPETITIONCODE: MATCHCODE : INNINGSNO];
            
            [objDBManagerDeclareInnings DeleteInningsEventForUpdateDeclareInnings : COMPETITIONCODE: MATCHCODE : INNINGSNO];
            
            [objDBManagerDeclareInnings DeleteMatchResultForUpdateDeclareInnings: COMPETITIONCODE: MATCHCODE];
        }
        
        
    }
    
}



@end
