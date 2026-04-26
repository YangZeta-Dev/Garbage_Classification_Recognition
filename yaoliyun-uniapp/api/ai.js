import { baseURl } from '@/utils/request.js'

/**
 * AI流式聊天接口
 * 使用SSE (Server-Sent Events) 实现流式输出
 * @param {String} message - 用户消息
 * @param {Function} onMessage - 接收消息回调
 * @param {Function} onError - 错误回调
 * @param {Function} onComplete - 完成回调
 */
export function streamChat(message, onMessage, onError, onComplete) {
	return new Promise((resolve, reject) => {
		const token = uni.getStorageSync('token')
		const url = `${baseURl}/ai/chat/stream?message=${encodeURIComponent(message)}`
		
		// #ifdef H5
		// H5端使用EventSource
		const eventSource = new EventSource(url + (token ? `&token=${token}` : ''))
		
		eventSource.onmessage = (event) => {
			let data = event.data
			
			// 如果数据以 "data:" 开头，去掉前缀（兼容处理）
			if (data.startsWith('data:')) {
				data = data.substring(5).trim()
			}
			
			if (data === '[DONE]') {
				eventSource.close()
				onComplete && onComplete()
				resolve()
			} else if (data) {
				onMessage && onMessage(data)
			}
		}
		
		eventSource.onerror = (error) => {
			console.error('SSE Error:', error)
			eventSource.close()
			onError && onError(error)
			reject(error)
		}
		// #endif
		
		// #ifndef H5
		// 非H5端解析SSE流式数据
		uni.request({
			url: url,
			method: 'GET',
			header: {
				'Authorization': token || '',
				'Accept': 'text/event-stream'
			},
			success: (res) => {
				if (res.statusCode === 200) {
					// 解析SSE格式的数据
					const responseText = res.data || ''
					
					// 将响应按行分割
					const lines = responseText.split('\n')
					const messages = []
					
					// 解析每一行数据
					for (const line of lines) {
						const trimmedLine = line.trim()
						// 跳过空行和注释
						if (!trimmedLine || trimmedLine.startsWith(':')) {
							continue
						}
						
						// 解析 "data: xxx" 格式
						if (trimmedLine.startsWith('data:')) {
							const data = trimmedLine.substring(5).trim()
							if (data && data !== '[DONE]') {
								messages.push(data)
							}
						}
					}
					
					// 模拟流式输出效果
					let index = 0
					const interval = setInterval(() => {
						if (index < messages.length) {
							onMessage && onMessage(messages[index])
							index++
						} else {
							clearInterval(interval)
							onComplete && onComplete()
							resolve()
						}
					}, 50) // 每50ms输出一条消息
				} else if (res.statusCode === 401) {
					uni.showModal({
						title: '温馨提示',
						content: '当前登录已过期请重新登录',
						success: (modalRes) => {
							if (modalRes.confirm) {
								uni.navigateTo({
									url: '/pages/login/login'
								})
							}
						}
					})
					reject(new Error('未授权'))
				} else {
					const error = new Error('请求失败')
					onError && onError(error)
					reject(error)
				}
			},
			fail: (error) => {
				console.error('Request failed:', error)
				onError && onError(error)
				reject(error)
			}
		})
		// #endif
	})
}

/**
 * AI简单聊天接口
 * @param {String} message - 用户消息
 */
export function simpleChat(message) {
	const token = uni.getStorageSync('token')
	return uni.request({
		url: `${baseURl}/ai/chat/simple`,
		method: 'POST',
		header: {
			'Authorization': token || '',
			'Content-Type': 'application/json'
		},
		data: {
			message: message
		}
	})
}

