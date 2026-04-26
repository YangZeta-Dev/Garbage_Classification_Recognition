import request from '@/utils/request.js'

// 查询用户的聊天会话列表
export function getChatSessions(userId) {
	return request({
		url: `/system/chat/sessions/${userId}`,
		method: 'get'
	})
}

// 查询两个用户之间的聊天记录
export function getChatMessages(userId1, userId2) {
	return request({
		url: `/system/chat/messages/${userId1}/${userId2}`,
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
export function markMessageAsRead(senderId, receiverId) {
	return request({
		url: `/system/chat/read/${senderId}/${receiverId}`,
		method: 'put'
	})
}

// 清零未读消息数
export function clearUnreadCount(userId, contactId) {
	return request({
		url: `/system/chat/sessions/clear-unread/${userId}/${contactId}`,
		method: 'put'
	})
}

// 查询用户的未读消息
export function getUnreadMessages(userId) {
	return request({
		url: `/system/chat/unread/${userId}`,
		method: 'get'
	})
}

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

// 检查用户是否在线
export function checkUserOnline(userId) {
	return request({
		url: `/system/chat/websocket/user-online/${userId}`,
		method: 'get'
	})
}

