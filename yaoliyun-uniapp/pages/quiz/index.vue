<template>
	<view class="quiz-container">
		<!-- 进度条 -->
		<view class="progress-section">
			<view class="progress-bar">
				<view class="progress-fill" :style="{ width: progressWidth }"></view>
			</view>
			<text class="progress-text">{{ currentIndex + 1 }}/{{ questionList.length }}</text>
		</view>
		
		<!-- 题目区域 -->
		<view v-if="currentQuestion" class="question-section">
			<view class="question-header">
				<view class="question-tag">第{{ currentIndex + 1 }}题</view>
				<view class="question-points">{{ currentQuestion.pointsValue || 10 }}分</view>
			</view>
			<text class="question-content">{{ currentQuestion.questionContent }}</text>
			
			<!-- 选项列表 -->
			<view class="options-list">
				<view 
					v-for="(option, key) in options" 
					:key="key" 
					class="option-item"
					:class="getOptionClass(key)"
					@click="selectOption(key)"
				>
					<view class="option-key">{{ key }}</view>
					<text class="option-text">{{ option }}</text>
					<uv-icon v-if="showResult && key === currentQuestion.correctAnswer" name="checkmark-circle-fill" size="24" color="#07c160"></uv-icon>
					<uv-icon v-if="showResult && selectedAnswer === key && key !== currentQuestion.correctAnswer" name="close-circle-fill" size="24" color="#ff4d4f"></uv-icon>
				</view>
			</view>
			
			<!-- 答案解析 -->
			<view v-if="showResult" class="explanation-section">
				<view class="explanation-header">
					<uv-icon name="info-circle" size="20" color="#1989fa"></uv-icon>
					<text>答案解析</text>
				</view>
				<text class="explanation-content">{{ currentQuestion.explanation || '暂无解析' }}</text>
			</view>
		</view>
		
		<!-- 操作按钮 -->
		<view class="action-section">
			<view v-if="!showResult" class="action-btn confirm-btn" :class="{ disabled: !selectedAnswer }" @click="confirmAnswer">
				确认答案
			</view>
			<view v-else class="action-btn next-btn" @click="nextQuestion">
				{{ isLastQuestion ? '查看结果' : '下一题' }}
			</view>
		</view>
		
		<!-- 空状态 -->
		<uv-empty v-if="!loading && questionList.length === 0" mode="data" text="暂无题目"></uv-empty>
		<uv-loading-icon v-if="loading" size="32"></uv-loading-icon>
	</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { listQuestion } from '@/api/system/question.js'

const questionList = ref([])
const currentIndex = ref(0)
const selectedAnswer = ref('')
const showResult = ref(false)
const loading = ref(false)
const score = ref(0)
const correctCount = ref(0)

// 当前题目
const currentQuestion = computed(() => questionList.value[currentIndex.value] || null)

// 进度百分比
const progressWidth = computed(() => {
	if (questionList.value.length === 0) return '0%'
	return ((currentIndex.value + 1) / questionList.value.length * 100) + '%'
})

// 是否最后一题
const isLastQuestion = computed(() => currentIndex.value >= questionList.value.length - 1)

// 选项
const options = computed(() => {
	if (!currentQuestion.value) return {}
	return {
		A: currentQuestion.value.optionA,
		B: currentQuestion.value.optionB,
		C: currentQuestion.value.optionC,
		D: currentQuestion.value.optionD
	}
})

// 获取选项样式类
const getOptionClass = (key) => {
	if (!showResult.value) {
		return selectedAnswer.value === key ? 'selected' : ''
	}
	if (key === currentQuestion.value.correctAnswer) {
		return 'correct'
	}
	if (selectedAnswer.value === key && key !== currentQuestion.value.correctAnswer) {
		return 'wrong'
	}
	return ''
}

// 选择答案
const selectOption = (key) => {
	if (showResult.value) return
	selectedAnswer.value = key
}

// 确认答案
const confirmAnswer = () => {
	if (!selectedAnswer.value) {
		uni.showToast({ title: '请选择答案', icon: 'none' })
		return
	}
	
	showResult.value = true
	
	if (selectedAnswer.value === currentQuestion.value.correctAnswer) {
		correctCount.value++
		score.value += currentQuestion.value.pointsValue || 10
	}
}

