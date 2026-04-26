<template>
	<uv-status-bar bgColor="#fff"></uv-status-bar>
	<view class="user-container">
		<!-- 顶部用户信息 -->
		<view class="user-header">
			<view class="header-bg"></view>
			<view class="user-info" @click="handleUserInfoClick">
				<view class="avatar-wrapper">
					<view class="avatar">
						<image 
							v-if="userInfo.avatar" 
							:src="userInfo.avatar" 
							mode="aspectFill"
							class="avatar-image"
						></image>
						<uv-icon v-else name="account-fill" size="48" color="#fff"></uv-icon>
					</view>
				</view>
				<view class="user-details">
					<text class="user-name">{{ userInfo.nickName || userInfo.userName || '未登录' }}</text>
					<text class="user-desc">{{ userInfo.phonenumber || '点击登录/注册' }}</text>
					<text class="user-title" v-if="isLoggedIn">🌿 环保小卫士</text>
				</view>
			</view>
		</view>
		
		
	
		
		<!-- 功能菜单 -->
		<view class="menu-section">
			<view 
				v-for="menu in menuList" 
				:key="menu.id" 
				class="menu-item"
				@click="handleMenuClick(menu)"
			>
				<view class="menu-left">
					<view class="menu-icon">
						<uv-icon :name="menu.icon" size="24" color="#333"></uv-icon>
					</view>
					<text class="menu-name">{{ menu.name }}</text>
				</view>
				<view class="menu-right">
					<text v-if="menu.badge" class="menu-badge">{{ menu.badge }}</text>
					<uv-icon name="arrow-right" size="18" color="#999"></uv-icon>
				</view>
			</view>
		</view>
		
		<!-- 其他功能 -->
		<view class="other-section">
			<view class="menu-item" @click="toAbout">
				<view class="menu-left">
					<view class="menu-icon">
						<uv-icon name="info-circle" size="24" color="#333"></uv-icon>
					</view>
					<text class="menu-name">关于我们</text>
				</view>
				<view class="menu-right">
					<text class="version-text">v1.0.0</text>
					<uv-icon name="arrow-right" size="18" color="#999"></uv-icon>
				</view>
			</view>
		</view>
		
		<!-- 退出登录按钮 -->
		<view class="logout-section" v-if="isLoggedIn">
			<view class="logout-btn" @click="handleLogout">
				<text class="logout-text">退出登录</text>
			</view>
		</view>
		
		<!-- 底部占位 -->
		<view class="bottom-placeholder"></view>
	</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { showError, showSuccess } from '@/utils/index.js'

const userInfo = ref({})
const ecoStats = ref({
	recognitions: 0,
	correct: 0,
	points: 0
})

// 是否已登录
const isLoggedIn = computed(() => {
	return !!userInfo.value.userId
})

// 功能菜单
const menuList = ref([
	{ 
		id: 1, 
		name: '识别记录', 
		icon: 'list', 
		url: '/pages/garbage/record'
	},
	{ 
		id: 2, 
		name: '分类指南', 
		icon: 'file-text', 
		url: '/pages/garbage/category'
	},
	{ 
		id: 3, 
		name: '修改密码', 
		icon: 'lock', 
		url: '/pages/user/change-password'
	},
	{ 
		id: 4, 
		name: '意见反馈', 
		icon: 'edit-pen', 
		url: '/pages/feedback/feedback'
	}
])

// 加载用户信息
const loadUserInfo = () => {
	const info = uni.getStorageSync('userInfo')
	if (info) {
		userInfo.value = info
	}
}

// 跳转到设置
const toSettings = () => {
	uni.navigateTo({
		url: '/pages/user/settings'
	})
}

// 跳转到我的项目
const toMyProjects = () => {
	if (!isLoggedIn.value) {
		toLogin()
		return
	}
	uni.showToast({
		title: '我的项目开发中',
		icon: 'none'
	})
}

// 跳转到我的模板
const toMyTemplates = () => {
	if (!isLoggedIn.value) {
		toLogin()
		return
	}
	uni.showToast({
		title: '我的模板开发中',
		icon: 'none'
	})
}

// 跳转到我的订单
const toMyOrders = () => {
	if (!isLoggedIn.value) {
		toLogin()
		return
	}
	uni.showToast({
		title: '我的订单开发中',
		icon: 'none'
	})
}

// 菜单点击
const handleMenuClick = (menu) => {
	if (!isLoggedIn.value) {
		toLogin()
		return
	}
	
	// 如果菜单有url，则跳转
	if (menu.url) {
		uni.navigateTo({
			url: menu.url
		})
	} else {
		uni.showToast({
			title: `${menu.name}开发中`,
			icon: 'none'
		})
	}
}

// 关于我们
const toAbout = () => {
	uni.navigateTo({
		url: '/pages/user/about'
	})
}

// 退出登录
const handleLogout = () => {
	uni.showModal({
		title: '提示',
		content: '确定要退出登录吗？',
		success: (res) => {
			if (res.confirm) {
				// 清除本地存储
				uni.removeStorageSync('token')
				uni.removeStorageSync('userInfo')
				userInfo.value = {}
				showSuccess('已退出登录')
				
				// 跳转到登录页
				setTimeout(() => {
					toLogin()
				}, 500)
			}
		}
	})
}

