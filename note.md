#NOTE
记录在毕设期间我所接触到的知识
也许会更新（笑）
##PicoScenes
基于Intel 9300网卡的大规模感知阵列系统

通过文本指令进行数据收集，精确到皮秒

###1.安装
blog：https://zpj.io/post/2018-2-2-picoscenes-get-started/
###2.使用

1）命令脚本（txrx.command）准备：

接收命令：

    --local-display-level detail; --interface phy0 --mode logger --freq 5200000000 --rxchainmask 3;

发射命令：

    --interface phy1 --mode injector --freq 5200000000 --inj-freq-repeat 500 --inj-bw 40 --inj-mcs 2 --txchainmask 1 --inj-delay 1000 --ack-bw 40 --ack-mcs 3 --ack-delay 1000

2）环境准备：

需要把网卡阵列调成工作状态

    array_prepare_for_csi_logging all

数据收集：

    sudo PicoScenes -b <txrx.command>

网卡阵列调回正常状态：

    Stop_All_Monitor_Interfaces
    Network-Manager_Unmanaged-for-Array
##CSI——tool
基于Intel 5300网卡的csi接收软件
###0.环境准备

1）准备

ubuntu12.04：系统

csi-tool：本体

matlab：数据处理

2）版本选择

ubuntu-i386 + matlab2011b

或

ubuntu-amd64 + matlab任意版本（推荐这个）
###1.安装

1）环境安装

    sudo apt-get install iw
    sudo apt-get install gcc make linux-headers-$(uname -r) git-core

2）软件包解压

    tar -zxvf csi-tool.tar
    unzip csi-tool.zip

3）安装开始

    cd linux-80211n-csitool
    make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi modules
    sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates modules_install
    sudo depmod

4）执行到上一步会报错"Can’t read private key"，正常反应，接下来在supplyment文件夹外执行下述命令

    for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done
    sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/
    sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode
    make -C linux-80211n-csitool-supplementary/netlink
5）csi-tool安装完毕

blog：https://chenweigao.github.io/2017/11/13/csitool.html

###2.使用

1）修改网络驱动

    sudo modprobe -r iwldvm iwlwifi mac80211
    sudo modprobe iwlwifi connector_log=0x1

2）连接一个没有密码的wifi

3）另开一个终端用来发包

    sudo ping 192.168.1.1 -i 0.002

0.002是相邻包的发射间隔，单位秒

4）收包

    sudo linux-80211n-csitool-supplementary/netlink/log_to_file csi.dat

为了方便处理数据，我写了一个一行的脚本

    sudo linux-80211n-csitool-supplementary/netlink/log_to_file ~/csi_data/$(date +18%m%d_%H%M%S_%N).dat

~/csi_data/是我在home目录下给csi数据准备的文件夹，一次收集一个文件。

估摸着数据量差不多的时候需要手动Ctrl+C强制中断

5）数据处理

打开matlab，把csi-tool-supplyment加入工作路径，然后进入csi数据所在目录，就能进行操作

##Ubuntu下matlab安装

###0.软件准备
Ubuntu任意版本的matlab镜像

###1.安装
1）iso镜像相当于DVD光盘，提前准备一个文件夹用来挂载

    mkdir ~/Matlab

2）挂载iso镜像，类似于插入光盘

    sudo mount -t auto -o loop *dvd.iso所在的绝对路径 ~/Matlab

3）接下来直接安装，安装界面会要求输入产品码

    sudo ~/Matlab/install

4）有的matlab（例：17a）安装镜像是两个，在安装过程中会提醒插入另一张DVD，这时候直接挂载即可

    sudo mount -t auto -o loop *dvd2.iso所在的绝对路径 ~/Matlab

5）安装完毕就是激活，请根据README.MD进行激活

6）解除挂载，之前挂载几次，现在就要解除几次

    sudo umount ~/Matlab

7）删除挂载目录

    sudo rm -r ~/Matlab

8）运行

    sudo matlab安装路径/MATLAB/R2017a/bin/matlab

##Ubuntu小技巧

###脚本运行权限

    chmod +x xxx.sh

执行完毕之后就能用“./”代替bash运行脚本

####别名

比如我性格特别急躁，脚本名字长度超过5我就不想打，这时候我可以给它起个“别名”，一个字母解决

打开终端

    vim .bashrc

在“ ls=‘’ ”的文本下面按照如下格式添加字段

    alias 别名='命令'
    例:alias matlab='sudo /usr/local/MATLAB/R2017a/bin/matlab'

保存退出，关闭终端，再打开，就能用‘matlab’字段打开matlab了
