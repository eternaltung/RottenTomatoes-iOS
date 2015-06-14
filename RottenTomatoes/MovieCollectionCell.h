//
//  MovieCollectionCell.h
//  RottenTomatoes
//
//  Created by Shih-Ming Tung on 6/14/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *PosterImg;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@end
