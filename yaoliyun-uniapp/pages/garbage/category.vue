<template>
	<view class="category-container">
		<view v-for="item in categoryList" :key="item.categoryId" class="category-card" @click="toDetail(item)">
			<view class="category-header" :style="{ backgroundColor: item.colorCode }">
				<uv-icon name="trash-fill" size="48" color="#fff"></uv-icon>
				<text class="category-name">{{ item.categoryName }}</text>
			</view>
			<view class="category-body">
				<text class="category-desc">{{ item.description }}</text>
				<view class="category-info">
					<text class="info-label">处理指南：</text>
					<text class="info-value">{{ item.disposalGuidelines || '暂无' }}</text>
				</view>
			</view>
			<view class="category-footer">
				<text class="view-more">查看详情</text>
				<uv-icon name="arrow-right" size="16" color="#999"></uv-icon>
			</view>
		</view>
		
		<uv-empty v-if="!loading && categoryList.length === 0" mode="data" text="暂无分类数据"></uv-empty>
		<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { listCategory } from '@/api/system/category.js'

const loading = ref(false)
const categoryList = ref([])

const loadData = async () => {
	loading.value = true
	try {
		const res = await listCategory({ status: '0' })
		if (res.code === 200) {
			categoryList.value = res.rows || []
		}
	} catch (error) {
		console.error('获取分类列表失败:', error)
		uni.showToast({ title: '获取数据失败', icon: 'none' })
	} finally {
		loading.value = false
	}
}

const toDetail = (item) => {
	uni.navigateTo({
		url: '/pages/garbage/category-detail?categoryId=' + item.categoryId
	})
}

onMounted(() => {
	loadData()
})
</script>

<style lang="scss" scoped>
.category-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding: 30rpx;
	display: flex;
	flex-direction: column;
	gap: 24rpx;
}

.category-card {
	background-color: #fff;
	border-radius: 16rpx;
	overflow: hidden;
	
	.category-header {
		padding: 40rpx;
		display: flex;
		align-items: center;
		gap: 20rpx;
		
		.category-name {
			font-size: 36rpx;
			font-weight: 700;
			color: #fff;
		}
	}
	
	.category-body {
		padding: 30rpx;
		
		.category-desc {
			font-size: 28rpx;
			color: #333;
			line-height: 1.6;
			display: block;
			margin-bottom: 20rpx;
		}
		
		.category-info {
			display: flex;
			
			.info-label {
				font-size: 26rpx;
				color: #999;
				flex-shrink: 0;
			}
			
			.info-value {
				font-size: 26rpx;
				color: #666;
				flex: 1;
			}
		}
	}
	
	.category-footer {
		padding: 24rpx 30rpx;
		border-top: 1rpx solid #f0f0f0;
		display: flex;
		align-items: center;
		justify-content: flex-end;
		gap: 8rpx;
		
		.view-more {
			font-size: 26rpx;
			color: #999;
		}
	}
}
</style>
