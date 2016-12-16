
//
//  MCMultiLineChartView.m
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCMultiLineChartView.h"
#import "MCChartInformationView.h"
#import "WormWicketRecord.h"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)

#define LINE_CHART_TOP_PADDING 30
#define LINE_CHART_LEFT_PADDING 40
#define LINE_CHART_RIGHT_PADDING 8
#define LINE_CHART_TEXT_HEIGHT 40

#define LINE_WIDTH_DEFAULT 2.0

#define DOT_PADDING_DEFAULT 60.0
#define DOT_BEGIN_POSTION 20.0

CGFloat static const kChartViewUndefinedCachedHeight = -1.0f;

@interface MCMultiLineChartView (){
    UIView * tooltip_view;
    
}

@property (nonatomic, strong) NSArray *chartDataSource;

@property (nonatomic, assign) NSUInteger lineCount;
@property (nonatomic, assign) CGFloat lineWith;
@property (nonatomic, assign) CGFloat dotPadding;

@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) CGFloat cachedMinHeight;
@property (nonatomic,strong) NSMutableArray *wicketDetails;

@end

@implementation MCMultiLineChartView {
    UIScrollView *_scrollView;
    
    CGFloat _chartHeight;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.bounds.size.width;
    _chartHeight = self.bounds.size.height - LINE_CHART_TOP_PADDING - LINE_CHART_TEXT_HEIGHT;
    _dotRadius = LINE_WIDTH_DEFAULT/2 * 3;
    
    _minValue = @0;
    
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _colorOfXAxis = _colorOfXText = [UIColor blackColor];
    _colorOfYAxis = _colorOfYText = [UIColor blackColor];
    _yFontSize = 14.0;
    _xFontSize = 14.0;
    
    _oppositeY = NO;
    
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(LINE_CHART_LEFT_PADDING, 0, width - 2 * LINE_CHART_TOP_PADDING, CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateWithContext:context];
}

#pragma mark - Draw Coordinate

- (void)drawCoordinateWithContext:(CGContextRef)context {
    CGFloat width = self.bounds.size.width;
    
    if (!_hideYAxis) {
        CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
        CGContextMoveToPoint(context, LINE_CHART_LEFT_PADDING - 1, LINE_CHART_TOP_PADDING - 1);
        CGContextAddLineToPoint(context, LINE_CHART_LEFT_PADDING - 1, LINE_CHART_TOP_PADDING + _chartHeight + 1);
        CGContextStrokePath(context);
    }
    
    
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, LINE_CHART_LEFT_PADDING - 1, LINE_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - LINE_CHART_RIGHT_PADDING + 1, LINE_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
}

#pragma mark - Height

- (CGFloat)normalizedHeightForRawHeight:(NSNumber *)rawHeight {
    CGFloat value = [rawHeight floatValue];
    CGFloat maxHeight = [self.maxValue floatValue];
    return value/maxHeight * _chartHeight;
}

- (id)maxValue {
    if (_maxValue == nil) {
        if ([self cachedMaxHeight] != kChartViewUndefinedCachedHeight) {
            _maxValue = @([self cachedMaxHeight]);
        }
    }
    return _maxValue;
}

- (CGFloat)cachedMinHeight {
    if(_cachedMinHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        _cachedMinHeight = 0;
        for (NSArray *array in chartValues) {
            for (NSNumber *number in array) {
                CGFloat height = [number floatValue];
                if (height < _cachedMinHeight) {
                    _cachedMinHeight = height;
                }
            }
        }
    }
    return _cachedMinHeight;
}

- (CGFloat)cachedMaxHeight {
    if (_cachedMaxHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        _cachedMaxHeight = 0;
        for (NSArray *array in chartValues) {
            for (NSNumber *number in array) {
                CGFloat height = [number floatValue];
                if (height > _cachedMaxHeight) {
                    _cachedMaxHeight = height;
                }
            }
        }
    }
    return _cachedMaxHeight;
}

#pragma mark - Reload Data
- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self reloadChartDataSource];
    _hideYAxis ?: [self reloadChartYAxis];
    [self reloadLineWithAnimate:animate];
}

