<template>
	<view class="about-container">
	
		<!-- 内容区 -->
		<scroll-view class="content-scroll" scroll-y>
			<!-- Logo区域 -->
			<view class="logo-section">
				<view class="logo">
					<image src="/static/images/logo.png" mode="aspectFit" class="logo-image"></image>
				</view>
				<text class="app-name">智能垃圾分类</text>
				<text class="app-slogan">环保从分类开始，让地球更美好</text>
				<text class="version">版本 v1.0.0</text>
			</view>
			
			<!-- 应用介绍 -->
			<view class="section">
				<view class="section-title">应用介绍</view>
				<view class="section-content">
					<text class="intro-text">智能垃圾分类是一款基于AI图像识别技术的环保应用，致力于帮助用户快速、准确地进行垃圾分类。通过拍照或上传图片，即可智能识别垃圾类别，获取正确的分类指导，共同保护我们的地球家园。</text>
				</view>
			</view>
			
			<!-- 核心功能 -->
			<view class="section">
				<view class="section-title">核心功能</view>
				<view class="feature-list">
					<view class="feature-item">
						<view class="feature-icon">
							<uv-icon name="checkmark-circle-fill" size="20" color="#4CAF50"></uv-icon>
						</view>
						<text class="feature-text">AI图像识别 - 拍照即可识别垃圾类别</text>
					</view>
					<view class="feature-item">
						<view class="feature-icon">
							<uv-icon name="checkmark-circle-fill" size="20" color="#4CAF50"></uv-icon>
						</view>
						<text class="feature-text">名称查询 - 输入名称快速查询分类</text>
					</view>
					<view class="feature-item">
						<view class="feature-icon">
							<uv-icon name="checkmark-circle-fill" size="20" color="#4CAF50"></uv-icon>
						</view>
						<text class="feature-text">分类指南 - 详细的垃圾分类知识</text>
					</view>
					<view class="feature-item">
						<view class="feature-icon">
							<uv-icon name="checkmark-circle-fill" size="20" color="#4CAF50"></uv-icon>
						</view>
						<text class="feature-text">识别记录 - 查看历史识别记录</text>
					</view>
				</view>
			</view>
			
			<!-- 垃圾分类说明 -->
			<view class="section">
				<view class="section-title">垃圾分类</view>
				<view class="garbage-types">
					<view class="garbage-type-item recyclable">
						<view class="type-icon">♻️</view>
						<text class="type-name">可回收物</text>
					</view>
					<view class="garbage-type-item hazardous">
						<view class="type-icon">☢️</view>
						<text class="type-name">有害垃圾</text>
					</view>
					<view class="garbage-type-item kitchen">
						<view class="type-icon">🍽️</view>
						<text class="type-name">厨余垃圾</text>
					</view>
					<view class="garbage-type-item other">
						<view class="type-icon">🗑️</view>
						<text class="type-name">其他垃圾</text>
					</view>
				</view>
			</view>
			
			<!-- 联系我们 -->
			<view class="section">
				<view class="section-title">联系我们</view>
				<view class="contact-list">
					<view class="contact-item">
						<view class="contact-label">
							<uv-icon name="email" size="20" color="#4CAF50"></uv-icon>
							<text class="label-text">邮箱</text>
						</view>
						<text class="contact-value">support@garbage-classify.com</text>
					</view>
					<view class="contact-item">
						<view class="contact-label">
							<uv-icon name="phone" size="20" color="#4CAF50"></uv-icon>
							<text class="label-text">电话</text>
						</view>
						<text class="contact-value">400-888-8888</text>
					</view>
					<view class="contact-item">
						<view class="contact-label">
							<uv-icon name="map" size="20" color="#4CAF50"></uv-icon>
							<text class="label-text">地址</text>
						</view>
						<text class="contact-value">中国·深圳</text>
					</view>
				</view>
			</view>
			
			<!-- 法律信息 -->
			<view class="section">
				<view class="legal-links">
					<text class="link-text" @click="handlePrivacy">隐私政策</text>
					<text class="divider">|</text>
					<text class="link-text" @click="handleTerms">用户协议</text>
				</view>
			</view>
			
			<!-- 版权信息 -->
			<view class="copyright">
				<text class="copyright-text">🌿 保护环境，从我做起</text>
				<text class="copyright-text">© 2024 智能垃圾分类</text>
			</view>
			
			<!-- 底部占位 -->
			<view class="bottom-placeholder"></view>
		</scroll-view>
	</view>
</template>

<script setup>
// 返回
const goBack = () => {
	uni.navigateBack()
}

