<template>
	
	<view class="login-container">
		<!-- 装饰圆圈 -->
		<view class="decoration-circles">
			<view class="circle circle-blue"></view>
			<view class="circle circle-yellow"></view>
		</view>
		
		<!-- Logo和标题 -->
		<view class="app-logo">
			<image src="https://tse1-mm.cn.bing.net/th/id/OIP-C.bFqvwtRcinzsOnk5xsr7qgHaJk?w=129&h=180&c=7&r=0&o=7&cb=ucfimg2&pid=1.7&rm=3&ucfimg=1" mode="aspectFit" class="logo-image"></image>
		</view>
		<view class="welcome-title">智能垃圾分类</view>
		<view class="welcome-subtitle">环保从分类开始，让地球更美好</view>
		
		<!-- 登录表单 -->
		<view class="login-form">
			<view class="input-group">
				<view class="input-wrapper">
					<input 
						class="input" 
						v-model="loginForm.username" 
						placeholder="账号" 
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>

			<view class="input-group">
				<view class="input-wrapper">
					<input 
						class="input" 
						v-model="loginForm.password" 
						:type="showPassword ? 'text' : 'password'" 
						placeholder="密码" 
						placeholder-style="color: #ccc"
					/>
					<view class="eye-icon" @click="togglePassword">
						<uv-icon :name="showPassword ? 'eye' : 'eye-off'" size="22" color="#ccc"></uv-icon>
					</view>
				</view>
			</view>

			<!-- 验证码 -->
			<view class="input-group" v-if="captchaEnabled">
				<view class="input-wrapper code-wrapper">
					<input 
						class="input code-input" 
						v-model="loginForm.code" 
						placeholder="验证码" 
						placeholder-style="color: #ccc"
						maxlength="4"
					/>
					<image 
						class="captcha-img" 
						:src="codeUrl" 
						@click="getCode"
						mode="aspectFit"
					></image>
				</view>
			</view>

			<view class="forgot-password" @click="handleForgot">
				<text>忘记密码？</text>
			</view>

		<view class="login-btn" @click="handleLogin">
			<text class="btn-text">{{ loading ? '登录中...' : '登录' }}</text>
		</view>

	<!-- #ifdef MP-WEIXIN -->
	<view class="other-login">
		<view class="divider-line"></view>
		<text class="divider-text">其他登录方式</text>
		<view class="divider-line"></view>
	</view>

	<view class="wechat-quick-login" @click="toWechatLogin">
		<view class="wechat-btn-content">
			<view class="wechat-icon-wrapper">
				<uv-icon name="weixin-fill" size="32" color="#fff"></uv-icon>
			</view>
			<text class="wechat-text">微信一键登录</text>
		</view>
	</view>
	<!-- #endif -->

	<view class="register-link">
		<text class="link-text">没有账号？</text>
		<text class="link-action" @click="toRegister">去注册</text>
	</view>

		<!-- 用户协议 -->
		<view class="agreement">
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
		</view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { login, getCodeImg, wechatLogin, getInfo } from '@/api/login.js'
import { showLoading, hideLoading, showError, showSuccess } from '@/utils/index.js'

// 登录表单
const loginForm = ref({
	username: '',
	password: '',
	code: '',
	uuid: ''
})

const loading = ref(false)
const showPassword = ref(false)
const captchaEnabled = ref(true)
const codeUrl = ref('')
const agreed = ref(false)

// 切换密码可见性
const togglePassword = () => {
	showPassword.value = !showPassword.value
}

// 获取验证码
const getCode = async () => {
	try {
		const res = await getCodeImg()
		if (res.code === 200) {
			captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
			if (captchaEnabled.value) {
				codeUrl.value = res.img
				loginForm.value.uuid = res.uuid
			}
		}
	} catch (error) {
		console.error('获取验证码失败:', error)
	}
}

// 账号密码登录
const handleLogin = async () => {
	if (!loginForm.value.username) {
		showError('请输入账号')
		return
	}
	if (!loginForm.value.password) {
		showError('请输入密码')
		return
	}
	if (captchaEnabled.value && !loginForm.value.code) {
		showError('请输入验证码')
		return
	}
	if (!agreed.value) {
		showError('请先阅读并同意用户协议和隐私协议')
		return
	}

	try {
		loading.value = true
		const res = await login(loginForm.value)
		
		if (res.code === 200) {
			// 保存token
			uni.setStorageSync('token', res.token)
			showSuccess('登录成功')
			const user=await getInfo()
			uni.setStorageSync('userInfo',user.user)
			// 延迟跳转，让用户看到成功提示
			setTimeout(() => {
				uni.switchTab({
					url: '/pages/index/index'
				})
			}, 1000)
		} else {
			showError(res.msg || '登录失败')
			// 刷新验证码
			if (captchaEnabled.value) {
				getCode()
			}
		}
	} catch (error) {
		console.error('登录失败:', error)
		showError('登录失败，请重试')
		// 刷新验证码
		if (captchaEnabled.value) {
			getCode()
		}
	} finally {
		loading.value = false
	}
}

