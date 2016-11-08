//
//  SectorWagonReportVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 27/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SectorWagonReportVC.h"
#import "DBManagerSpiderWagonReport.h"
#import "DBManagerpitchmapReport.h"
#import "SpiderWagonRecords.h"
#import "Utitliy.h"
#import "StrikerDetails.h"


@interface SectorWagonReportVC (){
    
    BOOL isStriker;
    BOOL isBowler;
    DBManagerSpiderWagonReport *objDBManagerSpiderWagonReport;
    DBManagerpitchmapReport *objDBManagerpitchmapReport;
    
    
    int zerocount;
    int Run1Count;
    int Run2Count;
    int Run3Count;
    int Run4Count;
    int Run6Count;
    
    
    
    
    
    UILabel * fineleg_lbl;
    UILabel * squareleg_lbl;
    UILabel * midWicket_lbl;
    UILabel * longon_lbl;
    UILabel * longoff_lbl;
    UILabel * cover_lbl;
    UILabel * point_lbl;
    UILabel * Thirdman_lbl;
    
    
    UILabel * lbl_fineleg_per;
    UILabel * lbl_squareleg_per;
    UILabel * lbl_midWicket_per;
    UILabel * lbl_longon_per;
    UILabel * lbl_longoff_per;
    UILabel * lbl_cover_per;
    UILabel * lbl_point_per;
    UILabel * lbl_Thirdman_per;
    
    
    int ThirdmanCountRun;
    int pointRun;
    int coverRun;
    int longoffRun;
    int longonRun;
    int midWicketRun;
    int squarelegRun;
    int finelegRun;
    
    
    int ThirdmanCount;
    int pointCount;
    int coverCount;
    int longoffCount;
    int longonCount;
    int midWicketCount;
    int squarelegCount;
    int finelegCount;
    

}

@property (nonatomic,strong) NSMutableArray *sectorWagonArray;

@property (nonatomic,strong) NSMutableArray * bowlerArray;
@property (nonatomic,strong) NSMutableArray * strikerArray;

@property (nonatomic,strong) NSString *selectRun;
@property (nonatomic,strong) NSString *selectOnSide;
@property (nonatomic,strong) NSString *teamBcode;
@property (nonatomic,strong) NSString *totalRuns;
@property (nonatomic,assign) NSNumber *tRuns;

@end

