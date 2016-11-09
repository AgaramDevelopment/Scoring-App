//
//  BatsmanKPIVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BatsmanKPIVC.h"
#import "DBManagerPlayersKPI.h"
#import "BatsmanKPITVC.h"
#import "PlayerKPIRecords.h"
#import "DBManagerpitchmapReport.h"

@interface BatsmanKPIVC (){
    
    DBManagerpitchmapReport *objDBManagerpitchmapReport;
    DBManagerPlayersKPI *objDBManagerPlayersKPI;
}

@property (nonatomic,strong) NSMutableArray *batsmanArray;
@end

@implementation BatsmanKPIVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    objDBManagerPlayersKPI = [[DBManagerPlayersKPI alloc]init];
    objDBManagerpitchmapReport = [[DBManagerpitchmapReport alloc]init];
    
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
   _batsmanArray = [objDBManagerPlayersKPI getBatsmanKpi :_matchTypeCode :_compititionCode :_matchCode :_teamCode :@"1"];
    
    [self setInningsBySelection:@"1"];
    [self setInningsView];
    self.tbl_details.separatorColor = [UIColor clearColor];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_batsmanArray count];
    
    
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView==self.tbl_details){
        static NSString * bowlerCell = @"Cell";
        
        
        PlayerKPIRecords *record = [_batsmanArray objectAtIndex:indexPath.row];
        
        BatsmanKPITVC *cell = (BatsmanKPITVC *)[tableView dequeueReusableCellWithIdentifier:bowlerCell];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"BatsmanKPITVC" owner:self options:nil];
            cell = self.batsmanKPIcell;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lbl_striker_name.text =  record.STRIKERNAME;
        
        cell.lbl_balls.text = record.BALLS;
        cell.lbl_runs.text = record.RUNS;
        cell.lbl_db.text = record.DOTBALL;
        cell.lbl_ones.text = record.ONES;
        cell.lbl_twos.text = record.TWOS;
        cell.lbl_threes.text = record.THREES;
        cell.lbl_b4.text = record.BOUNDARY4S;
        cell.lbl_b6.text = record.BOUNDARY6S;
        //cell.lbl_one_per.text = [NSString stringWithFormat:@"%@%@",record.ONESPERCENTAGE,@"%"];
        cell.lbl_ones_per.text = record.ONESPERCENTAGE;
        cell.lbl_twos_per.text = record.TWOSPERCENTAGE;
        cell.lbl_threes_per.text = record.THREESPERCENTAGE;
        cell.lbl_fours_per.text = record.FOURSPERCENTAGE;
        cell.lbl_six_per.text = record.SIXESPERCENTAGE;
        
        
        
        return cell;
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
