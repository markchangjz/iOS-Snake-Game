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

@property (retain, nonatomic) NSMutableArray *snakePoints;
@property (assign, nonatomic) MKPoint fruitPoint;
@property (assign, nonatomic) int AreaWidth;
@property (assign, nonatomic) int AreaHeight;

- (id)initWithMoveDirection:(MoveDirection)initDirection withAreaWidth:(int)width andAreaHeight:(int)height;
- (void)moveSnake;
- (void)changeMoveDirection:(MoveDirection)newDirection;

- (BOOL)isHeadHitSnakeBody;
- (BOOL)isSnakeEatFruit;
- (void)increaseSnakeBody;
- (void)putFruit;

@end
