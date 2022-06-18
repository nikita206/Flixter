//
//  GridViewController.m
//  Flixter
//
//  Created by Nikita Agarwal on 6/17/22.
//

#import "GridViewController.h"
#import "MovieGridCell.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *moviesArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self fetchMovies];
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
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // TODO: Get the array of movies
               NSLog(@"%@", dataDictionary);
               // TODO: Store the movies in a property to use elsewhere
               self.moviesArray = dataDictionary[@"results"];
               // TODO: Reload your table view data
               [self.collectionView reloadData];
           }
       }];
    //5.
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCell" forIndexPath:indexPath];
    NSDictionary *movie = self.moviesArray[indexPath.row];
    NSLog(@"%@", movie[@"title"]);
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    //[cell.MoviePoster setImageWithURL:posterURL];
    [cell.MoviePoster setImageWithURL:posterURL];
    cell.movieLabel.text = movie[@"title"];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.moviesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 4;
    int oddEven = indexPath.row / numberOfCellsPerRow % 2;
    int dimensions = (CGFloat)(totalwidth / numberOfCellsPerRow);
    if (oddEven == 0) {
        return CGSizeMake(dimensions, dimensions);
    } else {
        return CGSizeMake(dimensions, dimensions / 2);
    }
}


@end
