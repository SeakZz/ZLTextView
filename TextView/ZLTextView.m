//
//  ZLTextView.m
//  TextView
//
//  Created by long on 16/12/10.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ZLTextView.h"

static NSString *const kKeyPathContentSize = @"contentSize";

@interface ZLTextView ()

@property (nonatomic, strong) UILabel *placeLabel;

@end

@implementation ZLTextView {
    CGSize _placeSize;
    CGFloat _originalHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitialStatus];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInitialStatus];
    }
    return self;
}

- (void)setupInitialStatus {
    _heightType = ZLTextViewAutoHeightTypeNone;
    _originalHeight = self.bounds.size.height;
    self.maxHeight = 0;
    
    self.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.placeLabel];
    
    [self addObserver:self forKeyPath:kKeyPathContentSize options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(CGSizeZero, _placeSize)) {
        return;
    }
    _placeSize = [self sizeWithString:_placeholder];
    
    CGFloat singleHeight = [self sizeWithString:@""].height;
    
    if (_heightType == ZLTextViewAutoHeightTypeOneLineFrame) {
        
        self.placeLabel.frame = CGRectMake(self.textContainerInset.left + 4, self.textContainerInset.top, self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - 8, singleHeight);
        
    } else {
        
        if (_placeSize.height > self.bounds.size.height - self.textContainerInset.top - self.textContainerInset.bottom) {
            self.placeLabel.frame = CGRectMake(self.textContainerInset.left + 4, self.textContainerInset.top, _placeSize.width, (int)((self.bounds.size.height - self.textContainerInset.top - self.textContainerInset.bottom) / singleHeight) * singleHeight);
        } else {
            self.placeLabel.frame = CGRectMake(self.textContainerInset.left + 4, self.textContainerInset.top, _placeSize.width, singleHeight);
            
        }
    }
}


#pragma mark - init
- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.font = self.font;
        _placeLabel.textColor = [UIColor grayColor];
        _placeLabel.numberOfLines = 0;
    }
    return _placeLabel;
}

- (void)setHeightType:(ZLTextViewAutoHeightType)heightType {
    _heightType = heightType;
    
    if (heightType == ZLTextViewAutoHeightTypeOneLineFrame) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ceilf([self sizeThatFits:self.bounds.size].height));
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeLabel.text = placeholder;
}
- (void)setPlaceholderColer:(UIColor *)placeholderColer {
    _placeholderColer = placeholderColer;
    self.placeLabel.textColor = placeholderColer;
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeLabel.font = font;
    if (_heightType == ZLTextViewAutoHeightTypeOneLineFrame) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ceilf([self sizeThatFits:self.bounds.size].height));
    }
}
- (void)setText:(NSString *)text {
    [super setText:text];
    
    if (text.length != 0) {
        self.placeLabel.hidden = YES;
    }
}

@dynamic delegate;
- (id <ZLTextViewDelegate>)delegate {
    return (id <ZLTextViewDelegate>)[super delegate];
}
- (void)setDelegate:(id<ZLTextViewDelegate>)delegate {
    [super setDelegate:(id<UITextViewDelegate>)delegate];
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kKeyPathContentSize] && [object isKindOfClass:[self class]]) {
        
        switch (_heightType) {
            case ZLTextViewAutoHeightTypeOneLineFrame:
                [self showHeightChange:0];
                break;
                
            case ZLTextViewAutoHeightTypeOriginalFrame:
                [self showHeightChange:_originalHeight];
                break;
                
            default:
                break;
        }
        
    }
}

- (void)showHeightChange:(CGFloat)originalHeight {
    
    CGFloat contentH = ceilf([self sizeThatFits:self.bounds.size].height);
    if (originalHeight) {
        if (contentH > originalHeight) {
            if (self.maxHeight && contentH > self.maxHeight && self.maxHeight > originalHeight) {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.maxHeight);
            } else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentH);
            }
        } else {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _originalHeight);
        }
        
        if ([self.delegate respondsToSelector:@selector(textView:heightOfChange:)]) {
            [self.delegate textView:self heightOfChange:self.frame.size.height];
        }
    } else {
        if (self.maxHeight && self.maxHeight < contentH && self.maxHeight > [self sizeWithString:@""].height) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.maxHeight);
        } else {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentH);
        }
        if ([self.delegate respondsToSelector:@selector(textView:heightOfChange:)]) {
            [self.delegate textView:self heightOfChange:contentH];
        }
    }
}

- (void)textDidChange:(NSNotification *)noti {
    NSString *text = [[noti object] text];
    
    if (text.length == 0) {
        self.placeLabel.hidden = NO;
    } else {
        self.placeLabel.hidden = YES;
    }
}


- (CGSize)sizeWithString:(NSString *)str {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    CGSize maxSize = CGSizeMake(self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - 8, FLT_MAX);
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:kKeyPathContentSize];
}


@end
