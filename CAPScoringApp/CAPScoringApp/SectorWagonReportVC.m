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
    
    int ThirdmanCountRun;
    int pointRun;
    int coverRun;
    int longoffRun;
    int longonRun;
    int midWicketRun;
    int squarelegRun;
    int finelegRun;

}

@property (nonatomic,strong) NSMutableArray *sectorWagonArray;

@property (nonatomic,strong) NSMutableArray * bowlerArray;
@property (nonatomic,strong) NSMutableArray * strikerArray;

@property (nonatomic,strong) NSString *selectRun;
@property (nonatomic,strong) NSString *selectOnSide;
@property (nonatomic,strong) NSString *teamBcode;

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
    
    if(_sectorWagonArray.count>0){
        
        SpiderWagonRecords * objStriker =[self.sectorWagonArray objectAtIndex:0];
    
        _selectRegionCode = objStriker.SECTORREGIONCODE;
        _selectRuns = objStriker.RUNS;
        _selectBattingStyle = objStriker.BATTINGSTYLE;
        
    }

    [self sectorWagonwheel: _selectRegionCode : _selectBattingStyle : _selectRuns];
    [self setInningsBySelection:@"1"];
    [self setInningsView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_first_inns:(id)sender{
    
    [self setInningsBySelection:@"1"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"1"];
    
     [self.tbl_players reloadData];
}

- (IBAction)btn_sec_inns:(id)sender {
    
    [self setInningsBySelection:@"2"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"2"];
    

    [self.tbl_players reloadData];
}

- (IBAction)btn_third_inns:(id)sender {
    
    [self setInningsBySelection:@"3"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"3"];
    
    [self.tbl_players reloadData];
}

- (IBAction)btn_fourth_inns:(id)sender {
    
   
    [self setInningsBySelection:@"4"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"4"];
    _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"4"];
    
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
    
    
    
    
}


-(void)sectorWagonwheel:(NSString *) sectorwognwheelcode :(NSString *) batmanStyle :(NSString *) Run

{
    if([Run isEqualToString:@"1"])
    {
        Run1Count++;
    }
    else if ([Run isEqualToString:@"0"])
    {
        zerocount++;
    }
    else if ([Run isEqualToString:@"2"])
    {
        Run2Count++;
    }
    else if ([Run isEqualToString:@"3"])
    {
        Run3Count++;
    }
    else if ([Run isEqualToString:@"4"])
    {
        Run4Count++;
    }
    else if ([Run isEqualToString:@"6"])
    {
        Run6Count++;
    }
    
    
    if([sectorwognwheelcode isEqualToString:@"MDT036"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // fineleg++;
            finelegRun = [Run intValue]+finelegRun;
        }
        else
        {
            // fineleg++;
            NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
        }
        
        if(fineleg_lbl !=nil)
        {
            [fineleg_lbl removeFromSuperview];
        }
        
        fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [self.img_sector addSubview:fineleg_lbl];
        // self.batsmanCell.WangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
        
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT037"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
        }
        
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }
        
        squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,110,35, 35)];
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [self.img_sector addSubview:squareleg_lbl];
        // self.batsmanCell.wangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT038"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
        }
        
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }
        
        
        midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [self.img_sector addSubview:midWicket_lbl];
        //   self.batsmanCell.wangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT039"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // longon++;
            longonRun =longonRun+[Run intValue];
        }
        else
        {
            //            NSLog(@"RH");
            //longon++;
            longonRun =longonRun+[Run intValue];
        }
        
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        
        longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [self.img_sector addSubview:longon_lbl];
        // self.batsmanCell.wangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT041"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // longoff++;
            longoffRun =longoffRun +[Run intValue];
        }
        else
        {
            //            NSLog(@"RH");
            // longoff++;
            longoffRun =longoffRun +[Run intValue];
        }
        
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }
        
        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [self.img_sector addSubview:longoff_lbl];
        // self.batsmanCell.wangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];
        
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT042"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //cover++;
            coverRun = coverRun+[Run intValue];
        }
        else
        {
            //            NSLog(@"RH");
            //           // cover++;
            coverRun = coverRun+[Run intValue];
        }
        
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        
        cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [self.img_sector addSubview:cover_lbl];
        // self.batsmanCell.wangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT043"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // point++;
            pointRun = pointRun+[Run intValue];
            
        }
        else
        {
            //            NSLog(@"RH");
            //            //point++;
            pointRun = pointRun+[Run intValue];
        }
        
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }
        
        
        point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [self.img_sector addSubview:point_lbl];
        
    }
    else if([sectorwognwheelcode isEqualToString:@"MDT044"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //            //ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            
            
        }
        
        
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }
        
        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [self.img_sector addSubview:Thirdman_lbl];
        
    }
}


@end
