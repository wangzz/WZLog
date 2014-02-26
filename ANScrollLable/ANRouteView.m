//
//  ANRouteView.m
//  Test
//
//  Created by wangzz on 14-2-14.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "ANRouteView.h"

#define MAIN_LABLE_ANIMATION_DURATION   3.0f
#define SUB_LABLE_ANIMATION_DURATION    10.0f


@interface ANRouteView ()
{
    UILabel *_mainLable;
    UILabel *_subLable;
    NSInteger   _bottomViewWidth;
}

@end

@implementation ANRouteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor grayColor];
        
        NSInteger buttonWith = 30;
        NSInteger buttonHeight = 40;
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (frame.size.height - buttonHeight)/2, buttonWith, buttonHeight)];
        leftButton.backgroundColor = [UIColor redColor];
        [self addSubview:leftButton];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - buttonWith, (frame.size.height - buttonHeight)/2, buttonWith, buttonHeight)];
        rightButton.backgroundColor = [UIColor redColor];
        [self addSubview:rightButton];
        
        
        NSInteger imageWith = 30;
        NSInteger imageHeight = 30;
        UIImageView *signImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftButton.frame.size.width + 10, (frame.size.height - imageHeight)/2, imageWith, imageWith)];
        signImage.backgroundColor = [UIColor greenColor];
        [self addSubview:signImage];
        
        
        NSInteger lableOrign = signImage.frame.origin.x + imageWith + 10;
        
        _bottomViewWidth = 200;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(lableOrign, 0, _bottomViewWidth, frame.size.height)];
        bottomView.backgroundColor = [UIColor lightGrayColor];
        bottomView.layer.masksToBounds = YES;
        
        _mainLable = [[UILabel alloc] init];
        _mainLable.font = [UIFont systemFontOfSize:15.0f];
        _mainLable.backgroundColor = [UIColor yellowColor];
        [bottomView addSubview:_mainLable];
        
        _subLable = [[UILabel alloc] init];
        _subLable.font = [UIFont systemFontOfSize:13.0f];
        _subLable.backgroundColor = [UIColor yellowColor];
        [bottomView addSubview:_subLable];
        
        [self addSubview:bottomView];
    }
    return self;
}

#pragma mark - Text Relative
- (void)setMainLableString:(NSString *)aString
{
    _mainLableString = aString;
    _mainLable.text = aString;
    
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:15.0] string:aString];
    CGRect  newFrame = _mainLable.frame;
    newFrame.size.width = size.width;
    _mainLable.frame = newFrame;
}

- (void)setSubLableString:(NSString *)aString
{
    _subLableString = aString;
    _subLable.text = aString;
    
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:13.0] string:aString];
    CGRect  newFrame = _subLable.frame;
    newFrame.size.width = size.width;
    _subLable.frame = newFrame;
}

- (CGSize)sizeWithFont:(UIFont *)font string:(NSString *)string
{
    CGSize  size;
//    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//        size = [string sizeWithFont:font
//                  constrainedToSize:CGSizeMake(1000, 200)
//                      lineBreakMode:0];
//    } else {
//        NSDictionary * attDic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
//        size = [string boundingRectWithSize:CGSizeMake(1000, 200)
//                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                 attributes:attDic
//                                    context:nil].size;
//    }
    
    return size;
}


#pragma mark - Animation
- (void)startAnimation
{
    if ((_mainLableString.length > 0) && (_mainLable.frame.size.width > _bottomViewWidth)) {
        [self startMainLableAnimation];
    }
    
    if ((_subLableString.length > 0) && (_subLable.frame.size.width > _bottomViewWidth)) {
        [self startSubLableAnimation];
    }
}

- (void)startMainLableAnimation
{
    [UIView animateWithDuration:MAIN_LABLE_ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect tickerFrame = _mainLable.frame;
        if (tickerFrame.origin.x == 0) {
            tickerFrame.origin.x = -(tickerFrame.size.width - _bottomViewWidth);
        } else if (tickerFrame.origin.x < 0) {
            tickerFrame.origin.x = 0;
        }
        
        [_mainLable setFrame:tickerFrame];
    } completion:^(BOOL finished) {
//        CGRect tickerFrame = _mainLable.frame;
//        tickerFrame.origin.x = _mainOriginX;
//        [_mainLable setFrame:tickerFrame];
        [self performSelector:@selector(startMainLableAnimation) withObject:nil afterDelay:0.5f];
    }];
}

- (void)startSubLableAnimation
{
    [UIView animateWithDuration:SUB_LABLE_ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect tickerFrame = _subLable.frame;
        if (tickerFrame.origin.x == 0) {
            tickerFrame.origin.x = -(tickerFrame.size.width - _bottomViewWidth);
        } else if (tickerFrame.origin.x < 0) {
            tickerFrame.origin.x = 0;
        }
        
        [_subLable setFrame:tickerFrame];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(startSubLableAnimation) withObject:nil afterDelay:0.5f];
    }];
}


#pragma mark - Layout SubView
- (void)layoutSubviews
{
    if ((_mainLableString.length > 0) && (_subLableString.length > 0)) {
        _mainLable.frame = CGRectMake(0, 5, _mainLable.frame.size.width, 40);
        _subLable.frame = CGRectMake(0, 55, _subLable.frame.size.width, 40);
    } else if ((_mainLableString.length > 0) && (_subLableString.length == 0)) {
        _mainLable.frame = CGRectMake(0, (self.frame.size.height - 40)/2, _mainLable.frame.size.width, 40);
        _subLable.hidden = YES;
        
    } else if ((_mainLableString.length == 0) && (_subLableString.length > 0)) {
        _mainLable.hidden = YES;
        _subLable.frame = CGRectMake(0, (self.frame.size.height - 40)/2, _subLable.frame.size.width, 40);
        
    } else {
        _mainLable.hidden = YES;
        _subLable.hidden = YES;
    }
    
    [self startAnimation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
