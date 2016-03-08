# Touchs

- Swiper: 可监听各种onSwipe事件
- Touchmover: 可滑动的div
- TouchSelector: 模拟原生select

## Swiper

```
onSwipe: React.PropTypes.func
onSwipeLeft: React.PropTypes.func
onSwipeUpLeft: React.PropTypes.func
onSwipeUp: React.PropTypes.func
onSwipeUpRight: React.PropTypes.func
onSwipeRight: React.PropTypes.func
onSwipeDownRight: React.PropTypes.func
onSwipeDown: React.PropTypes.func
onSwipeDownLeft: React.PropTypes.func
```

## Touchmover

```
Touchmover设置好高度
<Touchmover>
    很长很长的内容
</Touchmover>
```

## TouchSelector

```
data = [
    value: 0
    text: '我啦个擦'
,
    value: 1
    text: '我啦个擦1'
,
    value: 2
    text: '我啦个擦2'
,
    value: 3
    text: '我啦个擦3'
,
    value: 1
    text: '我啦个擦1'
,
    value: 2
    text: '我啦个擦2'
]

<TouchSelector active={3} data={data}></TouchSelector>
```
