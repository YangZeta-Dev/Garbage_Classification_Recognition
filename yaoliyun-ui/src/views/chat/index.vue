<template>
  <div class="chat-container">
    <!-- 聊天头部 -->
    <div class="chat-header">
      <div class="chat-title">
        <i class="el-icon-chat-dot-round"></i>
        即时通讯
      </div>
      <div class="chat-info">
        <span class="online-count">在线用户: {{ onlineCount }}</span>
        <el-button size="mini" @click="showOnlineUsers">查看在线用户</el-button>
        <el-button size="mini" @click="clearHistory">清空记录</el-button>
      </div>
    </div>

    <!-- 聊天消息区域 -->
    <div class="chat-messages" ref="messagesContainer">
      <div
        v-for="message in messages"
        :key="message.messageId || message.timestamp"
        :class="['message-item', getMessageClass(message)]"
      >
        <div class="message-header">
          <span class="message-sender">{{ message.sender }}</span>
          <span class="message-time">{{ formatTime(message.timestamp) }}</span>
        </div>
        <div class="message-content">{{ message.content }}</div>
      </div>
    </div>

    <!-- 消息输入区域 -->
    <div class="chat-input">
      <div class="input-controls">
        <el-input
          v-model="username"
          placeholder="请输入用户名"
          size="small"
          style="width: 150px; margin-right: 10px;"
          :disabled="connected"
        />
        <el-button
          v-if="!connected"
          type="primary"
          size="small"
          @click="connect"
          :loading="connecting"
        >
          连接
        </el-button>
        <el-button
          v-else
          type="danger"
          size="small"
          @click="disconnect"
        >
          断开
        </el-button>
      </div>
      
      <div class="message-input" v-if="connected">
        <el-input
          v-model="messageText"
          type="textarea"
          :rows="3"
          placeholder="请输入消息内容..."
          @keyup.ctrl.enter="sendMessage"
        />
        <div class="input-actions">
          <el-button type="primary" @click="sendMessage" :disabled="!messageText.trim()">
            发送 (Ctrl+Enter)
          </el-button>
        </div>
      </div>
    </div>

    <!-- 在线用户对话框 -->
    <el-dialog title="在线用户" :visible.sync="onlineUsersVisible" width="400px">
      <el-tag
        v-for="user in onlineUsers"
        :key="user"
        style="margin: 5px;"
        :type="user === username ? 'success' : 'info'"
      >
        {{ user }}
      </el-tag>
      <div slot="footer">
        <el-button @click="onlineUsersVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getChatHistory, getOnlineUsers, clearChatHistory } from '@/api/chat'

