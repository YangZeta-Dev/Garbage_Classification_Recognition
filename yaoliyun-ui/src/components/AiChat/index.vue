<template>
  <el-drawer
    title="AI智能助手"
    :visible.sync="visible"
    :with-header="true"
    :before-close="handleClose"
    direction="rtl"
    :size="drawerSize"
    :modal="true"
    :close-on-click-modal="true"
    :modal-append-to-body="false"
    :append-to-body="true"
    class="ai-chat-drawer"
    @opened="handleOpened"
    @closed="handleClosed"
  >
    <div class="ai-chat-container">
      <!-- 聊天消息区域 -->
      <div class="chat-messages" ref="messagesContainer">
        <div
          v-for="(message, index) in messages"
          :key="index"
          :class="['message-item', message.role]"
        >
          <div class="message-avatar">
            <i :class="message.role === 'user' ? 'el-icon-user' : 'el-icon-cpu'"></i>
          </div>
          <div class="message-content">
            <div class="message-text" v-html="formatMessage(message.content)"></div>
            <div class="message-time">{{ formatTime(message.timestamp) }}</div>
          </div>
        </div>
        
        <!-- 加载状态 -->
        <div v-if="loading" class="message-item assistant">
          <div class="message-avatar">
            <i class="el-icon-cpu"></i>
          </div>
          <div class="message-content">
            <div class="message-text">
              <span class="typing-indicator">
                <span></span>
                <span></span>
                <span></span>
              </span>
              AI正在思考中...
            </div>
          </div>
        </div>
      </div>
      
      <!-- 输入区域 -->
      <div class="chat-input-area">
        <el-input
          ref="chatInput"
          v-model="inputMessage"
          type="textarea"
          :rows="3"
          placeholder="请输入您的问题..."
          :disabled="loading"
          @keydown.ctrl.enter.native="handleCtrlEnter"
          @keydown.native="handleKeydown"
          class="chat-input"
        ></el-input>
        <div class="input-actions">
          <div class="input-tips">
            <span>💡 Ctrl + Enter 快速发送</span>
          </div>
          <div class="input-buttons">
            <el-button @click="clearMessages" size="small" type="info" plain>清空</el-button>
            <el-button 
              @click="sendMessage" 
              size="small" 
              type="primary" 
              :loading="loading"
              :disabled="!inputMessage.trim()"
            >
              发送
            </el-button>
          </div>
        </div>
      </div>
    </div>
  </el-drawer>
</template>

<script>
import { simpleChat, conversation } from '@/api/ai'

