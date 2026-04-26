/**
 * UniApp WebSocket 聊天客户端
 * 用于即时通讯功能
 */
class ChatWebSocket {
  constructor() {
    this.socket = null
    this.isConnected = false
    this.reconnectTimer = null
    this.heartbeatTimer = null
    this.reconnectCount = 0
    this.maxReconnectCount = 5
    this.userId = ''
    this.baseUrl = 'ws://localhost:8080' // 根据实际情况修改
    
    // 事件回调
    this.onMessage = null
    this.onConnect = null
    this.onDisconnect = null
    this.onError = null
  }

  /**
   * 连接WebSocket
   * @param {string} userId 用户ID
   */
  connect(userId) {
    if (!userId) {
      console.error('用户ID不能为空')
      return
    }

    this.userId = userId
    const url = `${this.baseUrl}/websocket/chat/${userId}`

    console.log('正在连接WebSocket:', url)

    this.socket = uni.connectSocket({
      url: url,
      success: () => {
        console.log('WebSocket连接创建成功')
      },
      fail: (error) => {
        console.error('WebSocket连接创建失败:', error)
        this.handleError(error)
      }
    })

    // 监听WebSocket连接打开事件
    this.socket.onOpen(() => {
      console.log('WebSocket连接已打开')
      this.isConnected = true
      this.reconnectCount = 0
      this.startHeartbeat()
      
      if (this.onConnect) {
        this.onConnect()
      }
    })

    // 监听WebSocket接受到服务器的消息事件
    this.socket.onMessage((res) => {
      console.log('收到WebSocket消息:', res.data)
      this.handleMessage(res.data)
    })

    // 监听WebSocket连接关闭事件
    this.socket.onClose(() => {
      console.log('WebSocket连接已关闭')
      this.isConnected = false
      this.stopHeartbeat()
      
      if (this.onDisconnect) {
        this.onDisconnect()
      }
      
      // 自动重连
      this.autoReconnect()
    })

    // 监听WebSocket错误事件
    this.socket.onError((error) => {
      console.error('WebSocket连接发生错误:', error)
      this.handleError(error)
    })
  }

  /**
   * 发送消息
   * @param {string} toUserId 接收者ID
   * @param {string} message 消息内容
   * @param {string} messageType 消息类型
   */
  sendMessage(toUserId, message, messageType = 'text') {
    if (!this.isConnected) {
      console.error('WebSocket未连接')
      uni.showToast({
        title: '连接已断开，请重试',
        icon: 'none'
      })
      return false
    }

    const messageData = {
      toUserId: toUserId,
      message: message,
      messageType: messageType,
      timestamp: Date.now()
    }

    this.socket.send({
      data: JSON.stringify(messageData),
      success: () => {
        console.log('消息发送成功:', messageData)
      },
      fail: (error) => {
        console.error('消息发送失败:', error)
        uni.showToast({
          title: '消息发送失败',
          icon: 'none'
        })
      }
    })

    return true
  }

  /**
   * 处理接收到的消息
   * @param {string} data 消息数据
   */
  handleMessage(data) {
    try {
      let message
      if (typeof data === 'string') {
        message = JSON.parse(data)
      } else {
        message = data
      }
      
      switch (message.type) {
        case 'chat':
          // 聊天消息
          this.handleChatMessage(message)
          break
        case 'system':
          // 系统消息
          this.handleSystemMessage(message)
          break
        case 'ack':
          // 消息确认
          this.handleAckMessage(message)
          break
        case 'read_receipt':
          // 已读回执
          this.handleReadReceipt(message)
          break
        case 'user_status':
          // 用户状态变更
          this.handleUserStatus(message)
          break
        case 'broadcast':
          // 广播消息
          this.handleBroadcastMessage(message)
          break
        default:
          console.log('未知消息类型:', message)
      }

      // 调用外部消息处理回调
      if (this.onMessage) {
        this.onMessage(message)
      }
    } catch (error) {
      console.error('消息解析失败:', error)
      // 如果不是JSON格式，直接作为文本消息处理
      if (this.onMessage) {
        this.onMessage({
          type: 'text',
          message: data,
          timestamp: Date.now()
        })
      }
    }
  }

  /**
   * 处理聊天消息
   */
  handleChatMessage(message) {
    console.log('收到聊天消息:', message)
    
    // 显示消息通知
    if (message.fromUserId !== this.userId) {
      uni.showToast({
        title: `${message.fromUserName || message.fromUserId}: ${message.message}`,
        icon: 'none',
        duration: 3000
      })
    }
  }

  /**
   * 处理系统消息
   */
  handleSystemMessage(message) {
    console.log('收到系统消息:', message)
    
    uni.showModal({
      title: '系统消息',
      content: message.message,
      showCancel: false
    })
  }

  /**
   * 处理消息确认
   */
  handleAckMessage(message) {
    console.log('收到消息确认:', message)
  }

  /**
   * 处理已读回执
   */
  handleReadReceipt(message) {
    console.log('收到已读回执:', message)
  }

  /**
   * 处理用户状态变更
   */
  handleUserStatus(message) {
    console.log('用户状态变更:', message)
  }

  /**
   * 处理广播消息
   */
  handleBroadcastMessage(message) {
    console.log('收到广播消息:', message)
    
    uni.showModal({
      title: '系统广播',
      content: message.message,
      showCancel: false
    })
  }

  /**
   * 发送已读回执
   * @param {string} fromUserId 消息发送者ID
   * @param {number} messageId 消息ID
   */
  sendReadReceipt(fromUserId, messageId) {
    const receiptData = {
      type: 'read_receipt',
      fromUserId: this.userId,
      toUserId: fromUserId,
      messageId: messageId,
      timestamp: Date.now()
    }

    if (this.isConnected) {
      this.socket.send({
        data: JSON.stringify(receiptData)
      })
    }
  }

  /**
   * 开始心跳
   */
  startHeartbeat() {
    this.heartbeatTimer = setInterval(() => {
      if (this.isConnected) {
        this.socket.send({
          data: JSON.stringify({ 
            type: 'heartbeat', 
            timestamp: Date.now() 
          }),
          fail: (error) => {
            console.error('心跳发送失败:', error)
          }
        })
      }
    }, 30000) // 30秒发送一次心跳
  }

  /**
   * 停止心跳
   */
  stopHeartbeat() {
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer)
      this.heartbeatTimer = null
    }
  }

  /**
   * 自动重连
   */
  autoReconnect() {
    if (this.reconnectCount >= this.maxReconnectCount) {
      console.log('达到最大重连次数，停止重连')
      return
    }

    this.reconnectCount++
    console.log(`第${this.reconnectCount}次重连...`)

    this.reconnectTimer = setTimeout(() => {
      this.connect(this.userId)
    }, 3000 * this.reconnectCount) // 递增延迟重连
  }

  /**
   * 处理错误
   */
  handleError(error) {
    console.error('WebSocket错误:', error)
    
    if (this.onError) {
      this.onError(error)
    }
  }

  /**
   * 手动重连
   */
  reconnect() {
    this.disconnect()
    setTimeout(() => {
      this.connect(this.userId)
    }, 1000)
  }

  /**
   * 断开连接
   */
  disconnect() {
    this.isConnected = false
    this.stopHeartbeat()
    
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = null
    }

    if (this.socket) {
      this.socket.close()
      this.socket = null
    }
  }

  /**
   * 获取连接状态
   */
  getConnectionStatus() {
    return {
      isConnected: this.isConnected,
      userId: this.userId,
      reconnectCount: this.reconnectCount
    }
  }
}

export default ChatWebSocket