export default {
  name: 'Chat',
  data() {
    return {
      // WebSocket连接
      websocket: null,
      connected: false,
      connecting: false,
      
      // 用户信息
      username: '',
      
      // 消息相关
      messages: [],
      messageText: '',
      
      // 在线用户
      onlineCount: 0,
      onlineUsers: [],
      onlineUsersVisible: false
    }
  },
  mounted() {
    this.loadChatHistory()
    this.loadOnlineUsers()
  },
  beforeDestroy() {
    this.disconnect()
  },
  methods: {
    // 连接WebSocket
    connect() {
      if (!this.username.trim()) {
        this.$message.error('请输入用户名')
        return
      }
      
      this.connecting = true
      const wsUrl = `ws://localhost:8080/websocket/chat`
      
      try {
        this.websocket = new WebSocket(wsUrl)
        
        this.websocket.onopen = () => {
          this.connected = true
          this.connecting = false
          this.$message.success('连接成功')
          
          // 发送加入消息
          this.sendJoinMessage()
        }
        
        this.websocket.onmessage = (event) => {
          const message = JSON.parse(event.data)
          this.handleMessage(message)
        }
        
        this.websocket.onclose = () => {
          this.connected = false
          this.connecting = false
          this.$message.warning('连接已断开')
        }
        
        this.websocket.onerror = (error) => {
          this.connecting = false
          this.$message.error('连接失败')
          console.error('WebSocket错误:', error)
        }
      } catch (error) {
        this.connecting = false
        this.$message.error('连接失败')
        console.error('WebSocket连接错误:', error)
      }
    },
    
    // 断开连接
    disconnect() {
      if (this.websocket) {
        // 发送离开消息
        this.sendLeaveMessage()
        this.websocket.close()
        this.websocket = null
      }
      this.connected = false
    },
    
    // 发送加入消息
    sendJoinMessage() {
      const message = {
        type: 'JOIN',
        sender: this.username,
        content: '',
        timestamp: new Date()
      }
      this.websocket.send(JSON.stringify(message))
    },
    
    // 发送离开消息
    sendLeaveMessage() {
      if (this.websocket && this.connected) {
        const message = {
          type: 'LEAVE',
          sender: this.username,
          content: '',
          timestamp: new Date()
        }
        this.websocket.send(JSON.stringify(message))
      }
    },
    
    // 发送聊天消息
    sendMessage() {
      if (!this.messageText.trim()) {
        return
      }
      
      const message = {
        type: 'CHAT',
        sender: this.username,
        content: this.messageText.trim(),
        timestamp: new Date()
      }
      
      this.websocket.send(JSON.stringify(message))
      this.messageText = ''
    },
    
    // 处理接收到的消息
    handleMessage(message) {
      this.messages.push(message)
      this.$nextTick(() => {
        this.scrollToBottom()
      })
      
      // 更新在线用户数量
      if (message.type === 'JOIN' || message.type === 'LEAVE') {
        this.loadOnlineUsers()
      }
    },
    
    // 滚动到底部
    scrollToBottom() {
      const container = this.$refs.messagesContainer
      if (container) {
        container.scrollTop = container.scrollHeight
      }
    },
    
    // 获取消息样式类
    getMessageClass(message) {
      if (message.type === 'SYSTEM') {
        return 'system-message'
      } else if (message.sender === this.username) {
        return 'own-message'
      } else {
        return 'other-message'
      }
    },
    
    // 格式化时间
    formatTime(timestamp) {
      const date = new Date(timestamp)
      return date.toLocaleTimeString()
    },
    
    // 加载聊天记录
    async loadChatHistory() {
      try {
        const response = await getChatHistory()
        if (response.code === 200) {
          this.messages = response.data || []
          this.$nextTick(() => {
            this.scrollToBottom()
          })
        }
      } catch (error) {
        console.error('加载聊天记录失败:', error)
      }
    },
    
    // 加载在线用户
    async loadOnlineUsers() {
      try {
        const response = await getOnlineUsers()
        if (response.code === 200) {
          this.onlineUsers = response.data || []
          this.onlineCount = this.onlineUsers.length
        }
      } catch (error) {
        console.error('加载在线用户失败:', error)
      }
    },
    
    // 显示在线用户
    showOnlineUsers() {
      this.loadOnlineUsers()
      this.onlineUsersVisible = true
    },
    
    // 清空聊天记录
    async clearHistory() {
      try {
        await this.$confirm('确定要清空聊天记录吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        
        const response = await clearChatHistory()
        if (response.code === 200) {
          this.messages = []
          this.$message.success('聊天记录已清空')
        }
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('清空聊天记录失败')
        }
      }
    }
  }
}
</script>

<style scoped>
.chat-container {
  height: calc(100vh - 120px);
  display: flex;
  flex-direction: column;
  background: #f5f5f5;
}

.chat-header {
  background: white;
  padding: 15px 20px;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.chat-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.online-count {
  color: #666;
  font-size: 14px;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: white;
  margin: 10px;
  border-radius: 8px;
}

.message-item {
  margin-bottom: 15px;
  padding: 10px;
  border-radius: 8px;
}

.system-message {
  background: #f0f9ff;
  border-left: 4px solid #409eff;
  text-align: center;
  color: #666;
}

.own-message {
  background: #e7f7ff;
  border-left: 4px solid #67c23a;
  margin-left: 20%;
}

.other-message {
  background: #f9f9f9;
  border-left: 4px solid #909399;
  margin-right: 20%;
}

.message-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-size: 12px;
  color: #999;
}

.message-sender {
  font-weight: bold;
}

.message-content {
  color: #333;
  line-height: 1.5;
  word-wrap: break-word;
}

.chat-input {
  background: white;
  padding: 20px;
  border-top: 1px solid #e6e6e6;
}

.input-controls {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.message-input {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.input-actions {
  display: flex;
  justify-content: flex-end;
}
</style>
