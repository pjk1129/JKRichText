//
//  SEPhotoView.h
//  RichTextEditor
//
//  Created by kishikawa katsumi on 2013/09/26.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEPhotoView;

@protocol SEPhotoViewDelegate <NSObject>

@optional
- (void)deletePhotoView:(SEPhotoView *)photoView;

@end

@interface SEPhotoView : UIView

@property (nonatomic, weak) id<SEPhotoViewDelegate>  delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString  *urlStr;  //<img src="http://shihuo.hupucdn.com/..." />

@end
