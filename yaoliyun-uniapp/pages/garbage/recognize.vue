<template>
	<view class="recognize-container">
		<!-- 图片预览区 -->
		<view class="preview-section">
			<image v-if="imageUrl" class="preview-image" :src="imageUrl" mode="aspectFit"></image>
			<view v-else class="preview-placeholder">
				<uv-icon name="camera" size="64" color="#ccc"></uv-icon>
				<text class="placeholder-text">点击下方按钮拍照或选择图片</text>
			</view>
		</view>
		
		<!-- 操作按钮 -->
		<view class="action-section">
			<view class="action-btn camera-btn" @click="takePhoto">
				<uv-icon name="camera-fill" size="32" color="#fff"></uv-icon>
				<text class="btn-text">拍照识别</text>
			</view>
			<view class="action-btn album-btn" @click="chooseImage">
				<uv-icon name="photo-fill" size="32" color="#07c160"></uv-icon>
				<text class="btn-text">相册选择</text>
			</view>
		</view>
		
		<!-- 识别中状态 -->
		<view v-if="loading" class="loading-mask">
			<view class="loading-content">
				<uv-loading-icon size="48" color="#07c160"></uv-loading-icon>
				<text class="loading-text">正在识别中...</text>
			</view>
		</view>
		
		<!-- 使用提示 -->
		<view class="tips-section">
			<view class="tips-title">
				<uv-icon name="info-circle" size="20" color="#999"></uv-icon>
				<text>使用提示</text>
			</view>
			<view class="tips-list">
				<text class="tip-item">1. 请确保图片清晰，物品完整显示</text>
				<text class="tip-item">2. 尽量在光线充足的环境下拍摄</text>
				<text class="tip-item">3. 每次只识别一种垃圾效果更佳</text>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue'
import { recognizeGarbage } from '@/api/system/recognition.js'

const imageUrl = ref('')
const loading = ref(false)

// 拍照
const takePhoto = () => {
	uni.chooseImage({
		count: 1,
		sourceType: ['camera'],
		success: (res) => {
			imageUrl.value = res.tempFilePaths[0]
			recognizeImage(res.tempFilePaths[0])
		},
		fail: (err) => {
			console.error('拍照失败:', err)
		}
	})
}

// 选择图片
const chooseImage = () => {
	uni.chooseImage({
		count: 1,
		sourceType: ['album'],
		success: (res) => {
			imageUrl.value = res.tempFilePaths[0]
			recognizeImage(res.tempFilePaths[0])
		},
		fail: (err) => {
			console.error('选择图片失败:', err)
		}
	})
}

// 识别图片
const recognizeImage = async (filePath) => {
	loading.value = true
	
	try {
		// 读取图片转base64
		const base64 = await fileToBase64(filePath)
		
		const res = await recognizeGarbage({
			img: base64,
			mode: 0
		})
		console.log(res.data)
		if (res.code === 200 && res.data) {
			// 跳转结果页
			uni.navigateTo({
				url: '/pages/garbage/result?data=' + encodeURIComponent(JSON.stringify(res.data))
			})
		} else {
			uni.showToast({ title: res.msg || '识别失败', icon: 'none' })
		}
	} catch (error) {
		console.error('识别失败:', error)
		uni.showToast({ title: '识别失败，请重试', icon: 'none' })
	} finally {
		loading.value = false
	}
}

// 文件转base64
const fileToBase64 = (filePath) => {
	return new Promise((resolve, reject) => {
		// #ifdef MP-WEIXIN
		uni.getFileSystemManager().readFile({
			filePath: filePath,
			encoding: 'base64',
			success: (res) => {
				resolve(res.data)
			},
			fail: (err) => {
				reject(err)
			}
		})
		// #endif
		
		// #ifdef H5
		uni.request({
			url: filePath,
			responseType: 'arraybuffer',
			success: (res) => {
				const base64 = uni.arrayBufferToBase64(res.data)
				resolve(base64)
			},
			fail: (err) => {
				reject(err)
			}
		})
		// #endif
		
		// #ifdef APP-PLUS
		plus.io.resolveLocalFileSystemURL(filePath, (entry) => {
			entry.file((file) => {
				const reader = new plus.io.FileReader()
				reader.onloadend = (e) => {
					const base64 = e.target.result.split(',')[1]
					resolve(base64)
				}
				reader.readAsDataURL(file)
			})
		}, (err) => {
			reject(err)
		})
		// #endif
	})
}
</script>

<style lang="scss" scoped>
.recognize-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding: 30rpx;
}

.preview-section {
	background-color: #fff;
	border-radius: 24rpx;
	overflow: hidden;
	margin-bottom: 30rpx;
	
	.preview-image {
		width: 100%;
		height: 500rpx;
	}
	
	.preview-placeholder {
		height: 500rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 20rpx;
		background-color: #fafafa;
		
		.placeholder-text {
			font-size: 28rpx;
			color: #999;
		}
	}
}

.action-section {
	display: flex;
	gap: 30rpx;
	margin-bottom: 40rpx;
	
	.action-btn {
		flex: 1;
		height: 120rpx;
		border-radius: 16rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 16rpx;
		
		.btn-text {
			font-size: 30rpx;
			font-weight: 500;
		}
	}
	
	.camera-btn {
		background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
		
		.btn-text {
			color: #fff;
		}
	}
	
	.album-btn {
		background-color: #fff;
		border: 2rpx solid #07c160;
		
		.btn-text {
			color: #07c160;
		}
	}
}

.loading-mask {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.5);
	display: flex;
	align-items: center;
	justify-content: center;
	z-index: 999;
	
	.loading-content {
		background-color: #fff;
		border-radius: 16rpx;
		padding: 60rpx 80rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 24rpx;
		
		.loading-text {
			font-size: 28rpx;
			color: #333;
		}
	}
}

.tips-section {
	background-color: #fff;
	border-radius: 16rpx;
	padding: 30rpx;
	
	.tips-title {
		display: flex;
		align-items: center;
		gap: 12rpx;
		margin-bottom: 20rpx;
		
		text {
			font-size: 28rpx;
			color: #999;
		}
	}
	
	.tips-list {
		display: flex;
		flex-direction: column;
		gap: 12rpx;
		
		.tip-item {
			font-size: 26rpx;
			color: #666;
			line-height: 1.5;
		}
	}
}
</style>
