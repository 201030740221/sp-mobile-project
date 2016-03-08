var assign = require('object-assign');

var components = assign(
    {
        ComponentsMixins: require('./lib/mixins/index'),
        // 程序主体div框架,可有多个视窗，同一时间只显示一个视窗，每个视窗的历史记录应该是独立的
        Container: require('./lib/container'),
        // 视窗，每个视窗可有多个页面，每次有且只会显示一个页面，页面前进后退共享一个历史记录
        View: require('./lib/view'),
        // 页面
        Page: require('./lib/page'),
        // 页面内容
        PageContent: require('./lib/page-content'),
        // 页面内容 下拉加载
        PagePushContent: require('./lib/page-push-content'),
        // 列表
        ListView: require('./lib/list-view'),
        // 标题栏，位于头部
        Navbar: require('./lib/navbar'),
        // 工具栏，位于脚部
        Toolbar: require('./lib/toolbar'),
        // 按钮
        Button: require('./lib/button'),
        // 单行输入框
        Input: require('./lib/input'),
        // 多选框
        Checkbox: require('./lib/checkbox'),
        // 栅格化
        Grid: require('./lib/grid'),
        // 栅格化 - 列
        Col: require('./lib/col'),
        // 链接
        Link: require('./lib/link'),
        // 面板，块状显示
        Panel: require('./lib/panel'),
        // 触摸事件 [https://github.com/reapp/react-tappable]
        Tappable: require('react-tappable'),
        // 图片
        Img: require('./lib/img'),
        // 红点，作提示作用
        Badge: require('./lib/badge'),
        // 数量选择器
        Counter: require('./lib/counter/counter'),
        // 送装日期选择器
        DatePicker: require('./lib/date-picker'),
        // 弹窗
        Modal: require('./lib/modals/modal'),
        // confirm弹窗
        ConfirmModal: require('./lib/modals/confirm-modal'),
        // 带confirm弹窗的元素
        Confirmable: require('./lib/modals/confirmable'),
        // alert
        Alert: require('./lib/modals/alert'),
        // 带alert弹窗的元素
        Alertable: require('./lib/modals/alertable'),
        // 弱提示框
        Message: require('./lib/modals/message'),
        // Loaing Modal
        LoadingModal: require('./lib/modals/loading-modal'),
        // touch
        Swiper: require('./lib/touch-panel/swiper'),
        TouchSelector: require('./lib/touch-panel/touch-selector'),
        Touchmover: require('./lib/touch-panel/touchmover'),
        AutoScrollVertical: require('./lib/touch-panel/auto-scroll-vertical'),
        // Textarea autoHeight
        Textarea: require('./lib/textarea'),
        // 地区选择器
        RegionPicker: require('./lib/region-picker'),
        // 商品清单
        CheckoutGoods: require('./lib/checkout-goods/checkout-goods'),
        // 后退按钮
        BackButton: require('./lib/button-back'),
        // 首页按钮
        HomeButton: require('./lib/button-home'),
        //
        ChoiceCheckbox: require('./lib/choice-checkbox'),
        //Loading
        Loading: require('./lib/loading'),
        //Slider
        Slider: require('./lib/slider'),
        SliderVertical: require('./lib/slider-vertical'),
        SliderHorizontal: require('./lib/slider-horizontal'),
        // Icon
        Icon: require('./lib/icon'),
        // 关键词近似结果提示
        Suggestion: require('./lib/suggestion'),
        // 抽奖-跑马灯
        LotteryMarquee: require('./lib/lottery-marquee'),
        // Tab, TabItem
        Tab: require('./lib/tab').Tab,
        TabItem: require('./lib/tab').TabItem,
        //table-Tab, TabItem
        TableTab: require('./lib/table-tab').Tab,
        TableTabItem: require('./lib/table-tab').TabItem
    }
);

module.exports = components;