// 隐私政策
const handlePrivacy = () => {
	uni.showToast({
		title: '隐私政策开发中',
		icon: 'none'
	})
}

// 用户协议
const handleTerms = () => {
	uni.showToast({
		title: '用户协议开发中',
		icon: 'none'
	})
}
</script>

<style lang="scss" scoped>
.about-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.custom-navbar {
	background-color: #fff;
	padding: 20rpx 30rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1rpx solid #f0f0f0;
	
	.navbar-left,
	.navbar-right {
		width: 120rpx;
	}
	
	.navbar-left {
		display: flex;
		align-items: center;
	}
	
	.navbar-title {
		flex: 1;
		text-align: center;
		font-size: 32rpx;
		font-weight: 600;
		color: #333;
	}
}

.content-scroll {
	flex: 1;
}

.logo-section {
	background: linear-gradient(135deg, #4CAF50 0%, #8BC34A 100%);
	padding: 80rpx 30rpx 60rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-bottom: 20rpx;
	
	.logo {
		width: 160rpx;
		height: 160rpx;
		background-color: rgba(255, 255, 255, 0.2);
		border-radius: 40rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-bottom: 30rpx;
		border: 4rpx solid rgba(255, 255, 255, 0.3);
		
		.logo-image {
			width: 120rpx;
			height: 120rpx;
		}
	}
	
	.app-name {
		font-size: 44rpx;
		font-weight: 700;
		color: #fff;
		margin-bottom: 16rpx;
	}
	
	.app-slogan {
		font-size: 26rpx;
		color: rgba(255, 255, 255, 0.9);
		margin-bottom: 20rpx;
	}
	
	.version {
		font-size: 24rpx;
		color: #fff;
		padding: 8rpx 24rpx;
		background-color: rgba(255, 255, 255, 0.2);
		border-radius: 20rpx;
	}
}

.section {
	background-color: #fff;
	margin-bottom: 20rpx;
	padding: 30rpx;
	
	.section-title {
		font-size: 32rpx;
		font-weight: 600;
		color: #333;
		margin-bottom: 24rpx;
	}
	
	.section-content {
		.intro-text {
			font-size: 28rpx;
			color: #666;
			line-height: 1.8;
		}
	}
	
	.feature-list {
		display: flex;
		flex-direction: column;
		gap: 20rpx;
		
		.feature-item {
			display: flex;
			align-items: center;
			gap: 16rpx;
			
			.feature-icon {
				flex-shrink: 0;
			}
			
			.feature-text {
				font-size: 28rpx;
				color: #666;
			}
		}
	}
	
	.contact-list {
		display: flex;
		flex-direction: column;
		gap: 24rpx;
		
		.contact-item {
			display: flex;
			justify-content: space-between;
			align-items: center;
			
			.contact-label {
				display: flex;
				align-items: center;
				gap: 12rpx;
				
				.label-text {
					font-size: 28rpx;
					color: #666;
				}
			}
			
			.contact-value {
				font-size: 28rpx;
				color: #333;
				font-weight: 500;
			}
		}
	}
	
	.legal-links {
		display: flex;
		justify-content: center;
		align-items: center;
		gap: 20rpx;
		
		.link-text {
			font-size: 28rpx;
			color: #4CAF50;
			
			&:active {
				opacity: 0.7;
			}
		}
		
		.divider {
			font-size: 28rpx;
			color: #ddd;
		}
	}
	
	.garbage-types {
		display: flex;
		flex-wrap: wrap;
		gap: 20rpx;
		
		.garbage-type-item {
			width: calc(50% - 10rpx);
			padding: 24rpx;
			border-radius: 16rpx;
			display: flex;
			align-items: center;
			gap: 16rpx;
			
			.type-icon {
				font-size: 40rpx;
			}
			
			.type-name {
				font-size: 28rpx;
				font-weight: 500;
			}
			
			&.recyclable {
				background-color: #E3F2FD;
				.type-name { color: #1976D2; }
			}
			
			&.hazardous {
				background-color: #FFEBEE;
				.type-name { color: #D32F2F; }
			}
			
			&.kitchen {
				background-color: #E8F5E9;
				.type-name { color: #388E3C; }
			}
			
			&.other {
				background-color: #FFF3E0;
				.type-name { color: #F57C00; }
			}
		}
	}
}

.copyright {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 8rpx;
	padding: 40rpx 30rpx;
	
	.copyright-text {
		font-size: 24rpx;
		color: #999;
	}
}

.bottom-placeholder {
	height: 40rpx;
}
</style>

