<template>
	<uv-status-bar></uv-status-bar>
	<view class="index-container">
		<!-- 顶部导航栏 -->
		<view class="header">
			<view class="header-content">
				<view class="logo-section">
					<view class="logo">
						<uv-icon name="trash-fill" size="32" color="#07c160"></uv-icon>
					</view>
					<view class="app-info">
						<text class="app-name">垃圾分类助手</text>
						<text class="app-desc">让垃圾分类更简单</text>
					</view>
				</view>
				<!-- <view class="header-actions">
					<view class="action-btn" @click="toRecord">
						<uv-icon name="clock" size="24" color="#333"></uv-icon>
					</view>
				</view> -->
			</view>
		</view>
		
		<!-- 搜索框 -->
		<view class="search-section">
			<view class="search-box" @click="handleSearch">
				<uv-icon name="search" size="20" color="#999"></uv-icon>
				<text class="search-placeholder">搜索垃圾名称，如：电池、塑料瓶</text>
			</view>
		</view>
		
		<!-- 滚动内容区 -->
		<scroll-view class="content-scroll" scroll-y>
			<!-- 拍照识别入口 -->
			<view class="recognize-section">
				<view class="recognize-card" @click="toRecognize">
					<view class="recognize-icon">
						<uv-icon name="camera-fill" size="48" color="#fff"></uv-icon>
					</view>
					<view class="recognize-info">
						<text class="recognize-title">拍照识别</text>
						<text class="recognize-desc">拍一拍，快速识别垃圾分类</text>
					</view>
					<uv-icon name="arrow-right" size="24" color="#fff"></uv-icon>
				</view>
			</view>
			
			<!-- 四大分类 -->
			<view class="category-section">
				<view class="section-header">
					<text class="section-title">垃圾分类</text>
					<view class="more" @click="toCategory">
						<text class="more-text">查看全部</text>
						<uv-icon name="arrow-right" size="16" color="#999"></uv-icon>
					</view>
				</view>
				<view class="category-grid">
					<view 
						v-for="item in categoryList" 
						:key="item.categoryId" 
						class="category-item"
						:style="{ backgroundColor: item.colorCode + '15' }"
						@click="toCategoryDetail(item)"
					>
						<view class="category-icon" :style="{ backgroundColor: item.colorCode }">
							<uv-icon name="trash-fill" size="28" color="#fff"></uv-icon>
						</view>
						<text class="category-name">{{ item.categoryName }}</text>
						<text class="category-desc">{{ item.description }}</text>
					</view>
				</view>
			</view>
			
			<!-- 快捷功能 -->
			<view class="quick-menu">
				<view class="menu-title">常用功能</view>
				<view class="menu-grid">
					<view 
						v-for="menu in quickMenus" 
						:key="menu.id" 
						class="menu-item"
						@click="handleMenuClick(menu)"
					>
						<view class="menu-icon" :style="{ backgroundColor: menu.bgColor }">
							<uv-icon :name="menu.icon" size="28" color="#fff"></uv-icon>
						</view>
						<text class="menu-name">{{ menu.name }}</text>
					</view>
				</view>
			</view>
			
			<!-- 热门文章 -->
			<view class="article-section">
				<view class="section-header">
					<text class="section-title">知识学习</text>
					<view class="more" @click="toArticleList">
						<text class="more-text">更多</text>
						<uv-icon name="arrow-right" size="16" color="#999"></uv-icon>
					</view>
				</view>
				<view class="article-list">
					<view 
						v-for="article in articleList" 
						:key="article.articleId" 
						class="article-card"
						@click="toArticleDetail(article)"
					>
						<image v-if="article.coverImage" class="article-image" :src="article.coverImage" mode="aspectFill"></image>
						<view v-else class="article-image article-image-placeholder">
							<uv-icon name="file-text" size="32" color="#ccc"></uv-icon>
						</view>
						<view class="article-info">
							<text class="article-title">{{ article.title }}</text>
							<view class="article-meta">
								<text class="article-category">{{ article.categoryName || '分类知识' }}</text>
								<text class="article-views">{{ article.viewCount || 0 }}次阅读</text>
							</view>
						</view>
					</view>
				</view>
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

