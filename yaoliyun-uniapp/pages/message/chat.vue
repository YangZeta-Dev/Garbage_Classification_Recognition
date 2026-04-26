<template>
	<view class="chat-container">
		<!-- 消息列表 -->
		<scroll-view 
			class="message-list" 
			scroll-y
			:scroll-top="scrollTop"
			:scroll-with-animation="true"
			id="message-scroll-view"
		>
			<view class="message-list-content" id="message-list-content">
				<view 
					v-for="(message, index) in messages" 
					:key="message.id || index"
					:id="`msg-${index}`"
					class="message-item"
					:class="{ 'is-mine': message.senderId == currentUserId }"
				>
				<!-- 时间分隔 -->
				<view v-if="shouldShowTime(index)" class="time-divider">
					<text class="time-text">{{ formatChatTime(message.timestamp) }}</text>
				</view>
				
				<view class="message-wrapper">
					<!-- 头像 -->
					<view class="avatar">
						<image 
							v-if="getMessageAvatar(message)" 
							:src="getMessageAvatar(message)" 
							mode="aspectFill"
							class="avatar-image"
						></image>
						<uv-icon v-else name="account-fill" size="28" color="#fff"></uv-icon>
					</view>
					
					<!-- 消息内容 -->
					<view class="message-content">
						<!-- 文本消息 -->
						<view v-if="message.messageType === 'text'" class="message-bubble">
							<text class="message-text">{{ message.message }}</text>
						</view>
						
						<!-- 图片消息 -->
						<view v-else-if="message.messageType === 'image'" class="message-bubble image-bubble" @click="previewImage(message.message)">
							<image :src="message.message" mode="widthFix" class="message-image"></image>
						</view>
						
						<!-- 语音消息 -->
						<view v-else-if="message.messageType === 'voice'" class="message-bubble voice-bubble" @click="playVoice(message)">
							<view class="voice-content">
								<uv-icon 
									:name="playingAudioId === message.id ? 'pause-circle-fill' : 'play-circle-fill'" 
									size="24" 
									:color="message.senderId === currentUserId ? '#333' : '#fff'"
								></uv-icon>
								<text class="voice-duration">{{ formatVoiceDuration(message.duration) }}</text>
							</view>
							<!-- 语音动画 -->
							<view v-if="playingAudioId === message.id" class="voice-playing">
								<view class="wave-bar" style="animation-delay: 0s;"></view>
								<view class="wave-bar" style="animation-delay: 0.1s;"></view>
								<view class="wave-bar" style="animation-delay: 0.2s;"></view>
							</view>
						</view>
					</view>
				</view>
			</view>
			</view>
		</scroll-view>
		
		<!-- 录音遮罩 -->
		<!-- #ifndef H5 -->
		<view v-if="isRecording" class="recording-mask">
			<view class="recording-content">
				<view class="recording-icon" :class="{ 'cancel': isCancelRecording }">
					<uv-icon name="mic" size="60" color="#fff"></uv-icon>
				</view>
				<text class="recording-text">{{ isCancelRecording ? '松开手指，取消发送' : '松开结束，上滑取消' }}</text>
				<text class="recording-time">{{ recordTime }}"</text>
			</view>
		</view>
		<!-- #endif -->
		
		<!-- 输入框 -->
		<view class="input-bar">
			<!-- #ifndef H5 -->
			<view 
				class="action-btn" 
				@touchstart="handleVoiceTouchStart"
				@touchmove="handleVoiceTouchMove"
				@touchend="handleVoiceTouchEnd"
				@click="handleVoice"
			>
				<uv-icon name="mic" size="32" color="#666"></uv-icon>
			</view>
			<!-- #endif -->
			
			<view class="input-wrapper">
				<input 
					class="message-input" 
					v-model="inputMessage" 
					placeholder="输入消息..." 
					placeholder-style="color: #ccc"
					:adjust-position="true"
					confirm-type="send"
					@confirm="sendMessage"
					@focus="onInputFocus"
				/>
			</view>
			
			
			
			<view v-if="!inputMessage.trim()" class="action-btn" @click="handleMore">
				<uv-icon name="plus-circle" size="32" color="#666"></uv-icon>
			</view>
			
			<view v-else class="send-btn" @click="sendMessage">
				<text class="send-text">发送</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getChatMessages, sendMessage as sendMessageApi, markMessageAsRead } from '@/api/chat.js'
