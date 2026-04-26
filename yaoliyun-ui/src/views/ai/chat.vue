<template>
  <div class="ai-chat-container">
    <!-- 聊天头部 -->
    <div class="chat-header">
      <h3>AI智能助手</h3>
      <div class="header-actions">
        <el-button size="small" @click="clearChat">清空对话</el-button>
        <el-button size="small" @click="testConnection">测试连接</el-button>
        <el-switch
          v-model="streamMode"
          active-text="流式"
          inactive-text="普通"
          style="margin-left: 10px"
        ></el-switch>
      </div>
    </div>

    <!-- 聊天消息区域 -->
    <div class="chat-messages" ref="messagesContainer">
      <div
        v-for="(message, index) in messages"
        :key="index"
        :class="['message', message.role]"
      >
        <div class="message-avatar">
          <i :class="message.role === 'user' ? 'el-icon-user' : 'el-icon-cpu'"></i>
        </div>
        <div class="message-content">
          <div class="message-text" v-html="formatMessage(message.content)"></div>
          <div class="message-time">{{ message.timestamp }}</div>
        </div>
      </div>
      
      <!-- 正在输入指示器 -->
      <div v-if="isTyping" class="message assistant typing">
        <div class="message-avatar">
          <i class="el-icon-cpu"></i>
        </div>
        <div class="message-content">
          <div class="typing-indicator">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      </div>
    </div>

    <!-- 输入区域 -->
    <div class="chat-input">
      <el-input
        v-model="inputMessage"
        type="textarea"
        :rows="3"
        placeholder="请输入您的问题..."
        @keydown.ctrl.enter="sendMessage"
        :disabled="isTyping"
      ></el-input>
      <div class="input-actions">
        <span class="input-tip">Ctrl + Enter 发送</span>
        <el-button
          type="primary"
          @click="sendMessage"
          :loading="isTyping"
          :disabled="!inputMessage.trim()"
        >
          {{ isTyping ? '发送中...' : '发送' }}
        </el-button>
      </div>
    </div>

    <!-- 快捷问题 -->
    <div class="quick-questions" v-if="messages.length === 0">
      <h4>快捷问题</h4>
      <div class="question-tags">
        <el-tag
          v-for="question in quickQuestions"
          :key="question"
          @click="selectQuickQuestion(question)"
          class="question-tag"
        >
          {{ question }}
        </el-tag>
      </div>
    </div>
  </div>
</template>

<script>
import { simpleChat, streamChat } from '@/api/ai'

