<template>
	<view class="detail-container">
		<!-- 分类头部 -->
		<view class="detail-header" :style="{ backgroundColor: category.colorCode || '#07c160' }">
			<uv-icon name="trash-fill" size="64" color="#fff"></uv-icon>
			<text class="category-name">{{ category.categoryName }}</text>
			<text class="category-desc">{{ category.description }}</text>
		</view>
		
		<!-- 分类信息 -->
		<view class="info-section">
			<view class="info-title">处理指南</view>
			<view class="info-content">{{ category.disposalGuidelines || '暂无处理指南' }}</view>
		</view>
		
		<!-- 物品列表 -->
		<view class="item-section">
			<view class="section-header">
				<text class="section-title">包含物品</text>
				<text class="item-count">共{{ itemList.length }}件</text>
			</view>
			<view class="item-list">
				<view v-for="item in itemList" :key="item.itemId" class="item-card" @click="toItemDetail(item)">
					<image v-if="item.imageUrl" class="item-image" :src="item.imageUrl" mode="aspectFill"></image>
					<view v-else class="item-image item-placeholder">
						<uv-icon name="photo" size="32" color="#ccc"></uv-icon>
					</view>
					<view class="item-info">
						<text class="item-name">{{ item.itemName }}</text>
						<text class="item-tip">{{ item.disposalSuggestion || '暂无处理建议' }}</text>
					</view>
				</view>
			</view>
			<uv-empty v-if="!loading && itemList.length === 0" mode="data" text="暂无物品数据"></uv-empty>
		</view>
		
		<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getCategory } from '@/api/system/category.js'
import { listItem } from '@/api/system/item.js'

const category = ref({})
const itemList = ref([])
const loading = ref(false)

const loadData = async () => {
	const pages = getCurrentPages()
	const currentPage = pages[pages.length - 1]
	const categoryId = currentPage.options.categoryId
	
	if (!categoryId) {
		uni.showToast({ title: '参数错误', icon: 'none' })
		return
	}
	
	loading.value = true
	try {
		// 获取分类详情
		const catRes = await getCategory(categoryId)
		if (catRes.code === 200) {
			category.value = catRes.data || {}
		}
		
		// 获取物品列表
		const itemRes = await listItem({ categoryId, status: '0', pageSize: 1000 })
		if (itemRes.code === 200) {
			itemList.value = itemRes.rows || []
		}
	} catch (error) {
		console.error('获取数据失败:', error)
		uni.showToast({ title: '获取数据失败', icon: 'none' })
	} finally {
		loading.value = false
	}
}

const toItemDetail = (item) => {
	uni.navigateTo({
		url: '/pages/garbage/item-detail?itemId=' + item.itemId
	})
}

onMounted(() => {
	loadData()
})
</script>

<style lang="scss" scoped>
.detail-container {
	min-height: 100vh;
	background-color: #f5f5f5;
}

.detail-header {
	padding: 60rpx 40rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 16rpx;
	
	.category-name {
		font-size: 40rpx;
		font-weight: 700;
		color: #fff;
	}
	
	.category-desc {
		font-size: 28rpx;
		color: rgba(255, 255, 255, 0.8);
		text-align: center;
	}
}

.info-section {
	background-color: #fff;
	margin: 20rpx;
	border-radius: 16rpx;
	padding: 30rpx;
	
	.info-title {
		font-size: 30rpx;
		font-weight: 600;
		color: #333;
		margin-bottom: 16rpx;
	}
	
	.info-content {
		font-size: 28rpx;
		color: #666;
		line-height: 1.6;
	}
}

.item-section {
	background-color: #fff;
	margin: 20rpx;
	border-radius: 16rpx;
	padding: 30rpx;
	
	.section-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 24rpx;
		
		.section-title {
			font-size: 30rpx;
			font-weight: 600;
			color: #333;
		}
		
		.item-count {
			font-size: 26rpx;
			color: #999;
		}
	}
	
	.item-list {
		display: flex;
		flex-direction: column;
		gap: 20rpx;
		
		.item-card {
			display: flex;
			gap: 20rpx;
			padding: 20rpx;
			background-color: #f8f8f8;
			border-radius: 12rpx;
			
			.item-image {
				width: 120rpx;
				height: 120rpx;
				border-radius: 8rpx;
				flex-shrink: 0;
			}
			
			.item-placeholder {
				background-color: #eee;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.item-info {
				flex: 1;
				display: flex;
				flex-direction: column;
				justify-content: center;
				gap: 8rpx;
				
				.item-name {
					font-size: 28rpx;
					font-weight: 600;
					color: #333;
				}
				
				.item-tip {
					font-size: 24rpx;
					color: #999;
					display: -webkit-box;
					-webkit-line-clamp: 2;
					-webkit-box-orient: vertical;
					overflow: hidden;
				}
			}
		}
	}
}
</style>
