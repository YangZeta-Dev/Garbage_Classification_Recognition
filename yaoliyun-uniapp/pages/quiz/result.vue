<template>
	<view class="result-container">
		<!-- 结果头部 -->
		<view class="result-header" :class="{ excellent: isExcellent }">
			<view class="score-circle">
				<text class="score-value">{{ score }}</text>
				<text class="score-label">分</text>
			</view>
			<text class="result-title">{{ resultTitle }}</text>
			<text class="result-desc">答对{{ correct }}/{{ total }}题</text>
		</view>
		
		<!-- 统计信息 -->
		<view class="stats-section">
			<view class="stats-item">
				<text class="stats-value">{{ total }}</text>
				<text class="stats-label">总题数</text>
			</view>
			<view class="stats-divider"></view>
			<view class="stats-item">
				<text class="stats-value correct-color">{{ correct }}</text>
				<text class="stats-label">答对</text>
			</view>
			<view class="stats-divider"></view>
			<view class="stats-item">
				<text class="stats-value wrong-color">{{ total - correct }}</text>
				<text class="stats-label">答错</text>
			</view>
			<view class="stats-divider"></view>
			<view class="stats-item">
				<text class="stats-value">{{ accuracy }}%</text>
				<text class="stats-label">正确率</text>
			</view>
		</view>
		
		<!-- 评价 -->
		<view class="comment-section">
			<uv-icon :name="commentIcon" size="32" :color="commentColor"></uv-icon>
			<text class="comment-text">{{ commentText }}</text>
		</view>
		
		<!-- 操作按钮 -->
		<view class="action-section">
			<view class="action-btn primary-btn" @click="retryQuiz">
				<uv-icon name="reload" size="24" color="#fff"></uv-icon>
				<text>再做一次</text>
			</view>
			<view class="action-btn secondary-btn" @click="goHome">
				<uv-icon name="home" size="24" color="#07c160"></uv-icon>
				<text>返回首页</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const score = ref(0)
const total = ref(0)
const correct = ref(0)

// 是否优秀
const isExcellent = computed(() => accuracy.value >= 80)

// 正确率
const accuracy = computed(() => {
	if (total.value === 0) return 0
	return Math.round(correct.value / total.value * 100)
})

// 结果标题
const resultTitle = computed(() => {
	if (accuracy.value >= 90) return '太棒了！'
	if (accuracy.value >= 80) return '很不错！'
	if (accuracy.value >= 60) return '继续努力！'
	return '再接再厉！'
})

// 评价图标
const commentIcon = computed(() => {
	if (accuracy.value >= 80) return 'thumb-up-fill'
	if (accuracy.value >= 60) return 'star-fill'
	return 'heart-fill'
})

// 评价颜色
const commentColor = computed(() => {
	if (accuracy.value >= 80) return '#07c160'
	if (accuracy.value >= 60) return '#ff976a'
	return '#ff4d4f'
})

// 评价文字
const commentText = computed(() => {
	if (accuracy.value >= 90) return '你已经是垃圾分类小达人了！'
	if (accuracy.value >= 80) return '掌握得很好，继续保持！'
	if (accuracy.value >= 60) return '基础不错，还需要多加练习！'
	return '加油！多学习垃圾分类知识！'
})

const retryQuiz = () => {
	uni.redirectTo({
		url: '/pages/quiz/index'
	})
}

const goHome = () => {
	uni.switchTab({
		url: '/pages/index/index'
	})
}

onMounted(() => {
	const pages = getCurrentPages()
	const currentPage = pages[pages.length - 1]
	score.value = parseInt(currentPage.options.score) || 0
	total.value = parseInt(currentPage.options.total) || 0
	correct.value = parseInt(currentPage.options.correct) || 0
})
</script>

<style lang="scss" scoped>
.result-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding: 30rpx;
}

.result-header {
	background: linear-gradient(135deg, #ff976a 0%, #ff6b3d 100%);
	border-radius: 24rpx;
	padding: 60rpx 40rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 16rpx;
	margin-bottom: 30rpx;
	
	&.excellent {
		background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
	}
	
	.score-circle {
		width: 160rpx;
		height: 160rpx;
		border-radius: 50%;
		background-color: rgba(255, 255, 255, 0.2);
		display: flex;
		align-items: baseline;
		justify-content: center;
		
		.score-value {
			font-size: 64rpx;
			font-weight: 700;
			color: #fff;
		}
		
		.score-label {
			font-size: 28rpx;
			color: rgba(255, 255, 255, 0.8);
		}
	}
	
	.result-title {
		font-size: 40rpx;
		font-weight: 700;
		color: #fff;
	}
	
	.result-desc {
		font-size: 28rpx;
		color: rgba(255, 255, 255, 0.8);
	}
}

.stats-section {
	background-color: #fff;
	border-radius: 16rpx;
	padding: 40rpx;
	display: flex;
	align-items: center;
	margin-bottom: 30rpx;
	
	.stats-item {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 8rpx;
		
		.stats-value {
			font-size: 40rpx;
			font-weight: 700;
			color: #333;
			
			&.correct-color {
				color: #07c160;
			}
			
			&.wrong-color {
				color: #ff4d4f;
			}
		}
		
		.stats-label {
			font-size: 24rpx;
			color: #999;
		}
	}
	
	.stats-divider {
		width: 1rpx;
		height: 60rpx;
		background-color: #f0f0f0;
	}
}

.comment-section {
	background-color: #fff;
	border-radius: 16rpx;
	padding: 40rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 16rpx;
	margin-bottom: 40rpx;
	
	.comment-text {
		font-size: 28rpx;
		color: #666;
	}
}

.action-section {
	display: flex;
	gap: 24rpx;
	
	.action-btn {
		flex: 1;
		height: 96rpx;
		border-radius: 48rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 12rpx;
		font-size: 30rpx;
		font-weight: 500;
	}
	
	.primary-btn {
		background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
		color: #fff;
	}
	
	.secondary-btn {
		background-color: #fff;
		border: 2rpx solid #07c160;
		color: #07c160;
	}
}
</style>
