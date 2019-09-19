
//
//  SGHistogramContentView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGHistogramContentView.h"
#import "SGChartRemarksView.h"

@interface SGHistogramContentView ()

@property (nonatomic,strong) SGShapeLayer *mainLayer;//承载路径
@property (nonatomic,strong) SGShapeLayer *selectLayer;//选中的layer层
@property (nonatomic,strong) SGChartRemarksView *remarksView;//详情提示

@end

@implementation SGHistogramContentView


- (SGChartRemarksView *)remarksView {
    
    if (!_remarksView) {
        _remarksView = [[SGChartRemarksView alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
        _remarksView.layer.masksToBounds = YES;
        _remarksView.layer.cornerRadius = 5;
        _remarksView.alpha = 0.6;
        _remarksView.backgroundColor = UIColor.blackColor;
    }
    return _remarksView;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    [self drawLayerPaths];
}

-(void)setDatas:(NSArray *)datas{
    
    if (_datas != datas) {
        _datas = datas;
    }
    [self drawLayerPaths];
}

//重新绘制
- (void)drawLayerPaths {
    //移除之前的layer
    [_mainLayer removeFromSuperlayer];
    _mainLayer = nil;
    
    CGFloat lineWidth = (_lineWidth + 0.0);
//    lineWidth = (_lineWidth + 0.0) / [UIScreen mainScreen].scale;
//    lineWidth = (_lineWidth*_pointGap) / [UIScreen mainScreen].scale;
    
    UIBezierPath *path = [self createPath];
    self.mainLayer = [self createLayer];
    
    WS(ws)
    [_datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SGHistogramModel *model = obj;
        CGPoint topPoint = CGPointMake((model.x+1.0)*ws.pointScale, model.y);
        CGPoint bottomPoint = CGPointMake((model.x+1.0)*ws.pointScale, SGMTDChartHeight);
        CGPoint topPoint2 = CGPointMake((model.x+1.0+lineWidth)*ws.pointScale, model.y);
        CGPoint bottomPoint2 = CGPointMake((model.x+1.0+lineWidth)*ws.pointScale, SGMTDChartHeight);
        
        if (lineWidth <= 1.0) {
            [path moveToPoint:topPoint];
            [path addLineToPoint:bottomPoint];
        }else{
            [path moveToPoint:topPoint];
            [path addLineToPoint:topPoint2];
            [path addLineToPoint:bottomPoint2];
            [path addLineToPoint:bottomPoint];
            [path addLineToPoint:topPoint];
        }
        
    }];
    
//    path.lineWidth = lineWidth;
    _mainLayer.path = path.CGPath;
    _mainLayer.strokeColor = kSGMTDBlueColor.CGColor;
    _mainLayer.fillColor = kSGMTDBlueColor.CGColor;
    [self.layer addSublayer:_mainLayer];
    
    [path closePath];
    [path removeAllPoints];
    
}
 
#pragma mark 长按处理

//是否显示 备注视图
- (void)showRemarks:(BOOL)show {
    
    if (show) {
        
        [self addSubview:self.remarksView];
        
    }else{
        
        if (_remarksView) {
            
            [_remarksView removeFromSuperview];
            _remarksView = nil;
        }
    }
}

//手势的处理
- (void)handleGestureByPoint:(CGPoint)point showPoint:(CGPoint)showPoint{
    
    WS(ws)
    [self dismissSelectLayer];
    //
    CGFloat lineUnit = (_lineWidth + _lineSpace);
    NSInteger index = point.x/(lineUnit*_pointScale);
    
    if (index < _datas.count) {
        SGHistogramModel *model = _datas[index];
        _remarksView.histogramModel = model;
        [self addSelectLayerBySGHistogramModel:model];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = ws.remarksView.frame;
        frame.origin = showPoint;
        ws.remarksView.frame = frame;
        
    }];
    
}

//创建选中的柱状图朦板
- (void)addSelectLayerBySGHistogramModel:(SGHistogramModel *)model {
    
    UIBezierPath *path = [self createPath];
    self.selectLayer = [self createLayer];
    CGFloat lineWidth = (_lineWidth + 0.0);
  //点
    CGPoint topPoint = CGPointMake((model.x+1.0)*_pointScale, model.y);
    CGPoint bottomPoint = CGPointMake((model.x+1.0)*_pointScale, SGMTDChartHeight);
    CGPoint topPoint2 = CGPointMake((model.x+1.0+lineWidth)*_pointScale, model.y);
    CGPoint bottomPoint2 = CGPointMake((model.x+1.0+lineWidth)*_pointScale, SGMTDChartHeight);
    //路径绘制
    [path moveToPoint:topPoint];
    [path addLineToPoint:topPoint2];
    [path addLineToPoint:bottomPoint2];
    [path addLineToPoint:bottomPoint];
    [path addLineToPoint:topPoint];
    //添加路径
    _selectLayer.path = path.CGPath;
    _selectLayer.strokeColor = kSGMTDBlackColor.CGColor;
    _selectLayer.fillColor = kSGMTDBlackColor.CGColor;
    _selectLayer.opacity = 0.3;
    [self.layer addSublayer:_selectLayer];
    //移除路径
    [path closePath];
    [path removeAllPoints];
}
//移除选中的柱状图朦板
- (void)dismissSelectLayer{
    
    [_selectLayer removeFromSuperlayer];
    _selectLayer = nil;
}


@end
