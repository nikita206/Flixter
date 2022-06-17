//
//  DetailsViewController.h
//  Flixter
//
//  Created by Nikita Agarwal on 6/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backdropPathView;
@property (weak, nonatomic) IBOutlet UIImageView *posterPathView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSDictionary *detailDict;
@end

NS_ASSUME_NONNULL_END
