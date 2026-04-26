<template>
	<view class="result-container">
		<!-- 识别结果头部 -->
		<view class="result-header">
			<uv-icon name="checkmark-circle-fill" size="64" color="#07c160"></uv-icon>
			<text class="result-title">识别完成</text>
			<text class="result-desc">共识别到{{ resultList.length }}个可能的结果</text>
		</view>
		
		<!-- 结果列表 -->
		<view class="result-list">
			<view 
				v-for="(item, index) in resultList" 
				:key="index" 
				class="result-card"
				:class="{ 'is-first': index === 0 }"
			>
				<view class="card-header">
					<view class="card-rank" :class="{ 'rank-first': index === 0 }">{{ index + 1 }}</view>
					<view class="card-info">
						<text class="item-name">{{ item.name }}</text>
						<view class="item-type" :style="{ backgroundColor: getTypeColor(item.lajitype) }">
							{{ item.lajitypeName || getTypeName(item.lajitype) }}
						</view>
					</view>
					<view class="trust-info">
						<text class="trust-value">{{ item.trust }}%</text>
						<text class="trust-label">可信度</text>
					</view>
				</view>
				<view class="card-body">
					<text class="tip-text">{{ item.lajitip || '暂无投放提示' }}</text>
				</view>
			</view>
		</view>
		
		<!-- 操作按钮 -->
		<view class="action-section">
			<view class="action-btn primary-btn" @click="reRecognize">
				<uv-icon name="reload" size="24" color="#fff"></uv-icon>
				<text>重新识别</text>
			</view>
			<view class="action-btn secondary-btn" @click="goHome">
				<uv-icon name="home" size="24" color="#07c160"></uv-icon>
				<text>返回首页</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const resultList = ref([])

// 分类颜色
const typeColors = {
	0: '#07c160', // 可回收
	1: '#ff4d4f', // 有害
	2: '#fa8c16', // 厨余
	3: '#999999', // 其他
	4: '#1989fa'  // 未知
}

// 分类名称
const typeNames = {
	0: '可回收垃圾',
	1: '有害垃圾',
	2: '厨余垃圾',
	3: '其他垃圾',
	4: '未知'
}

const getTypeColor = (type) => typeColors[type] || '#999'
const getTypeName = (type) => typeNames[type] || '未知'

const reRecognize = () => {
	uni.navigateBack()
}

const goHome = () => {
	uni.switchTab({
		url: '/pages/index/index'
	})
}

onMounted(() => {
	const pages = getCurrentPages()
	const currentPage = pages[pages.length - 1]
	const data = currentPage.options.data
	
	if (data) {
		try {
			const parsed = JSON.parse(decodeURIComponent(data))
			resultList.value = parsed.list || []
		} catch (e) {
			console.error('解析数据失败:', e)
		}
	}
})
</script>

<style lang="scss" scoped>
.result-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding: 30rpx;
}

.result-header {
	background-color: #fff;
	border-radius: 24rpx;
	padding: 60rpx 40rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 16rpx;
	margin-bottom: 30rpx;
	
	.result-title {
		font-size: 36rpx;
		font-weight: 700;
		color: #333;
	}
	
	.result-desc {
		font-size: 28rpx;
		color: #999;
	}
}

.result-list {
	display: flex;
	flex-direction: column;
	gap: 20rpx;
	margin-bottom: 30rpx;
	
	.result-card {
		background-color: #fff;
		border-radius: 16rpx;
		overflow: hidden;
		
		&.is-first {
			border: 2rpx solid #07c160;
		}
		
		.card-header {
			padding: 30rpx;
			display: flex;
			align-items: center;
			gap: 20rpx;
			border-bottom: 1rpx solid #f0f0f0;
			
			.card-rank {
				width: 48rpx;
				height: 48rpx;
				border-radius: 50%;
				background-color: #f5f5f5;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 24rpx;
				font-weight: 600;
				color: #999;
				
				&.rank-first {
					background-color: #07c160;
					color: #fff;
				}
			}
			
			.card-info {
				flex: 1;
				display: flex;
				flex-direction: column;
				gap: 8rpx;
				
				.item-name {
					font-size: 30rpx;
					font-weight: 600;
					color: #333;
				}
				
				.item-type {
					display: inline-block;
					padding: 6rpx 16rpx;
					border-radius: 16rpx;
					font-size: 22rpx;
					color: #fff;
					align-self: flex-start;
				}
			}
			
			.trust-info {
				display: flex;
				flex-direction: column;
				align-items: center;
				
				.trust-value {
					font-size: 32rpx;
					font-weight: 700;
					color: #07c160;
				}
				
				.trust-label {
					font-size: 22rpx;
					color: #999;
				}
			}
		}
		
		.card-body {
			padding: 24rpx 30rpx;
			
			.tip-text {
				font-size: 26rpx;
				color: #666;
				line-height: 1.6;
			}
		}
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
