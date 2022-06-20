//
//  MovieViewController.m
//  Flixter
//
//  Created by Nikita Agarwal on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *navigationBar;
@property (nonatomic, strong) NSArray *moviesArray;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (nonatomic,strong) UIRefreshControl *refreshControl;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    [self fetchMovies];
    self.navigationBar.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    return cell;
}


- (void)searchBar:(UISearchBar *)navigationBar textDidChange:(NSString *)searchText {

    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"title"] lowercaseString] containsString:[searchText lowercaseString]];
        }];
        
        self.filteredMovies = [self.moviesArray filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMovies);
        
    }
    else {
        self.filteredMovies = self.moviesArray;
    }
    
    [self.tableView reloadData];
 
}

-(void)fetchMovies {
    //1. create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=29885b77e86b08b548c08281f5c782f2"];
    
    //2. create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    //3. create session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    //4. create our session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies"
                                              message:@"Please check your internet connection and try again."
                                              preferredStyle:UIAlertControllerStyleAlert];
                
               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {}];
                
               [alert addAction:defaultAction];
               [self presentViewController:alert animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // TODO: Get the array of movies
               NSLog(@"%@", dataDictionary);
               // TODO: Store the movies in a property to use elsewhere
               self.moviesArray = dataDictionary[@"results"];
               self.filteredMovies = self.moviesArray;
               // TODO: Reload your table view data
               [self.tableView reloadData];
               // Stop the activity indicator
               // Hides automatically if "Hides When Stopped" is enabled
               [self.activityIndicator stopAnimating];
           }
       }];
    [self.refreshControl endRefreshing];
    //5.
    [task resume];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredMovies.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    
    NSDictionary *dataToPass = self.moviesArray[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

@end
