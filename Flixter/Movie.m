//
//  movie.m
//  Flixter
//
//  Created by Nikita Agarwal on 6/21/22.
//

#import "Movie.h"

@implementation Movie
- (id)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];

    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    self.posterUrl = dictionary[@"poster_path"];

    // Set the other properties from the dictionary
    
    return self;
}
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
   // Implement this function
    NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dictionaryOne in dictionaries){
        Movie *movie = [[Movie alloc] initWithDictionary:dictionaryOne];
        [moviesArray addObject: movie];
    }
    return moviesArray;
}
@end
