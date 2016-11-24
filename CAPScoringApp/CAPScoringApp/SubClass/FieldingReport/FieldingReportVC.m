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
    NSInteger selectIndex;
    NSString * FFactorCode;
    UILabel * firs_lbl;
    UILabel * second_lbl ;
    UILabel * third_lbl;
    UILabel * RunSaved_lbl;
    int lbl_colorindex;

}
@property (nonatomic,strong) NSString * selectStrikerCode;
@property (nonatomic,strong) NSString * inningsno;
@end

@implementation FieldingReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objDBManagerFieldReport =[[DBManagerFieldReport alloc]init];
    objFFactorRecord     = [[FFactorRecord alloc]init];
    objFFactoredRecord = [[FFactoredRecord alloc]init];
    objFFactorDetailRecord =[[FFactorDetailRecord alloc]init];
    
    [self setInningsView];
    self.filter_view.hidden =YES;
    self.striker_Tbl.hidden =YES;
    NSMutableArray * fieldingFactorcode =[objDBManagerFieldReport GETFIELDINGFACTORCODE];
    
    objFFactorRecord = [fieldingFactorcode objectAtIndex:0];
    
//    fielderArray =[objDBManagerFieldReport GETFIELDERCODE:self.compitionCode :self.matchCode :self.Teamcode :@"1"];
//    
//    objFFactoredRecord =[fielderArray objectAtIndex:0];
//    
//    self.selectStrikerCode = objFFactoredRecord.FFatoredCode;
//    
//    self.FielderName_lbl.text = objFFactoredRecord.PlayerName;
    //FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :self.Teamcode :@"1" : objFFactorRecord.FFactorCode : objFFactoredRecord.FFatoredCode];
    [self.innings1_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.striker_view .layer setBorderWidth:2.0];
    [self.striker_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.striker_view .layer setMasksToBounds:YES];
    lbl_colorindex=3;
}

-(IBAction)didClickInns1:(id)sender
{
    [self setInningsBySelection:@"1"];
    
    self.inningsno =@"1";
   [self FielderDetailsMethod];
    [self.striker_Tbl reloadData];
}

-(IBAction)didClickInns2:(id)sender
{
    [self setInningsBySelection:@"2"];
    
    self.inningsno =@"2";
    
    [self FielderDetailsMethod];
    [self.striker_Tbl reloadData];
}

-(IBAction)didClickInn3:(id)sender
{
    [self setInningsBySelection:@"3"];
    
    self.inningsno =@"3";
    
   [self FielderDetailsMethod];
    [self.striker_Tbl reloadData];
}
-(IBAction)didClickInns4:(id)sender
{
    [self setInningsBySelection:@"4"];
    
    self.inningsno =@"4";
    [self FielderDetailsMethod];
    [self.striker_Tbl reloadData];
  
}

-(void)FielderDetailsMethod
{
    fielderArray   =[[NSMutableArray alloc]init];
    
    fielderArray =[objDBManagerFieldReport  GETFIELDERCODE:self.compitionCode :self.matchCode :@"" :self.inningsno];
    //fielderArray =[objDBManagerFieldReport GETFIELDERCODE:self.compitionCode :self.matchCode :self.Teamcode :self.inningsno];
    
    if(fielderArray.count > 0)
    {
        objFFactoredRecord =[fielderArray objectAtIndex:0];
        
        self.selectStrikerCode = objFFactoredRecord.FFatoredCode;
        
        self.FielderName_lbl.text = objFFactoredRecord.PlayerName;
    }
    else
    {
        self.FielderName_lbl.text =@"";
    }
    
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :@"" :self.inningsno : self.selectStrikerCode];
    
    [self displayValuemethod];
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

-(void) setInningsView{
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){
        //T20
        
        self.innings1_Btn.hidden = NO;
        self.innings2_Btn.hidden = NO;
        self.innings3_Btn.hidden = YES;
        self.innings4_Btn.hidden = YES;
        
        self.inn1_btnWidth.constant =  384; //(self.view.frame.size.width/2);
        //self.inn1_btnYposition.constant = self.inn1_btnWidth.constant;
        self.inns2_btnWidth.constant =  384; //(self.view.frame.size.width/2);
        
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){//ODI
        self.innings1_Btn.hidden = NO;
        self.innings2_Btn.hidden = NO;
        self.innings3_Btn.hidden = YES;
        self.innings4_Btn.hidden = YES;
        self.inn1_btnWidth.constant =   384;   //self.view.frame.size.width/2;
        self.inns2_btnWidth.constant =  384;      //self.view.frame.size.width/2;
        
        
    }else if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){//Test
        
        self.innings1_Btn.hidden = NO;
        self.innings2_Btn.hidden = NO;
        self.innings3_Btn.hidden = NO;
        self.innings4_Btn.hidden = NO;
        
        self.inn1_btnWidth.constant  = 192;   //self.view.frame.size.width/2;
        self.inns2_btnWidth.constant = 192;      //self.view.frame.size.width/2;
        self.inns3_btnwidth.constant  = 192;   //self.view.frame.size.width/2;
        self.inns4_btnwidth.constant = 192;
        
    }
}


-(IBAction)didclickStrikerSelection:(id)sender
{
    //self.strikerTblYposition.constant =self.striker_view.frame.origin.y-55;
    fielderArray=[[NSMutableArray alloc]init];
    fielderArray =[objDBManagerFieldReport GETFIELDERCODE:self.compitionCode :self.matchCode :@"" :self.inningsno];
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
    self.striker_Lbl.text=self.FielderName_lbl.text;
    
    
}
- (IBAction)btn_hide_view:(id)sender {
    
    self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
    
}

