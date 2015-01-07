EntitySystem for Objective-C
============================

This is a simple entity component system for Objective-C. All credit goes to
Ray Wenderlich who wrote this [awesome article](http://www.raywenderlich.com/24878/introduction-to-component-based-architecture-in-games)
on the subject. That is where I learned to understand the point of the ECS
pattern and much of the code here is from that article.

Overview of the ECS pattern
---------------------------

The three parts of ECS are entity, component and system. Components hold data
or state, systems hold the game logic and entities are the glue that holds it
all together. An entity has a unique identifier and as many components as is
applicable. A system would usually work on a specific component but there is no
hard connection there. This way you can easily reuse components and systems in
different combinations when composing your entities. For that reason systems
and components should be as generic as possible.

There are many advantages to the ECS pattern when building games and it has
helped me to avoid some of the pitfalls of inheritance based design which would
have been my first instinct. But don't take my word for it, read the article
above, Ray explains it all so well.

Usage
=====

Most likely the first component you will write is your render component, this
holds the sprite instance and is specific to the framework you are using. This
example shows how it could be done in cocos2d.

RenderComponent.h
```objective-c
#import "Component.h"
#import "cocos2d.h"

@interface RenderComponent : Component
@property (strong) CCNode *node;
- (id)initWithNode:(CCNode *)node;
@end
```

RenderComponent.m
```objective-c
#import "RenderComponent.h"

@implementation RenderComponent

- (id)initWithNode:(CCNode *)node {
    if ((self = [super init])) {
        self.node = node;
    }
    return self;
}

@end
```

Initialize the entity manager in your game scene. You will usually want to make
an entity factory for creating your entities but we'll keep it simple and
create the entity and add it's component on initialization.
```objective-c
#import "GameScene.h"

@implementation GameScene {
    EntityManager *_entityManager;
}
    - (void)didLoadFromCCB {
        _entityManager = [[EntityManager alloc] init];
        Entity *entity = [_entityManager createEntity];
        CCSprite *sprite = (CCSprite*)[CCSprite spriteWithImageNamed:@"Sprites/super_awesome_sprite.png"];
        [_entityManager addComponent:[[RenderComponent alloc] initWithNode:sprite] toEntity:entity];
        // ...
    }
@end
```

This would be the simplest example of an entity. You can now access the render
component on the entity and find the entity via the entity manager.

```objective-c
RenderComponent *render = (RenderComponent *)[_entityManager getComponentOfClass:[RenderComponent class] forEntity:self];
NSArray *entities = [_entityManager getAllEntitiesPosessingComponentOfClass:[RenderComponent class]];
```

The former gets rather clunky in the long run so I like to declare a category
for the Entity class where I add methods for accessing my components thusly.

Entity+MyEntity.h
```objective-c
#import "Entity.h"

@interface Entity (MyEntity)
- (RenderComponent *)render;
@end
```

MyEntity.m
```objective-c
#import "Entity+MyEntity.h"
#import "EntityManager.h"

@implementation Entity (MyEntity)
- (RenderComponent *)render {
    return (RenderComponent *)[self.entityManager getComponentOfClass:[RenderComponent class] forEntity:self];
}
@end
```

This way I can access the render component on any Entity using the dot notation
by simply importing "Entity+MyEntity.h".
```objective-c
entity.render.node.position = ccp(0.f, 0.f);
```

Now that we have an entity with a component lets look at the last piece of the
puzzle, let's create a system. A system encapsulates a part of the game logic
and should at least implement the update method which you will call on each
iteration of the game loop.

MoveSystem.h
```objective-c
#import "System.h"

@interface MoveSystem : System
- (void)update:(float)delta;
@end
```

MoveSystem.m
```objective-c
#import "Entity+MyEntity.h"
#import "MoveSystem.h"

@implementation MoveSystem
- (void)update:(float)delta {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[RenderComponent class]];

    for (Entity *entity in entities) {
        entity.render.position.x += delta * 0.1f;
    }
}
@end
```

This simple movement system will find all entities with a RenderComponent and
move it's sprite on the x axis based on how much time has passed. The update
method needs to be called from your game loop. Continuing on our cocos2d based
game scene from above it would look like this.

GameScene.m
```objective-c
#import "GameScene.h"

@implementation GameScene {
     EntityManager *_entityManager;
}
  - (void)didLoadFromCCB {
        // ...
        moveSystem = [[MoveSystem alloc] initWithEntityManager:_entityManager];
    }

    - (void)update:(CCTime)delta {
        // ...
        [moveSystem update:delta];
    }
@end
```

Finding entities
----------------

As I mentioned above the main way for systems to find entities to do work on is
to find all entities with a specific component.

```objective-c
NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[RenderComponent class]];
```

But I quickly found that you don't always want to work on entities based on
which components they have. Either your system doesn't have a component or it
works on a subset of a certain component. Therefore I decided to add a built in
component called the TagsComponent. By adding this component to your entity
you can add one or more tags in the form of NSStrings.

Add the component.
```objective-c
[_entityManager addComponent:[[TagsComponent alloc] initWithTags:@[@"my_super_awesome_tag"]] toEntity:entity];
```

Then you can find all entities with this tag using getAllEntitiesPosessingTag.
```objective-c
NSArray *entities = [self.entityManager getAllEntitiesPosessingTag:@"my_super_awesome_tag"];
```

You can also access entities by their unique ID in case you happen to have it.
```objective-c
Entity *entity = [self.entityManager getEntityById:1337];
```

The entity manager is really just an array of entities so you could slice it
in an infinite amount of ways but I have only found one other way that I've
needed thus far. In my game I have a method for finding an entity by it's
sprite instance. It's very useful in certain cases but it's specific to cocos2d
so I decided to not include it. If you find a useful way of finding or
filtering entites let me know.

Contributing
============

I'm pretty new to Objective-C and game development so I would appreciate any
input, thoughts, bug fixes, optimizations etc!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
