//
//  YcKeyBoardView.m
//  KeyBoardAndTextView
//
//  Created by Adrian on 14-9-1.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "YcKeyBoardView.h"

@interface YcKeyBoardView () <UITextViewDelegate>
@property (nonatomic, assign) CGFloat   textViewWidth;
@property (nonatomic, assign) BOOL      isChange;
@property (nonatomic, assign) BOOL      reduce;
@property (nonatomic, assign) CGRect    originalKey;
@property (nonatomic, assign) CGRect    originalText;
@end

@implementation YcKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [Utils hexStringToColor:@"#f4f4f4"];
        [self initTextView:frame];
    }

    return self;
}

- (void)initTextView:(CGRect)frame
{
    self.textView = [[UITextView alloc]init];
    self.textView.delegate = self;
    CGFloat textX = kStartLocation * 0.5;
    self.textViewWidth = frame.size.width - 2 * textX - 50;
    self.textView.frame = CGRectMake(textX, kStartLocation * 0.2, self.textViewWidth, frame.size.height - 2 * kStartLocation * 0.2);
    //    self.textView.frame=CGRectMake(10, 5 ,250 , 33);
    self.textView.backgroundColor = [Utils hexStringToColor:@"#f4f4f4"];
    self.textView.font = [UIFont systemFontOfSize:14.0];
    [self.textView.layer setBorderWidth:1.0];                                          // 边框宽度
    [self.textView.layer setBorderColor:[Utils hexStringToColor:@"#cecece"].CGColor];
    [self.textView.layer setCornerRadius:4.0f];
    [self addSubview:self.textView];

    _cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setFrame:CGRectMake(_textViewWidth + _textView.frame.origin.x + 20, kStartLocation * 0.2 + 10, 30, 20)];
    [_cancelBtn addTarget:self action:@selector(cancelCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)]) {
            [self.delegate keyBoardViewHide:self textView:self.textView];
        }

        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *content = textView.text;

    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0]];

    if (contentSize.width > self.textViewWidth) {
        if (!self.isChange) {
            CGRect keyFrame = self.frame;
            self.originalKey = keyFrame;
            keyFrame.size.height += keyFrame.size.height;
            keyFrame.origin.y -= keyFrame.size.height * 0.25;
            self.frame = keyFrame;

            CGRect textFrame = self.textView.frame;
            self.originalText = textFrame;
            textFrame.size.height += textFrame.size.height * 0.5 + kStartLocation * 0.2;
            self.textView.frame = textFrame;
            self.isChange = YES;
            self.reduce = YES;
        }
    }

    if (contentSize.width <= self.textViewWidth) {
        if (self.reduce) {
            self.frame = self.originalKey;
            self.textView.frame = self.originalText;
            self.isChange = NO;
            self.reduce = NO;
        }
    }
}

- (void)cancelCommentAction
{
    [self.textView resignFirstResponder];
}

@end