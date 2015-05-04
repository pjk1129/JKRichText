//
//  SEViewController.m
//  JKTextView
//
//  Created by Jecky on 15/4/28.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "SEViewController.h"
#import "SETextView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SEPhotoView.h"
#import "UIImage-Extensions.h"


@interface SEViewController ()<SETextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SEPhotoViewDelegate>

@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) SETextView     *textView;

@end

@implementation SEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"SETextView";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self titleLabel];
    [self textView];
    
    UIBarButtonItem  *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(submitData)];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)submitData
{
    NSString  *rich = [self richText];
    NSLog(@"%@",rich);
}

- (NSString *)richText
{
    NSArray *attachArray = [self.textView.attachments.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SETextAttachment *attachment1 = obj1;
        SETextAttachment *attachment2 = obj2;
        UIView *v1 = attachment1.object;
        UIView *v2 = attachment2.object;
        CGFloat value1 = CGRectGetMinY(v1.frame) + CGRectGetMinX(v1.frame);
        CGFloat value2 = CGRectGetMinY(v2.frame) + CGRectGetMinX(v2.frame);
        if (value1 < value2) {
            return NSOrderedAscending;
        } else if (value1 > value2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSString  *resultStr = self.textView.text;
    for (NSInteger i=0; i<[attachArray count]; i++) {
        SETextAttachment *att = [attachArray objectAtIndex:i];
        NSString *tempStr = @"[img]";
        if ([(SEPhotoView *)att.object urlStr]>0) {
            tempStr = [(SEPhotoView *)att.object urlStr];
        }
        NSRange  range = [resultStr rangeOfString:OBJECT_REPLACEMENT_CHARACTER];
        NSString *str1 = [resultStr substringToIndex:range.location];
        NSString *str2 = [resultStr substringFromIndex:range.location+range.length];
        resultStr = [NSString stringWithFormat:@"%@%@%@",str1,tempStr,str2];
    }
    
    return resultStr;
}

#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.scrollView.scrollEnabled = NO;
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.scrollView.frame = CGRectMake(10, 50, CGRectGetWidth(self.view.frame)-20,CGRectGetHeight(self.view.frame) - keyBoardSize.height-64);
    self.scrollView.scrollEnabled = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollView.scrollEnabled = NO;
    self.scrollView.frame = CGRectMake(10, 50, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-55-64);
    self.scrollView.scrollEnabled = YES;
    	
    if (self.textView.bounds.size.height<self.scrollView.bounds.size.height) {
        self.textView.frame = self.scrollView.bounds;
    }
}

#pragma mark - SETextViewDelegate
- (void)textViewDidBeginEditing:(SETextView *)textView{
    
}

- (void)textViewDidEndEditing:(SETextView *)textView{
    
}

- (void)textViewDidChangeSelection:(SETextView *)textView{
    
}

- (void)textViewDidEndSelecting:(SETextView *)textView{
    
}

- (void)textViewDidChange:(SETextView *)textView{
    [self updateLayout];
}

- (void)updateLayout
{
    CGSize containerSize = self.scrollView.frame.size;
    CGSize contentSize = [self.textView sizeThatFits:containerSize];
    
    CGRect frame = self.textView.frame;
    frame.size.height = MAX(contentSize.height, containerSize.height);
    
    self.textView.frame = frame;
    self.scrollView.contentSize = frame.size;
    [self.scrollView scrollRectToVisible:self.textView.caretRect animated:YES];
}

#pragma mark - SEPhotoViewDelegate
- (void)deletePhotoView:(SEPhotoView *)photoView{
    [self.textView removeSETextAttachments:photoView];    
}

#pragma mark - Button Action
- (void)hideKeyboard
{

    [self.view endEditing:YES];
}

- (void)photoAction
{
    [self hideKeyboard];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    UIImage *thumImg = [image jkImageByFitToWidth:CGRectGetWidth(self.textView.frame)-6];
    
    SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(3.0f, 0.0f,thumImg.size.width,thumImg.size.height)];
    photoView.image = image;
    photoView.delegate = self;
    [self.textView insertObject:photoView size:photoView.bounds.size];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame)-20, 40)];
        _titleLabel.text = @"标题";
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.borderColor = [UIColor grayColor].CGColor;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-55-64-300)];
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (SETextView *)textView{
    if (!_textView) {
        _textView = [[SETextView alloc] initWithFrame:self.scrollView.bounds];
        _textView.backgroundColor = [UIColor orangeColor];
        _textView.editable = YES;
        _textView.lineSpacing = 8.0f;
        _textView.delegate = self;
        
        UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
        inputAccessoryView.backgroundColor = [UIColor orangeColor];
        
        UIButton  *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(10, 7, 30, 30);
        [button1 setBackgroundImage:[UIImage imageNamed:@"photoMark"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:button1];
        
        UIButton  *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(CGRectGetWidth(self.view.frame)-30-10, 7, 30, 30);
        [button2 setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:button2];
        _textView.inputAccessoryView = inputAccessoryView;

        [self.scrollView addSubview:_textView];
    }
    return _textView;
}


@end
