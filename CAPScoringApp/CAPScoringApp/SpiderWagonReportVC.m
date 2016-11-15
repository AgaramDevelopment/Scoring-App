//
//  SpiderWagonReportVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 22/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SpiderWagonReportVC.h"
#import "DBManagerSpiderWagonReport.h"
#import "DBManagerpitchmapReport.h"
#import "SpiderWagonRecords.h"
#import "Utitliy.h"
#import "StrikerDetails.h"

@interface SpiderWagonReportVC ()
{
    BOOL isStriker;
    BOOL isBowler;
    DBManagerSpiderWagonReport *objDBManagerSpiderWagonReport;
    DBManagerpitchmapReport *objDBManagerpitchmapReport;
    
}

@property (nonatomic,strong) NSMutableArray *spiderWagonArray;

@property (nonatomic,strong) NSMutableArray * bowlerArray;
@property (nonatomic,strong) NSMutableArray * strikerArray;

@property (nonatomic,strong) NSString *selectRun;
@property (nonatomic,strong) NSString *selectOnSide;
@property (nonatomic,strong) NSString *teamBcode;

@end

@implementation SpiderWagonReportVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    _teamBcode = [objDBManagerSpiderWagonReport getTeamBCode:self.compititionCode :self.matchCode];
    

    
    [self setInningsBySelection:@"1"];
    
    
    
 self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
//    
// _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"1" :@"" :@"" :@"" :@"" :@"",@""];
    
    _spiderWagonArray = [objDBManagerSpiderWagonReport getSpiderWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1" :@"" :@"" :@"" :@"" :@"" :@""];
    
    
    [self drawSpiderWagonLine];
    [self setInningsView];
    
}



-(void)drawSpiderWagonLine{
    
    int x1position;
    int y1position;
    int x2position;
    int y2position;
    
    
    
    for(int i=0; i< _spiderWagonArray.count;i++)
    {
        SpiderWagonRecords * objRecord =(SpiderWagonRecords *)[_spiderWagonArray objectAtIndex:i];
        
    
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord.WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
        
        
//        if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
            
            int Xposition = x1position+7;
            int Yposition = y1position+4;
        
        
            CGMutablePathRef straightLinePath = CGPathCreateMutable();
            CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
            CGPathAddLineToPoint(straightLinePath, NULL,x2position+7,y2position+4);
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = straightLinePath;
            UIColor *fillColor = [UIColor redColor];
            shapeLayer.fillColor = fillColor.CGColor;
            UIColor *strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0f];
            shapeLayer.strokeColor = strokeColor.CGColor;
            shapeLayer.lineWidth = 2.0f;
            shapeLayer.fillRule = kCAFillRuleNonZero;
            shapeLayer.name = @"DrawLine";
            [_img_wagon.layer addSublayer:shapeLayer];
            
        //}
        
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

- (IBAction)btn_first_inns:(id)sender {
    

self.img_wagon.layer.sublayers = nil;
    

    [self setInningsBySelection:@"1"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
        _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"1"];

    
    _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"1" :@"" :@"" :@"" :@"" :@"":@""];
   [self drawSpiderWagonLine];
 
    
    [self.tbl_players reloadData];
}

- (IBAction)btn_sec_inns:(id)sender {
    
  
  self.img_wagon.layer.sublayers = nil;

    
    [self setInningsBySelection:@"2"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
        _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"2"];
    
   
    _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"2" :@"" :@"" :@"" :@"" :@"":@""];
    
    [self drawSpiderWagonLine];
    [self.tbl_players reloadData];
}

- (IBAction)btn_third_inns:(id)sender {
    
     self.img_wagon.layer.sublayers = nil;
    
    [self setInningsBySelection:@"3"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
        _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"3"];
    
    
    [self drawSpiderWagonLine];
     _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"3" :@"" :@"" :@"" :@"" :@"":@""];
    
    [self.tbl_players reloadData];
}

- (IBAction)btn_fourth_inns:(id)sender {
    
     self.img_wagon.layer.sublayers = nil;
    [self setInningsBySelection:@"4"];
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"4"];
        _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"4"];


    [self drawSpiderWagonLine];
    _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"4" :@"" :@"" :@"" :@"" :@"":@""];
    
    
    [self.tbl_players reloadData];
}

- (IBAction)hide_Filer_view:(id)sender {
    
     self.filter_view.hidden =NO;
       self.hide_btn_view.hidden = YES;
    
   
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

- (IBAction)btn_hide_view:(id)sender {
    
    self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
    
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



- (IBAction)btn_done:(id)sender {
    
    self.img_wagon.layer.sublayers = nil;
    
    //changing wagon wheel image based on batting style
    if ([self.selectBattingStyle isEqualToString:@"MSC012"]) {
        
        self.img_wagon.image = [UIImage imageNamed:@"LHWagon.png"];
        
    }else if ([self.selectBattingStyle isEqualToString:@"MSC013"]){
        
        self.img_wagon.image = [UIImage imageNamed:@"RHWagon.png"];
    }

    
    
    _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"" : self.selectStrikerCode == nil ? @"" : self.selectStrikerCode : self.selectBowlerCode == nil ? @"":self.selectBowlerCode :[self.selectRun isEqual:nil]?@"":self.selectRun == nil ? @"" : self.selectRun :@"" :@"":self.selectOnSide == nil ? @"" :self.selectOnSide];
    
      [self drawSpiderWagonLine];
    self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
}

- (IBAction)btn_hide_filter:(id)sender {
    
    
    
    self.filter_view.hidden=YES;
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
@end