// 点击用户信息区域
const handleUserInfoClick = () => {
	if (!isLoggedIn.value) {
		toLogin()
	} else {
		// 跳转到编辑资料页面
		uni.navigateTo({
			url: '/pages/user/edit'
		})
	}
}

// 跳转到登录页
const toLogin = () => {
	uni.navigateTo({
		url: '/pages/login/login'
	})
}

onMounted(() => {
	loadUserInfo()
})

onShow(() => {
	loadUserInfo()
})
</script>

<style lang="scss" scoped>
.user-container {
	min-height: 100vh;
	background-color: #f5f5f5;
}

.user-header {
	position: relative;
	padding: 60rpx 30rpx 40rpx;
	overflow: hidden;
	
	.header-bg {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		height: 280rpx;
		background: linear-gradient(135deg, #4CAF50 0%, #8BC34A 100%);
		border-radius: 0 0 60rpx 60rpx;
	}
	
	.user-info {
		position: relative;
		z-index: 1;
		display: flex;
		align-items: center;
		gap: 24rpx;
		flex: 1;
		
		.avatar-wrapper {
			.avatar {
				width: 140rpx;
				height: 140rpx;
				border-radius: 70rpx;
				background-color: rgba(255, 255, 255, 0.3);
				display: flex;
				align-items: center;
				justify-content: center;
				border: 4rpx solid #fff;
				overflow: hidden;
				box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.1);
				
				.avatar-image {
					width: 100%;
					height: 100%;
				}
			}
		}
		
		.user-details {
			display: flex;
			flex-direction: column;
			gap: 8rpx;
			
			.user-name {
				font-size: 40rpx;
				font-weight: 700;
				color: #fff;
			}
			
			.user-desc {
				font-size: 26rpx;
				color: rgba(255, 255, 255, 0.9);
			}
			
			.user-title {
				font-size: 24rpx;
				color: #fff;
				background-color: rgba(255, 255, 255, 0.2);
				padding: 6rpx 16rpx;
				border-radius: 20rpx;
				margin-top: 8rpx;
				display: inline-block;
				width: fit-content;
			}
		}
	}
}

.eco-stats {
	background-color: #fff;
	margin: -40rpx 30rpx 20rpx;
	border-radius: 24rpx;
	padding: 40rpx 0;
	display: flex;
	box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.08);
	position: relative;
	z-index: 2;
	
	.stat-item {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 12rpx;
		
		.stat-value {
			font-size: 44rpx;
			font-weight: 700;
			color: #4CAF50;
		}
		
		.stat-label {
			font-size: 24rpx;
			color: #999;
		}
	}
	
	.stat-divider {
		width: 2rpx;
		height: 60rpx;
		background-color: #f0f0f0;
		align-self: center;
	}
}

.stats-section {
	background-color: #fff;
	margin: 20rpx 30rpx;
	border-radius: 24rpx;
	padding: 40rpx 0;
	display: flex;
	box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
	
	.stat-item {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 12rpx;
		
		.stat-value {
			font-size: 40rpx;
			font-weight: 700;
			color: #333;
		}
		
		.stat-label {
			font-size: 26rpx;
			color: #999;
		}
	}
	
	.stat-divider {
		width: 2rpx;
		height: 60rpx;
		background-color: #f0f0f0;
		align-self: center;
	}
}

.menu-section,
.other-section {
	background-color: #fff;
	margin: 20rpx 30rpx;
	border-radius: 24rpx;
	overflow: hidden;
	box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
	
	.menu-item {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 28rpx 30rpx;
		border-bottom: 1rpx solid #f0f0f0;
		transition: background-color 0.3s;
		
		&:last-child {
			border-bottom: none;
		}
		
		&:active {
			background-color: #f8f8f8;
		}
		
		.menu-left {
			display: flex;
			align-items: center;
			gap: 24rpx;
			
			.menu-icon {
				width: 72rpx;
				height: 72rpx;
				border-radius: 16rpx;
				display: flex;
				align-items: center;
				justify-content: center;
				background-color: #f5f5f5;
			}
			
			.menu-name {
				font-size: 30rpx;
				color: #333;
			}
		}
		
		.menu-right {
			display: flex;
			align-items: center;
			gap: 16rpx;
			
			.menu-badge {
				min-width: 32rpx;
				height: 32rpx;
				background-color: #ff4d4f;
				border-radius: 16rpx;
				display: flex;
				align-items: center;
				justify-content: center;
				padding: 0 8rpx;
				font-size: 20rpx;
				color: #fff;
				font-weight: 600;
			}
			
			.version-text {
				font-size: 26rpx;
				color: #999;
			}
		}
	}
}

.logout-section {
	margin: 20rpx 30rpx;
	
	.logout-btn {
		background-color: #fff;
		border-radius: 24rpx;
		padding: 28rpx;
		text-align: center;
		box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
		border: 2rpx solid #ffcdd2;
		
		.logout-text {
			font-size: 30rpx;
			color: #f44336;
			font-weight: 600;
		}
	}
}

.bottom-placeholder {
	height: 120rpx;
}
</style>

