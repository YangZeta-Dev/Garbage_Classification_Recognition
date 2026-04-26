<template>
	<view class="history-container">
		<!-- 头部 -->
		<view class="page-header">
			<text class="header-title">我的反馈</text>
			<text class="header-subtitle">共 {{ total }} 条反馈记录</text>
		</view>
		
		<!-- 反馈列表 -->
		<scroll-view 
			class="feedback-list" 
			scroll-y
			@scrolltolower="loadMore"
		>
			<view 
				v-for="item in feedbackList" 
				:key="item.id"
				class="feedback-item"
				@click="viewDetail(item.id)"
			>
				<!-- 类型标签 -->
				<view class="item-header">
					<view class="type-tag" :class="`type-${item.type}`">
						<text class="type-text">{{ item.typeName }}</text>
					</view>
					<view class="status-tag" :class="`status-${item.status}`">
						<text class="status-text">{{ item.statusName }}</text>
					</view>
				</view>
				
				<!-- 反馈内容 -->
				<view class="item-content">
					<text class="content-text">{{ item.content }}</text>
				</view>
				
				<!-- 回复 -->
				<view v-if="item.reply" class="item-reply">
					<view class="reply-label">
						<uv-icon name="chat" size="16" color="#F5D858"></uv-icon>
						<text class="reply-label-text">官方回复：</text>
					</view>
					<text class="reply-text">{{ item.reply }}</text>
				</view>
				
				<!-- 时间 -->
				<view class="item-footer">
					<uv-icon name="clock" size="16" color="#999"></uv-icon>
					<text class="time-text">{{ item.createTime }}</text>
				</view>
			</view>
			
			<!-- 空状态 -->
			<view v-if="!loading && feedbackList.length === 0" class="empty-state">
				<uv-icon name="file-text" size="80" color="#ddd"></uv-icon>
				<text class="empty-text">暂无反馈记录</text>
				<view class="empty-btn" @click="goToFeedback">
					<text class="empty-btn-text">去反馈</text>
				</view>
			</view>
			
			<!-- 加载状态 -->
			<view v-if="loading" class="loading-state">
				<text class="loading-text">加载中...</text>
			</view>
			
			<view v-if="!hasMore && feedbackList.length > 0" class="no-more">
				<text class="no-more-text">没有更多了</text>
			</view>
		</scroll-view>
		
		<!-- 浮动按钮 -->
		<view class="float-btn" @click="goToFeedback">
			<uv-icon name="plus" size="32" color="#fff"></uv-icon>
		</view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getFeedbackList } from '@/api/feedback.js'
import { showError } from '@/utils/index.js'

const feedbackList = ref([])
const loading = ref(false)
const hasMore = ref(true)
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

// 加载反馈列表
const loadFeedbackList = async () => {
	if (loading.value || !hasMore.value) return
	
	try {
		loading.value = true
		
		const res = await getFeedbackList({
			pageNum: pageNum.value,
			pageSize: pageSize.value
		})
		
		if (res.code === 200) {
			const list = res.rows || []
			
			if (pageNum.value === 1) {
				feedbackList.value = list
			} else {
				feedbackList.value.push(...list)
			}
			
			total.value = res.total || 0
			hasMore.value = feedbackList.value.length < total.value
		} else {
			showError(res.msg || '加载失败')
		}
	} catch (error) {
		console.error('加载反馈列表失败:', error)
		showError('加载失败')
	} finally {
		loading.value = false
	}
}

// 加载更多
const loadMore = () => {
	if (hasMore.value && !loading.value) {
		pageNum.value++
		loadFeedbackList()
	}
}

// 查看详情
const viewDetail = (id) => {
	uni.navigateTo({
		url: `/pages/feedback/detail?id=${id}`
	})
}

// 去反馈
const goToFeedback = () => {
	uni.navigateTo({
		url: '/pages/feedback/feedback'
	})
}

onMounted(() => {
	loadFeedbackList()
})
</script>

