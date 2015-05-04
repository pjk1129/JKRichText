//
//  SEPhotoView.m
//  RichTextEditor
//
//  Created by kishikawa katsumi on 2013/09/26.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SEPhotoView.h"
#import <QuartzCore/QuartzCore.h>

@interface SEPhotoView ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton    *deleteButton;

@end

@implementation SEPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(frame)-54, 10, 44, 44);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteImageAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];

        self.urlStr = @"<img src= />";
    }
    
    return self;
}

- (void)deleteImageAction
{    
    if ([_delegate respondsToSelector:@selector(deletePhotoView:)]) {
        [_delegate deletePhotoView:self];
    }
}

- (void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = image;
        self.imageView.image = image;
    }
}

@end