- (void)reloadChartDataSource {
    _wicketDetails = [[NSMutableArray alloc]init];
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    
    _lineCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfLinesInLineChartView:)]) {
        _lineCount = [self.dataSource numberOfLinesInLineChartView:self];
    }
    
    NSAssert([self.dataSource respondsToSelector:@selector(lineChartView:lineCountAtLineNumber:)], @"MCMultiLineChartView // delegate must implement lineChartView:lineCountAtLineNumber:");
    
    _dotPadding = DOT_PADDING_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(dotPaddingInLineChartView:)]) {
        _dotPadding = [self.delegate dotPaddingInLineChartView:self];
    }
    
    NSAssert(([self.dataSource respondsToSelector:@selector(lineChartView:valueAtLineNumber:index:)]), @"MCMultiLineChartView // delegate must implement - (CGFloat)lineChartView:(MCMultiLineChartView *)lineChartView valueAtLineNumber:(NSUInteger)lineNumber index:(NSUInteger)index");
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:_lineCount];
    CGFloat maxContentWith = 0.0;
    CGFloat contentWidth = 0.0;
    for (NSUInteger i = 0; i < _lineCount; i ++) {
        NSUInteger lineCount = [self.dataSource lineChartView:self lineCountAtLineNumber:i];
        
        contentWidth = lineCount * _dotPadding;
        maxContentWith = MAX(maxContentWith, contentWidth);
        
        NSMutableArray *barArray = [NSMutableArray arrayWithCapacity:lineCount];
        for (NSInteger j = 0; j < lineCount; j ++) {
            id value = [self.dataSource lineChartView:self valueAtLineNumber:i index:j];
            [barArray addObject:value];
        }
        [dataArray addObject:barArray];
    }
    _scrollView.contentSize = CGSizeMake(maxContentWith, 0);
    _chartDataSource = [[NSMutableArray alloc] initWithArray:dataArray];
}

- (void)reloadChartYAxis {
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    UILabel *Run_lbl = [[UILabel alloc] initWithFrame:CGRectMake(-30, 130,50, 15)];
    Run_lbl.textColor = _colorOfYText;
    Run_lbl.textAlignment = NSTextAlignmentRight;
    Run_lbl.font = [UIFont systemFontOfSize:14];
    Run_lbl.numberOfLines = 0;
    Run_lbl.text = [NSString stringWithFormat:@"RUN"];
    [Run_lbl setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    [self addSubview:Run_lbl];
    
    CGFloat chartYOffset = _oppositeY ? LINE_CHART_TOP_PADDING : _chartHeight + LINE_CHART_TOP_PADDING;
    CGFloat unitHeight = _chartHeight/_numberOfYAxis;
    CGFloat unitValue = ([self.maxValue floatValue] - [_minValue floatValue])/_numberOfYAxis;
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chartYOffset - 10, LINE_CHART_LEFT_PADDING - 2, 20)];
        textLabel.textColor = _colorOfYText;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:_yFontSize];
        textLabel.numberOfLines = 0;
        textLabel.text = [NSString stringWithFormat:@"%.0f%@", unitValue * i + [_minValue floatValue], _unitOfYAxis];
        [self addSubview:textLabel];
        
        chartYOffset += _oppositeY ? unitHeight : -unitHeight;
    }
}

