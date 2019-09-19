//
//  SGHistogramContentView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGChartBaseView.h"

NS_ASSUME_NONNULL_BEGIN
//柱状图 绘制页面
@interface SGHistogramContentView : SGChartBaseView

@property (nonatomic,strong) NSArray *datas;
@property (assign, nonatomic) CGFloat pointScale;
//柱状图类型
@property (nonatomic,assign) SGChartLineType lineType;
//柱状图的宽度 和 间隙大小
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineSpace;

//是否显示 备注视图
- (void)showRemarks:(BOOL)show;

//移除选中的柱状图朦板
- (void)dismissSelectLayer;

//手势位置及变换的处理
- (void)handleGestureByPoint:(CGPoint)point showPoint:(CGPoint)showPoint;

@end

NS_ASSUME_NONNULL_END
