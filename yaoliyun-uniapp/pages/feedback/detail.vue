<template>
	<view class="detail-container">
		<scroll-view class="detail-scroll" scroll-y>
			<!-- 加载中 -->
			<view v-if="loading" class="loading-state">
				<text class="loading-text">加载中...</text>
			</view>
			
			<!-- 详情内容 -->
			<view v-else-if="detail" class="detail-content">
				<!-- 状态卡片 -->
				<view class="status-card">
					<view class="status-icon" :class="`status-${detail.status}`">
						<uv-icon 
							:name="getStatusIcon(detail.status)" 
							size="48" 
							color="#fff"
						></uv-icon>
					</view>
					<view class="status-info">
						<text class="status-name">{{ detail.statusName }}</text>
						<text class="status-time">提交于 {{ detail.createTime }}</text>
					</view>
				</view>
				
				<!-- 反馈类型 -->
				<view class="info-section">
					<view class="section-title">
						<uv-icon name="list" size="20" color="#F5D858"></uv-icon>
						<text class="section-title-text">反馈类型</text>
					</view>
					<view class="type-tag" :class="`type-${detail.type}`">
						<text class="type-text">{{ detail.typeName }}</text>
					</view>
				</view>
				
				<!-- 反馈内容 -->
				<view class="info-section">
					<view class="section-title">
						<uv-icon name="file-text" size="20" color="#F5D858"></uv-icon>
						<text class="section-title-text">反馈内容</text>
					</view>
					<view class="content-box">
						<text class="content-text">{{ detail.content }}</text>
					</view>
				</view>
				
				<!-- 截图 -->
				<view v-if="detail.images && detail.images.length > 0" class="info-section">
					<view class="section-title">
						<uv-icon name="image" size="20" color="#F5D858"></uv-icon>
						<text class="section-title-text">相关截图</text>
					</view>
					<view class="image-list">
						<image 
							v-for="(image, index) in detail.images"
							:key="index"
							:src="image"
							mode="aspectFill"
							class="image-item"
							@click="previewImage(index)"
						></image>
					</view>
				</view>
				
				<!-- 联系方式 -->
				<view v-if="detail.contact" class="info-section">
					<view class="section-title">
						<uv-icon name="phone" size="20" color="#F5D858"></uv-icon>
						<text class="section-title-text">联系方式</text>
					</view>
					<view class="contact-box">
						<text class="contact-text">{{ detail.contact }}</text>
					</view>
				</view>
				
				<!-- 官方回复 -->
				<view v-if="detail.reply" class="reply-section">
					<view class="reply-header">
						<view class="reply-avatar">
							<uv-icon name="account-fill" size="32" color="#fff"></uv-icon>
						</view>
						<view class="reply-info">
							<text class="reply-name">官方客服</text>
							<text class="reply-time">{{ detail.replyTime }}</text>
						</view>
					</view>
					<view class="reply-content">
						<text class="reply-text">{{ detail.reply }}</text>
					</view>
				</view>
				
				<!-- 未回复提示 -->
				<view v-else class="no-reply">
					<uv-icon name="clock" size="48" color="#ddd"></uv-icon>
					<text class="no-reply-text">我们会尽快处理您的反馈</text>
				</view>
			</view>
		</scroll-view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getFeedbackDetail } from '@/api/feedback.js'
import { showError } from '@/utils/index.js'

const feedbackId = ref('')
const detail = ref(null)
const loading = ref(false)

// 页面加载
onLoad((options) => {
	if (options.id) {
		feedbackId.value = options.id
		loadDetail()
	}
})

// 加载详情
const loadDetail = async () => {
	try {
		loading.value = true
		
		const res = await getFeedbackDetail(feedbackId.value)
		
		if (res.code === 200) {
			detail.value = res.data
			// 处理图片数组
			if (detail.value.images && typeof detail.value.images === 'string') {
				detail.value.images = detail.value.images.split(',').filter(img => img)
			}
		} else {
			showError(res.msg || '加载失败')
		}
	} catch (error) {
		console.error('加载反馈详情失败:', error)
		showError('加载失败')
	} finally {
		loading.value = false
	}
}