- (void)reloadLineWithAnimate:(BOOL)animate {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (NSInteger lineNumber = 0; lineNumber < _lineCount; lineNumber ++) {
        NSArray *array = _chartDataSource[lineNumber];
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
        CAShapeLayer *pointLayer = [[CAShapeLayer alloc] init];
        if ([self.delegate respondsToSelector:@selector(lineChartView:lineColorWithLineNumber:)]) {
            CGColorRef color = [self.delegate lineChartView:self lineColorWithLineNumber:lineNumber].CGColor;
            lineLayer.strokeColor = color;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            pointLayer.strokeColor = color;
            pointLayer.fillColor = [UIColor whiteColor].CGColor;
        } else {
            CGColorRef color = [UIColor redColor].CGColor;
            lineLayer.strokeColor = color;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            pointLayer.strokeColor = color;
            pointLayer.fillColor = [UIColor whiteColor].CGColor;
        }
        if ([self.delegate respondsToSelector:@selector(lineChartView:lineWidthWithLineNumber:)]) {
            lineLayer.lineWidth = [self.delegate lineChartView:self lineWidthWithLineNumber:lineNumber];
            pointLayer.lineWidth = [self.delegate lineChartView:self lineWidthWithLineNumber:lineNumber];
        } else {
            lineLayer.lineWidth = LINE_WIDTH_DEFAULT;
            pointLayer.lineWidth = LINE_WIDTH_DEFAULT;
        }
        
        
        
        CGFloat xOffset = _dotPadding/2;
        CGFloat chartYOffset = _oppositeY ? LINE_CHART_TOP_PADDING : _chartHeight + LINE_CHART_TOP_PADDING;
        UIBezierPath *lineBezierPath = [UIBezierPath bezierPath];
        //UIBezierPath *pointBezierPath = [UIBezierPath bezierPath];
        for (NSInteger index = 0; index < array.count; index ++) {
            
            if(lineNumber!=0){

                int xIndexValue = [self.dataSource getStartIndex :self titleAtLineNumber  :index:lineNumber];
                xOffset = (_dotPadding*xIndexValue)-(_dotPadding/2);
                
            }
            
            CGFloat normalizedHeight = [self normalizedHeightForRawHeight:array[index]];
            CGFloat yOffset = chartYOffset + (_oppositeY ? normalizedHeight : -normalizedHeight);
            if ([self.delegate respondsToSelector:@selector(lineChartView:pointViewOfDotInLineNumber:index:)]) {
                UIView *view = [self.delegate lineChartView:self pointViewOfDotInLineNumber:lineNumber index:index];
                if (view) {
                    view.center = CGPointMake(xOffset, yOffset);
                    [_scrollView addSubview:view];
                } else {
                    // [pointBezierPath moveToPoint:CGPointMake(xOffset + _dotRadius, yOffset)];
                    // [pointBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
                }
            } else {
                // [pointBezierPath moveToPoint:CGPointMake(xOffset + _dotRadius, yOffset)];
                // [pointBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            }
            
            if (index == 0) {
                [lineBezierPath addLineToPoint:CGPointMake(xOffset, yOffset)];
                // [lineBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:-M_PI endAngle:M_PI clockwise:YES];
                [lineBezierPath moveToPoint:CGPointMake(xOffset, yOffset)];
                
            } else {
                CGPoint currentPoint = lineBezierPath.currentPoint;
                CGFloat distance = sqrt((xOffset - currentPoint.x) * (xOffset - currentPoint.x) + (yOffset - currentPoint.y) * (yOffset - currentPoint.y));
                // CGFloat xDistance = (xOffset - currentPoint.x) * _dotRadius/distance;
                // CGFloat yDistance = (yOffset - currentPoint.y) * _dotRadius/distance;
                CGPoint fromPoint = CGPointMake(currentPoint.x , currentPoint.y );
                CGPoint toPoint = CGPointMake(xOffset , yOffset );
                
                
                [lineBezierPath moveToPoint:fromPoint];
                [lineBezierPath addLineToPoint:toPoint];
                
                [lineBezierPath moveToPoint:CGPointMake(xOffset, yOffset)];
                //  [lineBezierPath addLineToPoint:CGPointMake(xOffset, yOffset)];
                
                //[lineBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:-M_PI endAngle:M_PI clockwise:YES];
                [lineBezierPath moveToPoint:CGPointMake(xOffset, yOffset)];
            }
            
            //NSTimeInterval delay = animate ? (array.count + 1) * 0.4 : 0.0;
            NSTimeInterval delay = 0.0;
            if ([self.delegate respondsToSelector:@selector(lineChartView:hintViewOfDotInLineNumber:index:)]) {
                UIView *hintView = [self.delegate lineChartView:self hintViewOfDotInLineNumber:lineNumber index:index];
                if (hintView) {
                    hintView.center = CGPointMake(xOffset, yOffset - CGRectGetHeight(hintView.bounds)/2 - _dotRadius);
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        hintView.alpha = 1.0;
                    } completion:nil];
                }
            } else if ([self.delegate respondsToSelector:@selector(lineChartView:informationOfDotInLineNumber:index:)]) {
                NSString *information = [self.delegate lineChartView:self informationOfDotInLineNumber:lineNumber index:index];
                if (information) {
                    MCChartInformationView *informationView = [[MCChartInformationView alloc] initWithText:information];
                    informationView.center = CGPointMake(xOffset, yOffset - CGRectGetHeight(informationView.bounds)/2 - _dotRadius);
                    informationView.alpha = 0.0;
                    [_scrollView addSubview:informationView];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            }
            
            
            if ([self.delegate respondsToSelector:@selector(lineChartView:titleAtLineNumber:::)]) {
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset - _dotPadding/2 + 4, _chartHeight + LINE_CHART_TOP_PADDING, _dotPadding - 8, LINE_CHART_TEXT_HEIGHT)];
                textLabel.textColor = _colorOfXText;
                textLabel.numberOfLines = 0;
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.font = [UIFont systemFontOfSize:_xFontSize];
                textLabel.numberOfLines = 0;
                textLabel.text = [self.dataSource lineChartView :self titleAtLineNumber :index :lineNumber :0];
                
                if(lineNumber == 0){
                [_scrollView addSubview:textLabel];
                }
                
                
                
                PlayerWormChartRecords * wicket =[self.delegate lineChartView :self informationOfWicketInSection:lineNumber index:index];
                
                if(![wicket.WICKETNO isEqual:@"0"]){
                    
                    
                            UIButton * wicket_Btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
                            CGColorRef color = [self.delegate lineChartView:self lineColorWithLineNumber:lineNumber].CGColor;
                            
                            wicket_Btn.tag = _wicketDetails.count;
                    wicket_Btn.center = CGPointMake(xOffset, isnan( yOffset)?0:yOffset);
                            //[wicket_Btn setImage:[UIImage imageNamed:@"ballImg"] forState:UIControlStateNormal];
                            wicket_Btn.layer.cornerRadius = 12;
                            wicket_Btn.layer.borderColor=color;
                            wicket_Btn.layer.backgroundColor=color;
                            
                    
                            //[wicket_Btn setTitle:objManhattanRecord.wicketno forState:UIControlStateNormal];
                            wicket_Btn.alpha = 0.0;
                            [_scrollView addSubview:wicket_Btn];
                            [wicket_Btn addTarget:self action:@selector(tooltipMethod:) forControlEvents:UIControlEventTouchUpInside];
                            
                            UILabel * wicketno_lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,25,25)];
                            wicketno_lbl.text = wicket.WICKETNO;
                            wicketno_lbl.textColor = [UIColor whiteColor];
                            [wicket_Btn addSubview:wicketno_lbl];
                            wicketno_lbl.textAlignment=UITextAlignmentCenter;
                            
                            [_wicketDetails addObject:wicket];
                            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                wicket_Btn.alpha = 1.0;
                            } completion:nil];
                        
                    
                }
                
                
