//
//  TeamEntity+CoreDataProperties.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 19/12/17.
//  Copyright © 2017 cice. All rights reserved.
//
//

#import "TeamEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TeamEntity (CoreDataProperties)

+ (NSFetchRequest<TeamEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *teamName;
@property (nonatomic) BOOL isFavorite;
@property (nullable, nonatomic, retain) CompetitionEntity *competition;

@end

NS_ASSUME_NONNULL_END
