//
//  SGHistogramView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGHistogramView.h"
#import "SGChartPVView.h"
#import "SGChartTimeView.h"
#import "SGHistogramContentView.h"

@interface SGHistogramView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *backGroundScrollow;
@property (nonatomic,strong) SGHistogramContentView *contentView;
@property (nonatomic,strong) SGChartPVView *pvView;
@property (nonatomic,strong) SGChartTimeView *timeView;
@property (nonatomic,assign) CGFloat defaultScale;
@property (assign, nonatomic) CGFloat pointScale;

@end

@implementation SGHistogramView


- (UIScrollView *)backGroundScrollow {
    
    if (!_backGroundScrollow) {
        _backGroundScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(SGMTDChartLeft, SGMTDChartTop, SGMTDChartWidht, SGMTDChartHeight)];
        _backGroundScrollow.backgroundColor = SGMTDRGB(245, 247, 249);
        _backGroundScrollow.delegate = self;
        _backGroundScrollow.bouncesZoom = NO;
        _backGroundScrollow.bounces = NO;
        _backGroundScrollow.alwaysBounceVertical = YES;
        _backGroundScrollow.alwaysBounceHorizontal = YES;
    }
    return _backGroundScrollow;
}

-(UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[SGHistogramContentView alloc]initWithFrame:CGRectMake(0, 0, SGMTDChartWidht, SGMTDChartHeight)];
    }
    return _contentView;
}


-(SGChartPVView *)pvView {
    if (!_pvView) {
        _pvView = [[SGChartPVView alloc]initWithFrame:CGRectMake(0, SGMTDChartTop, SGMTDChartLeft, SGMTDChartHeight)];
    }
    return _pvView;
}

-(SGChartTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[SGChartTimeView alloc]initWithFrame:CGRectMake(SGMTDChartLeft, SGMTDChartTop+SGMTDChartHeight, SGMTDChartWidht, SGMTDChartBottom)];
    }
    return _timeView;
}
 
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backGroundScrollow];
        [self.backGroundScrollow addSubview:self.contentView];
        [self addSubview:self.pvView];
        [self addSubview:self.timeView];
        
        self.backGroundScrollow.contentSize = self.contentView.frame.size;
        self.contentView.lineWidth = _lineWidth;
        self.contentView.lineSpace = _lineSpace;
        _defaultScale = 5.0;
        _contentView.pointScale = 1.0;
        _pointScale = 1.0;
        
        // 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [self.backGroundScrollow addGestureRecognizer:pinch];
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [self.backGroundScrollow addGestureRecognizer:longPress];
        //单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGesture:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        //双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        // 双击事件响应失败时, 响应单击事件
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

-(void)setDatas:(NSArray *)datas{
    
    if (_datas != datas) {
        _datas = datas;
    }
    [self refreshMaxScale];
    self.contentView.datas = _datas;
    SGHistogramModel *model = [[SGHistogramModel alloc]init];
    model = [_datas firstObject];
    self.contentView.lineSpace = model.lineSpace;
    self.contentView.lineWidth = model.lineWidth;
    self.pvView.datas = _datas;
    self.timeView.datas = _datas;
    
}

//数据量大时，允许最大放大倍数增加
- (void)refreshMaxScale {
    NSInteger count = _datas.count;
    if (count < 2) {
        _defaultScale = 6.0;
    }else if (count < 13) {
        _defaultScale = 7.0;
    }else if (count < 32) {
        _defaultScale = 15.0;
    }else if (count < 367){
        _defaultScale = 30.0;
    }else{
        _defaultScale = 30.0;
    }
}

#pragma mark 返回scrollview上面需要所放的view
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//
//    return self.contentView;
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //单位柱状图 宽度间隙 之和
    CGFloat unitWidth = _lineWidth + _lineSpace;
    CGPoint p = scrollView.contentOffset;
    NSInteger start = p.x/(_pointScale * unitWidth);
    NSInteger end = (p.x+SGMTDChartWidht)/(_pointScale * unitWidth);
    _timeView.start = start;
    _timeView.end = end;
//    NSLog(@"end___%ld",end);
    [_timeView refreshContent];
    //柱状图滑动 可以不移除
