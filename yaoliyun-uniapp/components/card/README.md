# Card 卡片组件

现代化的卡片容器组件，支持图片展示和多种布局方式。

## 功能特性

- 🎨 **多种卡片类型**：默认、渐变、边框样式
- 🖼️ **图片支持**：支持顶部、底部、左侧、右侧四种图片位置
- 🎭 **图片遮罩**：支持自定义图片遮罩效果
- 📱 **响应式布局**：完美适配各种屏幕尺寸
- 🎯 **交互支持**：卡片点击、图片点击事件
- 🎪 **插槽支持**：header、default、footer插槽
- 🌈 **高度自定义**：颜色、尺寸、圆角等

## 基本用法

### 引入组件

```vue
<script>
import Card from '@/components/card/card.vue'

export default {
  components: {
    Card
  }
}
</script>
```

### 基础卡片

```vue
<card title="基础卡片" subtitle="简单的卡片组件">
  <text>卡片内容</text>
</card>
```

### 带图片的卡片

```vue
<!-- 顶部图片 -->
<card 
  title="商品展示"
  image-src="https://example.com/image.jpg"
  image-position="top"
  :image-height="300"
>
  <text>商品描述内容</text>
</card>

<!-- 左侧图片布局 -->
<card 
  image-src="https://example.com/image.jpg"
  image-position="left"
  :image-width="120"
  :image-height="160"
>
  <text>列表式布局内容</text>
</card>
```

### 渐变背景卡片

```vue
<card 
  type="gradient"
  title="渐变卡片"
  gradient-start="#667eea"
  gradient-end="#764ba2"
>
  <text>渐变背景内容</text>
</card>
```

### 图片遮罩效果

```vue
<card 
  image-src="https://example.com/image.jpg"
  image-position="top"
  image-mask="linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.7) 100%)"
>
  <text>遮罩效果内容</text>
</card>
```

## Props

| 参数 | 说明 | 类型 | 默认值 | 可选值 |
|------|------|------|--------|--------|
| type | 卡片类型 | String | 'default' | default/gradient/bordered |
| title | 标题 | String | '' | - |
| subtitle | 副标题 | String | '' | - |
| imageSrc | 图片地址 | String | '' | - |
| imagePosition | 图片位置 | String | 'top' | top/bottom/left/right |
| imageHeight | 图片高度(rpx) | String/Number | 300 | - |
| imageWidth | 图片宽度(rpx) | String/Number | 200 | - |
| imageMode | 图片模式 | String | 'aspectFill' | uni-app image组件mode |
| imageRadius | 图片圆角(rpx) | String/Number | 0 | - |
| imageMask | 图片遮罩 | String | '' | CSS渐变值 |
| imageLazy | 图片懒加载 | Boolean | true | true/false |
| shadow | 是否显示阴影 | Boolean | true | true/false |
| radius | 圆角大小(rpx) | String/Number | 12 | - |
| padding | 内边距(rpx) | String/Number | 20 | - |
| margin | 外边距(rpx) | String/Number | 0 | - |
| bgColor | 背景颜色 | String | '#ffffff' | - |
| gradientStart | 渐变起始色 | String | '#409EFF' | - |
| gradientEnd | 渐变结束色 | String | '#36CFC9' | - |
| titleColor | 标题颜色 | String | '#333333' | - |
| subtitleColor | 副标题颜色 | String | '#999999' | - |
| clickable | 是否可点击 | Boolean | false | true/false |
| customStyle | 自定义样式 | Object | {} | - |
| customClass | 自定义类名 | String | '' | - |

## Events

| 事件名 | 说明 | 回调参数 |
|--------|------|----------|
| click | 卡片点击时触发 | event |
| image-click | 图片点击时触发 | event |
| image-load | 图片加载完成时触发 | event |
| image-error | 图片加载失败时触发 | event |

## Slots

| 名称 | 说明 |
|------|------|
| default | 默认内容区域 |
| header | 头部内容区域 |
| footer | 底部内容区域 |

## 使用示例

查看 `pages/goods/list.vue` 文件，里面包含了各种卡片样式的完整示例。 