import { showError, showSuccess } from '@/utils/index.js'
import { formatChatTime, formatDateTime } from '@/utils/time.js'
import { uploadFile } from '@/utils/request.js'

const messages = ref([])
const inputMessage = ref('')
const contactId = ref('')
const contactName = ref('')
const contactAvatar = ref('')
const currentUserId = ref('')
const currentUserAvatar = ref('')
const scrollTop = ref(0)

// 语音相关状态
const isRecording = ref(false)
const recordTime = ref(0)
const recordTimer = ref(null)
const recorderManager = ref(null)
const audioContext = ref(null)
const playingAudioId = ref(null)
const touchStartY = ref(0)
const isCancelRecording = ref(false)

// 页面加载
onLoad((options) => {
	if (options.contactId) {
		contactId.value = options.contactId
	}
	if (options.contactName) {
		contactName.value = decodeURIComponent(options.contactName)
	}
	if (options.contactAvatar) {
		contactAvatar.value = decodeURIComponent(options.contactAvatar)
	}
	
	// 获取当前用户信息
	const userInfo = uni.getStorageSync('userInfo')
	console.log(userInfo)
	if (userInfo) {
		if (userInfo.userId) {
			currentUserId.value = userInfo.userId
		}
		if (userInfo.avatar) {
			currentUserAvatar.value = userInfo.avatar
		}
	}
	
	// 初始化录音管理器（仅在支持的环境下）
	// #ifndef H5
	initRecorder()
	// #endif
	
	// 加载聊天记录
	loadMessages()
})

// 获取消息的头像
const getMessageAvatar = (message) => {
	// 如果是当前用户发送的消息，显示当前用户头像
	if (message.senderId === currentUserId.value) {
		return currentUserAvatar.value
	}
	// 否则显示联系人头像
	return contactAvatar.value
}

// 加载聊天记录
const loadMessages = async () => {
	try {
		if (!currentUserId.value || !contactId.value) {
			showError('参数错误')
			return
		}
		
		const res = await getChatMessages(currentUserId.value, contactId.value)
		console.log(res)
		if (res.code === 200) {
			messages.value = res.data || []
			// 延迟滚动到底部，确保消息渲染完成
			nextTick(() => {
				setTimeout(() => {
					scrollToBottom()
				}, 300)
			})
			
			// 标记消息为已读
			await markMessageAsRead(contactId.value, currentUserId.value)
		} else {
			showError(res.msg || '获取聊天记录失败')
		}
	} catch (error) {
		console.error('获取聊天记录失败:', error)
		showError('获取聊天记录失败')
	}
}

// 发送消息
const sendMessage = async () => {
	if (!inputMessage.value.trim()) {
		return
	}
	
	try {
		const now = new Date()
		const messageData = {
			senderId: currentUserId.value,
			receiverId: contactId.value,
			message: inputMessage.value.trim(),
			messageType: 'text',
			timestamp: formatDateTime(now)
		}
		
		const res = await sendMessageApi(messageData)
		
		if (res.code === 200) {
			// 添加到消息列表
			messages.value.push({
				...messageData,
				id: res.data?.id || Date.now(),
				readStatus: '0'
			})
			
			// 清空输入框
			inputMessage.value = ''
			
			// 滚动到底部
			setTimeout(() => {
				scrollToBottom()
			}, 200)
		} else {
			showError(res.msg || '发送失败')
		}
	} catch (error) {
		console.error('发送消息失败:', error)
		showError('发送失败，请重试')
	}
}

