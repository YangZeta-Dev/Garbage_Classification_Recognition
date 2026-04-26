<template>
	<view class="detail-container">
		<scroll-view class="detail-scroll" scroll-y>
			<!-- 文章头部 -->
			<view class="article-header">
				<text class="article-title">{{ article.title }}</text>
				<view class="article-meta">
					<view class="meta-item">
						<view class="category-tag">{{ article.categoryName || '分类知识' }}</view>
					</view>
					<view class="meta-item">
						<uv-icon name="eye" size="16" color="#999"></uv-icon>
						<text>{{ article.viewCount || 0 }}次阅读</text>
					</view>
					<view class="meta-item">
						<uv-icon name="clock" size="16" color="#999"></uv-icon>
						<text>{{ formatTime(article.createTime) }}</text>
					</view>
				</view>
			</view>
			
			<!-- 封面图 -->
			<image v-if="article.coverImage" class="cover-image" :src="article.coverImage" mode="widthFix"></image>
			
			<!-- 文章内容 -->
			<view class="article-content">
				<rich-text :nodes="article.content || '暂无内容'"></rich-text>
			</view>
		</scroll-view>
		
		<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getArticleDetail } from '@/api/system/article.js'

const article = ref({})
const loading = ref(false)

const formatTime = (time) => {
	if (!time) return ''
	const date = new Date(time)
	const year = date.getFullYear()
	const month = String(date.getMonth() + 1).padStart(2, '0')
	const day = String(date.getDate()).padStart(2, '0')
	return `${year}-${month}-${day}`
}

const loadData = async () => {
	const pages = getCurrentPages()
	const currentPage = pages[pages.length - 1]
	const articleId = currentPage.options.articleId
	
	if (!articleId) {
		uni.showToast({ title: '参数错误', icon: 'none' })
		return
	}
	
	loading.value = true
	try {
		const res = await getArticleDetail(articleId)
		if (res.code === 200) {
			article.value = res.data || {}
		}
	} catch (error) {
		console.error('获取文章详情失败:', error)
		uni.showToast({ title: '获取文章失败', icon: 'none' })
	} finally {
		loading.value = false
	}
}

onMounted(() => {
	loadData()
})
</script>

<style lang="scss" scoped>
.detail-container {
	min-height: 100vh;
	background-color: #fff;
}

.detail-scroll {
	height: 100vh;
}

.article-header {
	padding: 30rpx;
	
	.article-title {
		font-size: 40rpx;
		font-weight: 700;
		color: #333;
		line-height: 1.4;
		display: block;
		margin-bottom: 24rpx;
	}
	
	.article-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 24rpx;
		
		.meta-item {
			display: flex;
			align-items: center;
			gap: 8rpx;
			font-size: 24rpx;
			color: #999;
			
			.category-tag {
				background-color: rgba(7, 193, 96, 0.1);
				color: #07c160;
				padding: 6rpx 16rpx;
				border-radius: 8rpx;
			}
		}
	}
}

.cover-image {
	width: 100%;
}

.article-content {
	padding: 30rpx;
	font-size: 30rpx;
	color: #333;
	line-height: 1.8;
}
</style>
