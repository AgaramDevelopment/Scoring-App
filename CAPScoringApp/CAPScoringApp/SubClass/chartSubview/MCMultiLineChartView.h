

//
//  MCMultiLineChartView.h
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCMultiLineChartView;
@protocol MCMultiLineChartViewDataSource <NSObject>

@required
- (NSUInteger)lineChartView:(MCMultiLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number;
- (id)lineChartView:(MCMultiLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

@optional
- (NSUInteger)numberOfLinesInLineChartView:(MCMultiLineChartView *)lineChartView;
- (NSString *)lineChartView:(MCMultiLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number :(NSInteger)linenumber :(NSInteger)dummy;
- (int)getStartIndex:(MCMultiLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number :(NSInteger)linenumber;

@end

@protocol MCMultiLineChartViewDelegate <NSObject>

@optional
-(void) TooltipMethod :(UIButton *)selectwicket;


- (NSString *)getWicketDetails:(UIButton *)selectwicket;

- (UIColor *)lineChartView:(MCMultiLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber;
- (CGFloat)lineChartView:(MCMultiLineChartView *)lineChartView lineWidthWithLineNumber:(NSInteger)lineNumber;

- (CGFloat)dotPaddingInLineChartView:(MCMultiLineChartView *)lineChartView;

- (NSString *)lineChartView:(MCMultiLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;
- (UIView *)lineChartView:(MCMultiLineChartView *)lineChartView hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;
- (UIView *)lineChartView:(MCMultiLineChartView *)lineChartView pointViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;
- (NSMutableArray *)lineChartView:(MCMultiLineChartView *)lineChartView informationOfWicketInSection:(NSInteger)section;
- (UIView *)lineChartView:(MCMultiLineChartView *)lineChartView hintViewOfLineInSection:(NSInteger)section index:(NSInteger)index;

@end

CGFloat static const kChartViewUndefinedValue = -1.0f;

@interface MCMultiLineChartView : UIView

@property (nonatomic, weak) id<MCMultiLineChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCMultiLineChartViewDelegate> delegate;

/// 最小值，默认为0
@property (nonatomic, strong) id minValue;
/// 最大值，如果未设置计算数据源中的最大值
@property (nonatomic, strong) id maxValue;
/// y轴数据标记个数
@property (nonatomic, assign) NSInteger numberOfYAxis;
/// y轴数据单位
@property (nonatomic, copy) NSString *unitOfYAxis;
/// y轴的颜色
@property (nonatomic, strong) UIColor *colorOfYAxis;
/// y轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfYText;
/// y轴文字大小
@property (nonatomic, assign) CGFloat yFontSize;

/// y轴数据反向排列
@property (nonatomic, assign) BOOL oppositeY;
/// 隐藏y轴
@property (nonatomic, assign) BOOL hideYAxis;

/// x轴的颜色
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfXText;
/// x轴文本文字大小
@property (nonatomic, assign) CGFloat xFontSize;

/// 是否为实心点
@property (nonatomic, assign) BOOL solidDot;
/// 点的半径大小
@property (nonatomic, assign) CGFloat dotRadius;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
