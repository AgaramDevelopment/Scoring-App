//
//  WormReportVC.m
//  CAPScoringApp
//
//  Created by Mac on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "WormReportVC.h"
#import "MCLineChartView.h"
#import "DBManagerReports.h"

@interface WormReportVC ()  <MCLineChartViewDataSource, MCLineChartViewDelegate>
@property (strong, nonatomic) MCLineChartView *lineChartView;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *wormDataArray;
@end


@implementation WormReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wormDataArray =
    
    _titles = @[@"A", @"B", @"C", @"D", @"E"];
    _dataSource = @[@100, @245, @180, @165, @225];
    
    _lineChartView = [[MCLineChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    _lineChartView.dotRadius = 5;
    _lineChartView.dataSource = self;
    _lineChartView.delegate = self;
    _lineChartView.minValue = @1;
    _lineChartView.maxValue = @300;
    _lineChartView.solidDot = YES;
    _lineChartView.numberOfYAxis = 7;
    _lineChartView.colorOfXAxis = [UIColor whiteColor];
    _lineChartView.colorOfXText = [UIColor whiteColor];
    _lineChartView.colorOfYAxis = [UIColor whiteColor];
    _lineChartView.colorOfYText = [UIColor whiteColor];
    [self.view addSubview:_lineChartView];
    
    [_lineChartView reloadDataWithAnimate:YES];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    return [_dataSource count];
}

- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    return _dataSource[index];
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
    return _titles[number];
}

- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    return [UIColor redColor];

}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    //if (index == 0 || index == _dataSource.count - 1) {
      //  return [NSString stringWithFormat:@"%@", _dataSource[index]];
    //}
    return nil;
}


@end
