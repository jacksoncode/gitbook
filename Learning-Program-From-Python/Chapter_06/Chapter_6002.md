# 6.2 属性管理

### 1．属性覆盖的背后

我们在继承中，提到了Python中属性覆盖的机制。为了深入理解属性覆盖，我们有必要理解Python的\_\_dict\_\_属性。当我们调用对象的属性时，这个属性可能有很多来源。除了来自对象属性和类属性，这个属性还可能是从祖先类那里继承来的。一个类或对象拥有的属性，会记录在\_\_dict\_\_中。这个\_\_dict\_\_是一个词典，键为属性名，对应的值为某个属性。Python在寻找对象的属性时，会按照继承关系依次寻找\_\_dict\_\_。

我们看下面的类和对象，Chicken类继承自Bird类，而summer为Chicken类的一个对象：

------------------------------------------------------------------------

    class Bird(object):
        feather = True

        def chirp(self):
            print("some sound")

    class Chicken(Bird):
        fly = False

        def __init__(self, age):
            self.age = age

        def chirp(self):
            print("ji")

    summer = Chicken(2)
    print("===> summer")
    print(summer.__dict__)

    print("===> Chicken")
    print(Chicken.__dict__)

    print("===> Bird")
    print(Bird.__dict__)

    print("===> object")
    print(object.__dict__)

------------------------------------------------------------------------

下面是我们的输出结果：

------------------------------------------------------------------------

    ===> summer
    {'age': 2}
    ===> Chicken
    {'fly': False, 'chirp': <function chirp at 0x10c550410>, '__module__': '__main__', '__doc__': None, '__init__': <function __init__ at 0x10c550398>}
    ===>Bird
    {'__module__': '__main__', 'chirp': <function chirp at 0x10c550320>, '__dict__': <attribute '__dict__' of 'Bird' objects>, 'feather': True, '__weakref__': <attribute '__weakref__' of 'Bird' objects>, '__doc__': None}
    ===>object
    {'__setattr__': <slot wrapper '__setattr__' of 'object' objects>, '__reduce_ex__': <method '__reduce_ex__' of 'object' objects>, '__new__': <built-in method __new__ of type object at 0x10c14fa80>, '__reduce__': <method '__reduce__' of 'object' objects>, '__str__': <slot wrapper '__str__' of 'object' objects>, '__format__': <method '__format__' of 'object' objects>, '__getattribute__': <slot wrapper '__getattribute__' of 'object' objects>, '__class__': <attribute '__class__' of 'object' objects>, '__delattr__': <slot wrapper '__delattr__' of 'object' objects>, '__subclasshook__': <method '__subclasshook__' of 'object' objects>, '__repr__': <slot wrapper '__repr__' of 'object' objects>, '__hash__': <slot wrapper '__hash__' of 'object' objects>, '__sizeof__': <method '__sizeof__' of 'object' objects>, '__doc__': 'The most base type', '__init__': <slot wrapper '__init__' of 'object' objects>}

------------------------------------------------------------------------

这个顺序是按照与summer对象的亲近关系排列的。第一部分为summer对象自身的属性，也就是age。第二部分为chicken类的属性，比如fly和\_\_init\_\_()方法。第三部分为Bird类的属性，比如feather。最后一部分属于object类，有诸如\_\_doc\_\_之类的属性。

如果我们用内置函数dir来查看对象summer的属性的话，可以看到summer对象包含了全部四个部分。也就是说，对象的属性是分层管理的。对象summer能接触到的所有属性，分别存在summer/Chicken/Bird/object这四层。当我们需要调用某个属性的时候，Python会一层层向下遍历，直到找到那个属性。由于对象不需要重复存储其祖先类的属性，所以分层管理的机制可以节省存储空间。

某个属性可能在不同层被重复定义。Python在向下遍历的过程中，会选取先遇到的那一个。这正是属性覆盖的原理所在。在上面的输出中，我们能看到，Chicken和Bird都有chirp()方法。如果从summer调用chirp()方法，那么使用的将是和对象summer关系更近的Chicken的版本：

------------------------------------------------------------------------

    summer.chirp()    #打印: 'ji'

------------------------------------------------------------------------

子类的属性比父类的同名属性有优先权，这正是属性覆盖的关键。

值得注意的是，上面都是调用属性的操作。如果进行赋值，那么Python就不会分层深入查找了。下面创建一个新的Chicken类的对象autumn，并通过autumn修改feather这一类属性：

------------------------------------------------------------------------

    autumn = Chicken(3)
    autumn.feather = False
    print(summer.feather)         # 打印True

------------------------------------------------------------------------

尽管autumn修改了feather属性值，但它并没有影响到Bird的类属性。当我们使用下面的方法查看autumn的对象属性时，会发现新建了一个名为feather的对象属性。

