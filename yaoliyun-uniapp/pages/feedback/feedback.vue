<template>
	<view class="feedback-container">
		<!-- 标题区域 -->
		<view class="header-section">
			<text class="main-title">意见反馈</text>
			<text class="sub-title">您的建议是我们前进的动力</text>
			<view class="history-btn" @click="goToHistory">
				<uv-icon name="clock" size="20" color="#666"></uv-icon>
				<text class="history-text">历史记录</text>
			</view>
		</view>
		
		<!-- 反馈表单 -->
		<view class="feedback-form">
			<!-- 反馈类型 -->
			<view class="form-section">
				<view class="section-title">
					<text class="title-text">反馈类型</text>
				</view>
				<view class="type-list">
					<view 
						v-for="(type, index) in feedbackTypes" 
						:key="index"
						class="type-item"
						:class="{ 'active': feedbackForm.type === type.value }"
						@click="selectType(type.value)"
					>
						<uv-icon :name="type.icon" size="24" :color="feedbackForm.type === type.value ? '#fff' : '#666'"></uv-icon>
						<text class="type-text">{{ type.label }}</text>
					</view>
				</view>
			</view>
			
			<!-- 反馈内容 -->
			<view class="form-section">
				<view class="section-title">
					<text class="title-text">反馈内容</text>
					<text class="required-mark">*</text>
				</view>
				<view class="textarea-wrapper">
					<textarea 
						class="feedback-textarea" 
						v-model="feedbackForm.content"
						placeholder="请详细描述您的问题或建议，我们会认真对待每一条反馈..."
						placeholder-style="color: #ccc"
						:maxlength="500"
					></textarea>
					<view class="char-count">{{ feedbackForm.content.length }}/500</view>
				</view>
			</view>
			
			<!-- 联系方式 -->
			<view class="form-section">
				<view class="section-title">
					<text class="title-text">联系方式</text>
					<text class="optional-mark">（选填）</text>
				</view>
				<view class="input-wrapper">
					<input 
						class="feedback-input" 
						v-model="feedbackForm.contact"
						placeholder="请留下您的手机号或邮箱，以便我们及时回复"
						placeholder-style="color: #ccc"
					/>
				</view>
			</view>
			
			<!-- 上传图片 -->
			<view class="form-section">
				<view class="section-title">
					<text class="title-text">上传截图</text>
					<text class="optional-mark">（选填，最多3张）</text>
				</view>
				<view class="image-upload">
					<view 
						v-for="(image, index) in feedbackForm.images" 
						:key="index"
						class="image-item"
					>
						<image :src="image" mode="aspectFill" class="upload-image"></image>
						<view class="delete-btn" @click="deleteImage(index)">
							<uv-icon name="close" size="16" color="#fff"></uv-icon>
						</view>
					</view>
					<view 
						v-if="feedbackForm.images.length < 3" 
						class="upload-btn"
						@click="chooseImage"
					>
						<uv-icon name="plus" size="40" color="#ccc"></uv-icon>
					</view>
				</view>
			</view>
		</view>
		
		<!-- 提交按钮 -->
		<view class="submit-section">
			<view class="submit-btn" @click="handleSubmit" :class="{ 'disabled': submitting }">
				<text class="submit-text">{{ submitting ? '提交中...' : '提交反馈' }}</text>
			</view>
		</view>
		
		<!-- 温馨提示 -->
		<view class="tips-section">
			<view class="tips-title">
				<text class="tips-title-text">温馨提示</text>
			</view>
			<view class="tips-content">
				<text class="tips-item">• 我们会在1-3个工作日内处理您的反馈</text>
				<text class="tips-item">• 如需进一步沟通，请留下联系方式</text>
				<text class="tips-item">• 感谢您为改进产品提出宝贵意见</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue'
import { submitFeedback } from '@/api/feedback.js'
import { showError, showSuccess } from '@/utils/index.js'
import { uploadFile } from '@/utils/request.js'

// 反馈类型
const feedbackTypes = [
	{ label: '功能建议', value: 'suggestion', icon: 'star' },
	{ label: '问题反馈', value: 'bug', icon: 'error-circle' },
	{ label: '使用咨询', value: 'question', icon: 'question-circle' },
	{ label: '其他', value: 'other', icon: 'more-circle' }
]

// 反馈表单
const feedbackForm = ref({
	type: 'suggestion',
	content: '',
	contact: '',
	images: []
})

const submitting = ref(false)

// 选择反馈类型
const selectType = (type) => {
	feedbackForm.value.type = type
}

// 选择图片
const chooseImage = () => {
	uni.chooseImage({
		count: 3 - feedbackForm.value.images.length,
		sizeType: ['compressed'],
		sourceType: ['album', 'camera'],
		success: async (res) => {
			const tempFilePaths = res.tempFilePaths
			
			// 显示上传提示
			uni.showLoading({
				title: '上传中...',
				mask: true
			})
			
			try {
				// 依次上传图片
				for (let filePath of tempFilePaths) {
					const uploadRes = await uploadFile(filePath)
					if (uploadRes.code === 200) {
						const imageUrl = uploadRes.url || uploadRes.data?.url || uploadRes.fileName
						feedbackForm.value.images.push(imageUrl)
					}
				}
				uni.hideLoading()
			} catch (error) {
				uni.hideLoading()
				console.error('上传图片失败:', error)
				showError('图片上传失败')
			}
		}
	})
}

// 删除图片
const deleteImage = (index) => {
	feedbackForm.value.images.splice(index, 1)
}

// 跳转到历史记录
const goToHistory = () => {
	uni.navigateTo({
		url: '/pages/feedback/history'
	})
}

