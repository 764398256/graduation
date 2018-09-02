#SpotFi流程

###1.收集数据

1）csi单位数据=发射天线x接收天线x子载波数

在本实验中，csi单位数据是从AP出发，到达网卡时的信道状态信息，包含多径效应

2）csi数据=包数xcsi单位数据

###2.去除STO（sampling time offset）

STO是一个常量，求出STO后按论文公式消除即可

###3.MUSIC算法

csi单位数据大小是3x30，需要按照论文把它修改成30x30,再丢进MUSIC算法中，得到Pmusic矩阵

###4.结果

在Pmusic矩阵中的峰值就是来波角度
