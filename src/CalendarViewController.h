#import <UIKit/UIKit.h>
#import "UtilsDataBase.h"

@interface CalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    CompetitionEntity *competitionEntity;
    NSArray *arrayMatches;
    NSMutableIndexSet *sectionsExpanded;
    int numOfWeeks;
    int numMatchesEachWeek;
}
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCalendar;

-(void) reloadDataTable:(CompetitionEntity *) competition;

@end
