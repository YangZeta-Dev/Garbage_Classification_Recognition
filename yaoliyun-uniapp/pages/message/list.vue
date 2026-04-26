<template>
	<uv-status-bar></uv-status-bar>
	<view class="message-list-container">
		<!-- 顶部标题栏 -->
		<view class="header">
			<view class="title">消息</view>
			<!-- <view class="header-actions">
				<view class="action-btn" @click="handleAddChat">
					<uv-icon name="plus-circle" size="24" color="#333"></uv-icon>
				</view>
			</view> -->
		</view>
		
		<!-- 搜索框 -->
		<view class="search-box">
			<view class="search-input-wrapper">
				<uv-icon name="search" size="20" color="#999"></uv-icon>
				<input 
					class="search-input" 
					v-model="searchKeyword" 
					placeholder="搜索联系人" 
					placeholder-style="color: #ccc"
					@input="handleSearch"
				/>
			</view>
		</view>
		
		<!-- 会话列表 -->
		<scroll-view 
			class="session-list" 
			scroll-y
			:refresher-enabled="true"
			:refresher-triggered="refreshing"
			@refresherrefresh="onRefresh"
		>
			<view 
				v-for="session in filteredSessions" 
				:key="session.id" 
				class="session-item"
				@click="openChat(session)"
			>
				<view class="avatar-wrapper">
					<view class="avatar">
						<image 
							v-if="session.contactAvatar || session.avatar" 
							:src="session.contactAvatar || session.avatar" 
							mode="aspectFill"
							class="avatar-image"
						></image>
						<uv-icon v-else name="account-fill" size="32" color="#fff"></uv-icon>
					</view>
					<view v-if="session.unreadCount > 0" class="unread-badge">
						{{ session.unreadCount > 99 ? '99+' : session.unreadCount }}
					</view>
				</view>
				
				<view class="session-content">
					<view class="session-header">
						<text class="contact-name">{{ session.contactName }}</text>
						<text class="message-time">{{ formatTime(session.lastMessageTime) }}</text>
					</view>
					<view class="last-message">
						<text class="message-text" :class="{ 'unread': session.unreadCount > 0 }">
							{{ formatLastMessage(session) }}
						</text>
					</view>
				</view>
			</view>
			
			<!-- 空状态 -->
			<view v-if="filteredSessions.length === 0" class="empty-state">
				<uv-icon name="chat" size="80" color="#ddd"></uv-icon>
				<text class="empty-text">暂无消息</text>
			</view>
		</scroll-view>
	</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getChatSessions } from '@/api/chat.js'
import { showError } from '@/utils/index.js'
import { formatMessageTime } from '@/utils/time.js'
import { onShow } from '@dcloudio/uni-app'

const sessions = ref([])
const searchKeyword = ref('')
const refreshing = ref(false)
const currentUserId = ref('')

// 过滤后的会话列表
const filteredSessions = computed(() => {
	if (!searchKeyword.value) {
		return sessions.value
	}
	return sessions.value.filter(session => 
		session.contactName.includes(searchKeyword.value)
	)
})

// 格式化时间
const formatTime = (time) => {
	if (!time) return ''
	return formatMessageTime(time)
}

// 格式化最后一条消息
const formatLastMessage = (session) => {
	if (!session.lastMessage) {
		return '暂无消息'
	}
	
	// 判断消息类型
	if (session.messageType === 'image' || session.lastMessageType === 'image') {
		return '【图片】'
	}
	
	// 如果lastMessage是图片URL（包含http或/profile等路径），也显示为【图片】
	if (session.lastMessage.includes('http') || session.lastMessage.includes('/profile/upload')) {
		return '【图片】'
	}
	
	return session.lastMessage
}

// 搜索处理
const handleSearch = () => {
	// 搜索逻辑已在computed中处理
}