// 提交反馈
const handleSubmit = async () => {
	// 验证
	if (!feedbackForm.value.content.trim()) {
		showError('请输入反馈内容')
		return
	}
	
	if (feedbackForm.value.content.trim().length < 10) {
		showError('反馈内容至少需要10个字')
		return
	}
	
	try {
		submitting.value = true
		
		const data = {
			type: feedbackForm.value.type,
			content: feedbackForm.value.content.trim(),
			contact: feedbackForm.value.contact.trim(),
			images: feedbackForm.value.images.join(',')
		}
		
		const res = await submitFeedback(data)
		
		if (res.code === 200) {
			showSuccess('提交成功，感谢您的反馈！')
			
			// 延迟返回
			setTimeout(() => {
				uni.navigateBack()
			}, 1500)
		} else {
			showError(res.msg || '提交失败')
		}
	} catch (error) {
		console.error('提交反馈失败:', error)
		showError('提交失败，请重试')
	} finally {
		submitting.value = false
	}
}
</script>

<style lang="scss" scoped>
.feedback-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding: 40rpx 30rpx;
	padding-bottom: calc(40rpx + env(safe-area-inset-bottom));
}

.header-section {
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-bottom: 48rpx;
	position: relative;
	
	.main-title {
		font-size: 48rpx;
		font-weight: 600;
		color: #333;
		margin-bottom: 12rpx;
	}
	
	.sub-title {
		font-size: 24rpx;
		color: #999;
	}
	
	.history-btn {
		position: absolute;
		top: 0;
		right: 0;
		display: flex;
		align-items: center;
		gap: 6rpx;
		padding: 12rpx 20rpx;
		background-color: #fff;
		border-radius: 24rpx;
		border: 1rpx solid #e8e8e8;
		transition: all 0.2s;
		
		&:active {
			background-color: #fafafa;
		}
		
		.history-text {
			font-size: 24rpx;
			color: #666;
		}
	}
}

.feedback-form {
	.form-section {
		margin-bottom: 32rpx;
		
		.section-title {
			display: flex;
			align-items: center;
			margin-bottom: 16rpx;
			
			.title-text {
				font-size: 28rpx;
				font-weight: 600;
				color: #333;
			}
			
			.required-mark {
				color: #ff4d4f;
				font-size: 28rpx;
				margin-left: 4rpx;
			}
			
			.optional-mark {
				font-size: 22rpx;
				color: #999;
				margin-left: 8rpx;
			}
		}
		
		.type-list {
			display: grid;
			grid-template-columns: repeat(2, 1fr);
			gap: 16rpx;
			
			.type-item {
				background-color: #fff;
				border-radius: 8rpx;
				padding: 28rpx 20rpx;
				display: flex;
				flex-direction: column;
				align-items: center;
				gap: 10rpx;
				border: 2rpx solid #e8e8e8;
				transition: all 0.2s;
				
				&.active {
					background-color: #333;
					border-color: #333;
				}
				
				.type-text {
					font-size: 26rpx;
					color: #666;
					font-weight: 500;
				}
				
				&.active .type-text {
					color: #fff;
				}
			}
		}
		
		.textarea-wrapper {
			background-color: #fff;
			border-radius: 8rpx;
			padding: 20rpx;
			border: 1rpx solid #e8e8e8;
			
			.feedback-textarea {
				width: 100%;
				min-height: 280rpx;
				font-size: 26rpx;
				color: #333;
				line-height: 1.6;
			}
			
			.char-count {
				text-align: right;
				font-size: 22rpx;
				color: #999;
				margin-top: 8rpx;
			}
		}
		
		.input-wrapper {
			background-color: #fff;
			border-radius: 8rpx;
			padding: 24rpx 20rpx;
			border: 1rpx solid #e8e8e8;
			
			.feedback-input {
				width: 100%;
				font-size: 26rpx;
				color: #333;
			}
		}
		
		.image-upload {
			display: flex;
			flex-wrap: wrap;
			gap: 16rpx;
			
			.image-item {
				width: 180rpx;
				height: 180rpx;
				border-radius: 8rpx;
				overflow: hidden;
				position: relative;
				
				.upload-image {
					width: 100%;
					height: 100%;
				}
				
				.delete-btn {
					position: absolute;
					top: 8rpx;
					right: 8rpx;
					width: 36rpx;
					height: 36rpx;
					background-color: rgba(0, 0, 0, 0.7);
					border-radius: 50%;
					display: flex;
					align-items: center;
					justify-content: center;
				}
			}
			
			.upload-btn {
				width: 180rpx;
				height: 180rpx;
				background-color: #fafafa;
				border: 2rpx dashed #d9d9d9;
				border-radius: 8rpx;
				display: flex;
				align-items: center;
				justify-content: center;
			}
		}
	}
}

.submit-section {
	margin: 48rpx 0 32rpx;
	
	.submit-btn {
		width: 100%;
		height: 88rpx;
		background-color: #333;
		border-radius: 8rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		transition: all 0.2s;
		
		&:active:not(.disabled) {
			opacity: 0.8;
		}
		
		&.disabled {
			opacity: 0.5;
		}
		
		.submit-text {
			font-size: 30rpx;
			color: #fff;
			font-weight: 500;
		}
	}
}

.tips-section {
	background-color: #fff;
	border-radius: 8rpx;
	padding: 24rpx;
	border: 1rpx solid #e8e8e8;
	
	.tips-title {
		margin-bottom: 16rpx;
		
		.tips-title-text {
			font-size: 26rpx;
			font-weight: 600;
			color: #333;
		}
	}
	
	.tips-content {
		display: flex;
		flex-direction: column;
		gap: 10rpx;
		
		.tips-item {
			font-size: 24rpx;
			color: #666;
			line-height: 1.6;
		}
	}
}
</style>

