//
//  SGBrokenLineView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGShapeLayer.h"
#import "SGBrokenLineModel.h"

NS_ASSUME_NONNULL_BEGIN

//折线图 手势处理 页面
@interface SGBrokenLineView : UIView


@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,assign) SGChartLineType lineType;
@property (nonatomic,assign) CGFloat unitWidth;

@end

NS_ASSUME_NONNULL_END
