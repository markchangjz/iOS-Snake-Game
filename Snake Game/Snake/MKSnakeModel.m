#import "MKSnakeModel.h"

MKPoint MKMakePoint(int pointX, int pointY)
{
    return (MKPoint) {.x = pointX, .y = pointY};
}

@implementation NSValue (PackageSnakePoint)

+ (NSValue *)valueWithSnakePoint:(MKPoint)snakePoint
{
    return [NSValue value:&snakePoint withObjCType:@encode(MKPoint)];
}

- (MKPoint)snakePointValue
{
    MKPoint sp;
    [self getValue:&sp];
    return sp;
}

@end

@implementation MKSnakeModel
{
    MoveDirection moveDirection;
    MKPoint fruitPoint;  
}

- (id)initWithMoveDirection:(MoveDirection)initDirection withAreaWidth:(int)width andAreaHeight:(int)height
{
    if (self = [super init]) {
        moveDirection = initDirection;
        _AreaWidth = width;
        _AreaHeight = height;
                
        [self.snakePoints addObject:[NSValue valueWithSnakePoint:MKMakePoint(12, 7)]];
        [self.snakePoints addObject:[NSValue valueWithSnakePoint:MKMakePoint(13, 7)]];
        
        [self putFruit];
    }

    return self;
}

- (void)moveSnake
{
    MKPoint snakeHeadPoint = [[self.snakePoints objectAtIndex:0] snakePointValue];
    int nextSnakeHeadX = (int)snakeHeadPoint.x;
    int nextSnakeHeadY = (int)snakeHeadPoint.y;
    
    [self.snakePoints removeLastObject];
    
    switch (moveDirection) {
        case directionUp:
            if (--nextSnakeHeadY < 0) {
                nextSnakeHeadY = _AreaHeight - 1;
            }
            break;
        case directionDown:
            if (++nextSnakeHeadY >= _AreaHeight) {
                nextSnakeHeadY = 0;
            }
            break;
        case directionLeft:
            if (--nextSnakeHeadX < 0) {
                nextSnakeHeadX = _AreaWidth - 1;
            }
            break;
        case directionRight:
            if (++nextSnakeHeadX >= _AreaWidth) {
                nextSnakeHeadX = 0;
            }
            break;
        default:
            break;
    }

    [self.snakePoints insertObject:[NSValue valueWithSnakePoint:MKMakePoint(nextSnakeHeadX, nextSnakeHeadY)]
                           atIndex:0];
}

- (void)changeMoveDirection:(MoveDirection)newDirection
{
    // "左右"移動時只能只能更改為"上下"移動
    if (moveDirection == directionLeft || moveDirection == directionRight) {
        if (newDirection == directionUp || newDirection == directionDown) {
            moveDirection = newDirection;
        }
        return;
    }
    
    // "上下"移動時只能只能更改為"左右"移動
    if (moveDirection == directionUp || moveDirection == directionDown) {
        if (newDirection == directionLeft || newDirection == directionRight) {
            moveDirection = newDirection;
        }
        return;
    }
}

- (BOOL)isHeadHitSnakeBody
{
    MKPoint firstSnakePoint = [[self.snakePoints objectAtIndex:0] snakePointValue];
    
    NSMutableArray *snakeBodyWithoutHead = [self.snakePoints mutableCopy];
    [snakeBodyWithoutHead removeObjectAtIndex:0];
    
    for (NSValue *v in snakeBodyWithoutHead) {
        
        MKPoint p =  [v snakePointValue];
        
        if (p.x == firstSnakePoint.x && p.y == firstSnakePoint.y) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isSnakeEatFruit
{
    MKPoint snakeHeadPoint = [[self.snakePoints objectAtIndex:0] snakePointValue];
    
    return (snakeHeadPoint.x == [self fruitPoint].x) && (snakeHeadPoint.y == [self fruitPoint].y);
}

- (void)increaseSnakeBody
{
    MKPoint snakeTailPoint = [[self.snakePoints lastObject] snakePointValue];
    MKPoint beforeSnakeTailPoint = [self.snakePoints[self.snakePoints.count - 2] snakePointValue];
    
    int offsetX = snakeTailPoint.x - beforeSnakeTailPoint.x;
    int offsetY = snakeTailPoint.y - beforeSnakeTailPoint.y;
    
    // 補左
    if ((offsetX == 1 && offsetY == 0) || (offsetX == -(_AreaWidth - 1) && offsetY == 0)) {
        [self.snakePoints addObject:[NSValue valueWithSnakePoint:MKMakePoint(snakeTailPoint.x + 1, snakeTailPoint.y)]];
    }
    // 補右
    else if ((offsetX == -1 && offsetY == 0) || (offsetX == _AreaWidth - 1 && offsetY == 0)) {
        [self.snakePoints addObject:[NSValue valueWithSnakePoint:MKMakePoint(snakeTailPoint.x - 1, snakeTailPoint.y)]];
    }
    // 補上
    else if ((offsetX == 0 && offsetY == -1) || (offsetX == 0 && offsetY == _AreaHeight - 1)) {
        [self.snakePoints addObject:[NSValue valueWithSnakePoint:MKMakePoint(snakeTailPoint.x, snakeTailPoint.y - 1)]];
    }
    // 補下
    else if ((offsetX == 0 && offsetY == 1) || (offsetX == 0 && offsetY == -(_AreaHeight - 1))) {
        [self.snakePoints addObject:[NSValue valueWithSnakePoint:MKMakePoint(snakeTailPoint.x, snakeTailPoint.y + 1)]];
    }
}

- (void)putFruit
{
    BOOL isFruitInSnakeBody = YES;
    
    while (isFruitInSnakeBody) {
        [self setFruitPoint:MKMakePoint(arc4random() % _AreaWidth, arc4random() % _AreaHeight)];
        
        for (NSValue *v in self.snakePoints) {
            
            MKPoint p = [v snakePointValue];
            
            if (p.x == [self fruitPoint].x && p.y == [self fruitPoint].y) {
                isFruitInSnakeBody = YES;
                break;
            }
            else {
                isFruitInSnakeBody = NO;
            }
        }
    }
}

#pragma mark - fruitPoint getter & setter

- (MKPoint)fruitPoint
{
    return fruitPoint;
}

- (void)setFruitPoint:(MKPoint)point
{
    fruitPoint = point;
}

#pragma mark - lazy instantiation

- (NSMutableArray *)snakePoints
{
    if (!_snakePoints) {
        _snakePoints = [[NSMutableArray alloc] init];
    }
    
    return _snakePoints;
}

@end