// 获取状态图标
const getStatusIcon = (status) => {
	const iconMap = {
		pending: 'clock',
		processing: 'loading',
		resolved: 'checkmark-circle'
	}
	return iconMap[status] || 'clock'
}

// 预览图片
const previewImage = (index) => {
	if (detail.value && detail.value.images) {
		uni.previewImage({
			urls: detail.value.images,
			current: index
		})
	}
}
</script>

<style lang="scss" scoped>
.detail-container {
	min-height: 100vh;
	background-color: #f5f5f5;
}

.detail-scroll {
	height: 100vh;
	padding: 30rpx;
	box-sizing: border-box;
}

.loading-state {
	padding: 120rpx 0;
	text-align: center;
	
	.loading-text {
		font-size: 28rpx;
		color: #999;
	}
}

.detail-content {
	.status-card {
		background-color: #fff;
		border-radius: 8rpx;
		padding: 32rpx;
		display: flex;
		align-items: center;
		gap: 20rpx;
		margin-bottom: 24rpx;
		border: 1rpx solid #e8e8e8;
		
		.status-icon {
			width: 80rpx;
			height: 80rpx;
			border-radius: 50%;
			display: flex;
			align-items: center;
			justify-content: center;
			flex-shrink: 0;
			background-color: #f5f5f5;
			
			&.status-pending {
				background-color: #f5f5f5;
			}
			
			&.status-processing {
				background-color: #f5f5f5;
			}
			
			&.status-resolved {
				background-color: #333;
			}
		}
		
		.status-info {
			display: flex;
			flex-direction: column;
			gap: 6rpx;
			
			.status-name {
				font-size: 32rpx;
				font-weight: 600;
				color: #333;
			}
			
			.status-time {
				font-size: 22rpx;
				color: #999;
			}
		}
	}
	
	.info-section {
		background-color: #fff;
		border-radius: 8rpx;
		padding: 24rpx;
		margin-bottom: 16rpx;
		border: 1rpx solid #e8e8e8;
		
		.section-title {
			display: flex;
			align-items: center;
			gap: 6rpx;
			margin-bottom: 16rpx;
			
			.section-title-text {
				font-size: 26rpx;
				font-weight: 600;
				color: #333;
			}
		}
		
		.type-tag {
			padding: 8rpx 20rpx;
			border-radius: 4rpx;
			display: inline-block;
			background-color: #f5f5f5;
			
			.type-text {
				font-size: 24rpx;
				color: #666;
			}
		}
		
		.content-box {
			.content-text {
				font-size: 26rpx;
				color: #333;
				line-height: 1.8;
			}
		}
		
		.image-list {
			display: flex;
			flex-wrap: wrap;
			gap: 16rpx;
			
			.image-item {
				width: 180rpx;
				height: 180rpx;
				border-radius: 8rpx;
			}
		}
		
		.contact-box {
			.contact-text {
				font-size: 26rpx;
				color: #333;
			}
		}
	}
	
	.reply-section {
		background-color: #fff;
		border-radius: 8rpx;
		padding: 24rpx;
		margin-bottom: 16rpx;
		border: 1rpx solid #e8e8e8;
		
		.reply-header {
			display: flex;
			align-items: center;
			gap: 12rpx;
			margin-bottom: 20rpx;
			
			.reply-avatar {
				width: 64rpx;
				height: 64rpx;
				border-radius: 50%;
				background-color: #f5f5f5;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.reply-info {
				display: flex;
				flex-direction: column;
				gap: 4rpx;
				
				.reply-name {
					font-size: 26rpx;
					font-weight: 600;
					color: #333;
				}
				
				.reply-time {
					font-size: 22rpx;
					color: #999;
				}
			}
		}
		
		.reply-content {
			background-color: #fafafa;
			border-radius: 6rpx;
			padding: 20rpx;
			border-left: 3rpx solid #333;
			
			.reply-text {
				font-size: 26rpx;
				color: #333;
				line-height: 1.8;
			}
		}
	}
	
	.no-reply {
		background-color: #fff;
		border-radius: 8rpx;
		padding: 64rpx 32rpx;
		margin-bottom: 16rpx;
		border: 1rpx solid #e8e8e8;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 20rpx;
		
		.no-reply-text {
			font-size: 24rpx;
			color: #999;
		}
	}
}
</style>