// 分类列表
const categoryList = ref([])

// 文章列表
const articleList = ref([])

// 快捷菜单
const quickMenus = ref([
	{ id: 1, name: '拍照识别', icon: 'camera', url: '/pages/garbage/recognize', bgColor: '#07c160' },
	{ id: 2, name: '垃圾搜索', icon: 'search', url: '/pages/garbage/search', bgColor: '#1989fa' },
	{ id: 3, name: '分类测验', icon: 'edit-pen', url: '/pages/quiz/index', bgColor: '#ff976a' },
	{ id: 4, name: '识别记录', icon: 'clock', url: '/pages/garbage/record', bgColor: '#7232dd' }
])

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
const loadArticleList = async () => {
	try {
		const res = await listArticle({ status: '0', pageNum: 1, pageSize: 3 })
		if (res.code === 200) {
			articleList.value = res.rows || []
		}
	} catch (error) {
		console.error('获取文章列表失败:', error)
	}
}

// 跳转识别记录
const toRecord = () => {
	uni.navigateTo({
		url: '/pages/garbage/record'
	})
}

// 跳转搜索页
const handleSearch = () => {
	uni.switchTab({
		url: '/pages/garbage/search'
	})
}

// 跳转拍照识别
const toRecognize = () => {
	uni.navigateTo({
		url: '/pages/garbage/recognize'
	})
}

// 跳转分类列表
const toCategory = () => {
	uni.navigateTo({
		url: '/pages/garbage/category'
	})
}

// 跳转分类详情
const toCategoryDetail = (item) => {
	uni.navigateTo({
		url: '/pages/garbage/category-detail?categoryId=' + item.categoryId
	})
}

// 菜单点击
const handleMenuClick = (menu) => {
	if (menu.url.includes('/pages/garbage/search')) {
		uni.switchTab({
			url: menu.url
		})
	} else {
		uni.navigateTo({
			url: menu.url
		})
	}
}

// 跳转文章列表
const toArticleList = () => {
	uni.switchTab({
		url: '/pages/article/list'
	})
}

// 跳转文章详情
const toArticleDetail = (article) => {
	uni.navigateTo({
		url: '/pages/article/detail?articleId=' + article.articleId
	})
}

onMounted(() => {
	loadCategoryList()
	loadArticleList()
})
</script>

