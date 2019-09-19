//
//  SGChartPVView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGChartPVView.h"
#import "SGBrokenLineModel.h"


@interface SGChartPVView ()

@property (nonatomic,assign) CGFloat maxPV;
@property (nonatomic,assign) CGFloat minPV;

@end

@implementation SGChartPVView

-(void)setDatas:(NSArray *)datas{
    
    if (_datas != datas) {
        _datas = datas;
    }
    [self setMaxMinPV];
    [self createSubViews];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createSubViews{
    
    NSInteger count = 5;
    CGFloat x = 0;
    CGFloat top = 0;
    CGFloat y = top;
    CGFloat w = self.frame.size.width;
    CGFloat unitH = self.frame.size.height / count;
    CGFloat h = 20;
    CGFloat fontSize = 10;
    CGFloat unit = (_maxPV - 0) / (count - 0);
    
    NSString *pvString = @"";
    CGFloat pv = 0.0f;
    for (int i=0; i<=count; i++) {
//        y = i * unitH + (unitH - h) / 2.0;
        y = i * unitH;
        if (i != 0 && i != (count - 0)) {
            pv = _maxPV - unit*i;
        }else if ((count - 0) == i){
            y = i * unitH - 10;
            pv = 0;
        }else{
            pv = _maxPV;
        }
        
        pvString = [NSString stringWithFormat:@"%.1f",pv];
        
        UILabel *pvLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        pvLabel.font = [UIFont systemFontOfSize:fontSize];
        pvLabel.textColor = UIColor.darkGrayColor;
        pvLabel.text = pvString;
        pvLabel.textAlignment = NSTextAlignmentCenter;
        pvLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:pvLabel];
    }
    
    
}

- (void)setMaxMinPV {
    
    _maxPV = CGFLOAT_MIN;
    _minPV = CGFLOAT_MAX;
    
    for (SGBrokenLineModel *model in _datas) {
        
        NSString *pv = model.PV;
        CGFloat pvValue = [pv floatValue];
        
        _maxPV = (_maxPV > pvValue) ? _maxPV : pvValue;
        _minPV = (_minPV < pvValue) ? _minPV : pvValue;
        
    }
}



@end
