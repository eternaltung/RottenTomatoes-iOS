//
//  MovieCell.h
//  RottenTomatoes
//
//  Created by Shih-Ming Tung on 6/12/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *PosterImg;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CriticsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *AudienceScoreLabel;

@end
