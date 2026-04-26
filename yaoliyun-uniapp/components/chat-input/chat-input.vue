<template>
  <view class="chat-input-wrapper">
    <!-- 连接状态输入 -->
    <view v-if="!isConnected" class="connection-input">
      <view class="input-row">
        <uv-input 
          v-model="username" 
          placeholder="请输入用户名" 
          :disabled="isConnecting"
          @confirm="handleConnect"
          :clearable="true"
        ></uv-input>
        <uv-button 
          type="primary" 
          size="small" 
          :loading="isConnecting"
          :disabled="!username.trim()"
          @click="handleConnect"
        >
          {{ isConnecting ? '连接中...' : '连接' }}
        </uv-button>
      </view>
      <view class="connection-tips">
        <uv-icon name="info-circle" color="#999" size="12"></uv-icon>
        <text class="tips-text">输入用户名后点击连接开始聊天</text>
      </view>
    </view>
    
    <!-- 消息输入 -->
    <view v-else class="message-input">
      <!-- 输入框 -->
      <view class="input-row">
        <view class="input-container">
          <uv-input 
            v-model="messageText" 
            placeholder="请输入消息内容..." 
            type="textarea"
            :autoHeight="true"
            :maxlength="maxLength"
            @confirm="handleSend"
            @input="handleInput"
            :showWordLimit="true"
          ></uv-input>
        </view>
        
        <!-- 功能按钮 -->
        <view class="action-buttons">
          <!-- 表情按钮 -->
          <uv-button 
            type="info" 
            size="small"
            plain
            @click="showEmojiPanel"
          >
            😊
          </uv-button>
          
          <!-- 发送按钮 -->
          <uv-button 
            type="primary" 
            size="small"
            :disabled="!canSend"
            @click="handleSend"
          >
            发送
          </uv-button>
        </view>
      </view>
      
      <!-- 工具栏 -->
      <view class="toolbar">
        <view class="toolbar-left">
          <text class="char-count">{{ messageText.length }}/{{ maxLength }}</text>
        </view>
        <view class="toolbar-right">
          <uv-button 
            type="error" 
            size="mini"
            plain
            @click="handleDisconnect"
          >
            断开连接
          </uv-button>
        </view>
      </view>
    </view>
    
    <!-- 表情面板 -->
    <view v-if="showEmoji" class="emoji-panel">
      <view class="emoji-header">
        <text class="emoji-title">选择表情</text>
        <uv-icon name="close" @click="hideEmojiPanel"></uv-icon>
      </view>
      <view class="emoji-grid">
        <text 
          v-for="emoji in emojiList" 
          :key="emoji" 
          class="emoji-item"
          @click="insertEmoji(emoji)"
        >
          {{ emoji }}
        </text>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  name: 'ChatInput',
  props: {
    isConnected: {
      type: Boolean,
      default: false
    },
    isConnecting: {
      type: Boolean,
      default: false
    },
    maxLength: {
      type: Number,
      default: 500
    }
  },
  
  data() {
    return {
      username: '',
      messageText: '',
      showEmoji: false,
      emojiList: [
        '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣',
        '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰',
        '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜',
        '🤪', '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏',
        '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣',
        '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠',
        '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨',
        '😰', '😥', '😓', '🤗', '🤔', '🤭', '🤫', '🤥',
        '😶', '😐', '😑', '😬', '🙄', '😯', '😦', '😧',
        '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐'
      ]
    }
  },
  
  computed: {
    canSend() {
      return this.messageText.trim().length > 0 && this.isConnected
    }
  },
  
  mounted() {
    // 从缓存获取用户名
    const cachedUsername = uni.getStorageSync('chat_username')
    if (cachedUsername) {
      this.username = cachedUsername
    }
  },
  
  methods: {
    // 处理连接
    handleConnect() {
      if (!this.username.trim()) {
        uni.showToast({
          title: '请输入用户名',
          icon: 'none'
        })
        return
      }
      
      this.$emit('connect', this.username.trim())
    },
    
    // 处理断开连接
    handleDisconnect() {
      this.$emit('disconnect')
    },
    
    // 处理发送消息
    handleSend() {
      if (!this.canSend) {
        return
      }
      
      const message = this.messageText.trim()
      this.$emit('send', message)
      this.messageText = ''
      this.hideEmojiPanel()
    },
    
    // 处理输入
    handleInput(value) {
      this.messageText = value
    },
    
    // 显示表情面板
    showEmojiPanel() {
      this.showEmoji = true
    },
    
    // 隐藏表情面板
    hideEmojiPanel() {
      this.showEmoji = false
    },
    
    // 插入表情
    insertEmoji(emoji) {
      this.messageText += emoji
      this.hideEmojiPanel()
    },
    
    // 清空输入
    clearInput() {
      this.messageText = ''
    },
    
    // 设置焦点
    focus() {
      // UniApp中需要通过ref来设置焦点
      this.$nextTick(() => {
        // 这里可以添加设置焦点的逻辑
      })
    }
  }
}
</script>

<style scoped>
.chat-input-wrapper {
  background-color: #fff;
  border-top: 1px solid #e6e6e6;
}

.connection-input {
  padding: 15px;
}

.message-input {
  padding: 10px 15px;
}

.input-row {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  margin-bottom: 8px;
}

.input-container {
  flex: 1;
}

.action-buttons {
  display: flex;
  gap: 8px;
  align-items: flex-end;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 5px;
}

.char-count {
  font-size: 12px;
  color: #999;
}

.connection-tips {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 8px;
  padding: 8px 12px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.tips-text {
  font-size: 12px;
  color: #666;
}

.emoji-panel {
  background-color: #f8f9fa;
  border-top: 1px solid #e6e6e6;
  max-height: 200px;
}

.emoji-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  border-bottom: 1px solid #e6e6e6;
}

.emoji-title {
  font-size: 14px;
  font-weight: bold;
  color: #333;
}

.emoji-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 10px;
  gap: 5px;
  max-height: 150px;
  overflow-y: auto;
}

.emoji-item {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  border-radius: 8px;
  background-color: #fff;
  border: 1px solid #e6e6e6;
}

.emoji-item:active {
  background-color: #f0f0f0;
}

/* 响应式设计 */
@media (max-width: 375px) {
  .input-row {
    flex-direction: column;
    align-items: stretch;
  }
  
  .action-buttons {
    justify-content: flex-end;
    margin-top: 8px;
  }
}
</style>
