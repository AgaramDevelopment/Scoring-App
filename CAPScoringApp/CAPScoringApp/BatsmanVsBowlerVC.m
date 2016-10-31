//
//  BatsmanVsBowlerVC.m
//  CAPScoringApp
//
//  Created by Mac on 27/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BatsmanVsBowlerVC.h"
#import "DBManagerReports.h"
#import "BvsBBowler.h"
#import "BvsBBatsman.h"
#import "BatsmanVsBowlerTVCell.h"
@interface BatsmanVsBowlerVC (){
    BOOL isStriker;
   // NSString *selectedFilterStricker;
    BvsBBatsman *selectedFilterBatsman;
    
}
@property (nonatomic,strong) NSMutableArray *batsmansArray;
@property (nonatomic,strong) NSMutableArray *bowlersArray;
@property (nonatomic,strong) NSMutableArray *bowlersFilterArray;


@end

@implementation BatsmanVsBowlerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view_filter_stricker .layer setBorderWidth:2.0];
    [self.view_filter_stricker.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_filter_stricker .layer setMasksToBounds:YES];
    
    
    [self setInningsDetailsView:@"1"];
    
    self.tableview_stricker.hidden=YES;


    [self setInningsView];
    [self setInningsBySelection:@"1"];
    self.tableview_stricker.separatorColor = [UIColor clearColor];
    self.tableview_bowlers.separatorColor = [UIColor clearColor];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setBowlerFilterArray{
    _bowlersFilterArray = [[NSMutableArray alloc]init];
    
    for (BvsBBowler *bvsBowler in self.bowlersArray) {
        if([bvsBowler.strickerCode isEqualToString:selectedFilterBatsman.strickerCode]){
            [_bowlersFilterArray addObject:bvsBowler];
        }
    }
    
    [_tableview_bowlers reloadData];
    
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
    self.batsmansArray = [dbReports retrieveBatVsBowlBatsmanList:self.matchCode :self.compititionCode :innsNo];
    self.bowlersArray = [dbReports retrieveBatVsBowlBowlersList:self.matchCode :self.compititionCode :innsNo];
    
    if(_batsmansArray.count>0){
        BvsBBatsman *bvsBBatsman = [_batsmansArray objectAtIndex:0];
        selectedFilterBatsman = bvsBBatsman;
        [self setBatsmanVeiw:bvsBBatsman];
        
        [self setBowlerFilterArray];
        _lbl_filter_stricker_name.text = bvsBBatsman.name;
        [self setViewWhenDataPresent];
        [_tableview_stricker reloadData];
        
    }else{
        [self setViewWhenNoData];
    }
}


-(void) setViewWhenNoData{
    self.view_open_filter.hidden = YES;
    self.view_filter.hidden=YES;
    self.view_bowler_header.hidden=YES;
    self.view_batsman_details.hidden=YES;
    self.tableview_bowlers.hidden=YES;

}


-(void) setViewWhenDataPresent{
    self.view_open_filter.hidden = NO;
    self.view_filter.hidden=YES;
    self.view_bowler_header.hidden=NO;
    self.view_batsman_details.hidden=NO;
    self.tableview_bowlers.hidden=NO;
}

-(void) setBatsmanVeiw:(BvsBBatsman *) bvsBBatsman{
    
    [self setImage:bvsBBatsman.strickerCode :self.img_batsman_photo];
    self.batsman_name.text= [bvsBBatsman name];
    self.lbl_dots.text= [bvsBBatsman dots];
    self.lbl_ones.text= [bvsBBatsman ones];
    self.lbl_twos.text= [bvsBBatsman twos];
    self.lbl_threes.text= [bvsBBatsman threes];
    self.lbl_fours.text= [bvsBBatsman fours];
    
    self.lbl_fives.text= [bvsBBatsman fives];
    self.lbl_sixes.text= [bvsBBatsman sixes];
    self.lbl_sevens.text= [bvsBBatsman sevens];
    self.lbl_b4s.text= [bvsBBatsman bFours];
    self.lbl_b6s.text= [bvsBBatsman bSixes];
    self.lbl_unc.text= [bvsBBatsman uncomfort];
    self.lbl_btn.text= [bvsBBatsman beaten];
    self.lbl_wtb.text= [bvsBBatsman wtb];
    self.lbl_balls.text= [bvsBBatsman balls];
    self.lbl_runs.text= [bvsBBatsman runs];
   // self.lbl_sr.text= [bvsBBatsman sr];
    
    self.lbl_sr.text = [NSString stringWithFormat:@" %.02f",[bvsBBatsman.sr floatValue]];

    
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





- (IBAction)did_click_filter_stricker:(id)sender {
    
    if(isStriker==NO)
    {
        
        self.tableview_stricker.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.tableview_stricker.hidden=YES;
        isStriker=NO;
    }
    
}
- (IBAction)did_click_open_filter:(id)sender {
    self.view_filter.hidden =NO;
    self.view_open_filter.hidden = YES;
    self.lbl_filter_stricker_name.text = selectedFilterBatsman.name;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.tableview_stricker){
        return [self.batsmansArray count];
    }else if(tableView==self.tableview_bowlers){
        return [self.bowlersFilterArray count];
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==self.tableview_bowlers){
        static NSString * bowlerCell = @"bowler_cell";
        
        
        BvsBBowler *bvsBBowler = [_bowlersFilterArray objectAtIndex:indexPath.row];
        
        BatsmanVsBowlerTVCell *cell = (BatsmanVsBowlerTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerCell];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"BatsmanVsBowlerTVCell" owner:self options:nil];
            cell = self.bats_vs_bow_tvcell;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lbl_name.text = bvsBBowler.name;
        cell.lbl_team_name.text = bvsBBowler.teamName;
        cell.lbl_runs.text = bvsBBowler.runs;
        cell.lbl_balls.text = bvsBBowler.balls;
        cell.lbl_zeros.text = bvsBBowler.dots;
        cell.lbl_ones.text = bvsBBowler.ones;
        cell.lbl_twos.text = bvsBBowler.twos;
        cell.lbl_threes.text = bvsBBowler.threes;
        cell.lbl_b4.text = bvsBBowler.bFours;
        cell.lbl_b6.text = bvsBBowler.bSixes;
        cell.lbl_unc.text = bvsBBowler.uncomfort;
        cell.lbl_btn.text = bvsBBowler.beaten;
        cell.lbl_wtb.text = bvsBBowler.wtb;
        cell.lbl_wicket_type.text = bvsBBowler.wicketType;

       
        
        return cell;
    }else if(tableView == self.tableview_stricker){
        
        
        
        //Other Cells
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        
        BvsBBatsman *bvsBBatsman = [_batsmansArray objectAtIndex:indexPath.row];

        
        cell.textLabel.text = [bvsBBatsman name];
        
        
        
        return cell;

        
        
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tableview_bowlers){
    }else if(tableView == self.tableview_stricker){

    BvsBBatsman *bvsBBatsman = [self.batsmansArray objectAtIndex:indexPath.row];
    
//        selectedFilterStricker = bvsBBatsman.strickerCode;
        selectedFilterBatsman = bvsBBatsman;

        _lbl_filter_stricker_name.text = bvsBBatsman.name;
        self.tableview_stricker.hidden=YES;

        isStriker=NO;

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
    
    
    self.tableview_stricker.hidden=YES;
    isStriker=NO;

    [self setBatsmanVeiw:selectedFilterBatsman];
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
    [self setBowlerFilterArray];
}
- (IBAction)did_click_close_filter:(id)sender {
    
    self.tableview_stricker.hidden=YES;
    isStriker=NO;

    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;

}
@end
