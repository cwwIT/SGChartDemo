//
//  SGChartVC.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGChartVC.h"
#import "SGBrokenLineView.h"
#import "SGHistogramView.h"
#import "SGChartIndexView.h"

@interface SGChartVC ()

//类型选择view
@property (nonatomic,strong) SGChartIndexView *excodeTypeView;
@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSMutableArray<SGBrokenLineModel *> *brokenArray;
//@property (nonatomic,strong) NSMutableArray<SGHistogramModel *> *dayArray;
@property (nonatomic,strong) NSMutableArray<SGHistogramModel *> *monthArray;
@property (nonatomic,strong) NSMutableArray<SGHistogramModel *> *yearArray;
@property (nonatomic,strong) NSMutableArray<SGHistogramModel *> *totalArray;

@property (nonatomic,strong) SGBrokenLineView *brokenLineView;
//@property (nonatomic,strong) SGHistogramView *dayHistogramView;
@property (nonatomic,strong) SGHistogramView *monthHistogramView;
@property (nonatomic,strong) SGHistogramView *yearHistogramView;
@property (nonatomic,strong) SGHistogramView *totalHistogramView;

@property (nonatomic,assign) CGFloat unitWidth; //折线图——单元宽度
@property (nonatomic,assign) CGFloat lineWidthMonth; //柱状图线宽
@property (nonatomic,assign) CGFloat lineSpaceMonth; //柱状图线之间间隙
@property (nonatomic,assign) CGFloat lineWidthYear; //柱状图线宽
@property (nonatomic,assign) CGFloat lineSpaceYear; //柱状图线之间间隙
@property (nonatomic,assign) CGFloat lineWidthTotal; //柱状图线宽
@property (nonatomic,assign) CGFloat lineSpaceTotal; //柱状图线之间间隙

@end

@implementation SGChartVC


- (SGChartIndexView *)excodeTypeView{
    
    if (!_excodeTypeView) {
        _excodeTypeView = [[SGChartIndexView alloc]initWithFrame:CGRectMake(0, kMTDTabarNavigationHeight, SGMTDSCREENWIDTH, kExcodeTypeViewHeight) array:_titles];
        _excodeTypeView.backgroundColor = [UIColor whiteColor];
        
        WS(ws)
        _excodeTypeView.excodeTypeClick = ^(NSString *type) {
            NSInteger tag = [type integerValue];
            [ws showViewByTag:tag];
        };
    }
    
    return _excodeTypeView;
}

- (SGBrokenLineView *)brokenLineView {
    
    if (!_brokenLineView) {
        _brokenLineView = [[SGBrokenLineView alloc]initWithFrame:CGRectMake(0, kMTDTabarNavigationHeight+kExcodeTypeViewHeight, SGMTDSCREENWIDTH, SGMTDChartHeight+SGMTDChartTop+SGMTDChartBottom)];
        _brokenLineView.backgroundColor = SGMTDRGB(240, 220, 200);
    }
    return _brokenLineView;
}

-(SGHistogramView *)monthHistogramView {
    
    if (!_monthHistogramView) {
        _monthHistogramView = [[SGHistogramView alloc]initWithFrame:CGRectMake(0, kMTDTabarNavigationHeight+kExcodeTypeViewHeight, SGMTDSCREENWIDTH, SGMTDChartHeight+SGMTDChartTop+SGMTDChartBottom)];
        _monthHistogramView.backgroundColor = SGMTDRGB(210, 240, 250);
    }
    return _monthHistogramView;
    
}

-(SGHistogramView *)yearHistogramView {
    
    if (!_yearHistogramView) {
        _yearHistogramView = [[SGHistogramView alloc]initWithFrame:CGRectMake(0, kMTDTabarNavigationHeight+kExcodeTypeViewHeight, SGMTDSCREENWIDTH, SGMTDChartHeight+SGMTDChartTop+SGMTDChartBottom)];
        _yearHistogramView.backgroundColor = SGMTDRGB(200, 240, 170);
    }
    return _yearHistogramView;
    
}

-(SGHistogramView *)totalHistogramView {
    
    if (!_totalHistogramView) {
        _totalHistogramView = [[SGHistogramView alloc]initWithFrame:CGRectMake(0, kMTDTabarNavigationHeight+kExcodeTypeViewHeight, SGMTDSCREENWIDTH, SGMTDChartHeight+SGMTDChartTop+SGMTDChartBottom)];
        _totalHistogramView.backgroundColor = SGMTDRGB(200, 200, 240);
    }
    return _totalHistogramView;
    
}

