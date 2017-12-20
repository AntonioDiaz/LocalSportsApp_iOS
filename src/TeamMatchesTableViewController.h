#import <UIKit/UIKit.h>
#import "CompetitionEntity+CoreDataProperties.h"
#import "FavoriteTeamEntity+CoreDataProperties.h"

@interface TeamMatchesTableViewController : UITableViewController
{
    NSMutableArray *matches;
    FavoriteTeamEntity *favoriteTeamEntity;
    CompetitionEntity *competitionEntity;
    UIBarButtonItem *buttonFavorite;
    BOOL isFavoriteTeam;
}
@property FavoriteTeamEntity *favoriteTeamEntity;
@property CompetitionEntity *competitionEntity;
@end