- (IBAction)btn_done:(id)sender {
    
    self.filter_view.hidden=YES;
    self.hide_btn_view.hidden = NO;
    
    self.FielderName_lbl.text = self.striker_Lbl.text;
    FieldreportDetail =[objDBManagerFieldReport getFieldingdetails:self.compitionCode :self.matchCode :@"" :self.inningsno : self.selectStrikerCode];
    
    [self displayValuemethod];
}
-(void) displayValuemethod
{
    int runSaved = 0;
    if(self.detail_View != nil)
    {
        [self.detail_View removeFromSuperview];
    }
    CGFloat totalwidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat width = 200;           //totalwidth/3;
    self.detail_View = [[UIView alloc]initWithFrame:CGRectMake(35,120,[[UIScreen mainScreen] bounds].size.width-70, [[UIScreen mainScreen] bounds].size.height-560)];
    [self.detail_View setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.detail_View];
    
    for(int i=0; FieldreportDetail.count > i; i++)
    {
        
        FFactorDetailRecord * record= [FieldreportDetail objectAtIndex:i];
        runSaved =[record.Runssaved intValue]+runSaved;
        
        if(i ==0)
        {
            firs_lbl =[[UILabel alloc]initWithFrame:CGRectMake(25,15,width,50)];
            [firs_lbl setBackgroundColor:[UIColor colorWithRed:(255/255.0f) green:(88/255.0f) blue:(86/255.0f) alpha:1.0f]];
            firs_lbl.textColor =[UIColor whiteColor];
            firs_lbl.text = [NSString stringWithFormat:@" RUN COST : %@",record.Runscost];
            firs_lbl.textAlignment = NSTextAlignmentCenter;
            [self.detail_View addSubview:firs_lbl];
            
            RunSaved_lbl =[[UILabel alloc]initWithFrame:CGRectMake(width+50,15,width,50)];
            [RunSaved_lbl setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(156/255.0f) blue:(121/255.0f) alpha:1.0f]];
//            RunSaved_lbl.text = [NSString stringWithFormat:@"RUN SAVED : %@",record.Runssaved];
            RunSaved_lbl.textAlignment = NSTextAlignmentCenter;
            RunSaved_lbl.textColor =[UIColor whiteColor];
            [self.detail_View addSubview:RunSaved_lbl];
            
            third_lbl =[[UILabel alloc]initWithFrame:CGRectMake(2*width+75,15,width,50)];
            third_lbl.text =[NSString stringWithFormat:@" %@ : %@",record.Fieldingfactor,record.Ballsfielded];
            third_lbl.textColor =[UIColor whiteColor];
            third_lbl.textAlignment = NSTextAlignmentCenter;
            [third_lbl setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(115/255.0f) blue:(201/255.0f) alpha:1.0f]];
            [self.detail_View addSubview:third_lbl];
        }
        else
        {
            lbl_colorindex++;
            UIColor * indexColor =  [self TextIndexcolormethod:lbl_colorindex];
            CGFloat moduloResult = i % 3;
            if(moduloResult == 1)
            {
                
                 firs_lbl =[[UILabel alloc]initWithFrame:CGRectMake(25,firs_lbl.frame.origin.y+80,width,50)];
                [firs_lbl setBackgroundColor:indexColor];
                firs_lbl.text =[NSString stringWithFormat:@" %@ : %@",record.Fieldingfactor,record.Ballsfielded];
                
                firs_lbl.textColor =[UIColor whiteColor];
                firs_lbl.textAlignment = NSTextAlignmentCenter;

                [self.detail_View addSubview:firs_lbl];
            }
            else if (moduloResult == 2)
            {
                second_lbl =[[UILabel alloc]initWithFrame:CGRectMake(width+50,RunSaved_lbl.frame.origin.y+80,width,50)];
                [second_lbl setBackgroundColor:indexColor];
                second_lbl.text =[NSString stringWithFormat:@" %@ : %@",record.Fieldingfactor,record.Ballsfielded];
                second_lbl.textColor =[UIColor whiteColor];
                second_lbl.textAlignment = NSTextAlignmentCenter;

                [self.detail_View addSubview:second_lbl];
            }
            else
            {
                third_lbl =[[UILabel alloc]initWithFrame:CGRectMake(2*width+75,third_lbl.frame.origin.y+80,width,50)];
                third_lbl.text =[NSString stringWithFormat:@" %@ : %@",record.Fieldingfactor,record.Ballsfielded];
                third_lbl.textColor =[UIColor whiteColor];
               
                third_lbl.textAlignment = NSTextAlignmentCenter;
               [third_lbl setBackgroundColor:indexColor];
                [self.detail_View addSubview:third_lbl];
            }
        }
         RunSaved_lbl.text = [NSString stringWithFormat:@"RUN SAVED : %d",runSaved];
    }
}

-(UIColor *)TextIndexcolormethod:(int) index
{
    UIColor * Textcolor;
    CGFloat moduloResult = index % 4;
    
    if(moduloResult == 1)
    {
        Textcolor =[UIColor colorWithRed:(223/255.0f) green:(104/255.0f) blue:(51/255.0f) alpha:1.0f];
    }
    else if(moduloResult == 2)
    {
        Textcolor =[UIColor colorWithRed:(255/255.0f) green:(88/255.0f) blue:(86/255.0f) alpha:1.0f];
    }
    else if(moduloResult == 3)
    {
        Textcolor =[UIColor colorWithRed:(0/255.0f) green:(156/255.0f) blue:(121/255.0f) alpha:1.0f];
    }
    else
    {
        Textcolor =[UIColor colorWithRed:(0/255.0f) green:(115/255.0f) blue:(201/255.0f) alpha:1.0f];
    }
    return Textcolor;
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
    
       selectIndex = indexPath.row;

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