export default {
  name: 'AiChat',
  data() {
    return {
      messages: [],
      inputMessage: '',
      isTyping: false,
      streamMode: true,
      quickQuestions: [
        '你好，请介绍一下自己',
        '常见的十字花科植物有哪些？',
        '请解释一下人工智能的基本概念',
        '如何学习编程？',
        '请推荐一些好书',
        '今天天气怎么样？'
      ]
    }
  },
  mounted() {
    this.addMessage('assistant', '您好！我是AI智能助手，有什么可以帮助您的吗？')
  },
  methods: {
    // 发送消息
    async sendMessage() {
      if (!this.inputMessage.trim() || this.isTyping) {
        return
      }

      const userMessage = this.inputMessage.trim()
      this.addMessage('user', userMessage)
      this.inputMessage = ''
      this.isTyping = true

      try {
        if (this.streamMode) {
          await this.sendStreamMessage(userMessage)
        } else {
          await this.sendNormalMessage(userMessage)
        }
      } catch (error) {
        console.error('发送消息失败:', error)
        this.addMessage('assistant', '抱歉，发送消息时出现错误：' + error.message)
      } finally {
        this.isTyping = false
      }
    },

    // 发送普通消息
    async sendNormalMessage(message) {
      try {
        const response = await simpleChat({ message })
        this.addMessage('assistant', response.data)
      } catch (error) {
        throw new Error(error.msg || '请求失败')
      }
    },

    // 发送流式消息
    async sendStreamMessage(message) {
      return new Promise((resolve, reject) => {
        const assistantMessage = this.addMessage('assistant', '')
        const messageIndex = this.messages.length - 1

        const eventSource = new EventSource(`/dev-api/test/ai/stream?message=${encodeURIComponent(message)}`)
        
        eventSource.onmessage = (event) => {
          const content = event.data
          this.messages[messageIndex].content += content
          this.$nextTick(() => {
            this.scrollToBottom()
          })
        }

        eventSource.onopen = () => {
          console.log('SSE连接已建立')
        }

        eventSource.onerror = (error) => {
          console.error('SSE连接错误:', error)
          eventSource.close()
          if (this.messages[messageIndex].content === '') {
            this.messages[messageIndex].content = '抱歉，连接出现问题，请稍后重试。'
          }
          reject(error)
        }

        eventSource.addEventListener('close', () => {
          eventSource.close()
          resolve()
        })

        // 设置超时
        setTimeout(() => {
          if (eventSource.readyState !== EventSource.CLOSED) {
            eventSource.close()
            resolve()
          }
        }, 60000) // 60秒超时
      })
    },

    // 添加消息
    addMessage(role, content) {
      const message = {
        role,
        content,
        timestamp: new Date().toLocaleTimeString()
      }
      this.messages.push(message)
      this.$nextTick(() => {
        this.scrollToBottom()
      })
      return message
    },

    // 选择快捷问题
    selectQuickQuestion(question) {
      this.inputMessage = question
      this.sendMessage()
    },

    // 清空对话
    clearChat() {
      this.$confirm('确定要清空所有对话吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.messages = []
        this.addMessage('assistant', '对话已清空，有什么可以帮助您的吗？')
      })
    },

    // 测试连接
    async testConnection() {
      try {
        this.$message.info('正在测试AI连接...')
        const response = await this.$http.get('/test/ai/connection')
        if (response.code === 200) {
          this.$message.success('AI连接测试成功')
        } else {
          this.$message.error('AI连接测试失败：' + response.msg)
        }
      } catch (error) {
        this.$message.error('AI连接测试失败：' + error.message)
      }
    },

    // 格式化消息内容
    formatMessage(content) {
      // 简单的markdown格式化
      return content
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
        .replace(/\*(.*?)\*/g, '<em>$1</em>')
        .replace(/`(.*?)`/g, '<code>$1</code>')
        .replace(/\n/g, '<br>')
    },

    // 滚动到底部
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.messagesContainer
        if (container) {
          container.scrollTop = container.scrollHeight
        }
      })
    }
  }
}
</script>

<style scoped>
.ai-chat-container {
  height: calc(100vh - 120px);
  display: flex;
  flex-direction: column;
  background: #f5f5f5;
}

.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background: white;
  border-bottom: 1px solid #e6e6e6;
}

.chat-header h3 {
  margin: 0;
  color: #333;
}

.header-actions {
  display: flex;
  align-items: center;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.message {
  display: flex;
  margin-bottom: 20px;
  animation: fadeIn 0.3s ease-in;
}

.message.user {
  flex-direction: row-reverse;
}

.message-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  margin: 0 10px;
}

.message.user .message-avatar {
  background: #409eff;
  color: white;
}

.message.assistant .message-avatar {
  background: #67c23a;
  color: white;
}

.message-content {
  max-width: 70%;
  background: white;
  padding: 12px 16px;
  border-radius: 12px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.message.user .message-content {
  background: #409eff;
  color: white;
}

.message-text {
  line-height: 1.5;
  word-wrap: break-word;
}

.message-time {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}

.message.user .message-time {
  color: rgba(255,255,255,0.8);
}

.typing-indicator {
  display: flex;
  align-items: center;
}

.typing-indicator span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #999;
  margin: 0 2px;
  animation: typing 1.4s infinite ease-in-out;
}

.typing-indicator span:nth-child(1) { animation-delay: -0.32s; }
.typing-indicator span:nth-child(2) { animation-delay: -0.16s; }

@keyframes typing {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
}

.chat-input {
  background: white;
  padding: 20px;
  border-top: 1px solid #e6e6e6;
}

.input-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
}

.input-tip {
  font-size: 12px;
  color: #999;
}

.quick-questions {
  background: white;
  padding: 20px;
  border-top: 1px solid #e6e6e6;
}

.quick-questions h4 {
  margin: 0 0 15px 0;
  color: #333;
}

.question-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.question-tag {
  cursor: pointer;
  transition: all 0.3s;
}

.question-tag:hover {
  background: #409eff;
  color: white;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
