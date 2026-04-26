/**
 * 格式化消息时间
 * @param {string} timestamp 时间戳
 * @returns {string} 格式化后的时间
 */
export function formatMessageTime(timestamp) {
	if (!timestamp) return ''
	
	const now = new Date()
	const messageTime = new Date(timestamp)
	const diff = now.getTime() - messageTime.getTime()
	
	// 小于1分钟
	if (diff < 60 * 1000) {
		return '刚刚'
	}
	
	// 小于1小时
	if (diff < 60 * 60 * 1000) {
		const minutes = Math.floor(diff / (60 * 1000))
		return `${minutes}分钟前`
	}
	
	// 今天
	if (isToday(messageTime)) {
		const hours = messageTime.getHours()
		const minutes = messageTime.getMinutes()
		return `${padZero(hours)}:${padZero(minutes)}`
	}
	
	// 昨天
	if (isYesterday(messageTime)) {
		return '昨天'
	}
	
	// 今年
	if (messageTime.getFullYear() === now.getFullYear()) {
		const month = messageTime.getMonth() + 1
		const day = messageTime.getDate()
		return `${month}月${day}日`
	}
	
	// 往年
	const year = messageTime.getFullYear()
	const month = messageTime.getMonth() + 1
	const day = messageTime.getDate()
	return `${year}年${month}月${day}日`
}

/**
 * 格式化聊天时间（带日期分组）
 * @param {string} timestamp 时间戳
 * @returns {string} 格式化后的时间
 */
export function formatChatTime(timestamp) {
	if (!timestamp) return ''
	
	const now = new Date()
	const messageTime = new Date(timestamp)
	
	// 今天
	if (isToday(messageTime)) {
		const hours = messageTime.getHours()
		const minutes = messageTime.getMinutes()
		return `${padZero(hours)}:${padZero(minutes)}`
	}
	
	// 昨天
	if (isYesterday(messageTime)) {
		const hours = messageTime.getHours()
		const minutes = messageTime.getMinutes()
		return `昨天 ${padZero(hours)}:${padZero(minutes)}`
	}
	
	// 今年
	if (messageTime.getFullYear() === now.getFullYear()) {
		const month = messageTime.getMonth() + 1
		const day = messageTime.getDate()
		const hours = messageTime.getHours()
		const minutes = messageTime.getMinutes()
		return `${month}月${day}日 ${padZero(hours)}:${padZero(minutes)}`
	}
	
	// 往年
	const year = messageTime.getFullYear()
	const month = messageTime.getMonth() + 1
	const day = messageTime.getDate()
	const hours = messageTime.getHours()
	const minutes = messageTime.getMinutes()
	return `${year}年${month}月${day}日 ${padZero(hours)}:${padZero(minutes)}`
}

/**
 * 判断是否是今天
 */
function isToday(date) {
	const now = new Date()
	return date.getFullYear() === now.getFullYear() &&
		date.getMonth() === now.getMonth() &&
		date.getDate() === now.getDate()
}

/**
 * 判断是否是昨天
 */
function isYesterday(date) {
	const yesterday = new Date()
	yesterday.setDate(yesterday.getDate() - 1)
	return date.getFullYear() === yesterday.getFullYear() &&
		date.getMonth() === yesterday.getMonth() &&
		date.getDate() === yesterday.getDate()
}

/**
 * 补零
 */
function padZero(num) {
	return num < 10 ? `0${num}` : num
}

/**
 * 格式化日期为后端需要的格式 yyyy-MM-dd HH:mm:ss
 * @param {Date} date 日期对象
 * @returns {string} 格式化后的日期字符串
 */
export function formatDateTime(date = new Date()) {
	const year = date.getFullYear()
	const month = String(date.getMonth() + 1).padStart(2, '0')
	const day = String(date.getDate()).padStart(2, '0')
	const hours = String(date.getHours()).padStart(2, '0')
	const minutes = String(date.getMinutes()).padStart(2, '0')
	const seconds = String(date.getSeconds()).padStart(2, '0')
	return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

