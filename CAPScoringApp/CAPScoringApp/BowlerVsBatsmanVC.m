//
//  BowlerVsBatsmanVC.m
//  CAPScoringApp
//
//  Created by Mac on 01/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BowlerVsBatsmanVC.h"
#import "DBManagerReports.h"
#import "BvsBBowler.h"
#import "BvsBBatsman.h"
#import "BowlerVsBatsmanTVCell.h"

@interface BowlerVsBatsmanVC (){
    BOOL isBowler;
    // NSString *selectedFilterStricker;
    BvsBBowler *selectedFilterBowler;
    
}
@property (nonatomic,strong) NSMutableArray *batsmansArray;
@property (nonatomic,strong) NSMutableArray *bowlersArray;
@property (nonatomic,strong) NSMutableArray *batsmanFilterArray;


@end

@implementation BowlerVsBatsmanVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view_filter_bowler .layer setBorderWidth:2.0];
    [self.view_filter_bowler.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_filter_bowler .layer setMasksToBounds:YES];
    
    
    [self setInningsDetailsView:@"1"];
    
    self.tableview_filter_bowler.hidden=YES;
    
    
    [self setInningsView];
    [self setInningsBySelection:@"1"];
    self.tableview_batsman.separatorColor = [UIColor clearColor];
    self.tableview_filter_bowler.separatorColor = [UIColor clearColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setBatsmanFilterArray{
    self.batsmanFilterArray = [[NSMutableArray alloc]init];
    
    for (BvsBBatsman *bvsBatsman in self.batsmansArray) {
        if([bvsBatsman.bowlerCode isEqualToString:selectedFilterBowler.bowlerCode]){
            [self.batsmanFilterArray addObject:bvsBatsman];
        }
    }
    
    [_tableview_batsman reloadData];
    
}


- (IBAction)did_click_inn_one:(id)sender {
    
    [self setInningsDetailsView:@"1"];
}

- (IBAction)did_click_inn_two:(id)sender {
    [self setInningsDetailsView:@"2"];
    
}

- (IBAction)did_click_inn_three:(id)sender {
    
    [self setInningsDetailsView:@"3"];
}

- (IBAction)did_click_inn_four:(id)sender {
    [self setInningsDetailsView:@"4"];
}


-(void )setInningsDetailsView: (NSString *) innsNo{
    [self setInningsBySelection:innsNo];
    
    DBManagerReports *dbReports = [[DBManagerReports alloc]init];
    self.batsmansArray = [dbReports retrieveBowVsBatsBatsmanList:self.matchCode :self.compititionCode :innsNo];
    self.bowlersArray = [dbReports retrieveBowVsBatsBowlersList:self.matchCode :self.compititionCode :innsNo];
    
    if(self.bowlersArray.count>0){
        BvsBBowler *bvsBBowler = [self.bowlersArray objectAtIndex:0];
        selectedFilterBowler = bvsBBowler;
        [self setBowlerVeiw:bvsBBowler];
        
        [self setBatsmanFilterArray];
        _lbl_filter_bowler_name.text = bvsBBowler.name;
        [self setViewWhenDataPresent];
        [_tableview_filter_bowler reloadData];
        
    }else{
        [self setViewWhenNoData];
    }
}


-(void) setViewWhenNoData{
    self.view_open_filter.hidden = YES;
    self.view_filter.hidden=YES;
    self.view_batsman_header.hidden=YES;
    self.view_bowler_details.hidden=YES;
    self.tableview_batsman.hidden=YES;
    
}


-(void) setViewWhenDataPresent{
    self.view_open_filter.hidden = NO;
    self.view_filter.hidden=YES;
    self.view_batsman_header.hidden=NO;
    self.view_bowler_details.hidden=NO;
    self.tableview_batsman.hidden=NO;
}

-(void) setBowlerVeiw:(BvsBBowler *) bvsBBowler{
    
    [self setImage:bvsBBowler.bowlerCode :self.img_bowler_photo];
    self.batsman_name.text= [bvsBBowler name];
    self.lbl_dots.text= [bvsBBowler dots];
    self.lbl_ones.text= [bvsBBowler ones];
    self.lbl_twos.text= [bvsBBowler twos];
    self.lbl_threes.text= [bvsBBowler threes];
    self.lbl_fours.text= [bvsBBowler fours];
    
    self.lbl_fives.text= [bvsBBowler fives];
    self.lbl_sixes.text= [bvsBBowler sixes];
    self.lbl_sevens.text= [bvsBBowler sevens];
    self.lbl_b4s.text= [bvsBBowler bFours];
    self.lbl_b6s.text= [bvsBBowler bSixes];
    self.lbl_unc.text= [bvsBBowler uncomfort];
    self.lbl_btn.text= [bvsBBowler beaten];
    self.lbl_wtb.text= [bvsBBowler wtb];
    self.lbl_balls.text= [bvsBBowler balls];
    self.lbl_runs.text= [bvsBBowler runs];
   // self.lbl_sr.text= [bvsBBowler sr];
    
    self.lbl_sr.text = [NSString stringWithFormat:@" %.02f",[bvsBBowler.sr floatValue]];
    
    
}

-(void) setInningsView{
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){//T20
        
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = YES;
        self.inns_four.hidden = YES;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //[self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        self.inns_two_width.constant = 384;
        self.inns_one_width.constant = 384;
        
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){//ODI
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = YES;
        self.inns_four.hidden = YES;
        self.inns_two_width.constant = 384;
        self.inns_one_width.constant = 384;
        
        //     [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //    [self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        
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





- (IBAction)did_click_filter_bowler:(id)sender{
    
    if(isBowler==NO)
    {
        
        self.tableview_filter_bowler.hidden=NO;
        isBowler=YES;
        
    }
    else
    {
        self.tableview_filter_bowler.hidden=YES;
        isBowler=NO;
    }
    
}
- (IBAction)did_click_open_filter:(id)sender {
    self.view_filter.hidden =NO;
    self.view_open_filter.hidden = YES;
    self.lbl_filter_bowler_name.text = selectedFilterBowler.name;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.tableview_batsman){
        return [self.batsmanFilterArray count];
    }else if(tableView==self.tableview_filter_bowler){
        return [self.bowlersArray count];
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==self.tableview_batsman){
        static NSString * batsmanCell = @"batsman_cell";
        
        
        BvsBBatsman *bvsBBatsman = [self.batsmanFilterArray objectAtIndex:indexPath.row];
        
        BowlerVsBatsmanTVCell *cell = (BowlerVsBatsmanTVCell *)[tableView dequeueReusableCellWithIdentifier:batsmanCell];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"BowlerVsBatsmanTVCell" owner:self options:nil];
            cell = self.bowl_vs_bats_tvcell;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lbl_name.text = bvsBBatsman.name;
        cell.lbl_team_name.text = bvsBBatsman.teamName;
        cell.lbl_runs.text = bvsBBatsman.runs;
        cell.lbl_balls.text = bvsBBatsman.balls;
        cell.lbl_zeros.text = bvsBBatsman.dots;
        cell.lbl_ones.text = bvsBBatsman.ones;
        cell.lbl_twos.text = bvsBBatsman.twos;
        cell.lbl_threes.text = bvsBBatsman.threes;
        cell.lbl_b4.text = bvsBBatsman.bFours;
        cell.lbl_b6.text = bvsBBatsman.bSixes;
        cell.lbl_unc.text = bvsBBatsman.uncomfort;
        cell.lbl_btn.text = bvsBBatsman.beaten;
        cell.lbl_wtb.text = bvsBBatsman.wtb;
        cell.lbl_wicket_type.text = bvsBBatsman.wicketType;
        cell.lbl_sr.text = [NSString stringWithFormat:@" %.02f",[bvsBBatsman.sr floatValue]];

        
        return cell;
        
    }else if(tableView == self.tableview_filter_bowler){
        
        
        
        //Other Cells
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        
        BvsBBowler *bvsBBowler = [_bowlersArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text = [bvsBBowler name];
        
        
        
        return cell;
        
        
        
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tableview_filter_bowler){
        
        BvsBBowler *bvsBBowler = [self.bowlersArray objectAtIndex:indexPath.row];
        
        //        selectedFilterStricker = bvsBBatsman.strickerCode;
        selectedFilterBowler = bvsBBowler;
        
        _lbl_filter_bowler_name.text = bvsBBowler.name;
        self.tableview_filter_bowler.hidden=YES;
        
        isBowler=NO;
        
    }
}

-(void) setImage:(NSString *)playerCode :(UIImageView *)teamLogoImg {
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,playerCode];
    
    NSError *attributesError = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:pngFilePath error:&attributesError];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    
    
    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist && fileSizeNumber.intValue>0){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
        teamLogoImg.image = img;
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
        teamLogoImg.image = img;
    }
}

- (IBAction)did_click_filter_ok:(id)sender {
    
    
    self.tableview_filter_bowler.hidden=YES;
    isBowler=NO;
    
    [self setBowlerVeiw:selectedFilterBowler];
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
    [self setBatsmanFilterArray];
}
- (IBAction)did_click_close_filter:(id)sender {
    
    self.tableview_filter_bowler.hidden=YES;
    isBowler=NO;
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
}

@end
