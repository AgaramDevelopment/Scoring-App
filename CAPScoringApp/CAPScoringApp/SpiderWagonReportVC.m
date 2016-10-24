//
//  SpiderWagonReportVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 22/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SpiderWagonReportVC.h"
#import "DBManagerSpiderWagonReport.h"
#import "SpiderWagonRecords.h"
#import "Utitliy.h"

@interface SpiderWagonReportVC ()
{
    DBManagerSpiderWagonReport *objDBManagerSpiderWagonReport;
    
}

@property (nonatomic,strong) NSMutableArray *spiderWagonArray;

@end

@implementation SpiderWagonReportVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.filter_view.hidden =YES;
    
    objDBManagerSpiderWagonReport = [[DBManagerSpiderWagonReport alloc]init];
    
   // _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon];
    
 _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon:self.matchTypeCode :self.compititionCode :self.matchCode :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@""];
    
    
//     _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon:self.matchTypeCode :self.compititionCode :self.matchCode :@"" :INNINGSNO :STRIKERCODE :NONSTRIKERCODE :BOWLERCODE :RUNS :ISFOUR :ISSIX];

    [self drawSpiderWagonLine];
    
    
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
        
        
        if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
            
            int Xposition = x1position+140;
            int Yposition = y1position+130;
            
            CGMutablePathRef straightLinePath = CGPathCreateMutable();
            CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
            CGPathAddLineToPoint(straightLinePath, NULL,x2position+140,y2position+130);
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
            
        }
        
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
    
}

- (IBAction)btn_sec_inns:(id)sender {
    
}

- (IBAction)btn_third_inns:(id)sender {
    
}

- (IBAction)btn_fourth_inns:(id)sender {
    
}

- (IBAction)hide_Filer_view:(id)sender {
    
     self.filter_view.hidden =NO;
}
@end
