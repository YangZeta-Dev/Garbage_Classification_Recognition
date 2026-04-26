<template>
	<view class="contacts-container">
		<!-- 搜索框 -->
		<view class="search-box">
			<view class="search-input-wrapper">
				<uv-icon name="search" size="20" color="#999"></uv-icon>
				<input 
					class="search-input" 
					v-model="searchKeyword" 
					placeholder="搜索用户" 
					placeholder-style="color: #ccc"
				/>
			</view>
		</view>
		
		<!-- 联系人列表 -->
		<scroll-view class="contacts-list" scroll-y>
			<view 
				v-for="contact in filteredContacts" 
				:key="contact.userId" 
				class="contact-item"
				@click="selectContact(contact)"
			>
				<view class="avatar">
					<image 
						v-if="contact.avatar" 
						:src="contact.avatar" 
						mode="aspectFill"
						class="avatar-image"
					></image>
					<uv-icon v-else name="account-fill" size="32" color="#fff"></uv-icon>
				</view>
				<view class="contact-info">
					<text class="contact-name">{{ contact.nickName || contact.userName }}</text>
					<text class="contact-desc">{{ contact.phonenumber || '暂无手机号' }}</text>
				</view>
			</view>
			
			<!-- 空状态 -->
			<view v-if="filteredContacts.length === 0" class="empty-state">
				<uv-icon name="account" size="80" color="#ddd"></uv-icon>
				<text class="empty-text">暂无联系人</text>
			</view>
		</scroll-view>
	</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import request from '@/utils/request.js'
import { showError } from '@/utils/index.js'

const contacts = ref([])
const searchKeyword = ref('')

// 过滤后的联系人列表
const filteredContacts = computed(() => {
	if (!searchKeyword.value) {
		return contacts.value
	}
	return contacts.value.filter(contact => {
		const name = contact.nickName || contact.userName || ''
		const phone = contact.phonenumber || ''
		return name.includes(searchKeyword.value) || phone.includes(searchKeyword.value)
	})
})

// 获取用户列表
const loadContacts = async () => {
	try {
		const res = await request({
			url: '/system/user/list',
			method: 'get'
		})
		
		if (res.code === 200) {
			contacts.value = res.rows || []
		} else {
			showError(res.msg || '获取用户列表失败')
		}
	} catch (error) {
		console.error('获取用户列表失败:', error)
		showError('获取用户列表失败')
	}
}

// 选择联系人
const selectContact = (contact) => {
	const avatar = contact.avatar || ''
	uni.navigateTo({
		url: `/pages/message/chat?contactId=${contact.userId}&contactName=${encodeURIComponent(contact.nickName || contact.userName)}&contactAvatar=${encodeURIComponent(avatar)}`
	})
}

onMounted(() => {
	loadContacts()
})
</script>

<style lang="scss" scoped>
.contacts-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	display: flex;
	flex-direction: column;
}

.search-box {
	background-color: #fff;
	padding: 20rpx 30rpx;
	border-bottom: 1rpx solid #f0f0f0;
	
	.search-input-wrapper {
		display: flex;
		align-items: center;
		background-color: #f5f5f5;
		border-radius: 50rpx;
		padding: 16rpx 30rpx;
		gap: 16rpx;
		
		.search-input {
			flex: 1;
			font-size: 28rpx;
			color: #333;
		}
	}
}

.contacts-list {
	flex: 1;
	background-color: #fff;
	
	.contact-item {
		display: flex;
		align-items: center;
		padding: 24rpx 30rpx;
		border-bottom: 1rpx solid #f0f0f0;
		transition: background-color 0.3s;
		
		&:active {
			background-color: #f8f8f8;
		}
		
		.avatar {
			width: 96rpx;
			height: 96rpx;
			border-radius: 16rpx;
			background: linear-gradient(135deg, #F5E27A 0%, #85C9E8 100%);
			display: flex;
			align-items: center;
			justify-content: center;
			margin-right: 24rpx;
			overflow: hidden;
			flex-shrink: 0;
			
			.avatar-image {
				width: 100%;
				height: 100%;
			}
		}
		
		.contact-info {
			flex: 1;
			display: flex;
			flex-direction: column;
			gap: 8rpx;
			
			.contact-name {
				font-size: 30rpx;
				font-weight: 600;
				color: #333;
			}
			
			.contact-desc {
				font-size: 26rpx;
				color: #999;
			}
		}
	}
	
	.empty-state {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		padding: 200rpx 0;
		
		.empty-text {
			margin-top: 30rpx;
			font-size: 28rpx;
			color: #999;
		}
	}
}
</style>