-(void)createBts{
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, kMTDStatusBarHeight, 100, 44)];
    [back setTitle:@"click back" forState:UIControlStateNormal];
    [back setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}

- (void)createDescriptionLabel {
    NSString *content = @"1.缩放，滑动。\n2.单击/长按 显示详情框。\n3.双击/缩放 隐藏详情框。";
    UILabel *descript = [[UILabel alloc]initWithFrame:CGRectMake(10, SGMTDSCREENHEIGHT-kMTDNavigationHeight-kMTDFooterHeight, SGMTDSCREENWIDTH-20, kMTDFooterHeight)];
    descript.font = [UIFont systemFontOfSize:12];
    descript.numberOfLines = 0;
    descript.textColor = UIColor.redColor;
    [self.view addSubview:descript];
    descript.text = content;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configData];
    [self createSubViews];
}

- (void)configData {
    
    self.view.backgroundColor = UIColor.whiteColor;
    _titles = @[@"日",@"月",@"年",@"总"];
    _brokenArray = [NSMutableArray array];
    _monthArray = [NSMutableArray array];
    _yearArray = [NSMutableArray array];
    _totalArray = [NSMutableArray array];
    
    //赋值
    [self addData];
}

- (void)createSubViews {
    
    [self createBts];
    [self.view addSubview:self.excodeTypeView];
    [self createLineViews];
}

- (void)createLineViews {
    
    //broken line (day line)
    [self.view addSubview:self.brokenLineView];
    self.brokenLineView.lineType = SGChartLineBrokenType;
    self.brokenLineView.unitWidth = _unitWidth;
    self.brokenLineView.datas = (NSArray *)_brokenArray;
    //month line
    [self.view addSubview:self.monthHistogramView];
    self.monthHistogramView.lineType = SGChartLineDayType;
    self.monthHistogramView.lineWidth = _lineWidthMonth;
    self.monthHistogramView.lineSpace = _lineSpaceMonth;
    self.monthHistogramView.datas = (NSArray *)_monthArray;
    //year line
    [self.view addSubview:self.yearHistogramView];
    self.yearHistogramView.lineType = SGChartLineDayType;
    self.yearHistogramView.lineWidth = _lineWidthYear;
    self.yearHistogramView.lineSpace = _lineSpaceYear;
    self.yearHistogramView.datas = (NSArray *)_yearArray;
    //total line
    [self.view addSubview:self.totalHistogramView];
    self.totalHistogramView.lineType = SGChartLineDayType;
    self.totalHistogramView.lineWidth = _lineWidthTotal;
    self.totalHistogramView.lineSpace = _lineSpaceTotal;
    self.totalHistogramView.datas = (NSArray *)_totalArray;
    
    [self showViewByTag:0];
    [self createDescriptionLabel];
}

#pragma mark ation

