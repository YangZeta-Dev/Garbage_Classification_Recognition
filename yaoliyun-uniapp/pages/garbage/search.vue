<template>
	<view class="search-container">
		<!-- <uv-status-bar></uv-status-bar> -->
		<!-- 搜索头部 -->
		<view class="search-header">
			<view class="search-input-wrap">
				<uv-icon name="search" size="20" color="#999"></uv-icon>
				<input 
					class="search-input" 
					v-model="keyword" 
					placeholder="搜索垃圾名称，如：电池、塑料瓶"
					@confirm="handleSearch"
					confirm-type="search"
				/>
				<uv-icon v-if="keyword" name="close-circle-fill" size="18" color="#ccc" @click="clearKeyword"></uv-icon>
			</view>
			<text class="search-btn" @click="handleSearch">搜索</text>
		</view>
		
		<!-- 搜索结果 -->
		<scroll-view class="search-content" scroll-y>
			<!-- 热门搜索 -->
			<view v-if="!hasSearched" class="hot-section">
				<view class="section-title">热门搜索</view>
				<view class="hot-tags">
					<view 
						v-for="(tag, index) in hotTags" 
						:key="index" 
						class="hot-tag"
						@click="searchTag(tag)"
					>{{ tag }}</view>
				</view>
			</view>
			
			<!-- 搜索结果列表 -->
			<view v-if="hasSearched" class="result-section">
				<view v-if="resultList.length > 0" class="result-list">
					<view 
						v-for="(item, index) in resultList" 
						:key="index" 
						class="result-card"
					>
						<view class="result-header">
							<text class="result-name">{{ item.name }}</text>
							<view class="result-type" :style="{ backgroundColor: getTypeColor(item.type) }">
								{{ getTypeName(item.type) }}
							</view>
						</view>
						<view class="result-body">
							<view class="result-row">
								<text class="result-label">投放提示：</text>
								<text class="result-value">{{ item.tip || '暂无' }}</text>
							</view>
							<view class="result-row">
								<text class="result-label">分类说明：</text>
								<text class="result-value">{{ item.explain || '暂无' }}</text>
							</view>
						</view>
					</view>
				</view>
				<uv-empty v-else mode="search" text="未找到相关结果"></uv-empty>
			</view>
			
			<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
			
			<!-- 底部占位 -->
			<view class="bottom-placeholder"></view>
		</scroll-view>
	</view>
</template>

<script setup>
import { ref } from 'vue'
import { searchByName } from '@/api/system/recognition.js'

const keyword = ref('')
const loading = ref(false)
const hasSearched = ref(false)
const resultList = ref([])

// 热门搜索标签
const hotTags = ref(['塑料瓶', '电池', '剩饭剩菜', '废纸', '玻璃瓶', '药品', '灯泡', '旧衣服'])

// 分类颜色
const typeColors = {
	0: '#07c160', // 可回收
	1: '#ff4d4f', // 有害
	2: '#fa8c16', // 厨余
	3: '#999999'  // 其他
}

// 分类名称
const typeNames = {
	0: '可回收',
	1: '有害垃圾',
	2: '厨余垃圾',
	3: '其他垃圾'
}

const getTypeColor = (type) => typeColors[type] || '#999'
const getTypeName = (type) => typeNames[type] || '未知'

const handleSearch = async () => {
	if (!keyword.value.trim()) {
		uni.showToast({ title: '请输入搜索内容', icon: 'none' })
		return
	}
	
	loading.value = true
	hasSearched.value = true
	
	try {
		const res = await searchByName(keyword.value.trim(), 10, 0, 1)
		console.log('搜索结果:', res)
		if (res.code === 200 && res.data) {
			// 后端返回的是 { list: [...], total: n }
			resultList.value = res.data.list || []
		} else {
			resultList.value = []
		}
	} catch (error) {
		console.error('搜索失败:', error)
		resultList.value = []
		// 不显示toast，因为可能只是没有搜索到结果
	} finally {
		loading.value = false
	}
}

const clearKeyword = () => {
	keyword.value = ''
	hasSearched.value = false
	resultList.value = []
}

const searchTag = (tag) => {
	keyword.value = tag
	handleSearch()
}
</script>

<style lang="scss" scoped>
.search-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.search-header {
	background-color: #fff;
	padding: 20rpx 30rpx;
	display: flex;
	align-items: center;
	gap: 20rpx;
	
	.search-input-wrap {
		flex: 1;
		background-color: #f5f5f5;
		border-radius: 50rpx;
		padding: 20rpx 30rpx;
		display: flex;
		align-items: center;
		gap: 16rpx;
		
		.search-input {
			flex: 1;
			font-size: 28rpx;
			color: #333;
		}
	}
	
	.search-btn {
		font-size: 30rpx;
		color: #07c160;
		font-weight: 500;
	}
}

.search-content {
	flex: 1;
	
	.hot-section {
		background-color: #fff;
		margin: 20rpx;
		border-radius: 16rpx;
		padding: 30rpx;
		
		.section-title {
			font-size: 30rpx;
			font-weight: 600;
			color: #333;
			margin-bottom: 24rpx;
		}
		
		.hot-tags {
			display: flex;
			flex-wrap: wrap;
			gap: 20rpx;
			
			.hot-tag {
				padding: 16rpx 32rpx;
				background-color: #f5f5f5;
				border-radius: 30rpx;
				font-size: 26rpx;
				color: #666;
			}
		}
	}
	
	.result-section {
		padding: 20rpx;
		
		.result-list {
			display: flex;
			flex-direction: column;
			gap: 20rpx;
			
			.result-card {
				background-color: #fff;
				border-radius: 16rpx;
				padding: 30rpx;
				
				.result-header {
					display: flex;
					justify-content: space-between;
					align-items: center;
					margin-bottom: 20rpx;
					
					.result-name {
						font-size: 32rpx;
						font-weight: 600;
						color: #333;
					}
					
					.result-type {
						padding: 8rpx 20rpx;
						border-radius: 20rpx;
						font-size: 24rpx;
						color: #fff;
					}
				}
				
				.result-body {
					.result-row {
						display: flex;
						margin-bottom: 12rpx;
						
						&:last-child {
							margin-bottom: 0;
						}
						
						.result-label {
							font-size: 26rpx;
							color: #999;
							flex-shrink: 0;
						}
						
						.result-value {
							font-size: 26rpx;
							color: #666;
							flex: 1;
						}
					}
				}
			}
		}
	}
	
	.bottom-placeholder {
		height: 120rpx;
	}
}
</style>
