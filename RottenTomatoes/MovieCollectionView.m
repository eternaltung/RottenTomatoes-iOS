//
//  MovieCollectionView.m
//  RottenTomatoes
//
//  Created by Shih-Ming Tung on 6/14/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MovieCollectionView.h"
#import "MovieCollectionCell.h"
#import <UIImageView+AFNetworking.h>
#import "DetailViewController.h"

@interface MovieCollectionView () <UISearchBarDelegate>

@property NSArray *filtermovies;

@end

@implementation MovieCollectionView

static NSString * const reuseIdentifier = @"MovieCell";
@synthesize movies;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"MovieCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    [self addSearchBar];
    [self addGesture];
}

// add tap gesture to hide the keyboard
- (void)addGesture{
    UITapGestureRecognizer *uitap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(OnTap:)];
    uitap.cancelsTouchesInView = NO;
    [self.navigationController.navigationBar addGestureRecognizer:uitap];
    [self.view addGestureRecognizer:uitap];
    
    uitap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap:)];
    uitap.cancelsTouchesInView = NO;
    [self.navigationController.navigationBar addGestureRecognizer:uitap];
}

- (void)addSearchBar{
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, 40)];
    [searchbar setPlaceholder:@"search"];
    searchbar.delegate = self;
    searchbar.showsCancelButton = YES;
    [self.view addSubview:searchbar];
}

- (void)viewDidAppear:(BOOL)animated{
    self.filtermovies = movies;
    [self.tabBarController setTitle:@"Search"];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *destination = [segue destinationViewController];
    destination.movie = self.filtermovies[((NSIndexPath*)sender).row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filtermovies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *movie = self.filtermovies[indexPath.row];
    cell.TitleLabel.text = movie[@"title"];
    [cell.PosterImg setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         cell.PosterImg.alpha = 0;
         cell.PosterImg.image = image;
         [UIView animateWithDuration:0.8 animations:^{
             cell.PosterImg.alpha = 1.0;
         }];
     } failure:nil];
    return cell;
}

//size
/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}*/

//collection view margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}*/

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"todetail" sender:indexPath];
}

//filter the movie when text input
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i =0; i< self.movies.count; i++) {
        if ([[((NSDictionary*)self.movies[i])[@"title"] lowercaseString] hasPrefix:[searchBar.text lowercaseString]]) {
            [temp addObject:self.movies[i]];
        }
    }
    self.filtermovies = temp;
    temp = nil;
    [self.collectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.filtermovies = movies;
    [self.collectionView reloadData];
    [self.view endEditing:YES];
}

- (IBAction)OnTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
@end
