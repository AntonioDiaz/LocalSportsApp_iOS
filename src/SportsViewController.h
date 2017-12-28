#import <UIKit/UIKit.h>
#import "Utils.h"

@interface SportsViewController : UIViewController <GADBannerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSManagedObjectContext *managedObjectContext;
    NSArray *arraySports;
    NSString *sportSelectedTag;
}


@property(nonatomic, strong) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *viewHostingBanner;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSports;

@end