<style lang="scss" scoped>
.history-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.page-header {
	background-color: #fff;
	padding: 32rpx 30rpx;
	border-bottom: 1rpx solid #e8e8e8;
	
	.header-title {
		font-size: 36rpx;
		font-weight: 600;
		color: #333;
		display: block;
		margin-bottom: 8rpx;
	}
	
	.header-subtitle {
		font-size: 24rpx;
		color: #999;
	}
}

.feedback-list {
	flex: 1;
	padding: 30rpx;
	box-sizing: border-box;
	
	.feedback-item {
		background-color: #fff;
		border-radius: 8rpx;
		padding: 24rpx;
		margin-bottom: 16rpx;
		border: 1rpx solid #e8e8e8;
		transition: all 0.2s;
		
		&:active {
			background-color: #fafafa;
		}
		
		.item-header {
			display: flex;
			align-items: center;
			gap: 12rpx;
			margin-bottom: 16rpx;
			
			.type-tag {
				padding: 6rpx 16rpx;
				border-radius: 4rpx;
				background-color: #f5f5f5;
				
				.type-text {
					font-size: 22rpx;
					color: #666;
				}
			}
			
			.status-tag {
				padding: 6rpx 16rpx;
				border-radius: 4rpx;
				margin-left: auto;
				
				&.status-pending {
					background-color: #fafafa;
					border: 1rpx solid #d9d9d9;
					
					.status-text {
						color: #666;
					}
				}
				
				&.status-processing {
					background-color: #f5f5f5;
					border: 1rpx solid #d9d9d9;
					
					.status-text {
						color: #333;
					}
				}
				
				&.status-resolved {
					background-color: #333;
					
					.status-text {
						color: #fff;
					}
				}
				
				.status-text {
					font-size: 22rpx;
				}
			}
		}
		
		.item-content {
			margin-bottom: 16rpx;
			
			.content-text {
				font-size: 26rpx;
				color: #333;
				line-height: 1.6;
				display: -webkit-box;
				-webkit-line-clamp: 3;
				-webkit-box-orient: vertical;
				overflow: hidden;
			}
		}
		
		.item-reply {
			background-color: #fafafa;
			border-radius: 6rpx;
			padding: 16rpx;
			margin-bottom: 16rpx;
			border-left: 3rpx solid #333;
			
			.reply-label {
				display: flex;
				align-items: center;
				gap: 6rpx;
				margin-bottom: 8rpx;
				
				.reply-label-text {
					font-size: 22rpx;
					color: #666;
					font-weight: 600;
				}
			}
			
			.reply-text {
				font-size: 24rpx;
				color: #666;
				line-height: 1.6;
			}
		}
		
		.item-footer {
			display: flex;
			align-items: center;
			gap: 6rpx;
			
			.time-text {
				font-size: 22rpx;
				color: #999;
			}
		}
	}
	
	.empty-state {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		padding: 120rpx 0;
		
		.empty-text {
			font-size: 26rpx;
			color: #999;
			margin: 32rpx 0 40rpx;
		}
		
		.empty-btn {
			padding: 16rpx 48rpx;
			background-color: #333;
			border-radius: 8rpx;
			
			.empty-btn-text {
				font-size: 26rpx;
				color: #fff;
				font-weight: 500;
			}
		}
	}
	
	.loading-state {
		padding: 40rpx 0;
		text-align: center;
		
		.loading-text {
			font-size: 26rpx;
			color: #999;
		}
	}
	
	.no-more {
		padding: 40rpx 0;
		text-align: center;
		
		.no-more-text {
			font-size: 26rpx;
			color: #ccc;
		}
	}
}

.float-btn {
	position: fixed;
	right: 40rpx;
	bottom: calc(100rpx + env(safe-area-inset-bottom));
	width: 112rpx;
	height: 112rpx;
	background-color: #333;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.15);
	z-index: 999;
	transition: all 0.2s;
	
	&:active {
		opacity: 0.8;
		transform: scale(0.95);
	}
}
</style>

