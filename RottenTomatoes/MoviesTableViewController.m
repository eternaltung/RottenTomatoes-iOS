//
//  MoviesTableViewController.m
//  RottenTomatoes
//
//  Created by Shih-Ming Tung on 6/12/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MoviesTableViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import "DetailViewController.h"
#import <SVProgressHUD.h>
#import "MovieCollectionView.h"

@interface MoviesTableViewController ()

@property NSArray *movies;

@end

@implementation MoviesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshViewController];
    [self GetJSONData];
    
}

- (void)addNetworkView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    view.backgroundColor = [UIColor colorWithRed:0.1529 green:0.1529 blue:0.047 alpha:0.35];
    UILabel *errorlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    errorlabel.textAlignment = NSTextAlignmentCenter;
    errorlabel.text = @"⚠️ Network error";
    [view addSubview:errorlabel];
    self.tableView.tableHeaderView = view;
}

- (void)viewDidAppear:(BOOL)animated{
    //change the current view title
    [self.tabBarItem.title isEqualToString:@"Movies"] ? [self.tabBarController setTitle:@"Box Office"] : [self.tabBarController setTitle:@"DVD Top Rentals"];
}

- (void)addRefreshViewController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshData{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"loading..."];
    [self performSelector:@selector(GetJSONData) withObject:nil afterDelay:0.5f];
}

- (void) GetJSONData{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    NSString *apikey = @"";
    NSString *url = [self.tabBarItem.title isEqualToString:@"Movies"] ? [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=%@&limit=20",apikey] : [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=%@&limit=20",apikey];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (connectionError == nil)
        {
            self.tableView.tableHeaderView = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
            [self.tableView reloadData];
            
            //set search view data
            MovieCollectionView *collectionview = (MovieCollectionView*)[self.tabBarController.viewControllers objectAtIndex:2];
            collectionview.movies = [[NSArray alloc] init];
            collectionview.movies = self.movies;
        }
        else
        {   //network error
            [self addNetworkView];
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.TitleLabel.text = movie[@"title"];
    cell.CriticsScoreLabel.text = [NSString stringWithFormat:@"%@%%",[movie valueForKeyPath:@"ratings.critics_score"]];
    cell.AudienceScoreLabel.text = [NSString stringWithFormat:@"%@%%",[movie valueForKeyPath:@"ratings.audience_score"]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *destination = [segue destinationViewController];
    destination.movie = self.movies[[self.tableView indexPathForCell:sender].row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