// 微信一键登录
const handleWechatLogin = async () => {
	// #ifdef MP-WEIXIN
	try {
		showLoading('登录中...')
		
		// 获取微信登录凭证
		const loginRes = await uni.login({
			provider: 'weixin'
		})
		
		if (loginRes[1].code) {
			// 调用后端接口
			const res = await wechatLogin({
				code: loginRes[1].code
			})
			
			hideLoading()
			
			if (res.code === 200) {
				// 保存token
				uni.setStorageSync('token', res.token)
				showSuccess('登录成功')
				
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

// 忘记密码
const handleForgot = () => {
	uni.showToast({
		title: '请联系管理员重置密码',
		icon: 'none'
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

// 跳转注册
const toRegister = () => {
	uni.navigateTo({
		url: '/pages/register/register'
	})
}

// 跳转微信登录
const toWechatLogin = () => {
	// #ifdef MP-WEIXIN
	uni.navigateTo({
		url: '/pages/wechat-login/wechat-login'
	})
	// #endif
	
	// #ifndef MP-WEIXIN
	uni.showModal({
		title: '提示',
		content: '微信一键登录仅支持微信小程序环境',
		showCancel: false
	})
	// #endif
}

onMounted(() => {
	// 页面加载时获取验证码
	getCode()
})
</script>

<style lang="scss" scoped>
.login-container {
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
		background: linear-gradient(135deg, #81C784 0%, #4CAF50 100%);
		opacity: 0.6;
	}
	
	.circle-yellow {
		background: linear-gradient(135deg, #AED581 0%, #8BC34A 100%);
		opacity: 0.8;
		margin-left: -40rpx;
	}
}

.app-logo {
	margin-top: 180rpx;
	display: flex;
	justify-content: center;
	z-index: 2;
	
	.logo-image {
		width: 160rpx;
		height: 160rpx;
	}
}

.welcome-title {
	margin-top: 30rpx;
	font-size: 48rpx;
	font-weight: 700;
	color: #2E7D32;
	text-align: center;
	z-index: 2;
}

.welcome-subtitle {
	font-size: 26rpx;
	color: #666;
	text-align: center;
	margin-bottom: 60rpx;
	z-index: 2;
}

.login-form {
	flex: 1;
	z-index: 2;
	
	.input-group {
		margin-bottom: 30rpx;
		
		.input-wrapper {
			display: flex;
			align-items: center;
			background-color: #fff;
			border-radius: 50rpx;
			padding: 32rpx 40rpx;
			position: relative;
			box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.03);
			
			.input {
				flex: 1;
				font-size: 28rpx;
				color: #333;
			}
			
			.eye-icon {
				padding: 10rpx;
				margin-left: 10rpx;
			}
		}
		
		.code-wrapper {
			padding: 20rpx 30rpx;
			
			.code-input {
				flex: 1;
			}
			
			.captcha-img {
				width: 180rpx;
				height: 60rpx;
				margin-left: 20rpx;
				border-radius: 8rpx;
			}
		}
	}
	
	.forgot-password {
		text-align: right;
		margin-bottom: 60rpx;
		margin-top: 10rpx;
		
		text {
			font-size: 26rpx;
			color: #666;
		}
	}
	
	.login-btn {
		width: 100%;
		height: 96rpx;
		background: linear-gradient(90deg, #4CAF50 0%, #8BC34A 100%);
		border-radius: 50rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-bottom: 40rpx;
		box-shadow: 0 8rpx 24rpx rgba(76, 175, 80, 0.3);
		
		.btn-text {
			font-size: 32rpx;
			color: #fff;
			font-weight: 600;
		}
	}
	
	.other-login {
		display: flex;
		align-items: center;
		margin-bottom: 40rpx;
		
		.divider-line {
			flex: 1;
			height: 1rpx;
			background-color: #E5E5E5;
		}
		
		.divider-text {
			font-size: 24rpx;
			color: #999;
			padding: 0 20rpx;
		}
	}
	
	.wechat-quick-login {
		width: 100%;
		height: 96rpx;
		background: linear-gradient(135deg, #09bb07 0%, #07C160 100%);
		border-radius: 50rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-bottom: 30rpx;
		box-shadow: 0 8rpx 24rpx rgba(9, 187, 7, 0.25);
		transition: all 0.3s;
		
		&:active {
			transform: scale(0.98);
			box-shadow: 0 4rpx 16rpx rgba(9, 187, 7, 0.2);
		}
		
		.wechat-btn-content {
			display: flex;
			align-items: center;
			justify-content: center;
			gap: 16rpx;
			
			.wechat-icon-wrapper {
				width: 48rpx;
				height: 48rpx;
				background: rgba(255, 255, 255, 0.2);
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.wechat-text {
				font-size: 30rpx;
				color: #fff;
				font-weight: 600;
				letter-spacing: 1rpx;
			}
		}
	}
	
	.register-link {
		text-align: center;
		margin-bottom: 60rpx;
		
		.link-text {
			font-size: 26rpx;
			color: #666;
		}
		
		.link-action {
			font-size: 26rpx;
			color: #333;
			font-weight: 500;
			margin-left: 8rpx;
		}
	}
	
	.agreement {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-wrap: wrap;
		padding-bottom: 40rpx;
		
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
					background-color: #4CAF50;
					border-color: #4CAF50;
				}
			}
		}
		
		.agreement-text {
			font-size: 22rpx;
			color: #999;
		}
		
		.agreement-link {
			font-size: 22rpx;
			color: #4CAF50;
			margin: 0 4rpx;
		}
	}
}
</style>


