<template>
	<view class="edit-container">	
		<!-- 表单内容 -->
		<view class="form-content">
			<!-- 头像 -->
			<view class="form-item" @click="chooseAvatar">
				<text class="item-label">头像</text>
				<view class="item-content">
					<view class="avatar-preview">
						<image 
							v-if="formData.avatar" 
							:src="formData.avatar" 
							mode="aspectFill"
							class="avatar-image"
						></image>
						<view v-else class="avatar-placeholder">
							<uv-icon name="account-fill" size="40" color="#fff"></uv-icon>
						</view>
					</view>
					<uv-icon name="arrow-right" size="20" color="#999"></uv-icon>
				</view>
			</view>
			
			<!-- 昵称 -->
			<view class="form-item">
				<text class="item-label">昵称</text>
				<view class="item-content">
					<input 
						class="item-input" 
						v-model="formData.nickName" 
						placeholder="请输入昵称"
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>
			
			<!-- 性别 -->
			<view class="form-item" @click="showGenderPicker">
				<text class="item-label">性别</text>
				<view class="item-content">
					<text class="item-value" :class="{ 'placeholder': !genderText }">
						{{ genderText || '请选择性别' }}
					</text>
					<uv-icon name="arrow-right" size="20" color="#999"></uv-icon>
				</view>
			</view>
			
			<!-- 手机号（只读） -->
			<view class="form-item">
				<text class="item-label">手机号</text>
				<view class="item-content">
					<text class="item-value readonly">{{ formData.phonenumber || '未设置' }}</text>
				</view>
			</view>
			
			<!-- 邮箱 -->
			<view class="form-item">
				<text class="item-label">邮箱</text>
				<view class="item-content">
					<input 
						class="item-input" 
						v-model="formData.email" 
						type="email"
						placeholder="请输入邮箱"
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>
		</view>
		
		<!-- 保存按钮 -->
		<view class="save-section">
			<view class="save-btn" @click="handleSave">
				<text class="save-text">保存</text>
			</view>
		</view>
		
		<!-- 性别选择器 -->
		<uv-action-sheet 
			:show="genderPickerShow" 
			:actions="genderOptions"
			@close="genderPickerShow = false"
			@select="selectGender"
		></uv-action-sheet>
	</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getInfo } from '@/api/login.js'
import { updateUserProfile } from '@/api/system/user.js'
import { uploadFile } from '@/utils/request.js'
import { showError, showSuccess } from '@/utils/index.js'

const formData = ref({
	userId: '',
	userName: '',
	nickName: '',
	email: '',
	phonenumber: '',
	sex: '0',
	avatar: ''
})

const genderPickerShow = ref(false)
const genderOptions = [
	{ name: '男', value: '0' },
	{ name: '女', value: '1' },
	{ name: '保密', value: '2' }
]

// 性别文本
const genderText = computed(() => {
	const option = genderOptions.find(item => item.value === formData.value.sex)
	return option ? option.name : ''
})

// 页面加载
onMounted(() => {
	loadUserInfo()
})

// 加载用户信息
const loadUserInfo = async () => {
	try {
		uni.showLoading({ title: '加载中...' })
		
		const res = await getInfo()
		
		uni.hideLoading()
		
		if (res.code === 200 && res.user) {
			formData.value = {
				userId: res.user.userId,
				userName: res.user.userName,
				nickName: res.user.nickName || '',
				email: res.user.email || '',
				phonenumber: res.user.phonenumber || '',
				sex: res.user.sex || '0',
				avatar: res.user.avatar || ''
			}
		} else {
			showError(res.msg || '获取用户信息失败')
		}
	} catch (error) {
		uni.hideLoading()
		console.error('获取用户信息失败:', error)
		showError('获取用户信息失败')
	}
}

// 选择头像
const chooseAvatar = () => {
	uni.showActionSheet({
		itemList: ['拍照', '从相册选择'],
		success: (res) => {
			if (res.tapIndex === 0) {
				uploadAvatar('camera')
			} else if (res.tapIndex === 1) {
				uploadAvatar('album')
			}
		}
	})
}

// 上传头像
const uploadAvatar = (sourceType) => {
	uni.chooseImage({
		count: 1,
		sizeType: ['compressed'],
		sourceType: [sourceType],
		success: async (res) => {
			const tempFilePath = res.tempFilePaths[0]
			
			uni.showLoading({
				title: '上传中...',
				mask: true
			})
			
			try {
				const uploadRes = await uploadFile(tempFilePath)
				
				uni.hideLoading()
				
				if (uploadRes.code === 200) {
					const avatarUrl = uploadRes.url || uploadRes.data?.url || uploadRes.fileName
					formData.value.avatar = avatarUrl
					showSuccess('头像上传成功')
				} else {
					showError(uploadRes.msg || '头像上传失败')
				}
			} catch (error) {
				uni.hideLoading()
				console.error('头像上传失败:', error)
				showError('头像上传失败')
			}
		}
	})
}

// 显示性别选择器
const showGenderPicker = () => {
	genderPickerShow.value = true
}

// 选择性别
const selectGender = (e) => {
	formData.value.sex = e.value
	genderPickerShow.value = false
}

// 保存用户信息
const handleSave = async () => {
	// 验证必填项
	if (!formData.value.nickName || !formData.value.nickName.trim()) {
		showError('请输入昵称')
		return
	}
	
	// 验证邮箱格式
	if (formData.value.email && formData.value.email.trim()) {
		const emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
		if (!emailReg.test(formData.value.email)) {
			showError('请输入正确的邮箱格式')
			return
		}
	}
	
	try {
		uni.showLoading({
			title: '保存中...',
			mask: true
		})
		
		const res = await updateUserProfile(formData.value)
		
		uni.hideLoading()
		
		if (res.code === 200) {
			showSuccess('保存成功')
			
			// 更新本地存储的用户信息
			const userInfo = uni.getStorageSync('userInfo') || {}
			Object.assign(userInfo, formData.value)
			uni.setStorageSync('userInfo', userInfo)
			
			// 延迟返回，让用户看到成功提示
			setTimeout(() => {
				uni.navigateBack()
			}, 1000)
		} else {
			showError(res.msg || '保存失败')
		}
	} catch (error) {
		uni.hideLoading()
		console.error('保存失败:', error)
		showError('保存失败，请重试')
	}
}
</script>

<style lang="scss" scoped>
.edit-container {
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
	
	&:active {
		background-color: #f8f8f8;
	}
	
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
		gap: 20rpx;
		
		.item-input {
			flex: 1;
			font-size: 28rpx;
			color: #333;
			text-align: right;
		}
		
		.item-value {
			font-size: 28rpx;
			color: #333;
			
			&.placeholder {
				color: #ccc;
			}
			
			&.readonly {
				color: #999;
			}
		}
		
		.avatar-preview {
			width: 120rpx;
			height: 120rpx;
			border-radius: 60rpx;
			overflow: hidden;
			
			.avatar-image {
				width: 100%;
				height: 100%;
			}
			
			.avatar-placeholder {
				width: 100%;
				height: 100%;
				background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
				display: flex;
				align-items: center;
				justify-content: center;
			}
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

