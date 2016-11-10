//
//  PartnershipVC.m
//  CAPScoringApp
//
//  Created by APPLE on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PartnershipVC.h"
#import "DBManagerPartnership.h"
#import "PartnershipRecord.h"
#import "PartnershipCell.h"

@interface PartnershipVC ()

@property (nonatomic,strong) NSMutableArray * objpartnershipdetail;

@property (nonatomic,strong) DBManagerPartnership * objDBManagerPartnership;

@property (nonatomic,strong) IBOutlet PartnershipCell * PShipCell;


@end

@implementation PartnershipVC
@synthesize matchcode,matchtypecode,compitioncode,objpartnershipdetail,objDBManagerPartnership;
- (void)viewDidLoad {
    [super viewDidLoad];
    objDBManagerPartnership=[[DBManagerPartnership alloc]init];
    objpartnershipdetail =[[NSMutableArray alloc]init];
    [self setInningsBySelection:@"1"];

  objpartnershipdetail =[objDBManagerPartnership getPartnershipdetail:self.compitioncode :self.matchcode :@"" :@"1"];
}

-(IBAction)didClickInnigs1:(id)sender
{
    [self setInningsBySelection:@"1"];

    objpartnershipdetail =[objDBManagerPartnership getPartnershipdetail:self.compitioncode :self.matchcode :@"" :@"1"];
    [self.PShip_tbl reloadData];
}
-(IBAction)didClickInnings2:(id)sender
{
    [self setInningsBySelection:@"2"];

    objpartnershipdetail =[objDBManagerPartnership getPartnershipdetail:self.compitioncode :self.matchcode :@"" :@"2"];
    [self.PShip_tbl reloadData];
}
-(IBAction)didClickInnings3:(id)sender
{
    [self setInningsBySelection:@"3"];

    objpartnershipdetail =[objDBManagerPartnership getPartnershipdetail:self.compitioncode :self.matchcode :@"" :@"3"];
    [self.PShip_tbl reloadData];
}
-(IBAction)didClickInnings4:(id)sender
{
    [self setInningsBySelection:@"4"];

    objpartnershipdetail =[objDBManagerPartnership getPartnershipdetail:self.compitioncode :self.matchcode :@"" :@"4"];
    [self.PShip_tbl reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return objpartnershipdetail.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *MyIdentifier2 = @"PartnershipCell";
        
        PartnershipCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier2];
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"PartnershipCell" owner:self options:nil];
            cell = self.PShipCell;
        }
      PartnershipRecord * objRecord =(PartnershipRecord*)[objpartnershipdetail objectAtIndex:indexPath.row];
        
      cell.strikerName_lbl.text =objRecord.STRIKER1;
    
      cell.nonstrikerName_lbl.text =objRecord.NONSTRIKER1;
    
    cell.comparestriker_lbl.text =[NSString stringWithFormat:@"%@(%@) %@(%@)",objRecord.PLAYER1,objRecord.PLAYER1BALLS,objRecord.PLAYER2,objRecord.PLAYER2BALLS];
    
    
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
