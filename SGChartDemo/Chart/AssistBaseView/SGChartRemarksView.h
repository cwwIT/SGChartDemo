//
//  SGChartRemarksView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBrokenLineModel.h"
#import "SGHistogramModel.h"

NS_ASSUME_NONNULL_BEGIN
//长按 显示的备注视图
@interface SGChartRemarksView : UIView

@property (nonatomic,strong) SGBrokenLineModel *model;
@property (nonatomic,strong) SGHistogramModel *histogramModel;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
