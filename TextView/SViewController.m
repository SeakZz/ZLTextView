//
//  SViewController.m
//  TextView
//
//  Created by long on 2017/5/15.
//  Copyright © 2017年 long. All rights reserved.
//

#import "SViewController.h"
#import "ZLTextView.h"

@interface SViewController ()

@property (weak, nonatomic) IBOutlet ZLTextView *textView;
@end

@implementation SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textView.layer.borderWidth = 1.f;
    _textView.placeholder = @"Sssdfsdkjflksdjflksdjflkdsjflksdjflkdsjflskdfjldksjflsss";
    _textView.heightType = ZLTextViewAutoHeightTypeOriginalFrame;
    _textView.font = [UIFont systemFontOfSize:40];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
