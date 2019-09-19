//
//  ExcodeTypeView.m
//  Coinuex
//
//  Created by cww on 2018/7/19.
//  Copyright © 2018年 dangfm. All rights reserved.
//

#import "SGChartIndexView.h"

@implementation SGChartIndexView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubview];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array{
    
    if (self = [super initWithFrame:frame]) {
        _titleArray = [array copy];
        [self createSubview];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTabTag:) name:@"serviceChangeToShare" object:nil];
    
    return self;
}
-(void)createSubview{
    
    _bts = [NSMutableArray array];
    
    int i=0 ;
    
    CGFloat top = 0;
    CGFloat h = kExcodeTypeViewHeight-1;
    CGFloat left = 10;
    CGFloat x = left;
    CGFloat w = (SGMTDSCREENWIDTH-2*left)/_titleArray.count;
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SGMTDSCREENWIDTH, top)];
    topline.backgroundColor = kSGMTDDarkGrayColor;
//    [self addSubview:topline];
    
    for (NSString *title in _titleArray) {
        
        x = left + i*w;
        
        UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(x, top, w, h)]; 
        [bt setTitle:title forState:UIControlStateNormal];
        bt.tag = i;
        [bt setTitleColor:kSGMTDDarkGrayColor forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(typeBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [_bts addObject:bt];
        if (i==0) {
            [self setBtStateHilight:bt];
        }
        i++;
    }
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, kExcodeTypeViewHeight-1, SGMTDSCREENWIDTH, 1)];
    bottomline.backgroundColor = kSGMTDDarkGrayColor;
    [self addSubview:bottomline];
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(left, kExcodeTypeViewHeight-2, w, 2)];
    _line.backgroundColor = kSGMTDBlueColor;
    [self addSubview:_line];
    
}

-(void)changeTabTag:(NSNotification *)notif{
    UIButton *bt = _bts[2];
    [self typeBtClick:bt];
}
-(void)typeBtClick:(UIButton *)bt{
    
    NSInteger tag = bt.tag;
    NSString *type = [NSString stringWithFormat:@"%ld",tag];
    
    [self setAllBtStateNomal];
    [self setBtStateHilight:bt];
    
    if (_excodeTypeClick) {
        _excodeTypeClick(type);
    }
    
}

-(void)movelineFrameWithTag:(NSInteger)tag{
    
    CGFloat left = 10;
    CGFloat w = (SGMTDSCREENWIDTH-2*left)/_bts.count;
    CGFloat x = left + tag*w;
    
    _line.frame = CGRectMake(x, kExcodeTypeViewHeight-2, w, 2);
}

-(void)setAllBtStateNomal{
    
    for (UIButton *bt in _bts) {
        [bt setTitleColor:kSGMTDDarkGrayColor forState:UIControlStateNormal];
    }
    
}

-(void)setBtStateHilight:(UIButton *)bt{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self movelineFrameWithTag:bt.tag];
        [bt setTitleColor:kSGMTDBlueColor forState:UIControlStateNormal];
    }];
}

@end
