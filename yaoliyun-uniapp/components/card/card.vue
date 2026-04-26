<template>
  <view 
    class="card" 
    :class="[`card--${type}`, `card--${imagePosition}`, customClass, {
      'card--clickable': clickable,
      'card--shadow': shadow
    }]"
    :style="[cardStyle, customStyle]"
    @tap="handleClick"
  >
    <!-- 顶部图片 -->
    <view 
      v-if="imageSrc && imagePosition === 'top'" 
      class="card__image card__image--top"
      :style="imageContainerStyle"
    >
      <image 
        :src="imageSrc" 
        :mode="imageMode"
        :lazy-load="imageLazy"
        class="card__img"
        :style="imageStyle"
        @tap.stop="handleImageClick"
        @error="handleImageError"
        @load="handleImageLoad"
      />
      <view v-if="imageMask" class="card__image-mask" :style="{ background: imageMask }"></view>
    </view>
    
    <!-- 主体内容区域 -->
    <view class="card__body" :class="{ 'card__body--horizontal': isHorizontalLayout }">
      <!-- 左侧图片 -->
      <view 
        v-if="imageSrc && imagePosition === 'left'" 
        class="card__image card__image--left"
        :style="imageContainerStyle"
      >
        <image 
          :src="imageSrc" 
          :mode="imageMode"
          :lazy-load="imageLazy"
          class="card__img"
          :style="imageStyle"
          @tap.stop="handleImageClick"
          @error="handleImageError"
          @load="handleImageLoad"
        />
      </view>
      
      <!-- 内容区域 -->
      <view class="card__content" :style="contentStyle">
        <!-- 头部区域 -->
        <view v-if="title || subtitle || $slots.header" class="card__header">
          <view v-if="title" class="card__title" :style="{ color: titleColor }">{{ title }}</view>
          <view v-if="subtitle" class="card__subtitle" :style="{ color: subtitleColor }">{{ subtitle }}</view>
          <slot name="header"></slot>
        </view>
        
        <!-- 主要内容 -->
        <view class="card__main">
          <slot></slot>
        </view>
        
        <!-- 底部区域 -->
        <view v-if="$slots.footer" class="card__footer">
          <slot name="footer"></slot>
        </view>
      </view>
      
      <!-- 右侧图片 -->
      <view 
        v-if="imageSrc && imagePosition === 'right'" 
        class="card__image card__image--right"
        :style="imageContainerStyle"
      >
        <image 
          :src="imageSrc" 
          :mode="imageMode"
          :lazy-load="imageLazy"
          class="card__img"
          :style="imageStyle"
          @tap.stop="handleImageClick"
          @error="handleImageError"
          @load="handleImageLoad"
        />
      </view>
    </view>
    
    <!-- 底部图片 -->
    <view 
      v-if="imageSrc && imagePosition === 'bottom'" 
      class="card__image card__image--bottom"
      :style="imageContainerStyle"
    >
      <image 
        :src="imageSrc" 
        :mode="imageMode"
        :lazy-load="imageLazy"
        class="card__img"
        :style="imageStyle"
        @tap.stop="handleImageClick"
        @error="handleImageError"
        @load="handleImageLoad"
      />
    </view>
  </view>
</template>