// 滚动到底部
const scrollToBottom = () => {
	nextTick(() => {
		// 使用 uni.createSelectorQuery 获取准确的滚动高度
		const query = uni.createSelectorQuery()
		
		// 查询消息列表内容的高度
		query.select('#message-list-content').boundingClientRect()
		// 查询 scroll-view 的高度
		query.select('#message-scroll-view').boundingClientRect()
		
		query.exec((res) => {
			if (res && res[0] && res[1]) {
				const contentHeight = res[0].height // 内容高度
				const scrollViewHeight = res[1].height // 容器高度
				
				// 计算需要滚动的距离
				const newScrollTop = contentHeight - scrollViewHeight
				
				// 确保值发生变化以触发滚动
				if (newScrollTop > 0) {
					// 如果当前值已经等于目标值，先设置一个稍小的值再设置回来
					if (scrollTop.value === newScrollTop) {
						scrollTop.value = newScrollTop - 1
						setTimeout(() => {
							scrollTop.value = newScrollTop
						}, 20)
					} else {
						scrollTop.value = newScrollTop
					}
				}
			}
		})
	})
}

// 输入框聚焦
const onInputFocus = () => {
	setTimeout(() => {
		scrollToBottom()
	}, 400)
}

// 判断是否显示时间
const shouldShowTime = (index) => {
	if (index === 0) return true
	
	const currentMsg = messages.value[index]
	const prevMsg = messages.value[index - 1]
	
	if (!currentMsg.timestamp || !prevMsg.timestamp) return false
	
	const currentTime = new Date(currentMsg.timestamp).getTime()
	const prevTime = new Date(prevMsg.timestamp).getTime()
	
	// 间隔超过5分钟显示时间
	return (currentTime - prevTime) > 5 * 60 * 1000
}

// 初始化录音管理器
const initRecorder = () => {
	try {
		recorderManager.value = uni.getRecorderManager()
		
		if (!recorderManager.value) {
			console.warn('当前环境不支持录音功能')
			return
		}
		
		// 录音开始事件
		recorderManager.value.onStart(() => {
			console.log('录音开始')
			isRecording.value = true
			recordTime.value = 0
			isCancelRecording.value = false
			
			// 开始计时
			recordTimer.value = setInterval(() => {
				recordTime.value++
				// 最长录音60秒
				if (recordTime.value >= 60) {
					stopRecording()
				}
			}, 1000)
		})
		
		// 录音结束事件
		recorderManager.value.onStop((res) => {
			console.log('录音结束', res)
			clearInterval(recordTimer.value)
			isRecording.value = false
			
			// 如果是取消录音，不发送
			if (isCancelRecording.value) {
				uni.showToast({
					title: '已取消发送',
					icon: 'none'
				})
				return
			}
			
			// 录音时间太短
			if (recordTime.value < 1) {
				uni.showToast({
					title: '录音时间太短',
					icon: 'none'
				})
				return
			}
			
			// 发送语音消息
			sendVoiceMessage(res.tempFilePath, recordTime.value)
		})
		
		// 录音错误事件
		recorderManager.value.onError((err) => {
			console.error('录音错误:', err)
			clearInterval(recordTimer.value)
			isRecording.value = false
			showError('录音失败，请检查麦克风权限')
		})
	} catch (error) {
		console.error('初始化录音管理器失败:', error)
	}
}

// 开始录音
const startRecording = () => {
	// 检查录音管理器是否初始化
	if (!recorderManager.value) {
		uni.showToast({
			title: '当前环境不支持录音',
			icon: 'none'
		})
		return
	}
	
	// 检查录音权限
	uni.authorize({
		scope: 'scope.record',
		success: () => {
			recorderManager.value.start({
				format: 'mp3',
				sampleRate: 16000,
				numberOfChannels: 1,
				encodeBitRate: 96000
			})
		},
		fail: () => {
			uni.showModal({
				title: '提示',
				content: '需要录音权限才能发送语音',
				confirmText: '去设置',
				success: (res) => {
					if (res.confirm) {
						uni.openSetting()
					}
				}
			})
		}
	})
}

// 停止录音
const stopRecording = () => {
	if (recorderManager.value && isRecording.value) {
		recorderManager.value.stop()
	}
}

// 取消录音
const cancelRecording = () => {
	isCancelRecording.value = true
	stopRecording()
}

// 语音按钮触摸开始
const handleVoiceTouchStart = (e) => {
	touchStartY.value = e.touches[0].clientY
	startRecording()
}

