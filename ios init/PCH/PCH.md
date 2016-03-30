PCH文件的创建和使用

点击项目（文件夹）新建文件 iOS---->Other---->PCH File 点击next 修改名称点击Create
点击项目（文件）Buidl Settings---->输入搜索 prefix header 在Apple LLVM7.0 -Language---->Prefix Header----->$(SRCROOT)/(项目文件夹名)/(pch文件名包括.pch)
在pch文件中添加宏，然后就可以在所有的类中使用该宏