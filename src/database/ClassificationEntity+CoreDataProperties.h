//
//  ClassificationEntity+CoreDataProperties.h
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "ClassificationEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClassificationEntity (CoreDataProperties)

+ (NSFetchRequest<ClassificationEntity *> *)fetchRequest;

@property (nonatomic) int32_t matchesDrawn;
@property (nonatomic) int32_t matchesLost;
@property (nonatomic) int32_t matchesPlayed;
@property (nonatomic) int32_t matchesWon;
@property (nonatomic) int32_t points;
@property (nonatomic) int32_t position;
@property (nullable, nonatomic, copy) NSString *team;
@property (nullable, nonatomic, retain) CompetitionEntity *competition;

@end

NS_ASSUME_NONNULL_END