// 语音按钮触摸移动
const handleVoiceTouchMove = (e) => {
	if (!isRecording.value) return
	
	const currentY = e.touches[0].clientY
	const distance = touchStartY.value - currentY
	
	// 上滑超过100px，显示取消提示
	if (distance > 100) {
		isCancelRecording.value = true
	} else {
		isCancelRecording.value = false
	}
}

// 语音按钮触摸结束
const handleVoiceTouchEnd = () => {
	stopRecording()
}

// 语音输入（旧的点击事件，现改为触摸事件）
const handleVoice = () => {
	uni.showToast({
		title: '长按录音',
		icon: 'none'
	})
}

// 表情
const handleEmoji = () => {
	uni.showToast({
		title: '表情功能开发中',
		icon: 'none'
	})
}

// 更多功能
const handleMore = () => {
	uni.showActionSheet({
		itemList: ['相册', '拍摄'],
		success: (res) => {
			if (res.tapIndex === 0) {
				// 从相册选择图片
				chooseImage('album')
			} else if (res.tapIndex === 1) {
				// 拍摄照片
				chooseImage('camera')
			}
		}
	})
}

// 选择图片
const chooseImage = (sourceType) => {
	uni.chooseImage({
		count: 1,
		sizeType: ['compressed'],
		sourceType: [sourceType],
		success: async (res) => {
			const tempFilePath = res.tempFilePaths[0]
			await sendImageMessage(tempFilePath)
		},
		fail: (err) => {
			console.error('选择图片失败:', err)
			showError('选择图片失败')
		}
	})
}

// 发送语音消息
const sendVoiceMessage = async (filePath, duration) => {
	// 显示加载提示
	uni.showLoading({
		title: '发送中...',
		mask: true
	})
	
	try {
		// 上传语音文件
		const uploadRes = await uploadFile(filePath)
		
		uni.hideLoading()
		
		if (uploadRes.code === 200) {
			const voiceUrl = uploadRes.url || uploadRes.data?.url || uploadRes.fileName
			
			// 发送语音消息
			const messageData = {
				senderId: currentUserId.value,
				receiverId: contactId.value,
				message: voiceUrl,
				messageType: 'voice',
				timestamp: formatDateTime(new Date()),
				duration: duration // 语音时长
			}
			
			const res = await sendMessageApi(messageData)
			
			if (res.code === 200) {
				// 添加到消息列表
				messages.value.push({
					...messageData,
					id: res.data?.id || Date.now(),
					readStatus: '0'
				})
				
				// 滚动到底部
				setTimeout(() => {
					scrollToBottom()
				}, 200)
			} else {
				showError(res.msg || '发送失败')
			}
		} else {
			showError(uploadRes.msg || '语音上传失败')
		}
	} catch (error) {
		uni.hideLoading()
		console.error('发送语音失败:', error)
		showError('发送语音失败')
	}
}

// 发送图片消息
const sendImageMessage = async (filePath) => {
	// 显示加载提示
	uni.showLoading({
		title: '上传中...',
		mask: true
	})
	
	try {
		// 上传图片
		const uploadRes = await uploadFile(filePath)
		
		uni.hideLoading()
		
		if (uploadRes.code === 200) {
			const imageUrl = uploadRes.url || uploadRes.data?.url || uploadRes.fileName
			
			// 发送图片消息
			const messageData = {
				senderId: currentUserId.value,
				receiverId: contactId.value,
				message: imageUrl,
				messageType: 'image',
				timestamp: formatDateTime(new Date())
			}
			
			const res = await sendMessageApi(messageData)
			
			if (res.code === 200) {
				// 添加到消息列表
				messages.value.push({
					...messageData,
					id: res.data?.id || Date.now(),
					readStatus: '0'
				})
				
				// 滚动到底部
				setTimeout(() => {
					scrollToBottom()
				}, 400)
			} else {
				showError(res.msg || '发送失败')
			}
		} else {
			showError(uploadRes.msg || '图片上传失败')
		}
	} catch (error) {
		uni.hideLoading()
		console.error('发送图片失败:', error)
		showError('发送图片失败')
	}
}

