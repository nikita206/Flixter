//
//  ColorCell.h
//  Flixter
//
//  Created by Nikita Agarwal on 6/17/22.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieGridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MoviePoster;

@end

NS_ASSUME_NONNULL_END
