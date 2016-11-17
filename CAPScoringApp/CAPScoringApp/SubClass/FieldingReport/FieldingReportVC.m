//
//  FieldingReportVC.m
//  CAPScoringApp
//
//  Created by APPLE on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FieldingReportVC.h"
#import "DBManagerFieldReport.h"
#import "FFactorRecord.h"
#import "FFactoredRecord.h"
#import "FFactorDetailRecord.h"

@interface FieldingReportVC ()
{
    DBManagerFieldReport * objDBManagerFieldReport;
    FFactorRecord * objFFactorRecord;
    FFactoredRecord * objFFactoredRecord;
    FFactorDetailRecord * objFFactorDetailRecord;
    NSMutableArray * FieldreportDetail;
    NSMutableArray * fielderArray;
    BOOL isStriker;

}
@property (nonatomic,strong) NSString * selectStrikerCode;

@end

@implementation FieldingReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    objDBManagerFieldReport =[[DBManagerFieldReport alloc]init];
    objFFactorRecord     = [[FFactorRecord alloc]init];
    objFFactoredRecord = [[FFactoredRecord alloc]init];
    objFFactorDetailRecord =[[FFactorDetailRecord alloc]init];
    fielderArray   =[[NSMutableArray alloc]init];
    
     self.filter_view.hidden =YES;
    NSMutableArray * fieldingFactorcode =[objDBManagerFieldReport GETFIELDINGFACTORCODE];
    
    objFFactorRecord = [fieldingFactorcode objectAtIndex:0];
    
    fielderArray =[objDBManagerFieldReport GETFIELDERCODE:self.compitionCode :self.matchCode :self.Teamcode :@"1"];
    
    objFFactoredRecord =[fielderArray objectAtIndex:0];
    
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :self.Teamcode :@"1" : objFFactorRecord.FFactorCode : objFFactoredRecord.FFatoredCode];
    
    [self.striker_view .layer setBorderWidth:2.0];
    [self.striker_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.striker_view .layer setMasksToBounds:YES];
}

-(IBAction)didClickInns1:(id)sender
{
    [self setInningsBySelection:@"1"];
    
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :self.Teamcode :@"1" : objFFactorRecord.FFactorCode : objFFactoredRecord.FFatoredCode];
    //[self.PShip_tbl reloadData];
}

-(IBAction)didClickInns2:(id)sender
{
    [self setInningsBySelection:@"2"];
    
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :self.Teamcode :@"2" : objFFactorRecord.FFactorCode : objFFactoredRecord.FFatoredCode];
    //[self.PShip_tbl reloadData];
}

-(IBAction)didClickInn3:(id)sender
{
    [self setInningsBySelection:@"3"];
    
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :self.Teamcode :@"3" : objFFactorRecord.FFactorCode : objFFactoredRecord.FFatoredCode];
    //[self.PShip_tbl reloadData];
}
-(IBAction)didClickInns4:(id)sender
{
    [self setInningsBySelection:@"4"];
    
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :self.Teamcode :@"4" : objFFactorRecord.FFactorCode : objFFactoredRecord.FFatoredCode];
    //[self.PShip_tbl reloadData];
}

-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.innings1_Btn];
    [self setInningsButtonUnselect:self.innings2_Btn];
    [self setInningsButtonUnselect:self.innings3_Btn];
    [self setInningsButtonUnselect:self.innings4_Btn];
    
    [self.innings1_Btn setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.fstInnShortName] forState:UIControlStateNormal];
    [self.innings2_Btn setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.secInnShortName] forState:UIControlStateNormal];
    [self.innings3_Btn setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.thrdInnShortName] forState:UIControlStateNormal];
    [self.innings4_Btn setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.frthInnShortName] forState:UIControlStateNormal];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.innings1_Btn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.innings2_Btn];
        
    }else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.innings3_Btn];
        
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.innings4_Btn];
        
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

-(IBAction)didclickStrikerSelection:(id)sender
{
    //self.strikerTblYposition.constant =self.striker_view.frame.origin.y-55;
    fielderArray=[[NSMutableArray alloc]init];
    fielderArray =[objDBManagerFieldReport GETFIELDERCODE:self.compitionCode :self.matchCode :self.Teamcode :@"1"];
    if(isStriker==NO)
    {
        
        self.striker_Tbl.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.striker_Tbl.hidden=YES;
        isStriker=NO;
    }
    
    [self.striker_Tbl reloadData];
    
}

- (IBAction)hide_Filer_view:(id)sender {
    
    self.filter_view.hidden =NO;
    self.hide_btn_view.hidden = YES;
    
    
}
- (IBAction)btn_hide_view:(id)sender {
    
    self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
    
}

- (IBAction)btn_done:(id)sender {
    
        self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
        return fielderArray.count;
    
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
        objFFactoredRecord =[fielderArray objectAtIndex:indexPath.row];
    cell.textLabel.text = objFFactoredRecord.PlayerName;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
       objFFactoredRecord =[fielderArray objectAtIndex:indexPath.row];
        self.selectStrikerCode =objFFactoredRecord.FFatoredCode;
        self.striker_Lbl.text =objFFactoredRecord.PlayerName;
        
        self.striker_Tbl.hidden=YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