<script>
export default {
  name: 'Card',
  props: {
    // 卡片类型
    type: {
      type: String,
      default: 'default' // default, gradient, bordered
    },
    // 标题
    title: {
      type: String,
      default: ''
    },
    // 副标题
    subtitle: {
      type: String,
      default: ''
    },
    // 图片地址
    imageSrc: {
      type: String,
      default: ''
    },
    // 图片位置
    imagePosition: {
      type: String,
      default: 'top' // top, bottom, left, right
    },
    // 图片高度
    imageHeight: {
      type: [String, Number],
      default: 300
    },
    // 图片宽度（用于左右布局）
    imageWidth: {
      type: [String, Number],
      default: 200
    },
    // 图片模式
    imageMode: {
      type: String,
      default: 'aspectFill'
    },
    // 图片圆角
    imageRadius: {
      type: [String, Number],
      default: 0
    },
    // 图片遮罩
    imageMask: {
      type: String,
      default: ''
    },
    // 图片懒加载
    imageLazy: {
      type: Boolean,
      default: true
    },
    // 是否显示阴影
    shadow: {
      type: Boolean,
      default: true
    },
    // 圆角
    radius: {
      type: [String, Number],
      default: 12
    },
    // 内边距
    padding: {
      type: [String, Number],
      default: 20
    },
    // 外边距
    margin: {
      type: [String, Number],
      default: 0
    },
    // 背景颜色
    bgColor: {
      type: String,
      default: '#ffffff'
    },
    // 渐变起始色
    gradientStart: {
      type: String,
      default: '#409EFF'
    },
    // 渐变结束色
    gradientEnd: {
      type: String,
      default: '#36CFC9'
    },
    // 标题颜色
    titleColor: {
      type: String,
      default: '#333333'
    },
    // 副标题颜色
    subtitleColor: {
      type: String,
      default: '#999999'
    },
    // 是否可点击
    clickable: {
      type: Boolean,
      default: false
    },
    // 自定义样式
    customStyle: {
      type: Object,
      default: () => ({})
    },
    // 自定义类名
    customClass: {
      type: String,
      default: ''
    }
  },
  emits: ['click', 'image-click', 'image-load', 'image-error'],
  computed: {
    isHorizontalLayout() {
      return this.imageSrc && (this.imagePosition === 'left' || this.imagePosition === 'right')
    },
    cardStyle() {
      const style = {
        borderRadius: this.addUnit(this.radius),
        margin: this.addUnit(this.margin)
      }
      
      if (this.type === 'gradient') {
        style.background = `linear-gradient(135deg, ${this.gradientStart} 0%, ${this.gradientEnd} 100%)`
      } else {
        style.backgroundColor = this.bgColor
      }
      
      if (this.type === 'bordered') {
        style.border = '1px solid #e8e8e8'
      }
      
      return style
    },
    imageContainerStyle() {
      const style = {}
      
      if (this.imagePosition === 'left' || this.imagePosition === 'right') {
        style.width = this.addUnit(this.imageWidth)
      }
      
      return style
    },
    imageStyle() {
      const style = {
        width: '100%',
        height: this.addUnit(this.imageHeight)
      }
      
      if (this.imageRadius) {
        const radius = this.addUnit(this.imageRadius)
        if (this.imagePosition === 'top') {
          style.borderTopLeftRadius = radius
          style.borderTopRightRadius = radius
        } else if (this.imagePosition === 'bottom') {
          style.borderBottomLeftRadius = radius
          style.borderBottomRightRadius = radius
        } else {
          style.borderRadius = radius
        }
      }
      
      return style
    },
    contentStyle() {
      return {
        padding: this.addUnit(this.padding),
        flex: this.isHorizontalLayout ? 1 : 'none'
      }
    }
  },
  methods: {
    addUnit(value) {
      if (typeof value === 'number') {
        return `${value}rpx`
      }
      return value
    },
    handleClick(event) {
      if (this.clickable) {
        this.$emit('click', event)
      }
    },
    handleImageClick(event) {
      this.$emit('image-click', event)
    },
    handleImageLoad(event) {
      this.$emit('image-load', event)
    },
    handleImageError(event) {
      this.$emit('image-error', event)
    }
  }
}
</script>

<style lang="scss" scoped>
.card {
  background: #ffffff;
  overflow: hidden;
  transition: all 0.3s ease;
  position: relative;
  
  &--shadow {
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.08);
  }
  
  &--clickable {
    cursor: pointer;
    
    &:hover {
      transform: translateY(-4rpx);
      box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.12);
    }
    
    &:active {
      transform: translateY(-2rpx);
    }
  }
  
  &--gradient {
    color: #ffffff;
    
    .card__title {
      color: #ffffff !important;
    }
    
    .card__subtitle {
      color: rgba(255, 255, 255, 0.8) !important;
    }
  }
  
  &--bordered {
    border: 1rpx solid #e8e8e8;
  }
  
  &__body {
    display: flex;
    flex-direction: column;
    
    &--horizontal {
      flex-direction: row;
      align-items: stretch;
    }
  }
  
  &__image {
    position: relative;
    overflow: hidden;
    
    &--top,
    &--bottom {
      width: 100%;
    }
    
    &--left {
      margin-right: 20rpx;
      flex-shrink: 0;
    }
    
    &--right {
      margin-left: 20rpx;
      flex-shrink: 0;
    }
  }
  
  &__img {
    width: 100%;
    height: 100%;
    display: block;
    transition: transform 0.3s ease;
    
    &:hover {
      transform: scale(1.05);
    }
  }
  
  &__image-mask {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
  }
  
  &__content {
    display: flex;
    flex-direction: column;
  }
  
  &__header {
    margin-bottom: 16rpx;
  }
  
  &__title {
    font-size: 32rpx;
    font-weight: 600;
    line-height: 1.4;
    margin-bottom: 8rpx;
    color: #333333;
  }
  
  &__subtitle {
    font-size: 26rpx;
    line-height: 1.4;
    color: #999999;
  }
  
  &__main {
    flex: 1;
  }
  
  &__footer {
    margin-top: 16rpx;
    padding-top: 16rpx;
    border-top: 1rpx solid #f0f0f0;
  }
}

/* 适配小程序 */
/* #ifdef MP */
.card {
  box-sizing: border-box;
}
/* #endif */

/* 适配APP-NVUE */
/* #ifdef APP-NVUE */
.card {
  border-style: solid;
  border-width: 0;
}

.card__img {
  background-size: cover;
  background-position: center;
}
/* #endif */
</style> 