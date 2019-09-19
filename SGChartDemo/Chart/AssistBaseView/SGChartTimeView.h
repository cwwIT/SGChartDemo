//
//  SGChartTimeView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//显示时间的视图
@interface SGChartTimeView : UIView

@property (nonatomic,strong) NSArray *datas;

@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) NSInteger end;

- (void)refreshContent;

@end

NS_ASSUME_NONNULL_END
