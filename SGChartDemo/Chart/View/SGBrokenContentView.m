//
//  SGBrokenContentView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGBrokenContentView.h"
#import "SGChartRemarksView.h"

@interface SGBrokenContentView ()

@property (nonatomic,strong) SGShapeLayer *mainLayer;//承载路径
@property (nonatomic,strong) SGChartRemarksView *remarksView;//详情提示

@property (nonatomic,strong) SGShapeLayer *hLine;//横线
@property (nonatomic,strong) SGShapeLayer *vLine;//竖线

@end

@implementation SGBrokenContentView

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
    
    CGFloat lineWidth = 1.0 / [UIScreen mainScreen].scale;
//    CGFloat lineWidth = 5.0;
    
    UIBezierPath *path = [self createPath];
    self.mainLayer = [self createLayer];
    
    WS(ws)
    [_datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SGBrokenLineModel *model = obj;
        CGPoint p = CGPointMake(model.x*ws.pointScale, model.y);
        
        if (idx == 0) {
            
            [path moveToPoint:p];
            
        }else{
            
            if (model.y == (SGMTDChartHeight-20)) {
                //最低点，0，可以不连线
                [path moveToPoint:p];
                
            }else{
                
                [path addLineToPoint:p];
            }
        }
    }];
    
    path.lineWidth = lineWidth;
    _mainLayer.path = path.CGPath;
    _mainLayer.strokeColor = kSGMTDBlueColor.CGColor;
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

//长按手势的位置
- (void)longPressPoint:(CGPoint)point showPoint:(CGPoint)showPoint {
    
    WS(ws)
    [self dismissHVLineLayer];
    if (_unitWidth) {
        NSInteger index = point.x/(_unitWidth*_pointScale);
        
        if (index < _datas.count) {
            SGBrokenLineModel *model = _datas[index];
            _remarksView.model = model;
            [self addTipLinesBySGHistogramModel:model];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = ws.remarksView.frame;
        frame.origin = showPoint;
        ws.remarksView.frame = frame;
        
    }];
}
//添加十字线
- (void)addTipLinesBySGHistogramModel:(SGBrokenLineModel *)model {
    
    UIBezierPath *hPath = [self createPath];
    UIBezierPath *vPath = [self createPath];
    self.hLine = [self createLayer];
    self.vLine = [self createLayer];
    CGFloat lineWidth = _unitWidth;
    //点
    CGFloat totalWidth = _datas.count*_unitWidth*_pointScale;
    CGPoint leftPoint = CGPointMake(0, model.y);
    CGPoint rightPoint = CGPointMake(totalWidth, model.y);
    CGPoint topPoint = CGPointMake((model.x+0.0)*_pointScale, 0);
    CGPoint bottomPoint = CGPointMake((model.x+0.0)*_pointScale, SGMTDChartHeight);
    //路径绘制
    [hPath moveToPoint:leftPoint];
    [hPath addLineToPoint:rightPoint];
    [vPath moveToPoint:topPoint];
    [vPath addLineToPoint:bottomPoint];
    //添加路径
    _hLine.path = hPath.CGPath;
    _hLine.strokeColor = kSGMTDOrangeColor.CGColor;
    _hLine.opacity = 0.8;
    _hLine.lineWidth = 1.0/[UIScreen mainScreen].scale;
    [self.layer addSublayer:_hLine];
    _vLine.path = vPath.CGPath;
    _vLine.strokeColor = kSGMTDOrangeColor.CGColor;
    _vLine.opacity = 0.8;
    _vLine.lineWidth = 1.0/[UIScreen mainScreen].scale;
    [self.layer addSublayer:_vLine];
    //移除路径
    [hPath closePath];
    [hPath removeAllPoints];
    [vPath closePath];
    [vPath removeAllPoints];
}
//移除选中的柱状图朦板
- (void)dismissHVLineLayer{
    [_hLine removeFromSuperlayer];
    [_vLine removeFromSuperlayer];
    _hLine = nil;
    _vLine = nil;
}



@end
