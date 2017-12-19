#import <UIKit/UIKit.h>
#import "CompetitionEntity+CoreDataProperties.h"


@interface CompetitionTabBarController : UITabBarController
{
    CompetitionEntity *competitionEntity;
    NSManagedObjectContext *managedObjectContext;
    UIBarButtonItem *buttonFavorite;
}

@property CompetitionEntity *competitionEntity;

@end
