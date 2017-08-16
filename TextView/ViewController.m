//
//  ViewController.m
//  TextView
//
//  Created by long on 16/12/10.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ViewController.h"
#import "ZLTextView.h"

@interface ViewController () <ZLTextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZLTextView *tv = [[ZLTextView alloc] initWithFrame:CGRectMake(10, 150, 300, 112)];
    tv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tv.layer.borderWidth = 1.f;
    tv.placeholder = @"Ssssdlfkjsdlkfjsldkfjldskjfldksjflkdsjflksjflkdsjlfkdjslfkdjslkfjslkfdjslkfdjlksfjlksdjlfksdjlfkjdslkfjslkdjfldksjfl";
    tv.placeholderColer = [UIColor redColor];
    tv.maxHeight = 80;
    tv.text = @"ss";
    tv.delegate = self;
    [self.view addSubview:tv];
    tv.heightType = ZLTextViewAutoHeightTypeOneLineFrame;
    tv.font = [UIFont systemFontOfSize:40];
}


- (void)textView:(ZLTextView *)textView heightOfChange:(CGFloat)height {
    NSLog(@"%f", height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
