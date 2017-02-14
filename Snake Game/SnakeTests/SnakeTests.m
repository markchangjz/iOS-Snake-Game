#import <XCTest/XCTest.h>
#import "MKSnakeModel.h"

@interface SnakeTests : XCTestCase

@end

@implementation SnakeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (BOOL)isEqualPoint1:(MKPoint)point1 andPoint2:(MKPoint)point2
{
	return (point1.x == point2.x) && (point1.y == point2.y);
}

- (void)AssertPoint1:(MKPoint)p1 isEqualPoint2:(MKPoint)p2
{
	XCTAssertTrue([self isEqualPoint1:p1 andPoint2:p2], @"測試點座標必需為 (%luu, %d)",(unsigned long) (unsigned long)p2.x, p2.y);
}

#pragma mark - test

- (void)testSnakePoint
{
	MKPoint snakePoint = MKMakePoint(12, 7);
	
	NSValue *packageValue = [NSValue valueWithSnakePoint:snakePoint];
	
	MKPoint unpackageSnakePoint = [packageValue snakePointValue];
	
	[self AssertPoint1:snakePoint isEqualPoint2:unpackageSnakePoint];
}

- (void)testHitSnakeBody
{
	/*
	 ⏹⏹
	 ⏹⏹
	   ⏹
	 */
	
	MKPoint snakePoint1 = MKMakePoint(0, 1);
	MKPoint snakePoint2 = MKMakePoint(0, 0);
	MKPoint snakePoint3 = MKMakePoint(1, 0);
	MKPoint snakePoint4 = MKMakePoint(1, 1);
	MKPoint snakePoint5 = MKMakePoint(1, 2);
	
	MKSnakeModel *snakeModel = [[MKSnakeModel alloc] init];
	snakeModel.snakePoints = [[NSMutableArray alloc] init];
	
	[snakeModel.snakePoints addObjectsFromArray:@[[NSValue valueWithSnakePoint:snakePoint1],
												  [NSValue valueWithSnakePoint:snakePoint2],
												  [NSValue valueWithSnakePoint:snakePoint3],
												  [NSValue valueWithSnakePoint:snakePoint4],
												  [NSValue valueWithSnakePoint:snakePoint5]]];
	
	XCTAssertFalse([snakeModel isHeadHitSnakeBody], @"尚未撞到身體");
	
	[snakeModel changeMoveDirection:directionRight];
	[snakeModel moveSnake];
	
	XCTAssertTrue([snakeModel isHeadHitSnakeBody], @"已撞到身體");
}

- (void)testEatFruit
{
	// 測試蛇吃到水果後，身體是否有增加
	MKSnakeModel *snakeModel = [[MKSnakeModel alloc] initWithMoveDirection:directionLeft withAreaWidth:24 andAreaHeight:16];
	
	MKPoint snakePoint1 = MKMakePoint(12, 7);
	MKPoint snakePoint2 = MKMakePoint(13, 7);
	
	snakeModel.snakePoints = [[NSMutableArray alloc] init];
	[snakeModel.snakePoints addObjectsFromArray:@[[NSValue valueWithSnakePoint:snakePoint1],
												  [NSValue valueWithSnakePoint:snakePoint2]]];
	
	[snakeModel setFruitPoint:(MKPoint) {.x = 11, .y = 7}];
	
	/*
	 🍎⏹⏹
	 */
	
	[snakeModel moveSnake];
	
	if ([snakeModel isSnakeEatFruit]) {
		[snakeModel increaseSnakeBody];
		[snakeModel putFruit];
	}
	
	XCTAssertEqual(snakeModel.snakePoints.count, (NSUInteger)3, @"吃到水果後，蛇長度要增加至 3");
	
	// 測試吃到水果且向左移動一步後，坐標位置是否正確
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(11, 7)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(12, 7)];
	[self AssertPoint1:[snakeModel.snakePoints[2] snakePointValue] isEqualPoint2:MKMakePoint(13, 7)];
}

- (void)testMoveUp
{
	MKSnakeModel *snakeModel = [[MKSnakeModel alloc] initWithMoveDirection:directionUp withAreaWidth:24 andAreaHeight:16];
	
	// 測試蛇尚未碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(12, 6)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(12, 7)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(12, 5)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(12, 6)];
	
	// 測試蛇碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(12, 0)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(12, 1)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(12, snakeModel.areaHeight - 1)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(12, 0)];
}

- (void)testMoveDown
{
	MKSnakeModel *snakeModel = [[MKSnakeModel alloc] initWithMoveDirection:directionDown withAreaWidth:24 andAreaHeight:16];
	
	// 測試蛇尚未碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(12, 7)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(12, 6)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(12, 8)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(12, 7)];
	
	// 測試蛇碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(12, snakeModel.areaHeight - 1)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(12, snakeModel.areaHeight - 2)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(12, 0)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(12, snakeModel.areaHeight - 1)];
}

- (void)testMoveLeft
{
	MKSnakeModel *snakeModel = [[MKSnakeModel alloc] initWithMoveDirection:directionLeft withAreaWidth:24 andAreaHeight:16];
	
	// 測試蛇尚未碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(12, 7)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(13, 7)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(11, 7)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(12, 7)];
	
	// 測試蛇碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(0, 7)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(1, 7)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(snakeModel.areaWidth - 1, 7)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(0, 7)];
}

- (void)testMoveRight
{
	MKSnakeModel *snakeModel = [[MKSnakeModel alloc] initWithMoveDirection:directionRight withAreaWidth:24 andAreaHeight:16];
	
	// 測試蛇尚未碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(13, 7)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(12, 7)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(14, 7)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(13, 7)];
	
	// 測試蛇碰到邊界區域的移動
	snakeModel.snakePoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithSnakePoint:MKMakePoint(snakeModel.areaWidth - 1, 7)],
																	 [NSValue valueWithSnakePoint:MKMakePoint(snakeModel.areaWidth - 2, 7)]]];
	
	[snakeModel moveSnake];
	
	[self AssertPoint1:[snakeModel.snakePoints[0] snakePointValue] isEqualPoint2:MKMakePoint(0, 7)];
	[self AssertPoint1:[snakeModel.snakePoints[1] snakePointValue] isEqualPoint2:MKMakePoint(snakeModel.areaWidth - 1, 7)];
}

@end
