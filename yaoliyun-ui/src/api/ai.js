import request from '@/utils/request'

// 简单聊天
export function simpleChat(data) {
  return request({
    url: '/ai/chat/simple',
    method: 'post',
    data: data
  })
}

// 多轮聊天
export function conversation(data) {
  return request({
    url: '/ai/chat/conversation',
    method: 'post',
    data: data
  })
}

// 流式聊天（SSE）
export function streamChat(message) {
  return `/ai/chat/stream?message=${encodeURIComponent(message)}`
}

// 流式多轮聊天（SSE）
export function streamConversation(data) {
  return request({
    url: '/ai/chat/stream',
    method: 'post',
    data: data,
    responseType: 'stream'
  })
}

// 获取AI配置
export function getAiConfig() {
  return request({
    url: '/ai/chat/config',
    method: 'get'
  })
}

// 测试AI连接
export function testAiConnection() {
  return request({
    url: '/ai/chat/test',
    method: 'get'
  })
}

// 测试接口

// 测试AI配置
export function testConfig() {
  return request({
    url: '/test/ai/config',
    method: 'get'
  })
}

// 测试简单聊天
export function testSimpleChat(message) {
  return request({
    url: '/test/ai/simple',
    method: 'get',
    params: { message }
  })
}

// 测试多轮聊天
export function testConversation(data) {
  return request({
    url: '/test/ai/conversation',
    method: 'post',
    data: data
  })
}

// 测试连接
export function testConnection() {
  return request({
    url: '/test/ai/connection',
    method: 'get'
  })
}

// 性能测试
export function performanceTest(count = 5) {
  return request({
    url: '/test/ai/performance',
    method: 'get',
    params: { count }
  })
}

// 获取测试帮助
export function getTestHelp() {
  return request({
    url: '/test/ai/help',
    method: 'get'
  })
}
