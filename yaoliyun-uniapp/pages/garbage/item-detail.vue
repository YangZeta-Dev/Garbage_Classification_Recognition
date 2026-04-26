<template>
	<view class="item-detail-container">
		<view class="item-header">
			<image v-if="item.imageUrl" class="item-image" :src="item.imageUrl" mode="aspectFit"></image>
			<view v-else class="item-image placeholder">
				<uv-icon name="photo" size="64" color="#ccc"></uv-icon>
			</view>
			<text class="item-name">{{ item.itemName }}</text>
			<view class="item-category" :style="{ backgroundColor: categoryColor }">
				{{ item.categoryName || '未知分类' }}
			</view>
		</view>

		<view class="info-section">
			<view class="info-card">
				<view class="card-title">
					<uv-icon name="info-circle" size="20" color="#07c160"></uv-icon>
					<text>处理建议</text>
				</view>
				<view class="card-content">
					{{ item.disposalSuggestion || '暂无处理建议' }}
				</view>
			</view>
			
			<view class="info-card">
				<view class="card-title">
					<uv-icon name="twitte" size="20" color="#07c160"></uv-icon>
					<text>环保提示</text>
				</view>
				<view class="card-content">
					{{ item.environmentalTips || '暂无环保提示' }}
				</view>
			</view>
		</view>
		
		<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getItem } from '@/api/system/item.js'
import { getCategory } from '@/api/system/category.js'

const item = ref({})
const loading = ref(false)
const categoryColor = ref('#07c160')

const loadData = async () => {
	const pages = getCurrentPages()
	const currentPage = pages[pages.length - 1]
	const itemId = currentPage.options.itemId
	
	if (!itemId) {
		uni.showToast({ title: '参数错误', icon: 'none' })
		return
	}
	
	loading.value = true
	try {
		const res = await getItem(itemId)
		if (res.code === 200) {
			item.value = res.data || {}
			
			// 获取分类信息以显示颜色
			if (item.value.categoryId) {
				const catRes = await getCategory(item.value.categoryId)
				if (catRes.code === 200 && catRes.data) {
					categoryColor.value = catRes.data.colorCode || '#07c160'
					item.value.categoryName = catRes.data.categoryName // 确保有分类名称
				}
			}
		}
	} catch (error) {
		console.error('获取物品详情失败:', error)
		uni.showToast({ title: '获取详情失败', icon: 'none' })
	} finally {
		loading.value = false
	}
}

onMounted(() => {
	loadData()
})
</script>

<style lang="scss" scoped>
.item-detail-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding-bottom: 40rpx;
}

.item-header {
	background-color: #fff;
	padding: 60rpx 40rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-bottom: 20rpx;
	
	.item-image {
		width: 300rpx;
		height: 300rpx;
		margin-bottom: 30rpx;
		
		&.placeholder {
			background-color: #f9f9f9;
			border-radius: 16rpx;
			display: flex;
			align-items: center;
			justify-content: center;
		}
	}
	
	.item-name {
		font-size: 40rpx;
		font-weight: 700;
		color: #333;
		margin-bottom: 20rpx;
	}
	
	.item-category {
		padding: 8rpx 24rpx;
		border-radius: 30rpx;
		font-size: 26rpx;
		color: #fff;
	}
}

.info-section {
	padding: 0 30rpx;
	display: flex;
	flex-direction: column;
	gap: 20rpx;
	
	.info-card {
		background-color: #fff;
		border-radius: 16rpx;
		padding: 30rpx;
		
		.card-title {
			display: flex;
			align-items: center;
			gap: 12rpx;
			margin-bottom: 20rpx;
			
			text {
				font-size: 30rpx;
				font-weight: 600;
				color: #333;
			}
		}
		
		.card-content {
			font-size: 28rpx;
			color: #666;
			line-height: 1.6;
		}
	}
}
</style>
