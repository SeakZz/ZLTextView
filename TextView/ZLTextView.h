//
//  ZLTextView.h
//  TextView
//
//  Created by long on 16/12/10.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLTextView;

typedef NS_ENUM(NSInteger, ZLTextViewAutoHeightType) {
    ZLTextViewAutoHeightTypeNone = 0,
    ZLTextViewAutoHeightTypeOriginalFrame,
    ZLTextViewAutoHeightTypeOneLineFrame
};

@protocol ZLTextViewDelegate <UITextViewDelegate>

@optional
/** 高度变化后的回调 */
- (void)textView:(ZLTextView *)textView heightOfChange:(CGFloat)height;

@end

@interface ZLTextView : UITextView

/** 提示文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 提示颜色 */
@property (nonatomic, strong) UIColor *placeholderColer;

/** 是否根据文字多少自动适应高度 */
@property (nonatomic, assign) ZLTextViewAutoHeightType heightType;

/** 支持最大高度 */
@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, weak) id <ZLTextViewDelegate> delegate;

@end
