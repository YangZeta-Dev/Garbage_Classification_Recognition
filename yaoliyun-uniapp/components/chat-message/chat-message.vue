<template>
  <view class="chat-message-wrapper">
    <!-- 系统消息 -->
    <view v-if="isSystemMessage" class="system-message">
      <text class="system-text">{{ message.content }}</text>
      <text class="message-time">{{ formattedTime }}</text>
    </view>
    
    <!-- 普通聊天消息 -->
    <view v-else class="chat-message" :class="{ 'own-message': isOwnMessage }">
      <!-- 头像 -->
      <view class="avatar-wrapper" v-if="!isOwnMessage">
        <uv-avatar :text="message.sender" size="32" bgColor="#007AFF"></uv-avatar>
      </view>
      
      <!-- 消息内容 -->
      <view class="message-content">
        <!-- 发送者名称 -->
        <view class="message-header" v-if="!isOwnMessage">
          <text class="sender-name">{{ message.sender }}</text>
          <text class="message-time">{{ formattedTime }}</text>
        </view>
        
        <!-- 消息气泡 -->
        <view class="message-bubble" :class="bubbleClass">
          <text class="bubble-text">{{ message.content }}</text>
        </view>
        
        <!-- 自己消息的时间 -->
        <view class="message-header own-header" v-if="isOwnMessage">
          <text class="message-time">{{ formattedTime }}</text>
        </view>
      </view>
      
      <!-- 自己的头像 -->
      <view class="avatar-wrapper" v-if="isOwnMessage">
        <uv-avatar :text="message.sender" size="32" bgColor="#19be6b"></uv-avatar>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  name: 'ChatMessage',
  props: {
    message: {
      type: Object,
      required: true
    },
    currentUser: {
      type: String,
      default: ''
    }
  },
  
  computed: {
    isSystemMessage() {
      return ['SYSTEM', 'JOIN', 'LEAVE'].includes(this.message.type)
    },
    
    isOwnMessage() {
      return this.message.sender === this.currentUser
    },
    
    bubbleClass() {
      return {
        'own-bubble': this.isOwnMessage,
        'other-bubble': !this.isOwnMessage
      }
    },
    
    formattedTime() {
      return this.formatTime(this.message.timestamp)
    }
  },
  
  methods: {
    formatTime(timestamp) {
      const date = new Date(timestamp)
      const now = new Date()
      const diff = now - date
      
      if (diff < 60000) { // 1分钟内
        return '刚刚'
      } else if (diff < 3600000) { // 1小时内
        return Math.floor(diff / 60000) + '分钟前'
      } else if (date.toDateString() === now.toDateString()) { // 今天
        return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
      } else {
        return date.toLocaleDateString('zh-CN') + ' ' + date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
      }
    }
  }
}
</script>

<style scoped>
.chat-message-wrapper {
  margin-bottom: 15px;
}

.system-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8px 16px;
  background-color: rgba(0, 0, 0, 0.05);
  border-radius: 12px;
  margin: 0 20px;
}

.system-text {
  color: #666;
  font-size: 12px;
  text-align: center;
}

.chat-message {
  display: flex;
  align-items: flex-end;
  gap: 8px;
  padding: 0 10px;
}

.own-message {
  flex-direction: row-reverse;
}

.avatar-wrapper {
  flex-shrink: 0;
}

.message-content {
  flex: 1;
  max-width: 70%;
}

.message-header {
  display: flex;
  align-items: center;
  margin-bottom: 4px;
  gap: 8px;
}

.own-header {
  justify-content: flex-end;
  margin-top: 4px;
  margin-bottom: 0;
}

.sender-name {
  font-size: 12px;
  color: #666;
  font-weight: bold;
}

.message-time {
  color: #999;
  font-size: 10px;
}

.message-bubble {
  padding: 10px 12px;
  border-radius: 12px;
  max-width: 100%;
  word-wrap: break-word;
  position: relative;
}

.other-bubble {
  background-color: #fff;
  border-bottom-left-radius: 4px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.own-bubble {
  background-color: #007AFF;
  border-bottom-right-radius: 4px;
  box-shadow: 0 1px 2px rgba(0, 122, 255, 0.3);
}

.bubble-text {
  font-size: 14px;
  line-height: 1.4;
  color: #333;
}

.own-bubble .bubble-text {
  color: #fff;
}

/* 消息气泡箭头效果 */
.other-bubble::before {
  content: '';
  position: absolute;
  left: -6px;
  bottom: 8px;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 6px 6px 0;
  border-color: transparent #fff transparent transparent;
}

.own-bubble::before {
  content: '';
  position: absolute;
  right: -6px;
  bottom: 8px;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 0 6px 6px;
  border-color: transparent transparent #007AFF transparent;
}
</style>