<style lang="scss" scoped>
.index-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.header {
	background-color: #fff;
	padding: 20rpx 30rpx;
	border-bottom: 1rpx solid #f0f0f0;
	
	.header-content {
		display: flex;
		justify-content: space-between;
		align-items: center;
		
		.logo-section {
			display: flex;
			align-items: center;
			gap: 20rpx;
			
			.logo {
				width: 80rpx;
				height: 80rpx;
				background-color: rgba(7, 193, 96, 0.1);
				border-radius: 20rpx;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.app-info {
				display: flex;
				flex-direction: column;
				gap: 4rpx;
				
				.app-name {
					font-size: 36rpx;
					font-weight: 700;
					color: #333;
				}
				
				.app-desc {
					font-size: 24rpx;
					color: #666;
				}
			}
		}
		
		.header-actions {
			display: flex;
			gap: 20rpx;
			
			.action-btn {
				width: 72rpx;
				height: 72rpx;
				background-color: #f5f5f5;
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
			}
		}
	}
}

.search-section {
	padding: 20rpx 30rpx;
	background-color: #fff;
	
	.search-box {
		background-color: #f5f5f5;
		border-radius: 50rpx;
		padding: 24rpx 40rpx;
		display: flex;
		align-items: center;
		gap: 16rpx;
		
		.search-placeholder {
			font-size: 28rpx;
			color: #999;
		}
	}
}

.content-scroll {
	flex: 1;
	
	.recognize-section {
		padding: 30rpx;
		background-color: #fff;
		margin-bottom: 20rpx;
		
		.recognize-card {
			background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
			border-radius: 24rpx;
			padding: 40rpx;
			display: flex;
			align-items: center;
			gap: 30rpx;
			
			.recognize-icon {
				width: 100rpx;
				height: 100rpx;
				background-color: rgba(255, 255, 255, 0.2);
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.recognize-info {
				flex: 1;
				
				.recognize-title {
					font-size: 36rpx;
					font-weight: 700;
					color: #fff;
					display: block;
					margin-bottom: 8rpx;
				}
				
				.recognize-desc {
					font-size: 26rpx;
					color: rgba(255, 255, 255, 0.8);
				}
			}
		}
	}
	
	.category-section {
		background-color: #fff;
		padding: 30rpx;
		margin-bottom: 20rpx;
		
		.section-header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 30rpx;
			
			.section-title {
				font-size: 32rpx;
				font-weight: 700;
				color: #333;
			}
			
			.more {
				display: flex;
				align-items: center;
				gap: 8rpx;
				
				.more-text {
					font-size: 26rpx;
					color: #999;
				}
			}
		}
		
		.category-grid {
			display: grid;
			grid-template-columns: repeat(2, 1fr);
			gap: 20rpx;
			
			.category-item {
				padding: 30rpx;
				border-radius: 16rpx;
				display: flex;
				flex-direction: column;
				align-items: flex-start;
				gap: 12rpx;
				
				.category-icon {
					width: 64rpx;
					height: 64rpx;
					border-radius: 16rpx;
					display: flex;
					align-items: center;
					justify-content: center;
				}
				
				.category-name {
					font-size: 30rpx;
					font-weight: 600;
					color: #333;
				}
				
				.category-desc {
					font-size: 24rpx;
					color: #666;
					display: -webkit-box;
					-webkit-line-clamp: 1;
					-webkit-box-orient: vertical;
					overflow: hidden;
				}
			}
		}
	}
	
	.quick-menu {
		background-color: #fff;
		padding: 30rpx;
		margin-bottom: 20rpx;
		
		.menu-title {
			font-size: 32rpx;
			font-weight: 700;
			color: #333;
			margin-bottom: 30rpx;
		}
		
		.menu-grid {
			display: grid;
			grid-template-columns: repeat(4, 1fr);
			gap: 30rpx;
			
			.menu-item {
				display: flex;
				flex-direction: column;
				align-items: center;
				gap: 16rpx;
				
				.menu-icon {
					width: 96rpx;
					height: 96rpx;
					border-radius: 24rpx;
					display: flex;
					align-items: center;
					justify-content: center;
				}
				
				.menu-name {
					font-size: 24rpx;
					color: #666;
					text-align: center;
				}
			}
		}
	}
	
	.article-section {
		background-color: #fff;
		padding: 30rpx;
		margin-bottom: 20rpx;
		
		.section-header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 30rpx;
			
			.section-title {
				font-size: 32rpx;
				font-weight: 700;
				color: #333;
			}
			
			.more {
				display: flex;
				align-items: center;
				gap: 8rpx;
				
				.more-text {
					font-size: 26rpx;
					color: #999;
				}
			}
		}
		
		.article-list {
			display: flex;
			flex-direction: column;
			gap: 24rpx;
			
			.article-card {
				display: flex;
				gap: 20rpx;
				
				.article-image {
					width: 200rpx;
					height: 140rpx;
					border-radius: 12rpx;
					flex-shrink: 0;
				}
				
				.article-image-placeholder {
					background-color: #f5f5f5;
					display: flex;
					align-items: center;
					justify-content: center;
				}
				
				.article-info {
					flex: 1;
					display: flex;
					flex-direction: column;
					justify-content: space-between;
					
					.article-title {
						font-size: 28rpx;
						font-weight: 600;
						color: #333;
						display: -webkit-box;
						-webkit-line-clamp: 2;
						-webkit-box-orient: vertical;
						overflow: hidden;
						line-height: 1.4;
					}
					
					.article-meta {
						display: flex;
						align-items: center;
						gap: 20rpx;
						
						.article-category {
							font-size: 24rpx;
							color: #07c160;
							background-color: rgba(7, 193, 96, 0.1);
							padding: 4rpx 12rpx;
							border-radius: 6rpx;
						}
						
						.article-views {
							font-size: 24rpx;
							color: #999;
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
