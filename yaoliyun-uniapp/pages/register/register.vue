<template>
	<view class="register-container">
		<!-- 装饰圆圈 -->
		<view class="decoration-circles">
			<view class="circle circle-blue"></view>
			<view class="circle circle-yellow"></view>
		</view>
		
		
		<!-- Logo和标题 -->
		<view class="app-logo">
			<image src="https://tse1-mm.cn.bing.net/th/id/OIP-C.bFqvwtRcinzsOnk5xsr7qgHaJk?w=129&h=180&c=7&r=0&o=7&cb=ucfimg2&pid=1.7&rm=3&ucfimg=1" mode="aspectFit" class="logo-image"></image>
		</view>
		<view class="welcome-title">加入环保行动</view>
		<view class="welcome-subtitle">注册成为环保小卫士</view>
		
		<!-- 注册表单 -->
		<view class="register-form">
			<view class="input-group">
				<view class="input-wrapper">
					<input 
						class="input" 
						v-model="registerForm.username" 
						placeholder="账号（4-20位）" 
						placeholder-style="color: #ccc"
						maxlength="20"
					/>
				</view>
			</view>

			<view class="input-group">
				<view class="input-wrapper">
					<input 
						class="input" 
						v-model="registerForm.password" 
						:type="showPassword ? 'text' : 'password'" 
						placeholder="密码（6-20位）" 
						placeholder-style="color: #ccc"
						maxlength="20"
					/>
					<view class="eye-icon" @click="togglePassword">
						<uv-icon :name="showPassword ? 'eye' : 'eye-off'" size="22" color="#ccc"></uv-icon>
					</view>
				</view>
			</view>

			<view class="input-group">
				<view class="input-wrapper">
					<input 
						class="input" 
						v-model="registerForm.confirmPassword" 
						:type="showConfirmPassword ? 'text' : 'password'" 
						placeholder="确认密码" 
						placeholder-style="color: #ccc"
						maxlength="20"
					/>
					<view class="eye-icon" @click="toggleConfirmPassword">
						<uv-icon :name="showConfirmPassword ? 'eye' : 'eye-off'" size="22" color="#ccc"></uv-icon>
					</view>
				</view>
			</view>

			<view class="input-group">
				<view class="input-wrapper">
					<input 
						class="input" 
						v-model="registerForm.phonenumber" 
						type="number"
						placeholder="手机号" 
						placeholder-style="color: #ccc"
						maxlength="11"
					/>
				</view>
			</view>

			<!-- 验证码 -->
			<view class="input-group">
				<view class="input-wrapper code-wrapper">
					<input 
						class="input code-input" 
						v-model="registerForm.code" 
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

			<view class="register-btn" @click="handleRegister">
				<text class="btn-text">{{ loading ? '注册中...' : '立即注册' }}</text>
			</view>

			<view class="login-link">
				<text class="link-text">已有账号？</text>
				<text class="link-action" @click="toLogin">立即登录</text>
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
import { register, getCodeImg } from '@/api/login.js'
import { showError, showSuccess, validatePhone } from '@/utils/index.js'

// 注册表单
const registerForm = ref({
	username: '',
	password: '',
	confirmPassword: '',
	phonenumber: '',
	code: '',
	uuid: ''
})

const loading = ref(false)
const agreed = ref(false)
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const codeUrl = ref('')

// 切换密码可见性
const togglePassword = () => {
	showPassword.value = !showPassword.value
}

// 切换确认密码可见性
const toggleConfirmPassword = () => {
	showConfirmPassword.value = !showConfirmPassword.value
}

// 获取验证码
const getCode = async () => {
	try {
		const res = await getCodeImg()
		if (res.code === 200) {
			if (res.captchaEnabled !== false) {
				codeUrl.value = res.img
				registerForm.value.uuid = res.uuid
			}
		}
	} catch (error) {
		console.error('获取验证码失败:', error)
	}
}

