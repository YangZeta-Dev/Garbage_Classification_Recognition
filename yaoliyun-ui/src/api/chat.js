import request from '@/utils/request'

// 查询聊天消息列表
export function listMessages(query) {
  return request({
    url: '/system/chat/messages',
    method: 'get',
    params: query
  })
}

// 查询两个用户之间的聊天记录
export function getChatHistory(userId1, userId2) {
  return request({
    url: `/system/chat/messages/${userId1}/${userId2}`,
    method: 'get'
  })
}

// 查询用户的未读消息
export function getUnreadMessages(userId) {
  return request({
    url: `/system/chat/unread/${userId}`,
    method: 'get'
  })
}

// 发送消息
export function sendMessage(data) {
  return request({
    url: '/system/chat/send',
    method: 'post',
    data: data
  })
}

// 标记消息为已读
export function markAsRead(senderId, receiverId) {
  return request({
    url: `/system/chat/read/${senderId}/${receiverId}`,
    method: 'put'
  })
}

// 查询聊天消息详细
export function getMessage(id) {
  return request({
    url: '/system/chat/messages/' + id,
    method: 'get'
  })
}

// 新增聊天消息
export function addMessage(data) {
  return request({
    url: '/system/chat/messages',
    method: 'post',
    data: data
  })
}

// 修改聊天消息
export function updateMessage(data) {
  return request({
    url: '/system/chat/messages',
    method: 'put',
    data: data
  })
}

// 删除聊天消息
export function delMessage(id) {
  return request({
    url: '/system/chat/messages/' + id,
    method: 'delete'
  })
}

// ==================== 会话相关接口 ====================

// 查询用户的聊天会话列表
export function getUserSessions(userId) {
  return request({
    url: `/system/chat/sessions/${userId}`,
    method: 'get'
  })
}

// 查询聊天会话列表
export function listSessions(query) {
  return request({
    url: '/system/chat/sessions',
    method: 'get',
    params: query
  })
}

// 查询聊天会话详细
export function getSession(id) {
  return request({
    url: '/system/chat/sessions/info/' + id,
    method: 'get'
  })
}

// 清零未读消息数
export function clearUnreadCount(userId, contactId) {
  return request({
    url: `/system/chat/sessions/clear-unread/${userId}/${contactId}`,
    method: 'put'
  })
}

// 新增聊天会话
export function addSession(data) {
  return request({
    url: '/system/chat/sessions',
    method: 'post',
    data: data
  })
}

// 修改聊天会话
export function updateSession(data) {
  return request({
    url: '/system/chat/sessions',
    method: 'put',
    data: data
  })
}

// 删除聊天会话
export function delSession(id) {
  return request({
    url: '/system/chat/sessions/' + id,
    method: 'delete'
  })
}

// 导出聊天消息
export function exportMessage(query) {
  return request({
    url: '/system/chat/messages/export',
    method: 'post',
    params: query
  })
}

// ==================== WebSocket相关接口 ====================

// 通过WebSocket发送消息
export function sendWebSocketMessage(data) {
  return request({
    url: '/system/chat/websocket/send',
    method: 'post',
    data: data
  })
}

// 获取在线用户列表
export function getOnlineUsers() {
  return request({
    url: '/system/chat/websocket/online-users',
    method: 'get'
  })
}

// 获取在线用户数量
export function getOnlineUserCount() {
  return request({
    url: '/system/chat/websocket/online-count',
    method: 'get'
  })
}

// 检查用户是否在线
export function isUserOnline(userId) {
  return request({
    url: `/system/chat/websocket/user-online/${userId}`,
    method: 'get'
  })
}

// 发送系统消息
export function sendSystemMessage(data) {
  return request({
    url: '/system/chat/websocket/system-message',
    method: 'post',
    data: data
  })
}

// 发送广播消息
export function broadcastMessage(data) {
  return request({
    url: '/system/chat/websocket/broadcast',
    method: 'post',
    data: data
  })
}

// 发送已读回执
export function sendReadReceipt(data) {
  return request({
    url: '/system/chat/websocket/read-receipt',
    method: 'post',
    data: data
  })
}

// WebSocket连接测试
export function testWebSocket() {
  return request({
    url: '/system/chat/websocket/test',
    method: 'get'
  })
}

// 修复在线人数计数
export function fixOnlineCount() {
  return request({
    url: '/system/chat/websocket/fix-count',
    method: 'post'
  })
}

// 重置在线人数计数
export function resetOnlineCount() {
  return request({
    url: '/system/chat/websocket/reset-count',
    method: 'post'
  })
}

// 获取在线统计信息
export function getOnlineStatistics() {
  return request({
    url: '/system/chat/websocket/statistics',
    method: 'get'
  })
}

// 测试发送聊天消息
export function testSendChatMessage(data) {
  return request({
    url: '/system/chat/websocket/test-send',
    method: 'post',
    data: data
  })
}
