
# scrcpy命令行 简单使用说明
命令行工具仓库地址：https://github.com/Genymobile/scrcpy
## 如何有线连接手机
 - Android手机端设置：
   打开 开发者选项->USB调试
 - PC端设置
   - 只有一个安卓手机连接PC的情况下
    `scrcpy -d`
   - 有多个设备连接的情况下
     从命令`adb devices`的第一列中选一个设备ID
     然后通过命令`scrcpy -s ID`连接设备
   
## 如何无线连接手机
### 1. 第一种情况：手头有USB线(优先选择）
 - Android手机端设置：
   打开 开发者选项->USB调试
 - PC端设置：
   初次一键无线命令(通过USB线连接PC)
   `scrcpy --tcpip -d` 如果有多个安卓设备连接PC请用`scrcpy --tcpip -s ID`
   会在命令行后台显示出IP地址和PORT端口号，记录下，下次连的时候用
   ## 然后下次就拔掉USB线通过IP连接了
   `scrcpy --tcpip=IP:PORT`
### 2. 第二种情况：手头没有USB线，但手机安卓系统支持无线调试(好像是Android版本>=10的才支持)
 - Android手机端设置：
   打开 开发者选项->无线调试（打开并记录下IP跟PORT_1）->使用配对码配对设备->记录下用来跟PC配对的IP&端口&配对码三样东西（IP,PORT_2,CODE)
 - PC端设置:
   执行这个命令后`adb pair IP:PORT_2`，按提示输入配对码CODE
   然后就可以通过`scrcpy --tcpip=IP:PORT_1`连接了,还没完

   最好再重新执行下`scrcpy --tcpip -s ID`
## 尾注   
- 注1：上面命令行里大写的变量需要替换成你记录的数字串。
- 注2：遇到奇怪的问题无法连接直接`adb kill-server`，再重试就好了..
- 注3：无线调试会在断开Wifi后自动失效，需要进手机重新开启，所以优选开启USB调试
