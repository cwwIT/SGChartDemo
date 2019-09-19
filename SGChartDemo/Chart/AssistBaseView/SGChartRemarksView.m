//
//  SGChartRemarksView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGChartRemarksView.h"

@interface SGChartRemarksView ()
 
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *PVLb;

@end

@implementation SGChartRemarksView

- (void)setModel:(SGBrokenLineModel *)model {
    if (_model != model) {
        _model = model;
    }
    NSString *time = model.time;
    NSString *pv = model.PV;
    _timeLb.text = [NSString stringWithFormat:@"time:%@",time];
    _PVLb.text = [NSString stringWithFormat:@"PV:%@（瓦）",pv];
}

-(void)setHistogramModel:(SGHistogramModel *)histogramModel {
    
    if (_histogramModel != histogramModel) {
        _histogramModel = histogramModel;
    }
    NSString *time = histogramModel.time;
    NSString *pv = histogramModel.PV;
    _timeLb.text = [NSString stringWithFormat:@"time:%@",time];
    _PVLb.text = [NSString stringWithFormat:@"PV:%@（瓦）",pv];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    CGFloat x = 10;
    CGFloat top = 10;
    CGFloat y = top;
    CGFloat w = self.frame.size.width - 20;
    CGFloat h = (self.frame.size.height - 2*top)/2.0;
    CGFloat fontSize = 11;
    
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _timeLb.font = [UIFont systemFontOfSize:fontSize];
        _timeLb.textColor = UIColor.whiteColor;
        _timeLb.text = @"time:--";
        _timeLb.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_timeLb];
    }
    
    if (!_PVLb) {
        y = y + h;
        _PVLb = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _PVLb.font = [UIFont systemFontOfSize:fontSize];
        _PVLb.textColor = UIColor.whiteColor;
        _PVLb.text = @"PV:--（瓦）";
        _PVLb.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_PVLb];
    }
    
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end
