<template>
	<view class="password-container">
		<!-- 表单内容 -->
		<view class="form-content">
			<!-- 旧密码 -->
			<view class="form-item">
				<text class="item-label">旧密码</text>
				<view class="item-content">
					<input 
						class="item-input" 
						v-model="formData.oldPassword" 
						type="password"
						placeholder="请输入旧密码"
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>
			
			<!-- 新密码 -->
			<view class="form-item">
				<text class="item-label">新密码</text>
				<view class="item-content">
					<input 
						class="item-input" 
						v-model="formData.newPassword" 
						type="password"
						placeholder="请输入新密码"
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>
			
			<!-- 确认密码 -->
			<view class="form-item">
				<text class="item-label">确认密码</text>
				<view class="item-content">
					<input 
						class="item-input" 
						v-model="formData.confirmPassword" 
						type="password"
						placeholder="请再次输入新密码"
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>
			
			<!-- 密码要求提示 -->
			<view class="tips-section">
				<view class="tips-title">
					<uv-icon name="info-circle" size="16" color="#999"></uv-icon>
					<text class="tips-title-text">密码要求</text>
				</view>
				<view class="tips-list">
					<text class="tips-item">• 密码长度为 6-20 个字符</text>
					<text class="tips-item">• 建议包含字母、数字和特殊字符</text>
					<text class="tips-item">• 不能与旧密码相同</text>
				</view>
			</view>
		</view>
		
		<!-- 保存按钮 -->
		<view class="save-section">
			<view class="save-btn" @click="handleSubmit">
				<text class="save-text">确认修改</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue'
import { updateUserPwd } from '@/api/system/user.js'
import { showError, showSuccess } from '@/utils/index.js'

const formData = ref({
	oldPassword: '',
	newPassword: '',
	confirmPassword: ''
})

// 验证密码格式
const validatePassword = (password) => {
	if (!password || password.length < 6 || password.length > 20) {
		return false
	}
	return true
}

// 提交修改
const handleSubmit = async () => {
	// 验证旧密码
	if (!formData.value.oldPassword || !formData.value.oldPassword.trim()) {
		showError('请输入旧密码')
		return
	}
	
	// 验证新密码
	if (!formData.value.newPassword || !formData.value.newPassword.trim()) {
		showError('请输入新密码')
		return
	}
	
	// 验证密码格式
	if (!validatePassword(formData.value.newPassword)) {
		showError('新密码长度必须为 6-20 个字符')
		return
	}
	
	// 验证确认密码
	if (!formData.value.confirmPassword || !formData.value.confirmPassword.trim()) {
		showError('请再次输入新密码')
		return
	}
	
	// 验证两次密码是否一致
	if (formData.value.newPassword !== formData.value.confirmPassword) {
		showError('两次输入的新密码不一致')
		return
	}
	
	// 验证新旧密码是否相同
	if (formData.value.oldPassword === formData.value.newPassword) {
		showError('新密码不能与旧密码相同')
		return
	}
	
	try {
		uni.showLoading({
			title: '修改中...',
			mask: true
		})
		
		const res = await updateUserPwd(formData.value.oldPassword, formData.value.newPassword)
		
		uni.hideLoading()
		
		if (res.code === 200) {
			showSuccess('密码修改成功，请重新登录')
			
			// 清除本地存储的token和用户信息
			setTimeout(() => {
				uni.removeStorageSync('token')
				uni.removeStorageSync('userInfo')
				
				// 跳转到登录页
				uni.reLaunch({
					url: '/pages/login/login'
				})
			}, 1500)
		} else {
			showError(res.msg || '密码修改失败')
		}
	} catch (error) {
		uni.hideLoading()
		console.error('密码修改失败:', error)
		showError('密码修改失败，请重试')
	}
}
</script>

<style lang="scss" scoped>
.password-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.form-content {
	flex: 1;
	margin-top: 20rpx;
}

.form-item {
	background-color: #fff;
	padding: 30rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1rpx solid #f0f0f0;
	
	.item-label {
		font-size: 30rpx;
		color: #333;
		font-weight: 500;
		min-width: 140rpx;
	}
	
	.item-content {
		flex: 1;
		display: flex;
		justify-content: flex-end;
		align-items: center;
		
		.item-input {
			flex: 1;
			font-size: 28rpx;
			color: #333;
			text-align: right;
		}
	}
}

.tips-section {
	background-color: #fff;
	margin-top: 20rpx;
	padding: 30rpx;
	
	.tips-title {
		display: flex;
		align-items: center;
		gap: 8rpx;
		margin-bottom: 20rpx;
		
		.tips-title-text {
			font-size: 28rpx;
			color: #999;
		}
	}
	
	.tips-list {
		display: flex;
		flex-direction: column;
		gap: 12rpx;
		
		.tips-item {
			font-size: 26rpx;
			color: #999;
			line-height: 1.6;
		}
	}
}

.save-section {
	padding: 30rpx;
	padding-bottom: calc(30rpx + env(safe-area-inset-bottom));
	background-color: #fff;
	border-top: 1rpx solid #f0f0f0;
	
	.save-btn {
		background-color: #333;
		border-radius: 48rpx;
		padding: 28rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		transition: all 0.3s;
		
		&:active {
			opacity: 0.8;
			transform: scale(0.98);
		}
		
		.save-text {
			font-size: 32rpx;
			color: #fff;
			font-weight: 600;
		}
	}
}
</style>

