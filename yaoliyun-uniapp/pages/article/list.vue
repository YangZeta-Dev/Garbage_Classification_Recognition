<template>
	<view class="article-container">
		<!-- 分类筛选 -->
		<scroll-view class="category-scroll" scroll-x>
			<view class="category-tabs">
				<view 
					class="category-tab" 
					:class="{ active: currentCategory === null }"
					@click="selectCategory(null)"
				>全部</view>
				<view 
					v-for="item in categoryList" 
					:key="item.categoryId" 
					class="category-tab"
					:class="{ active: currentCategory === item.categoryId }"
					@click="selectCategory(item.categoryId)"
				>{{ item.categoryName }}</view>
			</view>
		</scroll-view>
		
		<!-- 文章列表 -->
		<scroll-view class="article-scroll" scroll-y @scrolltolower="loadMore">
			<view v-if="articleList.length > 0" class="article-list">
				<view 
					v-for="item in articleList" 
					:key="item.articleId" 
					class="article-card"
					@click="toDetail(item)"
				>
					<image v-if="item.coverImage" class="article-image" :src="item.coverImage" mode="aspectFill"></image>
					<view v-else class="article-image article-placeholder">
						<uv-icon name="file-text" size="48" color="#ccc"></uv-icon>
					</view>
					<view class="article-info">
						<text class="article-title">{{ item.title }}</text>
						<view class="article-meta">
							<view class="meta-left">
								<view class="article-category">{{ item.categoryName || '分类知识' }}</view>
							</view>
							<view class="meta-right">
								<uv-icon name="eye" size="16" color="#999"></uv-icon>
								<text class="view-count">{{ item.viewCount || 0 }}</text>
							</view>
						</view>
					</view>
				</view>
			</view>
			
			<uv-empty v-if="!loading && articleList.length === 0" mode="list" text="暂无文章"></uv-empty>
			<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
			<view v-if="!loading && finished && articleList.length > 0" class="load-finished">
				<text>没有更多了</text>
			</view>
			
			<!-- 底部占位 -->
			<view class="bottom-placeholder"></view>
		</scroll-view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { listCategory } from '@/api/system/category.js'
import { listArticle } from '@/api/system/article.js'

const categoryList = ref([])
const articleList = ref([])
const currentCategory = ref(null)
const loading = ref(false)
const finished = ref(false)
const pageNum = ref(1)
const pageSize = ref(10)

// 加载分类列表
const loadCategoryList = async () => {
	try {
		const res = await listCategory({ status: '0' })
		if (res.code === 200) {
			categoryList.value = res.rows || []
		}
	} catch (error) {
		console.error('获取分类列表失败:', error)
	}
}

// 加载文章列表
const loadArticleList = async (isRefresh = false) => {
	if (loading.value) return
	if (!isRefresh && finished.value) return
	
	loading.value = true
	
	try {
		const params = {
			pageNum: pageNum.value,
			pageSize: pageSize.value,
			status: '0'
		}
		if (currentCategory.value) {
			params.categoryId = currentCategory.value
		}
		
		const res = await listArticle(params)
		if (res.code === 200) {
			const rows = res.rows || []
			if (isRefresh) {
				articleList.value = rows
			} else {
				articleList.value = [...articleList.value, ...rows]
			}
			finished.value = rows.length < pageSize.value
		}
	} catch (error) {
		console.error('获取文章列表失败:', error)
	} finally {
		loading.value = false
	}
}

// 选择分类
const selectCategory = (categoryId) => {
	currentCategory.value = categoryId
	pageNum.value = 1
	finished.value = false
	loadArticleList(true)
}

// 加载更多
const loadMore = () => {
	if (!finished.value && !loading.value) {
		pageNum.value++
		loadArticleList()
	}
}

// 跳转详情
const toDetail = (item) => {
	uni.navigateTo({
		url: '/pages/article/detail?articleId=' + item.articleId
	})
}

onMounted(() => {
	loadCategoryList()
	loadArticleList(true)
})
</script>

<style lang="scss" scoped>
.article-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.category-scroll {
	background-color: #fff;
	flex-shrink: 0;
	
	.category-tabs {
		display: flex;
		padding: 20rpx 30rpx;
		gap: 20rpx;
		
		.category-tab {
			padding: 16rpx 32rpx;
			border-radius: 30rpx;
			font-size: 26rpx;
			color: #666;
			background-color: #f5f5f5;
			white-space: nowrap;
			
			&.active {
				background-color: #07c160;
				color: #fff;
			}
		}
	}
}

.article-scroll {
	flex: 1;
	padding: 20rpx;
	box-sizing: border-box;
	.article-list {
		display: flex;
		flex-direction: column;
		gap: 20rpx;
		
		.article-card {
			background-color: #fff;
			border-radius: 16rpx;
			overflow: hidden;
			
			.article-image {
				width: 100%;
				height: 300rpx;
			}
			
			.article-placeholder {
				background-color: #f5f5f5;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.article-info {
				padding: 24rpx;
				
				.article-title {
					font-size: 30rpx;
					font-weight: 600;
					color: #333;
					display: -webkit-box;
					-webkit-line-clamp: 2;
					-webkit-box-orient: vertical;
					overflow: hidden;
					line-height: 1.4;
					margin-bottom: 16rpx;
				}
				
				.article-meta {
					display: flex;
					justify-content: space-between;
					align-items: center;
					
					.meta-left {
						.article-category {
							font-size: 24rpx;
							color: #07c160;
							background-color: rgba(7, 193, 96, 0.1);
							padding: 6rpx 16rpx;
							border-radius: 8rpx;
						}
					}
					
					.meta-right {
						display: flex;
						align-items: center;
						gap: 8rpx;
						
						.view-count {
							font-size: 24rpx;
							color: #999;
						}
					}
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
	
	.bottom-placeholder {
		height: 120rpx;
	}
}
</style>