//                CGFloat position = 0;
//                for (int i=0; wicket.count > i; i++) {
//                    
//                    WormWicketRecord * record =(WormWicketRecord *)[wicket objectAtIndex:i];
//                    
//                    if([textLabel.text isEqualToString:record.wicketOver])
//                    {
//                        if(![record.wicketNo isEqualToString:@"0"] && record.wicketNo!= nil)
//                        {
//                            UIButton * wicket_Btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//                            CGColorRef color = [self.delegate lineChartView:self lineColorWithLineNumber:lineNumber].CGColor;
//                            
//                            wicket_Btn.tag = [record.tag intValue];
//                            wicket_Btn.center = CGPointMake(xOffset+position, yOffset);
//                            //[wicket_Btn setImage:[UIImage imageNamed:@"ballImg"] forState:UIControlStateNormal];
//                            wicket_Btn.layer.cornerRadius = 12;
//                            wicket_Btn.layer.borderColor=color;
//                            wicket_Btn.layer.backgroundColor=color;
//                            
//                            
//                            //[wicket_Btn setTitle:objManhattanRecord.wicketno forState:UIControlStateNormal];
//                            wicket_Btn.alpha = 0.0;
//                            [_scrollView addSubview:wicket_Btn];
//                            [wicket_Btn addTarget:self action:@selector(tooltipMethod:) forControlEvents:UIControlEventTouchUpInside];
//                            
//                            UILabel * wicketno_lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,25,25)];
//                            wicketno_lbl.text = record.wicketNo;
//                            wicketno_lbl.textColor = [UIColor whiteColor];
//                            [wicket_Btn addSubview:wicketno_lbl];
//                            wicketno_lbl.textAlignment=UITextAlignmentCenter;
//                            
//                            
//                            position = position +25;
//                            
//                            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                                wicket_Btn.alpha = 1.0;
//                            } completion:nil];
//                        }
//                    }
//                }
                
                
            }
            
            xOffset += _dotPadding;
        }
        lineLayer.path = lineBezierPath.CGPath;
        // pointLayer.path = pointBezierPath.CGPath;
        //   pointLayer.fillColor = _solidDot ? lineLayer.strokeColor : [UIColor clearColor].CGColor;
        [_scrollView.layer insertSublayer:lineLayer atIndex:(unsigned)lineNumber];
        [_scrollView.layer insertSublayer:pointLayer above:lineLayer];
        
        if (animate) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(0.0);
            animation.toValue = @(1.0);
            animation.repeatCount = 1.0;
            //animation.duration = array.count * 0.4;
            animation.duration = 1.0;
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self;
            [lineLayer addAnimation:animation forKey:@"animation"];
        }
    }
    
    UILabel *over_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 300,50, 15)];
    over_lbl.textColor = [UIColor whiteColor];
    over_lbl.textAlignment = NSTextAlignmentRight;
    over_lbl.font = [UIFont systemFontOfSize:14];
    over_lbl.numberOfLines = 0;
    over_lbl.text = [NSString stringWithFormat:@"BALLS"];
    
    
    [self addSubview:over_lbl];
}




