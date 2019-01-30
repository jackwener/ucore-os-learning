# Ucore操作系统

## introduction

Ucore OS Labs是用于清华大学计算机系本科操作系统课程的教学试验内容。

## about ucore

ucore目前支持的硬件环境是基于Intel 80386以上的计算机系统。更多的硬件相关内容（比如保护模式等）将随着实现ucore的过程逐渐展开介绍。那我们准备如何一步一步实现ucore呢？安装一个操作系统的开发过程，我们可以有如下的开发步骤：

  1. bootloader+toy ucore：理解操作系统启动前的硬件状态和要做的准备工作，了解运行操作系统的外设硬件支持，操作系统如何加载到内存中，理解两类中断--“外设中断”，“陷阱中断”，内核态和用户态的区别；
  2. 物理内存管理：理解x86分段/分页模式，了解操作系统如何管理物理内存；
  3. 虚拟内存管理：理解OS虚存的基本原理和目标，以及如何结合页表+中断处理（缺页故障处理）来实现虚存的目标，如何实现基于页的内存替换算法和替换过程；
  4. 内核线程管理：理解内核线程创建、执行、切换和结束的动态管理过程，以及内核线程的运行周期等；
  5. 用户进程管理：理解用户进程创建、执行、切换和结束的动态管理过程，以及在用户态通过系统调用得到内核中各种服务的过程；
  6. 处理器调度：理解操作系统的调度过程和调度算法；
  7. 同步互斥与进程间通信：理解同步互斥的具体实现以及对系统性能的影响，研究死锁产生的原因，如何避免死锁，以及线程/进程间如何进行信息交换和共享；
  8. 文件系统：理解文件系统的具体实现，与进程管理和内存管理等的关系，缓存对操作系统IO访问的性能改进，虚拟文件系统（VFS）、buffer cache和disk driver之间的关系。

其中每个开发步骤都是建立在上一个步骤之上的，就像搭积木，从一个一个小木块，最终搭出来一个小房子。在搭房子的过程中，完成从理解操作系统原理到实践操作系统设计与实现的探索过程。这个房子最终的建筑架构和建设进度如下图所示
>  （！可进一步标注处各个proj在下图中的位置）

![ucore操作系统架构](img/ucore_arch.png)

## resouces that the course provides

[github上课程提供的的simple_os_book](https://github.com/chyyuu/simple_os_book)

**[清华的OS课程地址](http://os.cs.tsinghua.edu.cn/oscourse/OS2017spring#A.2Bi.2F56C4nGmJE-)**

[课程问答集合](https://xuyongjiande.gitbooks.io/os-qa/content/index.html)

[群内精彩答疑](https://chyyuu.gitbooks.io/os_course_qa/content/QQTalk.html)

[gitbook上的在线实验任务书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

[gitbook上课程练习](https://chyyuu.gitbooks.io/os_course_exercises/content/)

[学堂在线提供的清华OS在线课程](http://www.xuetangx.com/courses/course-v1:TsinghuaX+30240243X+sp/about)

[好好利用提供的Pizza问答交流区](https://piazza.com/tsinghua.edu.cn/spring2015/30240243x/home)

## Resources  in my learning   

[一本通俗易懂却内容不错的OS书籍：Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/)     (链接为在线阅读地址)

 [深入理解计算机系统（原书第3版）](https://book.douban.com/subject/26912767/)，感觉可以为OS学习打好基础

[Orange'S:一个操作系统的实现](https://book.douban.com/subject/3735649/)

[Linux内核设计与实现(原书第3版)](https://book.douban.com/subject/6097773/)

[哈工大李治军老师提供的OS课，网易云课堂](https://mooc.study.163.com/course/1000002004#/info)

## furthermore

MIT有一门非常有名并且出色的课程mit-6.828，难度大一些，对个人能力要求高一些。不做过多介绍，在此提一下

希望大家学的开学。

我建了一个大家用于交流OS学习的群：868984501  (作为一个专业非CS，并且无处交流的菜鸡，很苦恼，希望建群给其他人一个交流的地方)