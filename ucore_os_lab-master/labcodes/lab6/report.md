# Lab 6

## 知识点

这些是与本实验有关的原理课的知识点：

* 时间片轮转算法：不过原理课没有考虑实现上的细节，实验需要考虑

此外，本实验还涉及如下知识点：

* 调度器框架
* Stride Scheduling调度算法

遗憾的是，如下知识点在原理课中很重要，但本次实验没有很好的对应：

* 其他调度算法
* 实时调度
* 多处理器调度
* 优先级反置问题解决

## 练习0

首先，需要对之前的代码进行微小的修改：

1. `ticks % TICK_NUM == 0`时，不再将当前进程的`need_resched`置1，因为这是临时的调度策略
2. 每一次时钟中断来临时调用`sched_class_proc_tick`函数，为此还需要将这个函数变为非`static`并在头文件中加入声明

与参考答案相比，参考答案忘记在时钟中断调用`sched_class_proc_tick`了，这是严重的错误。

## 练习1

一般来说，调度器内部会维护一个数据结构，存放目前就绪的进程，基于这个设计，有一些接口。现在，总结调度器接口每个函数的作用或用法：

**init**

初始化调度器内部数据结构。同时清零进程个数计数器。

**enqueue**

将一个（新的）进程放入调度器内部数据结构。同时，将进程个数计数器增加1。

如果是基于时间片的调度算法，并且这个进程时间片用完，则需要分配新的时间片。

**dequeue**

将一个指定的进程从调度器内部数据结构中移除。同时，将进程个数计数器减少1。

**pick_next**

当前进程需要被重新调度，即需要选择一个新的进程运行时，此函数会被调用来从内部数据结构中选出下一个运行的进程。

这个函数可以认为是调度算法的核心。

**proc_tick**

每一次时钟中断，此函数都会被调用。

如果是基于时间片的调度算法，可以在此函数中减少当前进程的时间片。

如果当前进程时间片用完，则置当前进程为需要被重新调度状态。

### 一个例子

下面为简单，记Round Robin调度算法为RR调度器。

假设系统已经初始化好，当前进程剩余时间片为5。

此时，发生了时钟中断，`proc_tick`被调用，该进程时间片减少1后恢复运行，好像没有什么变化。

直到第5次发生时钟中断，`proc_tick`被调用，该进程时间片被减少到0，根据算法，当前进程的`need_resched`被设置为1，说明需要重新调度了。

中断处理程序发现`need_resched`被设置为1后，接下来会调用`schedule`，调度器真正开始发挥作用。

首先，内核会调用`enqueue`将当前进程放入RR调度器队列的尾部，放入时，RR调度器还会将这个进程的时间片增加为算法设定好的时间片最大值。然后，调用`pick_next`从RR调度器队列首部选择下一个占用处理器的进程，如果存在的话，接着还需要调用`dequeue`，将这个进程从RR调度器的队列中取出。如果失败，说明没有可以运行的进行了，内核就让`idle`进程占用处理器。注意，`pick_next`可能返回的进程就是刚刚调用`enqueue`时被放入RR调度器队列的那个进程，不过这不需要特殊处理。

最后，内核调用`proc_run`开始执行新的进程。关于`proc_run`的说明，请见Lab 4实验报告的练习3。

### 多级反馈队列调度算法

调度算法的设计，其实是接口函数的实现的设计。

算法需要为每个优先级维护一个队列，然后维护一个当前优先级的运行状态。同时，还需要为每个进程记录当前所在的优先级，初始化时，优先级为最高优先级。

**init**

初始化算法维护的所有数据结构。

**enqueue**

若该进程时间片为0，说明是新进程或者刚刚用完了时间片，那么不改变其优先级，并将其放入相应优先级的队列中。

否则，说明该进程没有用完时间片，将其优先级降低一级，然后将其放入相应优先级的队列中。

最后，将进程的时间片置为相应优先级应有的时间片。

**dequeue**

从相应优先级的队列中将此进程取出即可。

**pick_next**

首先，根据调度算法维护的当前优先级的运行状态，利用某种调度算法（比如RR调度），选择下一个要执行的进程的优先级。

然后，从相应优先级队列中，取出一个进程返回。

**proc_tick**

这是基于时间片的调度算法，函数的功能或用法同上面所述。

## 练习2

