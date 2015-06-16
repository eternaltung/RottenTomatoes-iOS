//
//  DetailViewController.m
//  RottenTomatoes
//
//  Created by Shih-Ming Tung on 6/12/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImg;
@property (weak, nonatomic) IBOutlet UIView *detailTextView;

@end

@implementation DetailViewController
@synthesize movie;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = movie[@"title"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@) %@mis",movie[@"title"],movie[@"year"],movie[@"runtime"]];
    [self addDescLabel:movie[@"synopsis"]];
    [self.BackgroundImg setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    [self.BackgroundImg setImageWithURL:[NSURL URLWithString:[self convertToHighResolutionImg:[movie valueForKeyPath:@"posters.thumbnail"]]]];
    
    [self addGesture];
    
}

- (void)addDescLabel:(NSString*)text{
    UILabel *desclabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + 40, self.titleLabel.frame.size.width, [self heightForLabel:self.titleLabel withText:text])];
    desclabel.textColor = [UIColor whiteColor];
    desclabel.numberOfLines = 0;
    desclabel.text = text;
    [self.detailTextView addSubview:desclabel];
}

- (void)addGesture{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(handleSwipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.detailTextView addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleSwipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.detailTextView addGestureRecognizer:swipe];
}

-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:label.font}
                                              context:nil];
    return rect.size.height;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    float duration = 0.5;
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:duration];
            self.detailTextView.frame = CGRectMake(0, self.detailTextView.frame.origin.y - 200, self.detailTextView.frame.size.width, self.detailTextView.frame.size.height);            [UIView commitAnimations];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:duration];
            self.detailTextView.frame = CGRectMake(0, self.detailTextView.frame.origin.y + 200, self.detailTextView.frame.size.width, self.detailTextView.frame.size.height);            [UIView commitAnimations];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)convertToHighResolutionImg:(NSString *)url {
    NSRange range = [url rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *returnstring = url;
    if (range.length > 0) {
        returnstring = [url stringByReplacingCharactersInRange:range withString:@"https://content6.flixster.com/"];
    }
    return returnstring;
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