// 预览图片
const previewImage = (url) => {
	// 获取所有图片消息的URL
	const imageUrls = messages.value
		.filter(msg => msg.messageType === 'image')
		.map(msg => msg.message)
	
	uni.previewImage({
		urls: imageUrls,
		current: url
	})
}

// 播放语音
const playVoice = (message) => {
	// 如果正在播放同一条语音，则停止
	if (playingAudioId.value === message.id) {
		stopVoice()
		return
	}
	
	// 停止之前的播放
	if (audioContext.value) {
		audioContext.value.stop()
		audioContext.value.destroy()
	}
	
	// 创建音频上下文
	audioContext.value = uni.createInnerAudioContext()
	audioContext.value.src = message.message
	
	// 播放开始
	audioContext.value.onPlay(() => {
		console.log('开始播放')
		playingAudioId.value = message.id
	})
	
	// 播放结束
	audioContext.value.onEnded(() => {
		console.log('播放结束')
		playingAudioId.value = null
	})
	
	// 播放错误
	audioContext.value.onError((err) => {
		console.error('播放错误:', err)
		playingAudioId.value = null
		showError('播放失败')
	})
	
	// 开始播放
	audioContext.value.play()
}

// 停止播放语音
const stopVoice = () => {
	if (audioContext.value) {
		audioContext.value.stop()
		playingAudioId.value = null
	}
}

// 格式化语音时长
const formatVoiceDuration = (duration) => {
	if (!duration) return "1''"
	return duration + "''"
}

// 返回
const goBack = () => {
	uni.navigateBack()
}
</script>

<style lang="scss" scoped>
.chat-container {
	height: 100vh;
	display: flex;
	flex-direction: column;
	background-color: #f5f5f5;
}

.chat-header {
	background-color: #fff;
	padding: 20rpx 30rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1rpx solid #f0f0f0;
	
	.header-left,
	.header-right {
		width: 80rpx;
		height: 60rpx;
		display: flex;
		align-items: center;
	}
	
	.header-right {
		justify-content: flex-end;
	}
	
	.header-title {
		flex: 1;
		text-align: center;
		font-size: 32rpx;
		font-weight: 600;
		color: #333;
	}
}