export default {
  name: 'AiChat',
  props: {
    value: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      inputMessage: '',
      loading: false,
      messages: [],
      screenWidth: window.innerWidth
    }
  },
  computed: {
    visible: {
      get() {
        return this.value
      },
      set(val) {
        this.$emit('input', val)
      }
    },
    drawerSize() {
      if (this.screenWidth <= 768) {
        return '100%' // 移动端全屏
      } else if (this.screenWidth <= 1024) {
        return '60%' // 平板端60%
      } else if (this.screenWidth <= 1440) {
        return '500px' // 中等桌面端
      } else if (this.screenWidth <= 1920) {
        return '600px' // 大桌面端
      } else {
        return '700px' // 超大屏幕
      }
    }
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        if (this.messages.length === 0) {
          this.initChat()
        }
        // 抽屉打开后自动聚焦到输入框
        this.$nextTick(() => {
          setTimeout(() => {
            if (this.$refs.chatInput) {
              this.$refs.chatInput.focus()
            }
          }, 300) // 等待抽屉动画完成
        })
      }
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    // 添加全局键盘事件监听器
    document.addEventListener('keydown', this.handleGlobalKeydown)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
    document.removeEventListener('keydown', this.handleGlobalKeydown)
  },
  methods: {
    // 初始化聊天
    initChat() {
      this.messages = [
        {
          role: 'assistant',
          content: '您好！我是AI智能助手，有什么可以帮助您的吗？',
          timestamp: new Date()
        }
      ]
    },
    
    // 发送消息
    async sendMessage() {
      console.log('sendMessage 被调用')
      if (!this.inputMessage.trim() || this.loading) {
        console.log('消息为空或正在加载，取消发送')
        return
      }
      
      const userMessage = this.inputMessage.trim()
      this.inputMessage = ''
      
      // 添加用户消息
      this.messages.push({
        role: 'user',
        content: userMessage,
        timestamp: new Date()
      })
      
      this.scrollToBottom()
      this.loading = true
      
      try {
        // 调用AI接口
        const response = await simpleChat({ message: userMessage })
        console.log(response)
        // 添加AI回复
        this.messages.push({
          role: 'assistant',
          content: response.msg || '抱歉，我暂时无法回答这个问题。',
          timestamp: new Date()
        })
      } catch (error) {
        console.error('AI聊天失败:', error)
        this.messages.push({
          role: 'assistant',
          content: '抱歉，服务暂时不可用，请稍后再试。',
          timestamp: new Date()
        })
        this.$message.error('AI聊天失败: ' + (error.message || '未知错误'))
      } finally {
        this.loading = false
        this.scrollToBottom()
      }
    },
    
    // 清空消息
    clearMessages() {
      this.$confirm('确定要清空所有聊天记录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.messages = []
        this.initChat()
      }).catch(() => {})
    },
    
    // 格式化消息内容
    formatMessage(content) {
      if (!content) return ''
      
      // 简单的换行处理
      return content.replace(/\n/g, '<br>')
    },
    
    // 格式化时间
    formatTime(timestamp) {
      const now = new Date()
      const time = new Date(timestamp)
      const diff = now - time
      
      if (diff < 60000) { // 1分钟内
        return '刚刚'
      } else if (diff < 3600000) { // 1小时内
        return Math.floor(diff / 60000) + '分钟前'
      } else if (diff < 86400000) { // 24小时内
        return time.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
      } else {
        return time.toLocaleDateString('zh-CN') + ' ' + time.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
      }
    },
    
    // 滚动到底部
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.messagesContainer
        if (container) {
          container.scrollTop = container.scrollHeight
        }
      })
    },
    
    // 关闭抽屉
    handleClose() {
      this.visible = false
      // 确保页面恢复正常状态
      this.$nextTick(() => {
        document.body.style.overflow = ''
        // 移除可能的模态层影响
        const modalElements = document.querySelectorAll('.v-modal')
        modalElements.forEach(el => {
          if (el.style.zIndex < 2000) { // 只移除低层级的模态层
            el.remove()
          }
        })
      })
    },

    // 处理窗口大小变化
    handleResize() {
      this.screenWidth = window.innerWidth
    },

    // 抽屉打开事件
    handleOpened() {
      this.$emit('opened')
      // 确保输入框聚焦
      this.$nextTick(() => {
        setTimeout(() => {
          if (this.$refs.chatInput) {
            this.$refs.chatInput.focus()
          }
        }, 100)
      })
    },

    // 抽屉关闭事件
    handleClosed() {
      this.$emit('closed')
    },

    // 处理Ctrl+Enter快捷键
    handleCtrlEnter(event) {
      event.preventDefault()
      event.stopPropagation()
      this.sendMessage()
    },

    // 处理键盘事件
    handleKeydown(event) {
      // 调试日志
      if (event.ctrlKey && event.keyCode === 13) {
        console.log('Ctrl+Enter 被触发 (输入框事件)')
        event.preventDefault()
        event.stopPropagation()
        this.sendMessage()
        return false
      }
    },

    // 全局键盘事件处理
    handleGlobalKeydown(event) {
      // 只在抽屉打开且焦点在输入框时处理
      if (this.visible && event.ctrlKey && event.keyCode === 13) {
        const activeElement = document.activeElement
        const isInChatInput = activeElement && (
          activeElement === this.$refs.chatInput?.$el?.querySelector('textarea') ||
          activeElement.closest('.ai-chat-drawer')
        )

        if (isInChatInput) {
          console.log('Ctrl+Enter 被触发 (全局事件)')
          event.preventDefault()
          event.stopPropagation()
          this.sendMessage()
          return false
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.ai-chat-drawer {
  ::v-deep .el-drawer {
    min-width: 350px; // 设置最小宽度
  }

  ::v-deep .el-drawer__wrapper {
    z-index: 2000 !important;
  }

  ::v-deep .el-drawer__body {
    padding: 0;
    display: flex;
    flex-direction: column;
  }

  ::v-deep .el-drawer__header {
    padding: 20px 24px;
    border-bottom: 1px solid #ebeef5;
    margin-bottom: 0;
    background: linear-gradient(135deg, #409EFF 0%, #764ba2 100%);
    color: white;

    span {
      font-size: 18px;
      font-weight: 600;
      color: white;
    }

    .el-drawer__close-btn {
      color: white;
      font-size: 20px;

      &:hover {
        color: rgba(255, 255, 255, 0.8);
      }
    }
  }
}

.ai-chat-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px 24px;
  background: linear-gradient(to bottom, #f8f9fa 0%, #ffffff 100%);

  .message-item {
    display: flex;
    margin-bottom: 16px;
    
    &.user {
      flex-direction: row-reverse;
      
      .message-content {
        background-color: #409eff;
        color: white;
        margin-right: 10px;
      }
      
      .message-avatar {
        background-color: #409eff;
      }
    }
    
    &.assistant {
      .message-content {
        background-color: white;
        margin-left: 10px;
      }
      
      .message-avatar {
        background-color: #67c23a;
      }
    }
  }
  
  .message-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 14px;
    flex-shrink: 0;
  }

  .message-content {
    max-width: 75%;
    padding: 10px 14px;
    border-radius: 16px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    font-size: 14px;
  }
  
  .message-text {
    line-height: 1.5;
    word-wrap: break-word;
  }
  
  .message-time {
    font-size: 12px;
    opacity: 0.7;
    margin-top: 5px;
  }
}

.chat-input-area {
  padding: 20px 24px;
  border-top: 1px solid #ebeef5;
  background-color: white;
  flex-shrink: 0;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.05);

  .chat-input {
    margin-bottom: 12px;

    ::v-deep .el-textarea__inner {
      border-radius: 12px;
      border: 1px solid #dcdfe6;
      font-size: 14px;

      &:focus {
        border-color: #409eff;
      }
    }
  }

  .input-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .input-tips {
    font-size: 11px;
    color: #909399;
  }

  .input-buttons {
    display: flex;
    gap: 8px;

    .el-button {
      border-radius: 8px;
    }
  }
}

// 打字机效果
.typing-indicator {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  margin-right: 8px;
  
  span {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #409eff;
    animation: typing 1.4s infinite ease-in-out;
    
    &:nth-child(1) { animation-delay: -0.32s; }
    &:nth-child(2) { animation-delay: -0.16s; }
    &:nth-child(3) { animation-delay: 0s; }
  }
}

@keyframes typing {
  0%, 80%, 100% {
    transform: scale(0.8);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

// 大屏幕优化
@media (min-width: 1440px) {
  .ai-chat-drawer {
    ::v-deep .el-drawer__header {
      padding: 24px 32px;

      span {
        font-size: 20px;
      }
    }
  }

  .chat-messages {
    padding: 24px 32px;

    .message-item {
      margin-bottom: 20px;
    }

    .message-avatar {
      width: 36px;
      height: 36px;
      font-size: 16px;
    }

    .message-content {
      padding: 12px 16px;
      font-size: 15px;
      border-radius: 18px;
    }
  }

  .chat-input-area {
    padding: 24px 32px;

    .chat-input {
      ::v-deep .el-textarea__inner {
        font-size: 15px;
        padding: 12px 16px;
      }
    }

    .input-buttons {
      gap: 12px;

      .el-button {
        padding: 10px 20px;
        font-size: 14px;
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .ai-chat-drawer {
    ::v-deep .el-drawer__header {
      padding: 16px;

      span {
        font-size: 16px;
      }
    }
  }

  .ai-chat-container {
    height: 100vh;
  }

  .chat-messages {
    padding: 12px;

    .message-item {
      margin-bottom: 12px;
    }

    .message-avatar {
      width: 28px;
      height: 28px;
      font-size: 12px;
    }

    .message-content {
      max-width: 80%;
      padding: 8px 12px;
      font-size: 13px;
    }
  }

  .chat-input-area {
    padding: 12px;

    .chat-input {
      ::v-deep .el-textarea__inner {
        font-size: 16px; // 防止iOS缩放
      }
    }

    .input-tips {
      font-size: 10px;
    }

    .input-buttons {
      gap: 6px;

      .el-button {
        padding: 8px 12px;
        font-size: 12px;
      }
    }
  }
}

@media (max-width: 480px) {
  .chat-messages {
    .message-content {
      max-width: 85%;
      padding: 6px 10px;
      font-size: 12px;
    }
  }

  .input-actions {
    flex-direction: column;
    align-items: stretch;
    gap: 8px;

    .input-tips {
      text-align: center;
    }

    .input-buttons {
      justify-content: center;
    }
  }
}
</style>
