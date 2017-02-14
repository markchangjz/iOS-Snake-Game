#import <Foundation/Foundation.h>

typedef struct {
    int x;
    int y;
} MKPoint;

MKPoint MKMakePoint(int pointX, int pointY);

typedef enum {
    directionUp,
    directionDown,
    directionLeft,
    directionRight
} MoveDirection;

@interface NSValue (PackageSnakePoint)

+ (NSValue *)valueWithSnakePoint:(MKPoint)snakePoint;
- (MKPoint)snakePointValue;

@end

@interface MKSnakeModel : NSObject

@property (nonatomic) NSMutableArray *snakePoints;
@property (nonatomic) MKPoint fruitPoint;
@property (nonatomic) int areaWidth;
@property (nonatomic) int areaHeight;

- (id)initWithMoveDirection:(MoveDirection)initDirection withAreaWidth:(int)width andAreaHeight:(int)height;
- (void)moveSnake;
- (void)changeMoveDirection:(MoveDirection)newDirection;

- (BOOL)isHeadHitSnakeBody;
- (BOOL)isSnakeEatFruit;
- (void)increaseSnakeBody;
- (void)putFruit;

@end
