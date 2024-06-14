# API SPECIFICATIONS

## Top Module

### Parameter Specifications

#### Constant
| 变量名    | 类型 | 初始值   | 描述 |
| ------- | ---- | ------- | ----------- |
| ScreenH |      | 9'd480  |      屏幕的高度       |
| ScreenW |      | 10'd640 |      屏幕的宽度       |

#### Clocks
| 变量名    | 类型 | 初始值   | 描述 |
| :-------- | :------ | :------- | :----------- |
| pclk               | wire        | 25Mhz  |   用于VGA的时钟信号       |
| animateclk         | wire        | 4Hz  |   用于控制动画的时钟信号       |
| scoreclk           | wire        | 10Hz  |   用于记录分数的时钟信号       |
| refreshclk         | wire        |  60Hz |  用于与VGA刷新同步的时钟信号       |
| bgndclk            | wire        | 500Hz  |   用于背景和障碍物移动的时钟信号       |
| obsclk             | wire        | 0.05Hz  |   用于生成障碍物的时钟信号       |
| cclk               | wire [31:0] | --------  |   板载时钟的分频信号       |

#### State
##### gamestate

决定游戏的整体状态
| 值 |名称    | 描述 |
| --------|-----  | :----------- |
|2'b00|Unbegin |游戏处于未开始阶段，当且仅当复位时或初始时进入该状态|
|2'b01|Running |游戏处于进行阶段，当且仅当按下JUMP键使小恐龙开始跳跃时进入该状态|
|2'b01|Dead |游戏处于结束状态，当且仅当小恐龙与障碍物碰撞时进入该状态|

##### ObstacleSEL
决定障碍物的类型

| 值 |名称    | 描述 |
| --------|-----| :----------- |
|4'b1000|Bird|障碍物的类型为鸟|
|4'b0100|Cac1S|障碍物的类型为单个小型仙人掌|
|4'b0101|Cac1B|障碍物的类型为单个大型仙人掌|
|4'b0110|Cac2S|障碍物的类型为两个小型仙人掌|
|4'b0111|Cac2B|障碍物的类型为两个大型仙人掌|

##### AnimateSel

决定小恐龙的动画类型

| 值 |名称    | 描述 |
| --------|-----| :----------- |
|4'b0000|DinoDefault|小恐龙处于默认站姿|
|4'b0010|DinoDuckL|小恐龙处于蹲下状态并迈出左脚|
|4'b1011|DinoDuckR|小恐龙处于蹲下状态并迈出右脚|
|4'b0001|DinoDead|小恐龙处于死亡动画状态|
|4'b0011|DinoRunL|小恐龙处于正常奔跑状态并迈出左脚|
|4'b0111|DinoRunR|小恐龙处于正常奔跑状态并迈出右脚|

## IP

储存游戏UI、图片的资源

|名称  | 描述 |
|-----| :----------- |
|dist_mem_gen_0| BKG|
|dist_mem_gen_1| DinoDead|
|dist_mem_gen_2| DinoDefault|
|dist_mem_gen_3| DinoLeft|
|dist_mem_gen_4| DinoRight|
|dist_mem_gen_5| DinoDuckRight|
|dist_mem_gen_6| DinoDuckLeft|
|dist_mem_gen_7| Cac1S|
|dist_mem_gen_8| Cac2S|
|dist_mem_gen_9| Cac1B|
|dist_mem_gen_10| Cac2B|
|dist_mem_gen_11| BirdUp|
|dist_mem_gen_12| BirdDown|