@implementation SectorWagonReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filter_view.hidden =YES;
    
    
    [self.striker_view .layer setBorderWidth:2.0];
    [self.striker_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.striker_view .layer setMasksToBounds:YES];
    
    
    [self.bowler_view .layer setBorderWidth:2.0];
    [self.bowler_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.bowler_view .layer setMasksToBounds:YES];
    
    self.tbl_players.hidden=YES;
    
    objDBManagerSpiderWagonReport = [[DBManagerSpiderWagonReport alloc]init];
    objDBManagerpitchmapReport =[[DBManagerpitchmapReport alloc]init];
    
    
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
    
    _teamBcode = [objDBManagerSpiderWagonReport getTeamBCode:self.compititionCode :self.matchCode];
    
    
    
        
    
    _sectorWagonArray = [objDBManagerSpiderWagonReport getSectorWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1" :@"" :@"" :@"" :@"" :@"" :@""];



    _totalRuns =  [objDBManagerSpiderWagonReport getTotalRuns:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1"];
    
    
    _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    
    
    
    [self displayRuns];
    
    [self setInningsBySelection:@"1"];
    [self setInningsView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_first_inns:(id)sender{
    
  
    [self hideLbl];
    [self clearLbl];
    [self setInningsBySelection:@"1"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"1"];
    
    _sectorWagonArray = [objDBManagerSpiderWagonReport getSectorWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1" :@"" :@"" :@"" :@"" :@"" :@""];
    
    _totalRuns =  [objDBManagerSpiderWagonReport getTotalRuns:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1"];
    _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    
    
     [self displayRuns];
    
     [self.tbl_players reloadData];
}

- (IBAction)btn_sec_inns:(id)sender {
    
    
    
    [self hideLbl];
    [self clearLbl];
    
    [self setInningsBySelection:@"2"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"2"];
    

    _sectorWagonArray = [objDBManagerSpiderWagonReport getSectorWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"2" :@"" :@"" :@"" :@"" :@"" :@""];
    
    _totalRuns =  [objDBManagerSpiderWagonReport getTotalRuns:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"2"];
    _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    [self displayRuns];
    
    
    [self.tbl_players reloadData];
}

- (IBAction)btn_third_inns:(id)sender {
    
    [self hideLbl];
    [self clearLbl];
    [self setInningsBySelection:@"3"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"3"];
    _sectorWagonArray = [objDBManagerSpiderWagonReport getSectorWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"3" :@"" :@"" :@"" :@"" :@"" :@""];
    
    _totalRuns =  [objDBManagerSpiderWagonReport getTotalRuns:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"3"];
    _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    [self displayRuns];
    
    [self.tbl_players reloadData];
}

- (IBAction)btn_fourth_inns:(id)sender {
    
    [self hideLbl];
    [self clearLbl];
    [self setInningsBySelection:@"4"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"4"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"4"];
    
    _sectorWagonArray = [objDBManagerSpiderWagonReport getSectorWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"4" :@"" :@"" :@"" :@"" :@"" :@""];
    
    _totalRuns =  [objDBManagerSpiderWagonReport getTotalRuns:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"4"];
    _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    [self displayRuns];
    [self.tbl_players reloadData];
}

- (IBAction)hide_Filer_view:(id)sender {
    
    self.filter_view.hidden =NO;
    self.hide_btn_view.hidden = YES;
    
    
}

- (IBAction)ones:(id)sender {
    
    self.selectRun =@"1";
    [self.one_run setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
    [self.two_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.three_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.four_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.six_runs setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    
}

- (IBAction)twos:(id)sender {
    self.selectRun =@"2";
    [self.one_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.two_run setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
    [self.three_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.four_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.six_runs setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
}

- (IBAction)threes:(id)sender {
    
    self.selectRun =@"3";
    [self.one_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.two_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.three_run setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
    [self.four_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.six_runs setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
}

- (IBAction)fours:(id)sender {
    
    self.selectRun =@"4";
    [self.one_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.two_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.three_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.four_run setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
    [self.six_runs setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
}

- (IBAction)six:(id)sender {
    
    self.selectRun =@"6";
    [self.one_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.two_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.three_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.four_run setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.six_runs setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
    
}

- (IBAction)onSide:(id)sender {
    self.selectOnSide = @"1";
    
    [self.btn_onSide setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
    [self.btn_offSide setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    
}

- (IBAction)offSide:(id)sender {
    
    self.selectOnSide = @"0";
    [self.btn_onSide setImage:[UIImage imageNamed:@"Radio.off"] forState:UIControlStateNormal];
    [self.btn_offSide setImage:[UIImage imageNamed:@"Radio.on"] forState:UIControlStateNormal];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(isStriker == YES)
    {
        return self.strikerArray.count;
    }
    else if(isBowler == YES)
    {
        return self.bowlerArray.count;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    if(isStriker == YES)
    {
        
        SpiderWagonRecords * objStriker =[self.strikerArray objectAtIndex:indexPath.row];
        cell.textLabel.text =objStriker.STRIKERNAME;
    }
    else if(isBowler == YES)
    {
        SpiderWagonRecords * objStriker =[self.bowlerArray objectAtIndex:indexPath.row];
        cell.textLabel.text = objStriker.BOWLERNAME;
        
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isStriker == YES)
    {
        
        SpiderWagonRecords * objStriker =[self.strikerArray objectAtIndex:indexPath.row];
        
        
        self.lbl_striker.text = objStriker.STRIKERNAME;
        self.selectStrikerCode =objStriker.STRIKERCODE;
        self.selectBattingStyle = objStriker.BATTINGSTYLE;
        
        
        self.tbl_players.hidden=YES;
        
    }
    else if(isBowler == YES)
    {
        SpiderWagonRecords *objBowler =[self.bowlerArray objectAtIndex:indexPath.row];
        self.selectBowlerCode= objBowler.BOWLERCODE;
        _lbl_bowler.text = objBowler.BOWLERNAME;
        self.tbl_players.hidden = YES;
    }
    
}




- (IBAction)didClickStricker:(id)sender {
    
    self.strikerTblYposition.constant =self.striker_view.frame.origin.y;
    self.strikerArray=[[NSMutableArray alloc]init];
    self.strikerArray= [objDBManagerSpiderWagonReport getStrickerdetail:self.matchCode :_teamCode];
    
    if(isStriker==NO)
    {
        
        self.tbl_players.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.tbl_players.hidden=YES;
        isStriker=NO;
    }
    isBowler=NO;
    

    [self.tbl_players reloadData];
    
    
}

- (IBAction)didClickBowler:(id)sender {
    

    self.strikerTblYposition.constant = self.bowler_view.frame.origin.y;
    self.bowlerArray=[[NSMutableArray alloc]init];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"1"];
    
    if(isBowler==NO)
    {
        
        self.tbl_players.hidden=NO;
        isBowler=YES;
        
    }
    else
    {
        self.tbl_players.hidden=YES;
        isBowler=NO;
    }
    isStriker=NO;
    

    [self.tbl_players reloadData];
    
    
}

-(void) setInningsView{
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){//T20
        
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = YES;
        self.inns_four.hidden = YES;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //[self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        self.inns_one_width.constant = 384;
        self.inns_two_width.constant = 384;
        
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){//ODI
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = YES;
        self.inns_four.hidden = YES;
        
        
        self.inns_one_width.constant = 384;
        self.inns_two_width.constant = 384;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //   [self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        
    }else if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){//Test
        
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = NO;
        self.inns_four.hidden = NO;
    }
}



-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.inns_one];
    [self setInningsButtonUnselect:self.inns_two];
    [self setInningsButtonUnselect:self.inns_three];
    [self setInningsButtonUnselect:self.inns_four];
    
    
    [self.inns_one setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.fstInnShortName] forState:UIControlStateNormal];
    [self.inns_two setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.secInnShortName] forState:UIControlStateNormal];
    [self.inns_three setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.thrdInnShortName] forState:UIControlStateNormal];
    [self.inns_four setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.frthInnShortName] forState:UIControlStateNormal];
    
    
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.inns_one];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.inns_two];
        
    }else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.inns_three];
        
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.inns_four];
        
    }
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}

-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2374CD"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#000000"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

- (IBAction)btn_done:(id)sender {
    
    self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
    
    [self hideLbl];

    [self clearValues];
    
    _sectorWagonArray =[objDBManagerSpiderWagonReport getSectorWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"" : self.selectStrikerCode == nil ? @"" : self.selectStrikerCode : self.selectBowlerCode == nil ? @"":self.selectBowlerCode :[self.selectRun isEqual:nil]?@"":self.selectRun == nil ? @"" : self.selectRun :@"" :@"":self.selectOnSide == nil ? @"" :self.selectOnSide];
    
    _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    
    [self clearLbl];
    
    [self displayRuns];
    
    
    
    
}


-(void)sectorWagonwheel:(NSString *) sectorwognwheelcode :(NSString *) batmanStyle :(NSString *) Run

{
    
    if([sectorwognwheelcode isEqualToString:@"MDT036"]) //fine leg
    {
        if([batmanStyle isEqualToString:@"MSC012"])//Left hand
        {
            NSLog(@"LH");
            
           finelegRun = [Run intValue]+finelegRun;
            if(fineleg_lbl !=nil)
            {
                [fineleg_lbl removeFromSuperview];
            }
//
//            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(140,70,200,35)];
//            fineleg_lbl.textColor=[UIColor whiteColor];
//            fineleg_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",finelegRun,@"RUNS", finelegCount,@"BALLS"];
//            [self.img_sector addSubview:fineleg_lbl];
//            
//            if(lbl_fineleg_per !=nil)
//            {
//                [lbl_fineleg_per removeFromSuperview];
//            }
//            
//            float finelegper = (_tRuns.intValue != 0) ? ((float)(finelegRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_fineleg_per=[[UILabel alloc]initWithFrame:CGRectMake(160,80,70, 70)];
//            lbl_fineleg_per.textColor=[UIColor whiteColor];
//            lbl_fineleg_per.text =[NSString stringWithFormat:@"%.2f %@",finelegper,@"%"];
//            [self.img_sector addSubview:lbl_fineleg_per];
//            
            
        }
        else
        {
            NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
            if(fineleg_lbl !=nil)
            {
                [fineleg_lbl removeFromSuperview];
            }
        }
        
        
       
        
        fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(320,70,200,35)];
        fineleg_lbl.textColor=[UIColor whiteColor];
        //fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",finelegRun,@"RUNS", finelegCount,@"BALLS"];
        [self.img_sector addSubview:fineleg_lbl];
        
        if(lbl_fineleg_per !=nil)
        {
            [lbl_fineleg_per removeFromSuperview];
        }
        
        float finelegper = (_tRuns.intValue != 0) ? ((float)(finelegRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_fineleg_per=[[UILabel alloc]initWithFrame:CGRectMake(350,75,70, 70)];
        lbl_fineleg_per.textColor=[UIColor whiteColor];
        lbl_fineleg_per.text =[NSString stringWithFormat:@"%.2f %@",finelegper,@"%"];
        [self.img_sector addSubview:lbl_fineleg_per];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT037"])//Square
    {
        if([batmanStyle isEqualToString:@"MSC012"]) //Left hand
        {
            NSLog(@"LH");
            
//            squarelegRun =squarelegRun+[Run intValue];
//            if(squareleg_lbl !=nil)
//            {
//                [squareleg_lbl removeFromSuperview];
//            }
//            
//            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,200, 35)];
//            squareleg_lbl.textColor=[UIColor whiteColor];
//            squareleg_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",squarelegRun,@"RUNS", squarelegCount,@"BALLS"];
//            [self.img_sector addSubview:squareleg_lbl];
//            
//            
//            if(lbl_squareleg_per !=nil)
//            {
//                [lbl_squareleg_per removeFromSuperview];
//            }
//            
//            float squarelegper = (_tRuns.intValue != 0) ? ((float)(squarelegRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_squareleg_per=[[UILabel alloc]initWithFrame:CGRectMake(70,195,200,70)];
//            lbl_squareleg_per.textColor=[UIColor whiteColor];
//            lbl_squareleg_per.text =[NSString stringWithFormat:@"%.2f %@",squarelegper,@"%"];
//            [self.img_sector addSubview:lbl_squareleg_per];
            
        }
        else
        {
            NSLog(@"RH");
            
           
            
        }
        
        squarelegRun =squarelegRun+[Run intValue];
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }
        
        squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(425,180,200, 35)];
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",squarelegRun,@"RUNS", squarelegCount,@"BALLS"];
        [self.img_sector addSubview:squareleg_lbl];
        
        
        if(lbl_squareleg_per !=nil)
        {
            [lbl_squareleg_per removeFromSuperview];
        }
        
        float squarelegper = (_tRuns.intValue != 0) ? ((float)(squarelegRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_squareleg_per=[[UILabel alloc]initWithFrame:CGRectMake(450,185,200, 70)];
        lbl_squareleg_per.textColor=[UIColor whiteColor];
        lbl_squareleg_per.text =[NSString stringWithFormat:@"%.2f %@",squarelegper,@"%"];
        [self.img_sector addSubview:lbl_squareleg_per];
        
        
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT038"])//Mid Wkt
    {
        if([batmanStyle isEqualToString:@"MSC012"])//Left hand
        {
            NSLog(@"LH");
            
//            midWicketRun =midWicketRun+[Run intValue];
//            if(midWicket_lbl !=nil)
//            {
//                [midWicket_lbl removeFromSuperview];
//            }
//            
//            
//            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,330,200, 35)];
//            midWicket_lbl.textColor=[UIColor whiteColor];
//            midWicket_lbl.text = [NSString stringWithFormat:@"%d %@ %d %@",midWicketRun,@"RUNS", midWicketCount,@"BALLS"];
//            
//            
//            [self.img_sector addSubview:midWicket_lbl];
//            
//            
//            if(lbl_midWicket_per !=nil)
//            {
//                [lbl_midWicket_per removeFromSuperview];
//            }
//            
//            float midWktPer = (_tRuns.intValue != 0) ? ((float)(midWicketRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_midWicket_per=[[UILabel alloc]initWithFrame:CGRectMake(80,335,200,70)];
//            lbl_midWicket_per.textColor=[UIColor whiteColor];
//            lbl_midWicket_per.text =[NSString stringWithFormat:@"%.2f %@",midWktPer,@"%"];
//            [self.img_sector addSubview:lbl_midWicket_per];
            
        }
        else
        {
            NSLog(@"RH");
            
    }
        midWicketRun =midWicketRun+[Run intValue];
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }
        
        
        midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(430,360,200, 35)];
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text = [NSString stringWithFormat:@"%d %@ %d %@",midWicketRun,@"RUNS", midWicketCount,@"BALLS"];
        
        [self.img_sector addSubview:midWicket_lbl];
        
        
        if(lbl_midWicket_per !=nil)
        {
            [lbl_midWicket_per removeFromSuperview];
        }
        
        float midWktPer = (_tRuns.intValue != 0) ? ((float)(midWicketRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_midWicket_per=[[UILabel alloc]initWithFrame:CGRectMake(450,365,200,70)];
        lbl_midWicket_per.textColor=[UIColor whiteColor];
        lbl_midWicket_per.text =[NSString stringWithFormat:@"%.2f %@",midWktPer,@"%"];
        [self.img_sector addSubview:lbl_midWicket_per];
        

        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT039"])//Long on
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            
//            longonRun =longonRun+[Run intValue];
//            if(longon_lbl !=nil)
//            {
//                [longon_lbl removeFromSuperview];
//            }
//            
//            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(320,460,200, 35)];
//            longon_lbl.textColor=[UIColor whiteColor];
//            longon_lbl.text = [NSString stringWithFormat:@"%d %@ %d %@",longonRun,@"RUNS", longonCount,@"BALLS"];
//            [self.img_sector addSubview:longon_lbl];
//            
//            
//            if(lbl_longon_per !=nil)
//            {
//                [lbl_longon_per removeFromSuperview];
//            }
//            
//            float longOnPer = (_tRuns.intValue != 0) ? ((float)(longonRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_longon_per=[[UILabel alloc]initWithFrame:CGRectMake(340,465,200,70)];
//            lbl_longon_per.textColor=[UIColor whiteColor];
//            lbl_longon_per.text =[NSString stringWithFormat:@"%.2f %@",longOnPer,@"%"];
//            [self.img_sector addSubview:lbl_longon_per];
            
        }
        else
        {
            
            
            
        }
        longonRun =longonRun+[Run intValue];
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        
        longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(370,490,200, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text = [NSString stringWithFormat:@"%d %@ %d %@",longonRun,@"RUNS", longonCount,@"BALLS"];
        [self.img_sector addSubview:longon_lbl];
        
        
        if(lbl_longon_per !=nil)
        {
            [lbl_longon_per removeFromSuperview];
        }
        
        float longOnPer = (_tRuns.intValue != 0) ? ((float)(longonRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_longon_per=[[UILabel alloc]initWithFrame:CGRectMake(360,495,200,70)];
        lbl_longon_per.textColor=[UIColor whiteColor];
        lbl_longon_per.text =[NSString stringWithFormat:@"%.2f %@",longOnPer,@"%"];
        [self.img_sector addSubview:lbl_longon_per];
        
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT041"])//Long Off
    {
        if([batmanStyle isEqualToString:@"MSC012"])//Left hand
        {
            NSLog(@"LH");
            
            longoffRun =longoffRun +[Run intValue];
//            
//            if(longoff_lbl !=nil)
//            {
//                [longoff_lbl removeFromSuperview];
//            }
//            
//            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(165,460,200, 35)];
//            longoff_lbl.textColor=[UIColor whiteColor];
//            longoff_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",longoffRun,@"RUNS", longoffCount,@"BALLS"];
//            [self.img_sector addSubview:longoff_lbl];
//            
//            if(lbl_longoff_per !=nil)
//            {
//                [lbl_longoff_per removeFromSuperview];
//            }
//            
//            float longOffPer = (_tRuns.intValue != 0) ? ((float)(longoffRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_longoff_per=[[UILabel alloc]initWithFrame:CGRectMake(200,480,200,35)];
//            lbl_longoff_per.textColor=[UIColor whiteColor];
//            lbl_longoff_per.text =[NSString stringWithFormat:@"%.2f %@",longOffPer,@"%"];
//            [self.img_sector addSubview:lbl_longoff_per];
        }
        else
        {
              longoffRun =longoffRun +[Run intValue];
            
    }
        
      
        
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }
        
        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(160,490,200, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text = [NSString stringWithFormat:@"%d %@ %d %@",longoffRun,@"RUNS", longoffCount,@"BALLS"];
        [self.img_sector addSubview:longoff_lbl];
        
        if(lbl_longoff_per !=nil)
        {
            [lbl_longoff_per removeFromSuperview];
        }
        
        float longOffPer = (_tRuns.intValue != 0) ? ((float)(longoffRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_longoff_per=[[UILabel alloc]initWithFrame:CGRectMake(190,495,200,70)];
        lbl_longoff_per.textColor=[UIColor whiteColor];
        lbl_longoff_per.text =[NSString stringWithFormat:@"%.2f %@",longOffPer,@"%"];
        [self.img_sector addSubview:lbl_longoff_per];

        
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT042"])//Cover
        
    {
        if([batmanStyle isEqualToString:@"MSC012"])//Left hand
        {
            NSLog(@"LH");
            
           coverRun = coverRun+[Run intValue];
//            
//            if(cover_lbl !=nil)
//            {
//                [cover_lbl removeFromSuperview];
//            }
//            
//            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(420,330,200,35)];
//            cover_lbl.textColor=[UIColor whiteColor];
//            cover_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",coverRun,@"RUNS", coverCount,@"BALLS"];
//            [self.img_sector addSubview:cover_lbl];
//            
//            if(lbl_cover_per !=nil)
//            {
//                [lbl_cover_per removeFromSuperview];
//            }
//            
//            float coverPer = (_tRuns.intValue != 0) ? ((float)(coverRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_cover_per=[[UILabel alloc]initWithFrame:CGRectMake(465,335,200,70)];
//            lbl_cover_per.textColor=[UIColor whiteColor];
//            lbl_cover_per.text =[NSString stringWithFormat:@"%.2f %@",coverPer,@"%"];
//            [self.img_sector addSubview:lbl_cover_per];
            
        }
        else
        {
            
            coverRun = coverRun+[Run intValue];

    }
        
        
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        
        cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(40,350,200, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
       cover_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",coverRun,@"RUNS", coverCount,@"BALLS"];
        [self.img_sector addSubview:cover_lbl];
        
        if(lbl_cover_per !=nil)
        {
            [lbl_cover_per removeFromSuperview];
        }
        
        float coverPer = (_tRuns.intValue != 0) ? ((float)(coverRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_cover_per=[[UILabel alloc]initWithFrame:CGRectMake(50,350,200,70)];
        lbl_cover_per.textColor=[UIColor whiteColor];
        lbl_cover_per.text =[NSString stringWithFormat:@"%.2f %@",coverPer,@"%"];
        [self.img_sector addSubview:lbl_cover_per];

        
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT043"]) //Point
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            
//            pointRun = pointRun+[Run intValue];
//            
//            if(point_lbl !=nil)
//            {
//                [point_lbl removeFromSuperview];
//            }
//            
//            
//            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(425,180,200, 35)];
//            point_lbl.textColor=[UIColor whiteColor];
//            point_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",pointRun,@"RUNS", pointCount,@"BALLS"];
//            [self.img_sector addSubview:point_lbl];
//            
//            
//            if(lbl_point_per !=nil)
//            {
//                [lbl_point_per removeFromSuperview];
//            }
//            
//            float pointPer = (_tRuns.intValue != 0) ? ((float)(pointRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_point_per=[[UILabel alloc]initWithFrame:CGRectMake(470,185,200, 70)];
//            lbl_point_per.textColor=[UIColor whiteColor];
//            lbl_point_per.text =[NSString stringWithFormat:@"%.2f %@",pointPer,@"%"];
//            [self.img_sector addSubview:lbl_point_per];
//            
            
        }
        else
        {
            

        }
        
        pointRun = pointRun+[Run intValue];
        
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }
        
        
        point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,200,200, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",pointRun,@"RUNS", pointCount,@"BALLS"];
        [self.img_sector addSubview:point_lbl];
        
        
        if(lbl_point_per !=nil)
        {
            [lbl_point_per removeFromSuperview];
        }
        
        float pointPer = (_tRuns.intValue != 0) ? ((float)(pointRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_point_per=[[UILabel alloc]initWithFrame:CGRectMake(60,205,200,70)];
        lbl_point_per.textColor=[UIColor whiteColor];
        lbl_point_per.text =[NSString stringWithFormat:@"%.2f %@",pointPer,@"%"];
        [self.img_sector addSubview:lbl_point_per];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT044"])//Third man
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            
            
            if(Thirdman_lbl !=nil)
            {
                [Thirdman_lbl removeFromSuperview];
            }
//
//            
//            
//            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(320,70,200,35)];
//            Thirdman_lbl.textColor=[UIColor whiteColor];
//            Thirdman_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",ThirdmanCountRun,@"RUNS", ThirdmanCount,@"BALLS"];
//            [self.img_sector addSubview:Thirdman_lbl];
//            
//            
//            if(lbl_Thirdman_per !=nil)
//            {
//                [lbl_Thirdman_per removeFromSuperview];
//            }
//            
//            float thirdmanper = (_tRuns.intValue != 0) ? ((float)(ThirdmanCountRun) / ((float)([_tRuns intValue])/100)) : 0 ;
//            
//            lbl_Thirdman_per=[[UILabel alloc]initWithFrame:CGRectMake(350,75,70, 70)];
//            lbl_Thirdman_per.textColor=[UIColor whiteColor];
//            lbl_Thirdman_per.text =[NSString stringWithFormat:@"%.2f %@",thirdmanper,@"%"];
//            [self.img_sector addSubview:lbl_Thirdman_per];
            
            
        }
        else
        {
            NSLog(@"RH");
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            
            
            if(Thirdman_lbl !=nil)
            {
                [Thirdman_lbl removeFromSuperview];
            }
            
            
        }
        
       
        
        
        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(140,70,200,35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d %@ %d %@",ThirdmanCountRun,@"RUNS", ThirdmanCount,@"BALLS"];
        [self.img_sector addSubview:Thirdman_lbl];
        
        
        if(lbl_Thirdman_per !=nil)
        {
            [lbl_Thirdman_per removeFromSuperview];
        }
        
        float thirdmanper = (_tRuns.intValue != 0) ? ((float)(ThirdmanCountRun) / ((float)([_tRuns intValue])/100)) : 0 ;
        
        lbl_Thirdman_per=[[UILabel alloc]initWithFrame:CGRectMake(160,80,200, 70)];
        lbl_Thirdman_per.textColor=[UIColor whiteColor];
        lbl_Thirdman_per.text =[NSString stringWithFormat:@"%.2f %@",thirdmanper,@"%"];
        [self.img_sector addSubview:lbl_Thirdman_per];

        
    }
}

-(void) displayRuns {
    

    for (int i = 0 ; i < _sectorWagonArray.count; i++) {
        
        [self showLbl];
        
        SpiderWagonRecords * objStriker =[self.sectorWagonArray objectAtIndex:i];
        
        _selectRegionCode = objStriker.SECTORREGIONCODE;
        _selectRuns = objStriker.RUNS;
        _selectBattingStyle = objStriker.BATTINGSTYLE;
        
        

        if ([_selectRegionCode isEqualToString:@"MDT036"]) {
            
            finelegCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        
        if ([_selectRegionCode isEqualToString:@"MDT037"]) {
            
            squarelegCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        
        if ([_selectRegionCode isEqualToString:@"MDT038"]) {
            
            midWicketCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        
        if ([_selectRegionCode isEqualToString:@"MDT039"]) {
            
            longonCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        
        if ([_selectRegionCode isEqualToString:@"MDT041"]) {
            
            longoffCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        
        if ([_selectRegionCode isEqualToString:@"MDT042"]) {
            
            coverCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        if ([_selectRegionCode isEqualToString:@"MDT043"]) {
            
            pointCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
        }
        
        if ([_selectRegionCode isEqualToString:@"MDT044"]) {
            
   
            ThirdmanCount += _selectRun != 0 || _selectRun == nil ? 1 : 0;
      
            
        }
  
        
        
        [self sectorWagonwheel: _selectRegionCode : _selectBattingStyle : _selectRuns];
        
    }
    
    }


-(void)clearLbl{
    
    if(fineleg_lbl != nil)
    {
        [fineleg_lbl removeFromSuperview];
    }
    
     if(squareleg_lbl != nil)
    {
        [squareleg_lbl removeFromSuperview];
    }
    
     if(midWicket_lbl != nil)
    {
        [midWicket_lbl removeFromSuperview];
    }
    
     if(longon_lbl != nil )
    {
        [longon_lbl removeFromSuperview];
    }
    
     if(longoff_lbl != nil)
    {
        [longoff_lbl removeFromSuperview];
    }
    
     if(cover_lbl != nil)
    {
        [cover_lbl removeFromSuperview];
    }
     if(point_lbl != nil)
    {
        [point_lbl removeFromSuperview];
    }
     if(Thirdman_lbl != nil)
    {
        [Thirdman_lbl removeFromSuperview];
        
    }
    
    
    if(lbl_fineleg_per != nil)
    {
        [lbl_fineleg_per removeFromSuperview];
    }
    
     if(lbl_squareleg_per != nil )
    {
        [lbl_squareleg_per removeFromSuperview];
    }
    
     if(lbl_midWicket_per != nil)
    {
        [lbl_midWicket_per removeFromSuperview];
    }
    
     if(lbl_longon_per != nil)
    {
        [lbl_longon_per removeFromSuperview];
    }
    
     if(lbl_longoff_per != nil)
    {
        [lbl_longoff_per removeFromSuperview];
    }
    
     if(lbl_cover_per != nil )
    {
        [lbl_cover_per removeFromSuperview];
    }
     if(lbl_point_per != nil )
    {
        [lbl_point_per removeFromSuperview];
    }
     if(lbl_Thirdman_per != nil )
    {
        [lbl_Thirdman_per removeFromSuperview];
        
    }
}

-(void)hideLbl{
    
        fineleg_lbl.hidden = YES;
        squareleg_lbl .hidden = YES;
        midWicket_lbl .hidden = YES;
        longon_lbl .hidden = YES;
        longoff_lbl .hidden = YES;
        cover_lbl .hidden = YES;
        point_lbl .hidden = YES;
        Thirdman_lbl .hidden = YES;
    
    
        lbl_fineleg_per .hidden = YES;
        lbl_Thirdman_per.hidden = YES;
        lbl_squareleg_per .hidden = YES;
        lbl_midWicket_per .hidden = YES;
        lbl_longon_per .hidden = YES;
        lbl_longoff_per .hidden = YES;
        lbl_cover_per .hidden = YES;
        lbl_point_per .hidden = YES;
 
}

-(void)showLbl{
    
    fineleg_lbl.hidden = NO;
    squareleg_lbl .hidden = NO;
    midWicket_lbl .hidden = NO;
    longon_lbl .hidden = NO;
    longoff_lbl .hidden = NO;
    cover_lbl .hidden = NO;
    point_lbl .hidden = NO;
    Thirdman_lbl .hidden = NO;
    lbl_fineleg_per .hidden = NO;
    lbl_Thirdman_per.hidden = NO;
    lbl_squareleg_per .hidden = NO;
    lbl_midWicket_per .hidden = NO;
    lbl_longon_per .hidden = NO;
    lbl_longoff_per .hidden = NO;
    lbl_cover_per .hidden = NO;
    lbl_point_per .hidden = NO;
    
}


-(void) clearValues{
    
    ThirdmanCountRun = 0;
    pointRun = 0;
    coverRun = 0;
    longoffRun = 0;
    longonRun = 0;
    midWicketRun = 0;
    squarelegRun = 0;
    finelegRun = 0;
    
    
    ThirdmanCount = 0;
    pointCount = 0;
    coverCount = 0;
    longoffCount = 0;
    longonCount = 0;
    midWicketCount = 0;
    squarelegCount = 0;
    finelegCount = 0;
    

    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
}

@end