------------------------------------------------------------------------

    Print(autumn.__dict__)        # 结果: {"age": 3, "feather": False}

------------------------------------------------------------------------

因此，Python在为属性赋值时，只会搜索对象本身的\_\_dict\_\_。如果找不到对应属性，则将在\_\_dict\_\_中增加。在类定义的方法中，如果用self引用对象，则也会遵守相同的规则。

我们可以不依赖继承关系，直接去操作某个祖先类的属性，比如：

------------------------------------------------------------------------

    Bird.feather = 3

------------------------------------------------------------------------

其等效于修改Bird的\_\_dict\_\_：

------------------------------------------------------------------------

    Bird.__dict__["feather"] = 3

------------------------------------------------------------------------

### 2．特性

同一个对象的不同属性之间可能存在依赖关系。当某个属性被修改时，我们希望依赖于该属性的其他属性也同时变化。这时，我们不能通过\_\_dict\_\_的静态词典方式来储存属性。Python提供了多种即时生成属性的方法。其中一种称为**特性**（property）。特性是特殊的属性。比如我们为Chicken类增加一个表示成年与否的特性adult。当对象的年龄（age）超过1时，adult为真，否则为假：

------------------------------------------------------------------------

    class Bird(object):
       feather = True

    class Chicken(Bird):
       fly = False
       def __init__(self, age):
           self.age = age

       def get_adult(self):
           if self.age > 1.0:
               return True
           else:
               return False
       adult = property(get_adult)   # property is built-in

    summer = Chicken(2)
    print(summer.adult)    # 返回True

    summer.age = 0.5
    print(summer.adult)   # 返回False

------------------------------------------------------------------------

特性使用内置函数property()来创建。property()最多可以加载四个参数。前三个参数为函数，分别用于设置获取、修改和删除特性时，Python应该执行的操作。最后一个参数为特性的文档，可以为一个字符串，起说明作用。

下面我们用一个例子来进一步说明：

------------------------------------------------------------------------

    class num(object):
    def __init__(self, value):
        self.value = value

    def get_neg(self):
            return -self.value

    def set_neg(self, value):
        self.value = -value

    def del_neg(self):
        print("value also deleted")
        del self.value

    neg = property(get_neg, set_neg, del_neg, "I'm negative")

    x = num(1.1)
    print(x.neg)              # 打印-1.1
    x.neg = -22
    print(x.value)            # 打印22
    print(num.neg.__doc__)    # 打印"I'm negative"
    del x.neg                 # 打印"value also deleted"

------------------------------------------------------------------------

上面的num为一个数字，而neg为一个特性，用来表示数字的负数。当一个数字确定的时候，它的负数总是确定的。而当我们修改一个数的负数时，它本身的值也应该变化。这两点由get\_neg()和set\_neg()来实现。而del\_neg()表示的是，如果删除特性neg，那么应该执行的操作是删除属性value。property()的最后一个参数（"I'm negative"）为特性neg的说明文档。

### 3．\_\_getattr\_\_()方法

除内置函数property外，我们还可以用\_\_getattr\_\_(self, name)来查询即时生成的属性。当我们调用对象的一个属性时，如果通过\_\_dict\_\_机制无法找到该属性，那么Python就会调用对象的\_\_getattr\_\_()方法，来即时生成该属性，比如：

------------------------------------------------------------------------

    class Bird(object):
    feather = True

    class chicken(Bird):
        fly = False

        def __init__(self, age):
            self.age = age

        def __getattr__(self, name):
            if name == "adult":
               if self.age > 1.0:
                  return True
            else:
                  return False
        else:
            raise AttributeError(name)

    summer = Chicken(2)
    print(summer.adult)     # 打印True

    summer.age = 0.5
    print(summer.adult)     # 打印False
    print(summer.male)      # 抛出AttributeError异常

------------------------------------------------------------------------

每个特性都需要有自己的处理函数，而\_\_getattr\_\_()可以将所有的即时生成属性放在同一个函数中处理。\_\_getattr\_\_()可以根据函数名区别处理不同的属性。比如，上面我们查询属性名male的时候，抛出AttributeError类的错误。需要注意的是，\_\_getattr\_\_()只能用于查询不在\_\_dict\_\_系统中的属性[^(1)^](part0010.xhtml#ch1){#ch1-back}。

\_\_setattr\_\_(self, name, value)和\_\_delattr\_\_(self, name)可用于修改和删除属性。它们的应用面更广，可用于任意属性。

即时生成属性是非常值得了解的概念。在Python开发中，你有可能使用这种方法来更合理地管理对象的属性。即时生成属性还有其他的方式，比如使用descriptor类。有兴趣的读者可以进一步查阅。
