//
//  TeamMatchTableViewCell.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 8/12/17.
//  Copyright © 2017 cice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMatchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTeamLocal;
@property (weak, nonatomic) IBOutlet UILabel *labelTeamVisitor;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;

@end
