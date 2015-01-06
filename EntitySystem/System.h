//
//  System.h
//  EntitySystem
//
//  Created by Zoee Silcock on 04/09/14.
//

#import <Foundation/Foundation.h>

@class EntityManager;
@class EntityFactory;

@interface System : NSObject

@property (strong) EntityManager *entityManager;

- (id)initWithEntityManager:(EntityManager *)entityManager;
- (void)update:(float)dt;

@end