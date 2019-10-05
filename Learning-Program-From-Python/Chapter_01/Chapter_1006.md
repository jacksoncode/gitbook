# 附录B virtualenv

一台计算机中可以安装多个版本的Python，而使用virtualenv则可给每个版本的Python创造一个虚拟环境。下面就使用Python附带的pip[^(13)^](part0005.xhtml#ch13){#ch13-back}来安装virtualenv：

------------------------------------------------------------------------

    $pip install virtualenv

------------------------------------------------------------------------

你可以为计算机中某个版本的Python创建一个虚拟空间，比如：

------------------------------------------------------------------------

    $virtualenv –p /usr/bin/python3.5 myenv

------------------------------------------------------------------------

上面的命令中，/usr/bin/python3.5是解释器所在的位置，myenv是新建的虚拟环境的名称。下面命令可开始使用myenv这个虚拟环境：

------------------------------------------------------------------------

    $source myenv/bin/activate

------------------------------------------------------------------------

使用下面命令可退出虚拟环境：

------------------------------------------------------------------------

    $deactivate

------------------------------------------------------------------------

————————————————————

[(1)](part0005.xhtml#ch1-back){#ch1} 很多语言使用{}来表示程序块，比如C、Java和JavaScript。

[(2)](part0005.xhtml#ch2-back){#ch2} 这部电视剧是《蒙提·派森的飞行马戏团》（Monty
Python's Flying
Circus）。这部英国喜剧在当时广受欢迎。蒙提·派森是主创剧团的名字。Python即来自这里的“派森”。

[(3)](part0005.xhtml#ch3-back){#ch3} 即.so文件。

[(4)](part0005.xhtml#ch4-back){#ch4} 罗苏姆充当了社区的决策者。因此，他被称为仁慈的独裁者（Benevolent
Dictator For
Life）。在Python早期，不少Python追随者担心罗苏姆的生命。他们甚至热情讨论：如果罗苏姆出了车祸，Python会怎样。

[(5)](part0005.xhtml#ch5-back){#ch5} python.org

[(6)](part0005.xhtml#ch6-back){#ch6} Python Software Foundation

[(7)](part0005.xhtml#ch7-back){#ch7} Python的解释器是一个运行着的程序。它可以把Python语句一行一行地直接转译运行。

[(8)](part0005.xhtml#ch8-back){#ch8} Hello
World!之所以流行，是因为它被经典编程教材《C程序设计语言》用作例子。

[(9)](part0005.xhtml#ch9-back){#ch9} Homebrew是Mac下的软件包管理工具，其官方网址为：http://brew.sh/。

[(10)](part0005.xhtml#ch10-back){#ch10} Python官网：www.python.org。

[(11)](part0005.xhtml#ch11-back){#ch11} Anaconda官网：www.continuum.io。

[(12)](part0005.xhtml#ch12-back){#ch12} EPD官网：www.enthought.com/products/epd/。

[(13)](part0005.xhtml#ch13-back){#ch13} 将在第3章的附录部分进一步讲解pip的使用。