//
//  ClassificationEntity+CoreDataProperties.m
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "ClassificationEntity+CoreDataProperties.h"

@implementation ClassificationEntity (CoreDataProperties)

+ (NSFetchRequest<ClassificationEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ClassificationEntity"];
}

@dynamic matchesDrawn;
@dynamic matchesLost;
@dynamic matchesPlayed;
@dynamic matchesWon;
@dynamic points;
@dynamic position;
@dynamic team;
@dynamic competition;

@end
