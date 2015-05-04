//
//  UIImage-Extensions.m
//  The9AdPlatform
//
//  Created by zhang xiaodong on 11-5-31.
//  Copyright 2011 the9. All rights reserved.
//

#import "UIImage-Extensions.h"

@implementation UIImage (CS_Extensions)

- (UIImage *)jkImageByDrawInRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    [self drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)jkImageByFitToWidth:(CGFloat)width
{
    CGSize newSize = self.size;
    CGFloat scale;
    if (newSize.width != 0) {
        scale = width/newSize.width;
    } else {
        return nil;
    }
    return [self jkImageByDrawInRect:CGRectMake(0, 0, width, newSize.height*scale)];
}


@end;