// 获取会话列表
const loadSessions = async () => {
	try {
		// 从本地存储获取当前用户ID
		const userInfo = uni.getStorageSync('userInfo')
		if (!userInfo || !userInfo.userId) {
			showError('请先登录')
			return
		}
		
		currentUserId.value = userInfo.userId
		const res = await getChatSessions(currentUserId.value)
		
		if (res.code === 200) {
			sessions.value = res.data || []
		} else {
			showError(res.msg || '获取会话列表失败')
		}
	} catch (error) {
		console.error('获取会话列表失败:', error)
		showError('获取会话列表失败')
	}
}

// 下拉刷新
const onRefresh = async () => {
	refreshing.value = true
	await loadSessions()
	setTimeout(() => {
		refreshing.value = false
	}, 500)
}

// 打开聊天页面
const openChat = (session) => {
	const avatar = session.contactAvatar || session.avatar || ''
	uni.navigateTo({
		url: `/pages/message/chat?contactId=${session.contactId}&contactName=${encodeURIComponent(session.contactName)}&contactAvatar=${encodeURIComponent(avatar)}`
	})
}

// 添加新聊天
const handleAddChat = () => {
	uni.navigateTo({
		url: '/pages/message/contacts'
	})
}

onMounted(() => {
	loadSessions()
})

onShow(() => {
	// 页面显示时刷新列表
	loadSessions()
})
</script>

<style lang="scss" scoped>
.message-list-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.header {
	background-color: #fff;
	padding: 20rpx 30rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1rpx solid #f0f0f0;
	
	.title {
		font-size: 36rpx;
		font-weight: 700;
		color: #333;
	}
	
	.header-actions {
		display: flex;
		gap: 20rpx;
		
		.action-btn {
			width: 60rpx;
			height: 60rpx;
			display: flex;
			align-items: center;
			justify-content: center;
		}
	}
}

.search-box {
	background-color: #fff;
	padding: 20rpx 30rpx;
	border-bottom: 1rpx solid #f0f0f0;
	
	.search-input-wrapper {
		display: flex;
		align-items: center;
		background-color: #f5f5f5;
		border-radius: 50rpx;
		padding: 16rpx 30rpx;
		gap: 16rpx;
		
		.search-input {
			flex: 1;
			font-size: 28rpx;
			color: #333;
		}
	}
}

.session-list {
	flex: 1;
	background-color: #fff;
	
	.session-item {
		display: flex;
		padding: 24rpx 30rpx;
		border-bottom: 1rpx solid #f0f0f0;
		transition: background-color 0.3s;
		
		&:active {
			background-color: #f8f8f8;
		}
		
		.avatar-wrapper {
			position: relative;
			margin-right: 24rpx;
			
			.avatar {
				width: 96rpx;
				height: 96rpx;
				border-radius: 16rpx;
				background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
				display: flex;
				align-items: center;
				justify-content: center;
				overflow: hidden;
				
				.avatar-image {
					width: 100%;
					height: 100%;
				}
			}
			
			.unread-badge {
				position: absolute;
				top: -8rpx;
				right: -8rpx;
				min-width: 36rpx;
				height: 36rpx;
				background-color: #ff4d4f;
				border-radius: 18rpx;
				display: flex;
				align-items: center;
				justify-content: center;
				padding: 0 8rpx;
				font-size: 20rpx;
				color: #fff;
				font-weight: 600;
			}
		}
		
		.session-content {
			flex: 1;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			overflow: hidden;
			
			.session-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 12rpx;
				
				.contact-name {
					font-size: 30rpx;
					font-weight: 600;
					color: #333;
				}
				
				.message-time {
					font-size: 24rpx;
					color: #999;
				}
			}
			
			.last-message {
				.message-text {
					font-size: 26rpx;
					color: #999;
					overflow: hidden;
					text-overflow: ellipsis;
					white-space: nowrap;
					display: block;
					
					&.unread {
						color: #333;
						font-weight: 500;
					}
				}
			}
		}
	}
	
	.empty-state {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		padding: 200rpx 0;
		
		.empty-text {
			margin-top: 30rpx;
			font-size: 28rpx;
			color: #999;
		}
	}
}
</style>

