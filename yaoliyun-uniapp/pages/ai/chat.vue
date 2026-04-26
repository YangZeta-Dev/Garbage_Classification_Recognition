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
					:key="message.id"
					:id="`msg-${index}`"
					class="message-item"
					:class="{ 'is-mine': message.role === 'user' }"
				>
					<!-- 时间分隔 -->
					<view v-if="shouldShowTime(index)" class="time-divider">
						<text class="time-text">{{ formatChatTime(message.timestamp) }}</text>
					</view>
					
					<view class="message-wrapper">
						<!-- 头像 -->
						<view class="avatar">
							<uv-avatar v-if="message.role === 'user'"  :src="avatar"></uv-avatar>
							<uv-avatar v-else  src="https://tse1-mm.cn.bing.net/th/id/OIP-C.zV2PgNEemYIi7XNTb9RXAAHaEm?w=289&h=180&c=7&r=0&o=7&pid=1.7&rm=3"></uv-avatar>
							
						</view>
						
						<!-- 消息内容 -->
						<view class="message-content">
							<view class="message-bubble">
								<text class="message-text">{{ message.content }}</text>
								<!-- 加载动画 -->
								<view v-if="message.loading" class="typing-indicator">
									<view class="typing-dot"></view>
									<view class="typing-dot"></view>
									<view class="typing-dot"></view>
								</view>
							</view>
						</view>
					</view>
				</view>
			</view>
		</scroll-view>
		
		<!-- 输入框 -->
		<view class="input-bar">
			<view class="input-wrapper">
				<input 
					class="message-input" 
					v-model="inputMessage" 
					placeholder="向AI提问..." 
					placeholder-style="color: #ccc"
					:adjust-position="true"
					:disabled="isSending"
					confirm-type="send"
					@confirm="sendMessage"
					@focus="onInputFocus"
				/>
			</view>
			
			<view 
				class="send-btn" 
				:class="{ 'disabled': !inputMessage.trim() || isSending }"
				@click="sendMessage"
			>
				<text class="send-text">{{ isSending ? '发送中' : '发送' }}</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { simpleChat } from '@/api/ai.js'
import { showError } from '@/utils/index.js'
import { formatChatTime, formatDateTime } from '@/utils/time.js'

const messages = ref([])
const inputMessage = ref('')
const avatar=ref()
const scrollTop = ref(0)
const isSending = ref(false)
let messageIdCounter = 0

// 页面加载
onLoad(() => {
	// 添加欢迎消息
	addMessage({
		role: 'assistant',
		content: '你好！我是AI助手，有什么可以帮助你的吗？',
		timestamp: new Date()
	})
	const user = uni.getStorageSync('userInfo')
	avatar.value=user.avatar
})

// 添加消息到列表
const addMessage = (message) => {
	messages.value.push({
		id: ++messageIdCounter,
		role: message.role,
		content: message.content || '',
		timestamp: message.timestamp || new Date(),
		loading: message.loading || false
	})
	
	// 延迟滚动到底部
	nextTick(() => {
		setTimeout(() => {
			scrollToBottom()
		}, 100)
	})
}

// 更新最后一条消息的内容
const updateLastMessage = (content, loading = false) => {
	if (messages.value.length > 0) {
		const lastMessage = messages.value[messages.value.length - 1]
		lastMessage.content = content
		lastMessage.loading = loading
		
		// 滚动到底部
		nextTick(() => {
			scrollToBottom()
		})
	}
}

// 发送消息
const sendMessage = async () => {
	const message = inputMessage.value.trim()
	if (!message || isSending.value) {
		return
	}
	
	// 添加用户消息
	addMessage({
		role: 'user',
		content: message,
		timestamp: new Date()
	})
	
	// 清空输入框
	inputMessage.value = ''
	isSending.value = true
	
	// 添加AI消息占位符（显示加载动画）
	addMessage({
		role: 'assistant',
		content: '',
		timestamp: new Date(),
		loading: true
	})
	
	try {
		// 调用简单聊天接口
		const res = await simpleChat(message)
		
		if (res.statusCode === 200 && res.data.code === 200) {
			updateLastMessage(res.data.msg || res.data.data || '抱歉，我暂时无法回答这个问题。', false)
		} else {
			updateLastMessage('抱歉，我遇到了一些问题，请稍后再试。', false)
		}
		
		isSending.value = false
	} catch (error) {
		console.error('发送消息失败:', error)
		updateLastMessage('抱歉，发送失败，请重试。', false)
		isSending.value = false
	}
}

// 滚动到底部
const scrollToBottom = () => {
	nextTick(() => {
		const query = uni.createSelectorQuery()
		
		query.select('#message-list-content').boundingClientRect()
		query.select('#message-scroll-view').boundingClientRect()
		
		query.exec((res) => {
			if (res && res[0] && res[1]) {
				const contentHeight = res[0].height
				const scrollViewHeight = res[1].height
				
				const newScrollTop = contentHeight - scrollViewHeight
				
				if (newScrollTop > 0) {
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
</script>

<style lang="scss" scoped>
.chat-container {
	height: 100vh;
	display: flex;
	flex-direction: column;
	background-color: #f5f5f5;
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
				display: flex;
				align-items: center;
				justify-content: center;
				margin-right: 16rpx;
				flex-shrink: 0;
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
					position: relative;
					
					.message-text {
						font-size: 28rpx;
						color: #333;
						line-height: 1.6;
						word-wrap: break-word;
						word-break: break-word;
						white-space: pre-wrap;
					}
					
					.typing-indicator {
						display: flex;
						align-items: center;
						gap: 8rpx;
						margin-top: 12rpx;
						
						.typing-dot {
							width: 12rpx;
							height: 12rpx;
							border-radius: 50%;
							background-color: #85C9E8;
							animation: typing 1.4s infinite;
							
							&:nth-child(2) {
								animation-delay: 0.2s;
							}
							
							&:nth-child(3) {
								animation-delay: 0.4s;
							}
						}
					}
				}
			}
		}
		
		&.is-mine {
			.message-wrapper {
				flex-direction: row-reverse;
				
				.avatar {
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
				}
			}
		}
	}
}

@keyframes typing {
	0%, 60%, 100% {
		transform: translateY(0);
		opacity: 0.5;
	}
	30% {
		transform: translateY(-10rpx);
		opacity: 1;
	}
}

.input-bar {
	background-color: #fff;
	padding: 16rpx 24rpx;
	display: flex;
	align-items: center;
	gap: 12rpx;
	border-top: 1rpx solid #e8e8e8;
	// padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
	box-shadow: 0 -2rpx 8rpx rgba(0, 0, 0, 0.03);
	
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
		
		&:active:not(.disabled) {
			transform: scale(0.95);
			box-shadow: 0 2rpx 8rpx rgba(245, 226, 122, 0.2);
		}
		
		&.disabled {
			opacity: 0.5;
			box-shadow: none;
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


