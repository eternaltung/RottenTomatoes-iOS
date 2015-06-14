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
@property (weak, nonatomic) IBOutlet UILabel *DescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImg;

@end

@implementation DetailViewController
@synthesize movie;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = movie[@"title"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@) %@mis",movie[@"title"],movie[@"year"],movie[@"runtime"]];
    self.DescLabel.text = movie[@"synopsis"];
    [self.BackgroundImg setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    [self.BackgroundImg setImageWithURL:[NSURL URLWithString:[self convertToHighResolutionImg:[movie valueForKeyPath:@"posters.thumbnail"]]]];
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
    //NSLog(@"%@",returnstring);
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