//    [self removeTipViewAndLines];
    
}
// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    [self removeTipViewAndLines];
    //单位柱状图 宽度间隙 之和
    CGFloat unitWidth = _lineWidth + _lineSpace;
    CGFloat scale = recognizer.scale;
    //    NSLog(@"%.2f",scale);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }else{
 
        CGFloat currentIndex,leftMagin;
        if( recognizer.numberOfTouches == 2 ) {
            //.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
            CGPoint p1 = [recognizer locationOfTouch:0 inView:self.contentView];
            CGPoint p2 = [recognizer locationOfTouch:1 inView:self.contentView];
            CGFloat centerX = (p1.x+p2.x)/2;
            leftMagin = centerX - self.backGroundScrollow.contentOffset.x;
            currentIndex = centerX / _pointScale;
            
            self.pointScale *= scale;
            self.pointScale = self.pointScale > _defaultScale ? _defaultScale : self.pointScale;
            if (self.pointScale == _defaultScale || self.pointScale <= 1.0) {

                NSLog(@"已经放至最大/最小");
                return;
            }
            self.contentView.pointScale = self.pointScale;
            recognizer.scale = 1.0;

            self.contentView.frame = CGRectMake(0, 0, self.datas.count * self.pointScale * unitWidth, self.frame.size.height);

            self.backGroundScrollow.contentOffset = CGPointMake(currentIndex*self.pointScale-leftMagin, 0);
            

        }


    }
//    self.contentView.lineWidth = _lineWidth;
//    self.contentView.lineSpace = _lineSpace;
    self.backGroundScrollow.contentSize = CGSizeMake(self.contentView.frame.size.width, 0);
    //重新绘制layer
    [self.contentView setNeedsDisplay];
    
}

//长按手势处理
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        CGPoint location = [longPress locationInView:self.contentView];
        CGPoint showPoint = location; 
        CGPoint mainLocation = [longPress locationInView:self];
        CGFloat x = mainLocation.x;
        CGFloat y = mainLocation.y;
        
        if (x >= ((SGMTDChartWidht/2.0)+SGMTDChartLeft) && x <= (SGMTDChartWidht + SGMTDChartLeft)) {
            if (y >= (SGMTDChartHeight/2.0 + SGMTDChartTop) && y <= (SGMTDChartHeight + SGMTDChartTop)) {
                showPoint = CGPointMake(showPoint.x - 150, showPoint.y-60);
            }else if (y > SGMTDChartTop && y < (SGMTDChartHeight/2.0 + SGMTDChartTop)){
                showPoint = CGPointMake(showPoint.x - 150, showPoint.y+60);
            }else{
                return;
            }
        }else if (x < ((SGMTDChartWidht/2.0)+SGMTDChartLeft) && x >= SGMTDChartLeft){
            
            if (y >= (SGMTDChartHeight/2.0 + SGMTDChartTop) && y <= (SGMTDChartHeight + SGMTDChartTop)) {
                showPoint = CGPointMake(showPoint.x + 60, showPoint.y-60);
            }else if (y > SGMTDChartTop && y < (SGMTDChartHeight/2.0 + SGMTDChartTop)){
                showPoint = CGPointMake(showPoint.x + 60, showPoint.y+60);
            }else{
                return;
            }
            
        }else{
            return;
        }
        
        [_contentView showRemarks:YES];
        [_contentView handleGestureByPoint:location showPoint:showPoint];
        
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded) {
        [self removeTipViewAndLines];
    }
}

//点击手势 处理
- (void)singleGesture:(UIPinchGestureRecognizer *)tap {
    
    CGPoint location = [tap locationInView:self.contentView];
    CGPoint showPoint = location;
    CGPoint mainLocation = [tap locationInView:self];
    CGFloat x = mainLocation.x;
    CGFloat y = mainLocation.y;
    
    if (x >= ((SGMTDChartWidht/2.0)+SGMTDChartLeft) && x <= (SGMTDChartWidht + SGMTDChartLeft)) {
        if (y >= (SGMTDChartHeight/2.0 + SGMTDChartTop) && y <= (SGMTDChartHeight + SGMTDChartTop)) {
            showPoint = CGPointMake(showPoint.x - 150, showPoint.y-60);
        }else if (y > SGMTDChartTop && y < (SGMTDChartHeight/2.0 + SGMTDChartTop)){
            showPoint = CGPointMake(showPoint.x - 150, showPoint.y+60);
        }else{
            return;
        }
    }else if (x < ((SGMTDChartWidht/2.0)+SGMTDChartLeft) && x >= SGMTDChartLeft){
        
        if (y >= (SGMTDChartHeight/2.0 + SGMTDChartTop) && y <= (SGMTDChartHeight + SGMTDChartTop)) {
            showPoint = CGPointMake(showPoint.x + 60, showPoint.y-60);
        }else if (y > SGMTDChartTop && y < (SGMTDChartHeight/2.0 + SGMTDChartTop)){
            showPoint = CGPointMake(showPoint.x + 60, showPoint.y+60);
        }else{
            return;
        }
        
    }else{
        return;
    }
    
    [_contentView showRemarks:YES];
    [_contentView handleGestureByPoint:location showPoint:showPoint];
     
}

//双击
- (void)doubleGesture:(UIPinchGestureRecognizer *)doubleTap {
    [self removeTipViewAndLines];
}

- (void)removeTipViewAndLines {
    //    删除详情提示框
    [_contentView showRemarks:NO];
    //    删除选中柱状图 朦板
    [_contentView dismissSelectLayer];
}

@end