-(void) tooltipMethod :(UIButton *)selectwicket
{
    
    if(tooltip_view !=nil)
    {
        [tooltip_view removeFromSuperview];
    }
    
    
    tooltip_view =[[UIView alloc]initWithFrame:CGRectMake((selectwicket.frame.origin.x+140)>_scrollView.frame.size.width?selectwicket.frame.origin.x-200:selectwicket.frame.origin.x+30,selectwicket.frame.origin.y> ((_scrollView.frame.size.height/2)-80)?((_scrollView.frame.size.height/2)-80):selectwicket.frame.origin.y, 200, 160)];
    
    [tooltip_view setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:tooltip_view];
    
    tooltip_view.layer.borderColor = [UIColor whiteColor].CGColor;
    tooltip_view.layer.borderWidth = 2.0f;
    
    UILabel * objwicketText =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, tooltip_view.frame.size.width,tooltip_view.frame.size.height)];
    objwicketText.numberOfLines=10;
    objwicketText.textColor =[UIColor whiteColor];
    
    PlayerWormChartRecords *wicketdetail = [_wicketDetails objectAtIndex:selectwicket.tag];
    
    NSString *result = [NSString stringWithFormat:@" Batsman : %@ \n Bowler : %@ \n Over : %@ \n Wicket No : %@ \n Wicket Type : %@ ",wicketdetail.STRIKERNAME,wicketdetail.BOWLERNAME,wicketdetail.OVERBYOVER,wicketdetail.WICKETNO, wicketdetail.WICKERDESCRIPTION];

    
    
    objwicketText.text = result;
    
    [tooltip_view addSubview:objwicketText];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(hidepopview)
                                   userInfo:nil
                                    repeats:NO];
}


-(void)hidepopview
{
    if(tooltip_view !=nil)
    {
        [tooltip_view removeFromSuperview];
    }
}

@end