// 下一题
const nextQuestion = () => {
	if (isLastQuestion.value) {
		// 跳转结果页
		uni.navigateTo({
			url: `/pages/quiz/result?score=${score.value}&total=${questionList.value.length}&correct=${correctCount.value}`
		})
		return
	}
	
	currentIndex.value++
	selectedAnswer.value = ''
	showResult.value = false
}

// 加载题目
const loadData = async () => {
	loading.value = true
	try {
		const res = await listQuestion({ status: '0', pageNum: 1, pageSize: 10 })
		if (res.code === 200) {
			questionList.value = res.rows || []
		}
	} catch (error) {
		console.error('获取题目失败:', error)
		uni.showToast({ title: '获取题目失败', icon: 'none' })
	} finally {
		loading.value = false
	}
}

onMounted(() => {
	loadData()
})
</script>

<style lang="scss" scoped>
.quiz-container {
	min-height: 100vh;
	background-color: #f5f5f5;
	padding: 30rpx;
}

.progress-section {
	display: flex;
	align-items: center;
	gap: 20rpx;
	margin-bottom: 30rpx;
	
	.progress-bar {
		flex: 1;
		height: 12rpx;
		background-color: #e0e0e0;
		border-radius: 6rpx;
		overflow: hidden;
		
		.progress-fill {
			height: 100%;
			background-color: #07c160;
			border-radius: 6rpx;
			transition: width 0.3s ease;
		}
	}
	
	.progress-text {
		font-size: 26rpx;
		color: #666;
		flex-shrink: 0;
	}
}

.question-section {
	background-color: #fff;
	border-radius: 24rpx;
	padding: 30rpx;
	margin-bottom: 30rpx;
	
	.question-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 24rpx;
		
		.question-tag {
			font-size: 24rpx;
			color: #07c160;
			background-color: rgba(7, 193, 96, 0.1);
			padding: 8rpx 20rpx;
			border-radius: 20rpx;
		}
		
		.question-points {
			font-size: 26rpx;
			color: #ff976a;
			font-weight: 600;
		}
	}
	
	.question-content {
		font-size: 32rpx;
		color: #333;
		line-height: 1.6;
		margin-bottom: 40rpx;
	}
	
	.options-list {
		display: flex;
		flex-direction: column;
		gap: 20rpx;
		
		.option-item {
			display: flex;
			align-items: center;
			gap: 20rpx;
			padding: 24rpx;
			background-color: #f8f8f8;
			border-radius: 16rpx;
			border: 2rpx solid transparent;
			
			&.selected {
				border-color: #07c160;
				background-color: rgba(7, 193, 96, 0.05);
			}
			
			&.correct {
				border-color: #07c160;
				background-color: rgba(7, 193, 96, 0.1);
			}
			
			&.wrong {
				border-color: #ff4d4f;
				background-color: rgba(255, 77, 79, 0.1);
			}
			
			.option-key {
				width: 48rpx;
				height: 48rpx;
				border-radius: 50%;
				background-color: #e0e0e0;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 24rpx;
				font-weight: 600;
				color: #666;
				flex-shrink: 0;
			}
			
			.option-text {
				flex: 1;
				font-size: 28rpx;
				color: #333;
			}
		}
	}
	
	.explanation-section {
		margin-top: 30rpx;
		padding: 24rpx;
		background-color: rgba(25, 137, 250, 0.1);
		border-radius: 12rpx;
		
		.explanation-header {
			display: flex;
			align-items: center;
			gap: 8rpx;
			margin-bottom: 12rpx;
			
			text {
				font-size: 26rpx;
				color: #1989fa;
				font-weight: 500;
			}
		}
		
		.explanation-content {
			font-size: 26rpx;
			color: #666;
			line-height: 1.6;
		}
	}
}

.action-section {
	.action-btn {
		height: 96rpx;
		border-radius: 48rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 32rpx;
		font-weight: 500;
	}
	
	.confirm-btn {
		background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
		color: #fff;
		
		&.disabled {
			opacity: 0.5;
		}
	}
	
	.next-btn {
		background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
		color: #fff;
	}
}
</style>