- (void)showViewByTag:(NSInteger)tag {
    
    switch (tag) {
        case 0:
        {
            self.brokenLineView.hidden = NO;
            self.monthHistogramView.hidden = YES;
            self.yearHistogramView.hidden = YES;
            self.totalHistogramView.hidden = YES;
            break;
        }
        case 1:
        {
            self.brokenLineView.hidden = YES;
            self.monthHistogramView.hidden = NO;
            self.yearHistogramView.hidden = YES;
            self.totalHistogramView.hidden = YES;
            break;
        }
        case 2:
        {
            self.brokenLineView.hidden = YES;
            self.monthHistogramView.hidden = YES;
            self.yearHistogramView.hidden = NO;
            self.totalHistogramView.hidden = YES;
            break;
        }
        case 3:
        {
            self.brokenLineView.hidden = YES;
            self.monthHistogramView.hidden = YES;
            self.yearHistogramView.hidden = YES;
            self.totalHistogramView.hidden = NO;
            break;
        }
            
        default:
        {
            self.brokenLineView.hidden = NO;
            self.monthHistogramView.hidden = YES;
            self.yearHistogramView.hidden = YES;
            self.totalHistogramView.hidden = YES;
            break;
        }
    }
    
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark 添加假数据
//模拟数据
- (void)addData {
    
    CGFloat y = 0.0f;
//    CGFloat width = 1.0f;
    NSInteger count = 0;
    //1.日折线图 添加数据
//    CGFloat unitWidth = SGMTDChartWidht/(24*60*[UIScreen mainScreen].scale);
    CGFloat unitWidth = SGMTDChartWidht/(24*60);
//    unitWidth = unitWidth<width ? unitWidth:width;
    _unitWidth = unitWidth;
    
    for (int i=0; i<24; i++) {
        
        for (int j=0; j<60; j++) {
            y = arc4random()%(int)(SGMTDChartHeight-20)+10;
            SGBrokenLineModel *model = [[SGBrokenLineModel alloc]init];
            model.x = count*unitWidth;
            model.y = y;
            model.unitWidth = unitWidth;
            NSString *time_i = [NSString stringWithFormat:@"%d",i];
            NSString *time_j = [NSString stringWithFormat:@"%d",j];
            if (i<10) {
                time_i = [NSString stringWithFormat:@"0%d",i];
            }
            if (j<10) {
                time_j = [NSString stringWithFormat:@"0%d",j];
            }
            model.time = [NSString stringWithFormat:@"%@:%@",time_i,time_j];
            NSInteger pValue = arc4random()%(10000);
            CGFloat pv = pValue/10.0;
            model.PV = [NSString stringWithFormat:@"%.1f",pv];
            model.lineWidth = 1.0;
            model.index = count;
            [_brokenArray addObject:model];
            count++;
        }
    }
    
    //2.月
    count = 31;
    CGFloat lineSpace = 3.0;
    CGFloat lineWidth = ((SGMTDChartWidht)/((count+1)*1.0) - lineSpace);
    _lineSpaceMonth = lineSpace;
    _lineWidthMonth = lineWidth;
    
    for (int i=0; i<count; i++) {
        y = arc4random()%(int)(SGMTDChartHeight-20)+10; 
        SGHistogramModel *model = [[SGHistogramModel alloc]init];
        model.x = i*(lineWidth+lineSpace);
        model.y = y;
        model.lineWidth = lineWidth;
        model.lineSpace = lineSpace;
        model.time = [NSString stringWithFormat:@"09-%d",(i+1)];
        NSInteger pValue = arc4random()%(10000);
        CGFloat pv = pValue/5.0;
        model.PV = [NSString stringWithFormat:@"%.1f",pv];
        model.index = count;
        [_monthArray addObject:model];
    }
    
    //3.年
    count = 12;
    lineSpace = 5.0;
    lineWidth = ((SGMTDChartWidht)/((count+1)*1.0)  - lineSpace);
    _lineSpaceYear = lineSpace;
    _lineWidthYear = lineWidth;
    
    for (int i=0; i<count; i++) {
        y = arc4random()%(int)(SGMTDChartHeight-20)+10;
        SGHistogramModel *model = [[SGHistogramModel alloc]init];
        model.x = i*(lineWidth+lineSpace);
        model.y = y;
        model.lineWidth = lineWidth;
        model.lineSpace = lineSpace;
        model.time = [NSString stringWithFormat:@"%d",(i+1)];
        NSInteger pValue = arc4random()%(10000);
        CGFloat pv = pValue/2.0;
        model.PV = [NSString stringWithFormat:@"%.1f",pv];
        model.index = count;
        [_yearArray addObject:model];
    }
    //4.总
    count = 1;
    lineWidth = 50.0;
    lineSpace = 10.0;
    _lineSpaceTotal = lineSpace;
    _lineWidthTotal = lineWidth;
    
    for (int i=0; i<count; i++) {
        y = arc4random()%(int)(SGMTDChartHeight-20)+10;
        SGHistogramModel *model = [[SGHistogramModel alloc]init];
        model.x = i*(lineWidth+lineSpace);
        model.y = y;
        model.lineWidth = lineWidth;
        model.lineSpace = lineSpace;
        model.time = [NSString stringWithFormat:@"%d",(i+1)];
        NSInteger pValue = arc4random()%(10000);
        CGFloat pv = pValue/1.0;
        model.PV = [NSString stringWithFormat:@"%.1f",pv];
        model.index = count;
        [_totalArray addObject:model];
    }
    
    
}


@end

