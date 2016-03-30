==============安装===============
在终端中敲入依次敲入命令：

$ gem sources --remove https://rubygems.org/

//等有反应之后再敲入以下命令
$ gem sources -a http://ruby.taobao.org/

为了验证你的Ruby镜像是并且仅是taobao，可以用以下命令查看：
$ gem sources -l
只有在终端中出现下面文字才表明你上面的命令是成功的：
*** CURRENT SOURCES ***

http://ruby.taobao.org/

上面所有的命令完成,你再次在终端中运行：

$ sudo gem install cocoapods


==============使用===============
cd .xcodeproj 的上级目录
然后 pod init  等待......直到 .xcodeproj 的目录出现podfile且命令行可以输入
在podfile中添加你要的库 如
pod ‘AFNetworking’
pod ‘Diplomat’
pod ‘MJRefresh’
pod ‘FMDB’
pod ‘MBProgressHUD’
双引号单引号都可以；
然后在命令行输入 pod update --verbose --no-repo-update 
完成后 你的项目中将会多出.xcworkspace和Pods文件和Podfile.lock文件

需要更新时 只需要输入pod update即可完成更新 添加直接在podfile添加你要的库然后在pod update 这个过程都需要在.xcodeproj 的上级目录