.message-list {
	flex: 1;
	padding: 20rpx 30rpx;
	box-sizing: border-box;
	background-color: #f5f5f5;
	
	.message-list-content {
		width: 100%;
	}
	
	.message-item {
		margin-bottom: 30rpx;
		
		.time-divider {
			display: flex;
			justify-content: center;
			margin-bottom: 30rpx;
			
			.time-text {
				font-size: 24rpx;
				color: #999;
				background-color: rgba(0, 0, 0, 0.05);
				padding: 8rpx 16rpx;
				border-radius: 8rpx;
			}
		}
		
		.message-wrapper {
			display: flex;
			align-items: flex-start;
			
			.avatar {
				width: 72rpx;
				height: 72rpx;
				border-radius: 12rpx;
				background: linear-gradient(135deg, #A8D8F0 0%, #85C9E8 100%);
				display: flex;
				align-items: center;
				justify-content: center;
				margin-right: 16rpx;
				overflow: hidden;
				flex-shrink: 0;
				
				.avatar-image {
					width: 100%;
					height: 100%;
				}
			}
			
			.message-content {
				display: flex;
				flex-direction: column;
				align-items: flex-start;
				max-width: 500rpx;
				
				.message-bubble {
					background-color: #fff;
					padding: 20rpx 24rpx;
					border-radius: 12rpx;
					box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
					display: inline-block;
					max-width: 100%;
					
					.message-text {
						font-size: 28rpx;
						color: #333;
						line-height: 1.5;
						word-wrap: break-word;
						word-break: break-all;
					}
				}
				
				.image-bubble {
					padding: 8rpx;
					background-color: #fff;
					
					.message-image {
						max-width: 400rpx;
						max-height: 400rpx;
						min-width: 200rpx;
						min-height: 100rpx;
						border-radius: 8rpx;
						display: block;
					}
				}
				
				.voice-bubble {
					padding: 20rpx 32rpx;
					min-width: 160rpx;
					max-width: 400rpx;
					display: flex;
					align-items: center;
					gap: 16rpx;
					cursor: pointer;
					transition: all 0.3s;
					
					&:active {
						transform: scale(0.95);
					}
					
					.voice-content {
						display: flex;
						align-items: center;
						gap: 12rpx;
						
						.voice-duration {
							font-size: 28rpx;
							color: #333;
						}
					}
					
					.voice-playing {
						display: flex;
						align-items: center;
						gap: 6rpx;
						margin-left: auto;
						
						.wave-bar {
							width: 6rpx;
							height: 24rpx;
							background: #333;
							border-radius: 3rpx;
							animation: wave 1s ease-in-out infinite;
						}
					}
				}
			}
		}
		
		&.is-mine {
			.message-wrapper {
				flex-direction: row-reverse;
				
				.avatar {
					background: linear-gradient(135deg, #F5E27A 0%, #F0D858 100%);
					margin-right: 0;
					margin-left: 16rpx;
				}
				
				.message-content {
					align-items: flex-end;
					
					.message-bubble {
						background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
						
						.message-text {
							color: #333;
						}
					}
					
					.image-bubble {
						background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
					}
					
					.voice-bubble {
						background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
						
						.voice-content .voice-duration {
							color: #333;
						}
						
						.voice-playing .wave-bar {
							background: #333;
						}
					}
				}
			}
		}
	}
}

// 录音遮罩
.recording-mask {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.7);
	z-index: 9999;
	display: flex;
	align-items: center;
	justify-content: center;
	
	.recording-content {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 24rpx;
		
		.recording-icon {
			width: 200rpx;
			height: 200rpx;
			border-radius: 100%;
			background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
			display: flex;
			align-items: center;
			justify-content: center;
			box-shadow: 0 8rpx 32rpx rgba(245, 226, 122, 0.4);
			animation: recording-pulse 1.5s ease-in-out infinite;
			
			&.cancel {
				background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
				box-shadow: 0 8rpx 32rpx rgba(255, 107, 107, 0.4);
			}
		}
		
		.recording-text {
			font-size: 32rpx;
			color: #fff;
			font-weight: 600;
		}
		
		.recording-time {
			font-size: 48rpx;
			color: #F5E27A;
			font-weight: 700;
		}
	}
}

// 录音动画
@keyframes recording-pulse {
	0%, 100% {
		transform: scale(1);
	}
	50% {
		transform: scale(1.1);
	}
}

// 语音播放动画
@keyframes wave {
	0%, 100% {
		height: 24rpx;
	}
	50% {
		height: 48rpx;
	}
}

.input-bar {
	background-color: #fff;
	padding: 16rpx 24rpx;
	display: flex;
	align-items: center;
	gap: 12rpx;
	border-top: 1rpx solid #e8e8e8;
	padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
	box-shadow: 0 -2rpx 8rpx rgba(0, 0, 0, 0.03);
	
	.action-btn {
		width: 70rpx;
		height: 70rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		flex-shrink: 0;
		transition: all 0.3s;
		
		&:active {
			opacity: 0.6;
			transform: scale(0.95);
		}
	}
	
	.input-wrapper {
		flex: 1;
		min-width: 0;
		
		.message-input {
			width: 100%;
			background-color: #f7f7f7;
			border-radius: 48rpx;
			padding: 18rpx 32rpx;
			font-size: 30rpx;
			color: #333;
			line-height: 1.5;
			min-height: 72rpx;
			box-sizing: border-box;
		}
	}
	
	.send-btn {
		background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
		border-radius: 48rpx;
		padding: 18rpx 40rpx;
		min-width: 120rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		flex-shrink: 0;
		box-shadow: 0 4rpx 12rpx rgba(245, 226, 122, 0.3);
		transition: all 0.3s;
		
		&:active {
			transform: scale(0.95);
			box-shadow: 0 2rpx 8rpx rgba(245, 226, 122, 0.2);
		}
		
		.send-text {
			font-size: 30rpx;
			color: #333;
			font-weight: 600;
			letter-spacing: 1rpx;
		}
	}
}
</style>

