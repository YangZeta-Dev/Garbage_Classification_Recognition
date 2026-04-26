/**
 * 聊天配置文件
 */

// 开发环境配置
const development = {
  // WebSocket服务器地址
  wsBaseUrl: 'ws://localhost:8080',
  
  // HTTP API服务器地址
  apiBaseUrl: 'http://localhost:8080',
  
  // WebSocket连接配置
  websocket: {
    // 最大重连次数
    maxReconnectCount: 5,
    
    // 重连间隔（毫秒）
    reconnectInterval: 3000,
    
    // 心跳间隔（毫秒）
    heartbeatInterval: 30000,
    
    // 连接超时时间（毫秒）
    connectTimeout: 10000
  },
  
  // 消息配置
  message: {
    // 最大消息长度
    maxLength: 500,
    
    // 消息历史保存天数
    historyDays: 30,
    
    // 单次加载消息数量
    pageSize: 20
  },
  
  // 文件上传配置
  upload: {
    // 图片最大大小（字节）
    maxImageSize: 5 * 1024 * 1024, // 5MB
    
    // 文件最大大小（字节）
    maxFileSize: 10 * 1024 * 1024, // 10MB
    
    // 支持的图片格式
    imageTypes: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    
    // 支持的文件格式
    fileTypes: ['doc', 'docx', 'pdf', 'txt', 'xls', 'xlsx', 'ppt', 'pptx']
  }
}

// 生产环境配置
const production = {
  // WebSocket服务器地址
  wsBaseUrl: 'wss://your-domain.com',
  
  // HTTP API服务器地址
  apiBaseUrl: 'https://your-domain.com',
  
  // WebSocket连接配置
  websocket: {
    maxReconnectCount: 10,
    reconnectInterval: 5000,
    heartbeatInterval: 30000,
    connectTimeout: 15000
  },
  
  // 消息配置
  message: {
    maxLength: 500,
    historyDays: 90,
    pageSize: 20
  },
  
  // 文件上传配置
  upload: {
    maxImageSize: 5 * 1024 * 1024,
    maxFileSize: 10 * 1024 * 1024,
    imageTypes: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    fileTypes: ['doc', 'docx', 'pdf', 'txt', 'xls', 'xlsx', 'ppt', 'pptx']
  }
}

// 测试环境配置
const test = {
  wsBaseUrl: 'ws://test.your-domain.com',
  apiBaseUrl: 'http://test.your-domain.com',
  websocket: {
    maxReconnectCount: 3,
    reconnectInterval: 2000,
    heartbeatInterval: 20000,
    connectTimeout: 8000
  },
  message: {
    maxLength: 200,
    historyDays: 7,
    pageSize: 10
  },
  upload: {
    maxImageSize: 2 * 1024 * 1024,
    maxFileSize: 5 * 1024 * 1024,
    imageTypes: ['jpg', 'jpeg', 'png'],
    fileTypes: ['doc', 'pdf', 'txt']
  }
}

// 根据环境变量选择配置
const env = process.env.NODE_ENV || 'development'

let config
switch (env) {
  case 'production':
    config = production
    break
  case 'test':
    config = test
    break
  default:
    config = development
}

// 消息类型常量
export const MESSAGE_TYPES = {
  TEXT: 'text',
  IMAGE: 'image',
  FILE: 'file',
  SYSTEM: 'system',
  HEARTBEAT: 'heartbeat'
}

// 消息状态常量
export const MESSAGE_STATUS = {
  SENDING: 'sending',
  SENT: 'sent',
  DELIVERED: 'delivered',
  READ: 'read',
  FAILED: 'failed'
}

// WebSocket消息类型常量
export const WS_MESSAGE_TYPES = {
  CHAT: 'chat',
  SYSTEM: 'system',
  ACK: 'ack',
  READ_RECEIPT: 'read_receipt',
  USER_STATUS: 'user_status',
  BROADCAST: 'broadcast',
  HEARTBEAT: 'heartbeat'
}

// 用户状态常量
export const USER_STATUS = {
  ONLINE: 'online',
  OFFLINE: 'offline',
  AWAY: 'away',
  BUSY: 'busy'
}

// 导出配置
export default config

// 工具函数
export const utils = {
  /**
   * 格式化文件大小
   * @param {number} bytes 字节数
   * @returns {string} 格式化后的大小
   */
  formatFileSize(bytes) {
    if (bytes === 0) return '0 B'
    const k = 1024
    const sizes = ['B', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  },

  /**
   * 检查文件类型是否支持
   * @param {string} fileName 文件名
   * @param {string} type 文件类型 ('image' | 'file')
   * @returns {boolean} 是否支持
   */
  isFileTypeSupported(fileName, type = 'file') {
    const ext = fileName.split('.').pop().toLowerCase()
    const supportedTypes = type === 'image' ? config.upload.imageTypes : config.upload.fileTypes
    return supportedTypes.includes(ext)
  },

  /**
   * 检查文件大小是否符合要求
   * @param {number} size 文件大小（字节）
   * @param {string} type 文件类型 ('image' | 'file')
   * @returns {boolean} 是否符合要求
   */
  isFileSizeValid(size, type = 'file') {
    const maxSize = type === 'image' ? config.upload.maxImageSize : config.upload.maxFileSize
    return size <= maxSize
  },

  /**
   * 生成唯一ID
   * @returns {string} 唯一ID
   */
  generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2)
  },

  /**
   * 格式化时间
   * @param {Date|string|number} time 时间
   * @returns {string} 格式化后的时间
   */
  formatTime(time) {
    const date = new Date(time)
    const now = new Date()
    const diff = now - date

    if (diff < 60000) { // 1分钟内
      return '刚刚'
    } else if (diff < 3600000) { // 1小时内
      return Math.floor(diff / 60000) + '分钟前'
    } else if (diff < 86400000) { // 1天内
      return Math.floor(diff / 3600000) + '小时前'
    } else if (diff < 604800000) { // 1周内
      return Math.floor(diff / 86400000) + '天前'
    } else {
      return date.toLocaleDateString()
    }
  },

  /**
   * 获取消息状态文本
   * @param {string} status 状态
   * @returns {string} 状态文本
   */
  getStatusText(status) {
    const statusMap = {
      [MESSAGE_STATUS.SENDING]: '发送中',
      [MESSAGE_STATUS.SENT]: '已发送',
      [MESSAGE_STATUS.DELIVERED]: '已送达',
      [MESSAGE_STATUS.READ]: '已读',
      [MESSAGE_STATUS.FAILED]: '发送失败'
    }
    return statusMap[status] || ''
  }
}
