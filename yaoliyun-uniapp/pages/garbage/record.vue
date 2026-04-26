<template>
	<view class="record-container">
		<scroll-view class="record-scroll" scroll-y @scrolltolower="loadMore">
			<view v-if="recordList.length > 0" class="record-list">
				<view 
					v-for="item in recordList" 
					:key="item.recordId" 
					class="record-card"
				>
					<image v-if="item.imageUrl" class="record-image" :src="item.imageUrl" mode="aspectFill"></image>
					<view v-else class="record-image record-placeholder">
						<uv-icon name="photo" size="32" color="#ccc"></uv-icon>
					</view>
					<view class="record-info">
						<text class="record-name">{{ item.recognizedName || '未知物品' }}</text>
						<view class="record-meta">
							<view class="record-category" :style="{ backgroundColor: getCategoryColor(item.categoryId) }">
								{{ item.categoryName || '未知分类' }}
							</view>
							<text class="record-score">置信度: {{ item.confidenceScore || 0 }}%</text>
						</view>
						<text class="record-time">{{ formatTime(item.recognitionTime) }}</text>
					</view>
				</view>
			</view>
			
			<uv-empty v-if="!loading && recordList.length === 0" mode="history" text="暂无识别记录"></uv-empty>
			<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
			<view v-if="!loading && finished && recordList.length > 0" class="load-finished">
				<text>没有更多了</text>
			</view>
		</scroll-view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { listRecord } from '@/api/system/record.js'

const recordList = ref([])
const loading = ref(false)
const finished = ref(false)
const pageNum = ref(1)
const pageSize = ref(10)

// 分类颜色
const categoryColors = {
	1: '#07c160', // 可回收
	2: '#ff4d4f', // 有害
	3: '#fa8c16', // 厨余
	4: '#999999'  // 其他
}

const getCategoryColor = (categoryId) => categoryColors[categoryId] || '#999'

const formatTime = (time) => {
	if (!time) return ''
	const date = new Date(time)
	const year = date.getFullYear()
	const month = String(date.getMonth() + 1).padStart(2, '0')
	const day = String(date.getDate()).padStart(2, '0')
	const hours = String(date.getHours()).padStart(2, '0')
	const minutes = String(date.getMinutes()).padStart(2, '0')
	return `${year}-${month}-${day} ${hours}:${minutes}`
}

const loadData = async (isRefresh = false) => {
	if (loading.value) return
	if (!isRefresh && finished.value) return
	
	loading.value = true
	
	try {
		const userInfo = uni.getStorageSync('userInfo')
		const params = {
			pageNum: pageNum.value,
			pageSize: pageSize.value
		}
		if (userInfo && userInfo.userId) {
			params.userId = userInfo.userId
		}
		
		const res = await listRecord(params)
		if (res.code === 200) {
			const rows = res.rows || []
			if (isRefresh) {
				recordList.value = rows
			} else {
				recordList.value = [...recordList.value, ...rows]
			}
			finished.value = rows.length < pageSize.value
		}
	} catch (error) {
		console.error('获取记录失败:', error)
		uni.showToast({ title: '获取记录失败', icon: 'none' })
	} finally {
		loading.value = false
	}
}

const loadMore = () => {
	if (!finished.value && !loading.value) {
		pageNum.value++
		loadData()
	}
}

onMounted(() => {
	loadData(true)
})
</script>

<style lang="scss" scoped>
.record-container {
	min-height: 100vh;
	background-color: #f5f5f5;
}

.record-scroll {
	height: 100vh;
	padding: 20rpx;
	box-sizing: border-box;
}

.record-list {
	display: flex;
	flex-direction: column;
	gap: 20rpx;
	
	.record-card {
		background-color: #fff;
		border-radius: 16rpx;
		padding: 24rpx;
		display: flex;
		gap: 20rpx;
		
		.record-image {
			width: 140rpx;
			height: 140rpx;
			border-radius: 12rpx;
			flex-shrink: 0;
		}
		
		.record-placeholder {
			background-color: #f5f5f5;
			display: flex;
			align-items: center;
			justify-content: center;
		}
		
		.record-info {
			flex: 1;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			
			.record-name {
				font-size: 30rpx;
				font-weight: 600;
				color: #333;
			}
			
			.record-meta {
				display: flex;
				align-items: center;
				gap: 16rpx;
				
				.record-category {
					padding: 6rpx 16rpx;
					border-radius: 16rpx;
					font-size: 22rpx;
					color: #fff;
				}
				
				.record-score {
					font-size: 24rpx;
					color: #999;
				}
			}
			
			.record-time {
				font-size: 24rpx;
				color: #999;
			}
		}
	}
}

.load-finished {
	text-align: center;
	padding: 30rpx;
	
	text {
		font-size: 26rpx;
		color: #999;
	}
}
</style>
