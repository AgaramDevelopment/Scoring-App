//
//  SpellReportVC.m
//  CAPScoringApp
//
//  Created by APPLE on 19/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SpellReportVC.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "SpellReportRecord.h"
#import "DBManagerSpellReport.h"
#import "SpellReportCell.h"

@interface SpellReportVC ()
{
    DBManagerSpellReport *  objDBManagerSpellReport;
    NSMutableArray * objSpellReport;
}

@property (nonatomic,strong) NSString * inningsno;

@end

@implementation SpellReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInningsView];
    objDBManagerSpellReport =[[DBManagerSpellReport alloc]init];
    objSpellReport   =[[NSMutableArray alloc]init];
    [self.Inn1_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }

-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.Inn1_Btn];
    [self setInningsButtonUnselect:self.Inn2_Btn];
    [self setInningsButtonUnselect:self.Inn3_Btn];
    [self setInningsButtonUnselect:self.Inn4_Btn];
    
    [self.Inn1_Btn setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.fstInnShortName] forState:UIControlStateNormal];
    [self.Inn2_Btn setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.secInnShortName] forState:UIControlStateNormal];
    [self.Inn3_Btn setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.thrdInnShortName] forState:UIControlStateNormal];
    [self.Inn4_Btn setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.frthInnShortName] forState:UIControlStateNormal];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.Inn1_Btn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.Inn2_Btn];
        
    }else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.Inn3_Btn];
        
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.Inn4_Btn];
        
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

-(void) setInningsView{
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){
        //T20
        
        self.Inn1_Btn.hidden = NO;
        self.Inn2_Btn.hidden = NO;
        self.Inn3_Btn.hidden = YES;
        self.Inn4_Btn.hidden = YES;
        
        self.inn1_btnWidth.constant =  384; //(self.view.frame.size.width/2);
        //self.inn1_btnYposition.constant = self.inn1_btnWidth.constant;
        self.inns2_btnWidth.constant =  384; //(self.view.frame.size.width/2);
        
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){//ODI
        self.Inn1_Btn.hidden = NO;
        self.Inn2_Btn.hidden = NO;
        self.Inn3_Btn.hidden = YES;
        self.Inn4_Btn.hidden = YES;
        self.inn1_btnWidth.constant =   384;   //self.view.frame.size.width/2;
        self.inns2_btnWidth.constant =  384;      //self.view.frame.size.width/2;
        
        
    }else if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){//Test
        
        self.Inn1_Btn.hidden = NO;
        self.Inn2_Btn.hidden = NO;
        self.Inn3_Btn.hidden = NO;
        self.Inn4_Btn.hidden = NO;
        
        self.inn1_btnWidth.constant  = 192;   //self.view.frame.size.width/2;
        self.inns2_btnWidth.constant = 192;      //self.view.frame.size.width/2;
        self.inns3_btnwidth.constant  = 192;   //self.view.frame.size.width/2;
        self.inns4_btnwidth.constant = 192;
        
    }
}

-(IBAction)didClickInns1:(id)sender
{
    [self setInningsBySelection:@"1"];
    self.inningsno=@"1";
     NSMutableArray * objarray =[[NSMutableArray alloc]init];
    NSMutableArray * EmptyArray =[[NSMutableArray alloc]init];
    objarray =[objDBManagerSpellReport getSpellReportDetail:self.compitionCode :self.matchCode :self.Teamcode : self.inningsno];
   
    
    
    for(int i=0; i< objarray.count; i++)
    {
        SpellReportRecord * objRecord =[objarray objectAtIndex:i];
        NSString * objBowlerCode = objRecord.Bowlercode;
        //[EmptyArray addObject:objBowlerCode];
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Bowlercode =%@",objBowlerCode];
        
        NSArray * filtedPlayerArray =  [objarray filteredArrayUsingPredicate:resultPredicate];
        
        NSMutableArray * selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
        
        
        if(objSpellReport.count== 0)
        {
        
           [objSpellReport addObject:selectedPlayerFilterArray];
        }
        else
        {
//            for(NSObject * record in objSpellReport)
//                {
//                    
//                  if(record != objRecord.Bowlercode)
//                  {
//                    [objSpellReport addObject:selectedPlayerFilterArray];
//                  }
//                }
        }
        
    }
    
    
    
  
    
//    NSString * bowlerCode = 
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"playerName contains[c] %@",appStr];
//    
//    NSArray *filtedPlayerArray =  [slecteplayerlist filteredArrayUsingPredicate:resultPredicate];
//    
//    NSMutableArray * selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
//    
   
}
-(IBAction)didClickInns2:(id)sender
{
    [self setInningsBySelection:@"2"];
    self.inningsno=@"2";
    objSpellReport =[objDBManagerSpellReport getSpellReportDetail:self.compitionCode :self.matchCode :self.Teamcode : self.inningsno];
}

-(IBAction)didClickInn3:(id)sender
{
    [self setInningsBySelection:@"3"];
     self.inningsno=@"3";
    objSpellReport =[objDBManagerSpellReport getSpellReportDetail:self.compitionCode :self.matchCode :self.Teamcode : self.inningsno];

}
-(IBAction)didClickInns4:(id)sender
{
    [self setInningsBySelection:@"4"];
     self.inningsno=@"4";
    objSpellReport =[objDBManagerSpellReport getSpellReportDetail:self.compitionCode :self.matchCode :self.Teamcode : self.inningsno];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [objSpellReport count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [objSpellReport [section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return  [objSpellReport [indexPath.section][indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 1 && indexPath.row == 0 && indexPath.row == 3)
    //    {
    return YES;
    //    }
    //
    //    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"DAY %d",indexPath.row+1];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font= [UIFont fontWithName:@"Rajdhani-Bold" size:20];
    
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
        cell.expandable = YES;
    else
        cell.expandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SpellReportCell";
    
    SpellReportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SpellReportCell" owner:self options:nil];
        cell = self.spellReport;
        
    }
    
    
    SpellReportRecord *objRecord = objSpellReport[indexPath.section][indexPath.row][indexPath.subRow];
    cell.Batsname_lbl.text = objRecord.BowlerName;
    cell.spell_lbl.text =objRecord.Spell;
    cell.inningsno_lbl.text      =objRecord.inningsno;
    cell.day_lbl.text        =objRecord.Dayno;
    cell.overs_lbl.text       =objRecord.Overs;
    cell.dotBall_lbl.text  =objRecord.DotBall;
    cell.ones_lbl.text  =objRecord.ones;
    cell.seconds_lbl.text = objRecord.Twos;
    cell.threes_lbl.text = objRecord.Threes;
    cell.fours_lbl.text = objRecord.Fours;
    cell.sixes_lbl.text = objRecord.Sixs;
    cell.boundary_lbl.text = objRecord.Boundaries;
    cell.boundaries_lbl.text = objRecord.Boundariesper;
    cell.SB_lbl.text = objRecord.SB;
    cell.Runs_lbl.text = objRecord.Runs;
    cell.RSS_lbl.text = objRecord.RPSS;
    cell.Wickets_lbl.text = objRecord.Wickets;
    cell.maidens_lbl.text = objRecord.Maidens;
    cell.Economy_lbl.text = objRecord.Economy;


     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

#pragma mark - Actions

- (void)collapseSubrows
{
    //[self.tableView collapseCurrentlyExpandedIndexPaths];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
