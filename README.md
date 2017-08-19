MTSegmentedControl
========

Overview
========
`MTSegmentedControl` is a UIView widget imitate from CocoaTouch's SegmentedControl.

![image](https://github.com/mengtian-li/MTSegmentedControl/raw/master/Screenshots/segmentedControl.gif)

`MTSegmentedControl` can Customize segmented `border widht` `border cornerRadius` `selected color` `unselected color` and so on, which System's Control can't satisfy you

Useage
========
- `git clone` or `download` this project
- drag `MTSegmentControl` and `Category`(as your needed) group to your project
- `#import "MTSegmentedControl.h"`

```
    MTSegmentedControl *segmentControl = [[MTSegmentedControl alloc] initWithItem:@[@"你好",@"再见哇",@"萨瓦迪卡"]];
    segmentControl.frame = CGRectMake(0, 100, 250, 40);
```

License
=======

MIT. See [LICENSE](LICENSE) for details. 


