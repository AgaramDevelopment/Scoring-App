//
//  PlayerWormChartVC.m
//  CAPScoringApp
//
//  Created by Mac on 26/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerWormChartVC.h"
#import "BvsBBatsman.h"


@interface PlayerWormChartVC (){
    
    BOOL isStriker;
    // NSString *selectedFilterStricker;
    BvsBBatsman *selectedFilterBatsman;

}
@property (nonatomic,strong) NSMutableArray *batsmansArray;


@end

@implementation PlayerWormChartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view_filter_batsman .layer setBorderWidth:2.0];
    [self.view_filter_batsman.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_filter_batsman .layer setMasksToBounds:YES];
    
    [self setInningsView];
    [self setInningsBySelection:@"1"];
    self.tableview_batsman.separatorColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setViewWhenNoData{
    self.view_open_filter.hidden = YES;
    self.view_filter.hidden=YES;
}


-(void) setViewWhenDataPresent{
    self.view_open_filter.hidden = NO;
    self.view_filter.hidden=YES;
}

- (IBAction)did_click_inn_one:(id)sender {
    
  //  [self setInningsDetailsView:@"1"];
}

- (IBAction)did_click_inn_two:(id)sender {
 //   [self setInningsDetailsView:@"2"];
    
}

- (IBAction)did_click_inn_three:(id)sender {
    
 //   [self setInningsDetailsView:@"3"];
}

- (IBAction)did_click_inn_four:(id)sender {
 //   [self setInningsDetailsView:@"4"];
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





- (IBAction)did_click_filter_batsman:(id)sender {
    
    if(isStriker==NO)
    {
        
        self.tableview_batsman.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.tableview_batsman.hidden=YES;
        isStriker=NO;
    }
    
}
- (IBAction)did_click_open_filter:(id)sender {
    self.view_filter.hidden =NO;
    self.view_open_filter.hidden = YES;
    self.lbl_filter_batsman_name.text = selectedFilterBatsman.name;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.tableview_batsman){
        return [self.batsmansArray count];
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableview_batsman){
        
        
        
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
    if(tableView == self.tableview_batsman){
        
        BvsBBatsman *bvsBBatsman = [self.batsmansArray objectAtIndex:indexPath.row];
        
        //        selectedFilterStricker = bvsBBatsman.strickerCode;
        selectedFilterBatsman = bvsBBatsman;
        
        _lbl_filter_batsman_name.text = bvsBBatsman.name;
        self.tableview_batsman.hidden=YES;
        
        isStriker=NO;
        
    }
}


- (IBAction)did_click_filter_ok:(id)sender {
    
    
    self.tableview_batsman.hidden=YES;
    isStriker=NO;
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
}
- (IBAction)did_click_close_filter:(id)sender {
    
    self.tableview_batsman.hidden=YES;
    isStriker=NO;
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
}



@end