Stride Scheduling调度算法的实现实际上是接口的实现，把接口实现正确，调度算法就可以正常工作了。

算法实现参考MOOC和注释的讲解，Stride Scheduling调度算法与Round Robin调度算法唯一不同之处在于每一次选择的进程是当前`stride`值最小的那个而不是进程队列（可用链表实现）的头。这里，我选用斜堆实现。`run_queue`的`lab6_run_pool`存放斜堆堆顶的指针，这个调度算法实际上就是利用这个堆，每次选择`stride`值最小的进程。特别地，当堆中无进程时，`lab6_run_pool = NULL`。实际上也可以用链表实现，不过，这样查找`stride`值最小的进程并取出的复杂度为O(n)而不是O(logn)了。

与练习1类似，有如下接口的实现需要说明：

**init**

初始化堆，实际上就是赋值`lab6_run_pool = NULL`。

同时也要清零进程个数计数器。

**enqueue**

将新的进程插入斜堆，更新堆顶指针。将进程个数计数器增加1。

如果是基于时间片的调度算法，并且这个进程时间片用完，则需要分配新的时间片。

**dequeue**

将指定的进程从斜堆删除，更新堆顶指针。将进程个数计数器减少1。

**pick_next**

斜堆堆顶就是`stride`值最小的进程，根据Stride Scheduling调度算法，返回它即可。

特别地，对于Stride Scheduling调度算法，此时还需要增加进程的`stride`值，说明这个进程又执行了`pass = BIG_STRIDE / priority`。虽然此时进程还未执行，但是在之后调度到别的进程之前，一定会执行这么多的。

另外，时间片不需要在此函数维护，因为`enqueue`函数已经维护了。

**proc_tick**

与Round Robin调度算法一致，在此函数中减少当前进程的时间片。

如果当前进程时间片用完，则置当前进程为需要被重新调度状态。

### BIG_STRIDE的选取

记`max_stride`为某时刻所有`stride`真实值的最大值，`min_stride`为某时刻所有`stride`真实值的最小值，`PASS_MAX`为每一次`stride`增量的最大值。

对于每一个进程而言，考虑到优先级是`priority`正整数，每一次`stride`的增量`pass`有这样的关系：

`pass = BIG_STRIDE / priority <= BIG_STRIDE`

所以，`PASS_MAX <= BIG_STRIDE`

首先，利用数学归纳法证明`max_stride - min_stride <= PASS_MAX`：

不妨假设进程数多于一个，否则结论立即成立。

*基础*

起初，所有进程的`stride`都为0，所以`max_stride = min_stride = 0`。

某个进程的`stride`被增加后，有`max_stride = pass <= PASS_MAX`，且仍有`min_stride = 0`。

于是`max_stride - min_stride = max_stride <= PASS_MAX`。

*归纳*

根据归纳假设，有`max_stride - min_stride <= PASS_MAX`，为了便于区分，加一个角标，改写为：

`max_stride0 - min_stride0 <= PASS_MAX`，0表示增加`stride`之前的状态

根据算法，原来`min_stride0`的进程需要被变为`min_stride0 + pass <= min_stride0 + PASS_MAX`

**1** 若`min_stride0 + pass <= max_stride0`，则`max_stride`不发生变化，而`min_stride`变大，所以

```
   max_stride - min_stride
 = max_stride0 - min_stride
<= max_stride0 - min_stride0
<= PASS_MAX
```

**2** 否则，若`min_stride0 + pass > max_stride0`，则`max_stride = min_stride0 + pass`，而`min_stride`变大，所以

```
   max_stride - min_stride
 = min_stride0 + pass - min_stride
<= min_stride0 + pass - min_stride0
 = pass
<= PASS_MAX
```

Q.E.D.

于是，`max_stride - min_stride <= PASS_MAX <= BIG_STRIDE`

接着，考虑`BIG_STRIDE`的选取。

由于算法将使用两进程`stride`的差值，并将结果转换为32位有符号数来进行大小判断，因此需要保证任意两个进程`stride`的差值在32位有符号数能够表示的范围之内，即`max_stride - min_stride <= 0x7fffffff`。

立即得到`BIG_STRIDE <= 0x7fffffff`。经过实际测试，`BIG_STRIDE`稍微超过一点（比如取为`0x80000000`），就会导致最后结果混乱。

我的实现与参考答案十分一致，不过没有实现链表的版本。
