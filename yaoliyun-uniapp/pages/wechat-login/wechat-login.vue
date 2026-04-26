<template>
	<view class="wechat-login-container">
		<!-- 装饰圆圈 -->
		<view class="decoration-circles">
			<view class="circle circle-blue"></view>
			<view class="circle circle-yellow"></view>
		</view>
		
		<!-- Logo区域 -->
		<view class="logo-section">
			<view class="app-logo">
				<uv-icon name="star-fill" size="80" color="#F5E27A"></uv-icon>
			</view>
			<view class="app-name">瑶力云</view>
			<view class="app-slogan">智能代码生成平台</view>
		</view>
		
		<!-- 登录方式 -->
		<view class="login-methods">
			<!-- 微信一键登录 -->
			<view class="wechat-login-btn" @click="handleWechatLogin">
				<view class="wechat-btn-content">
					<view class="btn-icon-wrapper">
						<uv-icon name="weixin-fill" size="36" color="#fff"></uv-icon>
					</view>
					<text class="btn-text">微信一键登录</text>
				</view>
			</view>
			
			<!-- 其他登录方式 -->
			<view class="other-methods">
				<view class="method-item" @click="toAccountLogin">
					<view class="method-icon">
						<uv-icon name="account-fill" size="28" color="#666"></uv-icon>
					</view>
					<text class="method-text">账号密码登录</text>
				</view>
				
				<view class="method-item" @click="handlePhoneLogin">
					<view class="method-icon">
						<uv-icon name="phone-fill" size="28" color="#666"></uv-icon>
					</view>
					<text class="method-text">手机号登录</text>
				</view>
			</view>
		</view>
		
		<!-- 底部协议 -->
		<view class="footer-agreement">
			<view class="checkbox-wrapper" @click="agreed = !agreed">
				<view class="checkbox" :class="{ checked: agreed }">
					<uv-icon v-if="agreed" name="checkbox-mark" size="16" color="#fff"></uv-icon>
				</view>
				<text class="agreement-text">我已阅读并同意</text>
			</view>
			<text class="agreement-link" @click="showAgreement">《用户协议》</text>
			<text class="agreement-text">和</text>
			<text class="agreement-link" @click="showPrivacy">《隐私协议》</text>
		</view>
		
		<!-- 注册入口 -->
		<view class="register-entry">
			<text class="entry-text">没有账号？</text>
			<text class="entry-link" @click="toRegister">立即注册</text>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue'
import { wechatLogin, getInfo } from '@/api/login.js'
import { showLoading, hideLoading, showError, showSuccess } from '@/utils/index.js'

const agreed = ref(false)

// 微信一键登录
const handleWechatLogin = async () => {
	if (!agreed.value) {
		showError('请先阅读并同意用户协议和隐私协议')
		return
	}
	
	// #ifdef MP-WEIXIN
	try {
		showLoading('登录中...')
		
		// 获取微信登录凭证
		const loginRes = await uni.login({
			provider: 'weixin'
		})
		
		if (loginRes.code) {
			// 调用后端接口
			const res = await wechatLogin({
				code: loginRes.code
			})
			
			hideLoading()
			
			if (res.code === 200) {
				// 保存token
				uni.setStorageSync('token', res.token)
				showSuccess('登录成功')
				const user = await getInfo()
				uni.setStorageSync('userInfo', user.user)
				// 延迟跳转
				setTimeout(() => {
					uni.switchTab({
						url: '/pages/index/index'
					})
				}, 1000)
			} else {
				showError(res.msg || '微信登录失败')
			}
		} else {
			hideLoading()
			showError('获取微信登录凭证失败')
		}
	} catch (error) {
		hideLoading()
		console.error('微信登录失败:', error)
		showError('微信登录失败，请重试')
	}
	// #endif
	
	// #ifndef MP-WEIXIN
	uni.showModal({
		title: '提示',
		content: '微信登录仅支持微信小程序',
		showCancel: false
	})
	// #endif
}

// 手机号登录
const handlePhoneLogin = () => {
	uni.showToast({
		title: '手机号登录功能开发中',
		icon: 'none'
	})
}

// 跳转到账号密码登录
const toAccountLogin = () => {
	uni.navigateTo({
		url: '/pages/login/login'
	})
}

// 跳转注册
const toRegister = () => {
	uni.navigateTo({
		url: '/pages/register/register'
	})
}