// 表单验证
const validateForm = () => {
	if (!registerForm.value.username) {
		showError('请输入账号')
		return false
	}
	if (registerForm.value.username.length < 4 || registerForm.value.username.length > 20) {
		showError('账号长度应为4-20位')
		return false
	}
	
	if (!registerForm.value.password) {
		showError('请输入密码')
		return false
	}
	if (registerForm.value.password.length < 6 || registerForm.value.password.length > 20) {
		showError('密码长度应为6-20位')
		return false
	}
	
	if (!registerForm.value.confirmPassword) {
		showError('请确认密码')
		return false
	}
	if (registerForm.value.password !== registerForm.value.confirmPassword) {
		showError('两次密码输入不一致')
		return false
	}
	
	if (!registerForm.value.phonenumber) {
		showError('请输入手机号')
		return false
	}
	if (!validatePhone(registerForm.value.phonenumber)) {
		showError('请输入正确的手机号')
		return false
	}
	
	if (!registerForm.value.code) {
		showError('请输入验证码')
		return false
	}
	
	if (!agreed.value) {
		showError('请先同意用户协议和隐私政策')
		return false
	}
	
	return true
}

// 注册
const handleRegister = async () => {
	if (!validateForm()) {
		return
	}

	try {
		loading.value = true
		
		// 构建注册数据（不包含confirmPassword）
		const registerData = {
			username: registerForm.value.username,
			password: registerForm.value.password,
			phonenumber: registerForm.value.phonenumber,
			code: registerForm.value.code,
			uuid: registerForm.value.uuid
		}
		
		const res = await register(registerData)
		
		if (res.code === 200) {
			showSuccess('注册成功')
			
			// 延迟跳转到登录页
			setTimeout(() => {
				uni.navigateBack()
			}, 1500)
		} else {
			showError(res.msg || '注册失败')
			// 刷新验证码
			getCode()
		}
	} catch (error) {
		console.error('注册失败:', error)
		showError(error.data?.msg || '注册失败，请重试')
		// 刷新验证码
		getCode()
	} finally {
		loading.value = false
	}
}

// 显示用户协议
const showAgreement = () => {
	uni.showModal({
		title: '用户协议',
		content: '这里是用户协议内容...',
		showCancel: false
	})
}

// 显示隐私政策
const showPrivacy = () => {
	uni.showModal({
		title: '隐私政策',
		content: '这里是隐私政策内容...',
		showCancel: false
	})
}

// 跳转登录
const toLogin = () => {
	uni.navigateBack()
}

onMounted(() => {
	// 页面加载时获取验证码
	getCode()
})
</script>

<style lang="scss" scoped>
.register-container {
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
	margin-top: 160rpx;
	display: flex;
	justify-content: center;
	z-index: 2;
	
	.logo-image {
		width: 120rpx;
		height: 120rpx;
	}
}

.back-btn {
	position: absolute;
	top: 60rpx;
	left: 60rpx;
	width: 70rpx;
	height: 70rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	z-index: 10;
}

.welcome-title {
	margin-top: 20rpx;
	font-size: 44rpx;
	font-weight: 700;
	color: #2E7D32;
	text-align: center;
	z-index: 2;
}

.welcome-subtitle {
	font-size: 26rpx;
	color: #666;
	text-align: center;
	margin-bottom: 40rpx;
	z-index: 2;
}

.register-form {
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
	
	.register-btn {
		width: 100%;
		height: 96rpx;
		background: linear-gradient(90deg, #4CAF50 0%, #8BC34A 100%);
		border-radius: 50rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-top: 40rpx;
		margin-bottom: 30rpx;
		box-shadow: 0 8rpx 24rpx rgba(76, 175, 80, 0.3);
		
		.btn-text {
			font-size: 32rpx;
			color: #fff;
			font-weight: 600;
		}
	}
	
	.login-link {
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

