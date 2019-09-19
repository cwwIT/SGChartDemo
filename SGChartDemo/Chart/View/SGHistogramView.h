//
//  SGHistogramView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//
 
#import "SGChartBaseView.h"

NS_ASSUME_NONNULL_BEGIN
//柱状图 手势处理 页面
@interface SGHistogramView : SGChartBaseView

@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,assign) SGChartLineType lineType;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineSpace;

@end

NS_ASSUME_NONNULL_END