// 显示用户协议
const showAgreement = () => {
	uni.showModal({
		title: '用户协议',
		content: '这里是用户协议内容...',
		showCancel: false
	})
}

// 显示隐私协议
const showPrivacy = () => {
	uni.showModal({
		title: '隐私协议',
		content: '这里是隐私协议内容...',
		showCancel: false
	})
}
</script>

<style lang="scss" scoped>
.wechat-login-container {
	min-height: 100vh;
	background: linear-gradient(135deg, #FFFEF0 0%, #F5F9F0 100%);
	padding: 0 60rpx;
	display: flex;
	flex-direction: column;
	position: relative;
	overflow: hidden;
}

.decoration-circles {
	position: absolute;
	top: 100rpx;
	left: 60rpx;
	display: flex;
	gap: -40rpx;
	z-index: 1;
	
	.circle {
		width: 120rpx;
		height: 120rpx;
		border-radius: 50%;
	}
	
	.circle-blue {
		background: linear-gradient(135deg, #A8D8F0 0%, #85C9E8 100%);
		opacity: 0.6;
	}
	
	.circle-yellow {
		background: linear-gradient(135deg, #F5E27A 0%, #F0D858 100%);
		opacity: 0.8;
		margin-left: -40rpx;
	}
}

.logo-section {
	margin-top: 200rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	z-index: 2;
	
	.app-logo {
		width: 160rpx;
		height: 160rpx;
		background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
		border-radius: 40rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		box-shadow: 0 8rpx 32rpx rgba(245, 226, 122, 0.3);
		margin-bottom: 40rpx;
	}
	
	.app-name {
		font-size: 56rpx;
		font-weight: 700;
		color: #333;
		margin-bottom: 16rpx;
	}
	
	.app-slogan {
		font-size: 26rpx;
		color: #999;
	}
}

.login-methods {
	flex: 1;
	display: flex;
	flex-direction: column;
	justify-content: center;
	z-index: 2;
	margin-top: 100rpx;
	
	.wechat-login-btn {
		width: 100%;
		height: 100rpx;
		background: linear-gradient(135deg, #09bb07 0%, #07C160 100%);
		border-radius: 50rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		box-shadow: 0 10rpx 30rpx rgba(9, 187, 7, 0.3);
		margin-bottom: 60rpx;
		transition: all 0.3s;
		
		&:active {
			transform: scale(0.98);
			box-shadow: 0 6rpx 20rpx rgba(9, 187, 7, 0.25);
		}
		
		.wechat-btn-content {
			display: flex;
			align-items: center;
			justify-content: center;
			gap: 20rpx;
			
			.btn-icon-wrapper {
				width: 56rpx;
				height: 56rpx;
				background: rgba(255, 255, 255, 0.2);
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.btn-text {
				font-size: 34rpx;
				color: #fff;
				font-weight: 700;
				letter-spacing: 2rpx;
			}
		}
	}
	
	.other-methods {
		display: flex;
		justify-content: space-around;
		
		.method-item {
			display: flex;
			flex-direction: column;
			align-items: center;
			
			.method-icon {
				width: 100rpx;
				height: 100rpx;
				background: #fff;
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
				box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
				margin-bottom: 16rpx;
			}
			
			.method-text {
				font-size: 24rpx;
				color: #666;
			}
		}
	}
}

.footer-agreement {
	display: flex;
	align-items: center;
	justify-content: center;
	flex-wrap: wrap;
	padding-bottom: 20rpx;
	z-index: 2;
	
	.checkbox-wrapper {
		display: flex;
		align-items: center;
		margin-right: 8rpx;
		
		.checkbox {
			width: 32rpx;
			height: 32rpx;
			border: 2rpx solid #ddd;
			border-radius: 6rpx;
			display: flex;
			align-items: center;
			justify-content: center;
			margin-right: 8rpx;
			transition: all 0.3s;
			
			&.checked {
				background-color: #F5E27A;
				border-color: #F5E27A;
			}
		}
	}
	
	.agreement-text {
		font-size: 22rpx;
		color: #999;
	}
	
	.agreement-link {
		font-size: 22rpx;
		color: #F5D858;
		margin: 0 4rpx;
	}
}

.register-entry {
	text-align: center;
	padding-bottom: 60rpx;
	z-index: 2;
	
	.entry-text {
		font-size: 26rpx;
		color: #666;
	}
	
	.entry-link {
		font-size: 26rpx;
		color: #333;
		font-weight: 500;
		margin-left: 8rpx;
	}
}
</style>

