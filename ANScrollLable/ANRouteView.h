//
//  ANRouteView.h
//  Test
//
//  Created by wangzz on 14-2-14.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

/************
 实现功能：
 1、左右来回循环走马灯展示lable内容
 2、文字长度小于某个长度时，只静态展示，不启动走马灯
 3、根据主lable和子lable的赋值情况，调整lable的位置。比如，子lable没赋值时，主lable会上下居中显示。
 
 ***********/

#import <UIKit/UIKit.h>

@interface ANRouteView : UIView

@property (nonatomic, strong) NSString *mainLableString;
@property (nonatomic, strong) NSString *subLableString;

@end
