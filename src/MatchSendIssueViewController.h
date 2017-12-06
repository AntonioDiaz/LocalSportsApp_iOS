#import <UIKit/UIKit.h>
#import "MatchEntity+CoreDataProperties.h"

@interface MatchSendIssueViewController : UIViewController {
    MatchEntity *matchEntity;
}

@property MatchEntity *matchEntity;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSportCenter;

@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

- (IBAction)actionSendIssue:(id)sender;

@end
