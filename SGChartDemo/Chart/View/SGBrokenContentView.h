//
//  SGBrokenContentView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//
 
#import "SGChartBaseView.h"

NS_ASSUME_NONNULL_BEGIN

//折线图 绘制页面
@interface SGBrokenContentView : SGChartBaseView

@property (nonatomic,strong) NSArray *datas;
@property (assign, nonatomic) CGFloat pointScale;
@property (nonatomic,assign) CGFloat unitWidth;

//是否显示 备注视图
- (void)showRemarks:(BOOL)show;

//移除选中的柱状图朦板
- (void)dismissHVLineLayer;

//长按手势的位置
- (void)longPressPoint:(CGPoint)point showPoint:(CGPoint)showPoint;

@end

NS_ASSUME_NONNULL_END
