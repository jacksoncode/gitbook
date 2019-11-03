# 7.3 小女子的梳妆匣

### 1．装饰器

**装饰器**（decorator）是一种高级Python语法。装饰器可以对一个函数、方法或者类进行加工。在Python中，我们有多种方法对函数和类进行加工。装饰器从操作上入手，为函数增加额外的指令。因此，装饰器看起来就像是女孩子的梳妆匣，一番打扮之后让函数大变样。Python最初没有装饰器这一语法。装饰器在Python 2.5中才出现，最初只用于函数。在Python 2.6以及之后的Python版本中，装饰器被进一步用于类。

我们先定义两个简单的数学函数，一个用来计算平方和，一个用来计算平方差：

------------------------------------------------------------------------

    # 获得平方和
    def square_sum(a, b):
        return a**2 + b**2  # get square diff

    # 获得平方差
    def square_diff(a, b):
        return a**2 - b**2

    if __name__ == "__main__":
       print(square_sum(3, 4))               # 打印25
       print(square_diff(3, 4)               # 打印-7

------------------------------------------------------------------------

在拥有了基本的数学功能之后，我们可能想为函数增加其他的功能，比如打印输入。我们可以改写函数来实现这一点：

------------------------------------------------------------------------

    # 装饰：打印输入

    def square_sum(a, b):
        print("intput:", a, b)
        return a**2 + b**2

    def square_diff(a, b):
        print("input", a, b)
        return a**2 - b**2

    if __name__ == "__main__":
        print(square_sum(3, 4))
        print(square_diff(3, 4))

------------------------------------------------------------------------

我们修改了函数的定义，为函数增加了功能。从代码中可以看到，这两个函数在功能上的拓展有很高的相似性，都是增加了print("input",
a,
b)这一打印功能。我们可以改用装饰器，定义功能拓展本身，再把装饰器用于两个函数：

------------------------------------------------------------------------

    def decorator_demo(old_function):
        def new_function(a, b):
            print("input", a, b)      # 额外的打印操作
            return old_function(a, b)
        return new_function

    @decorator_demo
    def square_sum(a, b):
        return a**2 + b**2

    @decorator_demo
    def square_diff(a, b):
        return a**2 - b**2

    if __name__ == "__main__":
        print(square_sum(3, 4))
        print(square_diff(3, 4))

------------------------------------------------------------------------

装饰器可以用def的形式定义，如上面代码中的decorator\_demo()。装饰器接收一个可调用对象作为输入参数，并返回一个新的可调用对象。装饰器新建了一个函数对象，也就是上面的new\_function()。在new\_function()中，我们增加了打印的功能，并通过调用old\_function(a, b)来保留原有函数的功能。

定义好装饰器后，我们就可以通过@语法使用了。在函数square\_sum()和square\_diff()定义之前调用@decorator\_demo，实际上是将square\_sum()或square\_diff()传递给了decorator\_demo()，并将decorator\_demo()返回的新的函数对象赋给原来的函数名square\_sum()和square\_diff()。所以，当我们调用square\_sum(3, 4)的时候，实际上发生的是：

------------------------------------------------------------------------

    square_sum = decorator_demo(square_sum)
    square_sum(3, 4)

------------------------------------------------------------------------

我们知道，Python中的变量名和对象是分离的。变量名其实是指向一个对象的引用。从本质上，装饰器起到的作用就是**名称绑定**（name binding），让同一个变量名指向一个新返回的函数对象，从而达到修改函数对象的目的。只不过，我们很少彻底地更改函数对象。在使用装饰器时，我们往往会在新函数内部调用旧的函数，以便保留旧函数的功能。这也是“装饰”名称的由来。

下面看一个更有实用功能的装饰器。我们可以利用time包来测量程序运行的时间。把测量程序运行时间的功能做成一个装饰器，将这个装饰器运用于其他函数，将显示函数的实际运行时间：

------------------------------------------------------------------------

    import time

    def decorator_timer(old_function):
        def new_function(*arg, **dict_arg):
            t1 = time.time()
            result = old_function(*arg, **dict_arg)
            t2 = time.time()
            print("time: ", t2 - t1)
            return result
        return new_function

------------------------------------------------------------------------

在new\_function()中，除调用旧函数外，还前后额外调用了一次time.time()。由于time.time()返回挂钟时间，它们的差值反映了旧函数的运行时间。此外，我们通过打包参数的办法，可以在新函数和旧函数之间传递所有的参数。

装饰器可以实现代码的可复用性。我们可以用同一个装饰器修饰多个函数，以便实现相同的附加功能。比如说，在建设网站服务器时，我们能用不同函数表示对不同HTTP请求的处理。当我们在每次处理HTTP请求前，都想附加一个客户验证功能时，那么就可以定义一个统一的装饰器，作用于每一个处理函数。这样，程序能重复利用，可读性也大为提高。

### 2．带参装饰器

在上面的装饰器调用中，比如@decorator\_demo，该装饰器默认它后面的函数是唯一的参数。装饰器的语法允许我们调用decorator时，提供其他参数，比如@decorator(a)。这样，就为装饰器的编写和使用提供了更大的灵活性。

------------------------------------------------------------------------

    # 带参装饰器
    def pre_str(pre=""):
        def decorator(old_function):
            def new_function(a, b):
                print(pre + "input", a, b)
                return old_function(a, b)
            return new_function
        return decorator

    # 装饰square_sum()
    @pre_str("^_^")
    def square_sum(a, b):
        return a**2 + b**2  # get square diff

    # 装饰square_diff()
    @pre_str("T_T")
    def square_diff(a, b):
        return a**2 - b**2

    if __name__ == "__main__":
        print(square_sum(3, 4))
        print(square_diff(3, 4))

------------------------------------------------------------------------

上面的pre\_str是一个带参装饰器。它实际上是对原有装饰器的一个函数封装，并返回一个装饰器。我们可以将它理解为一个含有环境参量的闭包。当我们使用@pre\_str("\^\_\^")调用的时候，Python能够发现这一层的封装，并把参数传递到装饰器的环境中。该调用相当于：

------------------------------------------------------------------------

    square_sum = pre_str("^_^") (square_sum)

------------------------------------------------------------------------

根据参数不同，带参装饰器会对函数进行不同的加工，进一步提高了装饰器的适用范围。还是以网站的用户验证为例子。装饰器负责验证的功能，装饰了处理HTTP请求的函数。可能有的关键HTTP请求需要管理员权限，有的只需要普通用户权限。因此，我们可以把“管理员”和“用户”作为参数，传递给验证装饰器。对于那些负责关键HTTP请求的函数，我们可以把“管理员”参数传给装饰器。对于负责普通HTTP请求的函数，我们可以把“用户”参数传给它们的装饰器。这样，同一个装饰器就可以满足不同的需求了。

### 3．装饰类

在上面的例子中，装饰器接收一个函数，并返回一个函数，从而起到加工函数的效果。装饰器还拓展到了类。一个装饰器可以接收一个类，并返回一个类，从而起到加工类的效果。

------------------------------------------------------------------------

    def decorator_class(SomeClass):
        class NewClass(object):
           def __init__(self, age):
           self.total_display  = 0
           self.wrapped         = SomeClass(age)
        def display(self):
           self.total_display += 1
           print("total display", self.total_display)
           self.wrapped.display()
    return NewClass

    @decorator_class
    class Bird:
        def __init__(self, age):
            self.age = age
        def display(self):
            print("My age is",self.age)

    if __name__ == "__main__":
        eagle_lord = Bird(5)
        for i in range(3):
            eagle_lord.display()

------------------------------------------------------------------------

在装饰器decorator\_class中，我们返回了一个新类NewClass。在新类的构造器中，我们用一个属性self.wrapped记录了原来类生成的对象，并附加了新的属性total\_display，用于记录调用display()的次数。我们也同时更改了display方法。通过装饰，我们的Bird类可以显示调用display()的次数。

无论是装饰函数，还是装饰类，装饰器的核心作用都是名称绑定。虽然装饰器端出现较晚，但在各个Python项目中的使用却很广泛。即便不需要自定义装饰器，你也很有可能会在自己的项目中调用其他库中的装饰器。因此，Python程序员需要掌握这一语法。
