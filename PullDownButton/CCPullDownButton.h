//
//  CCPullDownButton.h
//  NSTableView
//
//  Created by wujungao on 2019/3/16.
//  Copyright © 2019 com.wujungao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPullDownButton : NSButton

/**
 @brief item的宽度，用于计算将menu放置的合适位置（放置在按钮下面，并且居中）
 
 @discussion menuItemWidth值，可以通过计算内容宽度获取，或者可以是item.view宽度值
 设置这个值，可以自动的将menu与按钮的centerX值相等
 */
@property(nonatomic,assign)CGFloat menuItemWidth;

#pragma mark - method

/**
 @brief 添加MenuItem到按钮

 @param item MenuItem
 @discussion 此处添加的Item，如果自定义了view，那么可以参照CCPullDownButton内部测试用的CCTextField自定义
 */
-(void)addMenuItem:(nonnull NSMenuItem *)item;

@end

NS_ASSUME_NONNULL_END
