//
//  SGChartTimeView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGChartTimeView.h"
#import "SGBrokenLineModel.h"

@interface SGChartTimeView ()

@property (nonatomic,strong) NSArray *times;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) UIView *timeBox;

@end


@implementation SGChartTimeView

-(UIView *)timeBox {
    if (!_timeBox) {
        _timeBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _timeBox;
}

-(void)setDatas:(NSArray *)datas{
    
    if (_datas != datas) {
        _datas = datas;
    }
    [self createSubViews];
    [self refreshContent];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createSubViews{
    
    _count = 3;
    CGFloat x = 0;
    CGFloat top = 0;
    CGFloat y = top;
    CGFloat w = self.frame.size.width;
    CGFloat h = 20;
    CGFloat fontSize = 10;
//    CGFloat www = SGMTDChartWidht;
    CGFloat unitW = SGMTDChartWidht / (_count - 0);
    [self addSubview:self.timeBox];
    for (int i=0; i<_count; i++) {
        
        x = i * unitW;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, unitW, h)];
        timeLabel.font = [UIFont systemFontOfSize:fontSize];
        timeLabel.textColor = UIColor.darkGrayColor;
        if (i==0) {
            timeLabel.textAlignment = NSTextAlignmentLeft;
        }else if (i == _count-1){
//            timeLabel.backgroundColor = UIColor.yellowColor;
            timeLabel.textAlignment = NSTextAlignmentRight;
        }else{
            timeLabel.textAlignment = NSTextAlignmentCenter;
        }
        timeLabel.adjustsFontSizeToFitWidth = YES;
        timeLabel.tag = i;
        [self.timeBox addSubview:timeLabel];
    }
    
    
}

- (void)refreshContent {
    
    if (_start < 0 || _end < 0 || _end >= _datas.count) {
        return;
    }
    
    NSInteger middele = (_start+_end)/2;
    SGBrokenLineModel *startModel = _datas[_start];
    SGBrokenLineModel *middleModel = _datas[middele];
    SGBrokenLineModel *endModel = _datas[_end];
    if (_start == 0) {
        NSLog(@"start");
    }
    if (!_start && !_end && _datas && _datas.count) {
        startModel = [_datas firstObject];
        middleModel = _datas[_datas.count/2];
        endModel = [_datas lastObject];
    }
    for (UILabel *label in _timeBox.subviews) {
        NSString *time = @"";
        if (label.tag == 0) {
            time = startModel.time;
        }else if (label.tag == 1){
            time = middleModel.time;
        }else{
            time = endModel.time;
        }
        label.text = time;
    }
}

@end
