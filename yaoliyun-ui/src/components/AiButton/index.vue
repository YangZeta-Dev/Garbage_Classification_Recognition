<template>
  <div class="ai-button-container">
    <!-- 悬浮AI按钮 -->
    <el-tooltip content="AI智能助手 - 侧边抽屉" placement="left" effect="dark">
      <div
        class="ai-floating-button"
        @click="openAiChat"
        :class="{ 'pulse': showPulse }"
      >
        <i class="el-icon-cpu"></i>
        <span class="ai-badge" v-if="showBadge">抽屉</span>
      </div>
    </el-tooltip>
    
    <!-- AI聊天抽屉 -->
    <ai-chat
      v-model="showAiChat"
      @input="handleAiChatToggle"
      @opened="handleDrawerOpened"
      @closed="handleDrawerClosed"
    />
  </div>
</template>

<script>
import AiChat from '@/components/AiChat'

export default {
  name: 'AiButton',
  components: {
    AiChat
  },
  data() {
    return {
      showAiChat: false,
      showPulse: true,
      showBadge: true
    }
  },
  mounted() {
    // 5秒后停止脉冲动画
    setTimeout(() => {
      this.showPulse = false
    }, 5000)

    // 检查是否是首次使用
    const hasUsedAi = localStorage.getItem('hasUsedAi')
    if (hasUsedAi) {
      this.showBadge = false
    }

    // 组件挂载时清理可能的残留模态层
    this.clearModalLayers()
  },
  methods: {
    openAiChat() {
      // 先清理可能存在的模态层
      this.clearModalLayers()

      this.showAiChat = true
      this.showPulse = false

      // 标记已使用AI功能
      if (this.showBadge) {
        localStorage.setItem('hasUsedAi', 'true')
        this.showBadge = false
      }
    },

    clearModalLayers() {
      // 清理可能残留的模态层
      const modals = document.querySelectorAll('.v-modal')
      modals.forEach(modal => {
        modal.remove()
      })

      // 重置body状态
      document.body.style.overflow = ''
      document.body.classList.remove('el-popup-parent--hidden')

      // 清理可能的抽屉wrapper
      const wrappers = document.querySelectorAll('.el-drawer__wrapper')
      wrappers.forEach(wrapper => {
        if (wrapper.style.display === 'none' || !wrapper.querySelector('.ai-chat-drawer')) {
          wrapper.remove()
        }
      })
    },

    handleAiChatToggle(visible) {
      this.showAiChat = visible
    },

    handleDrawerOpened() {
      // 抽屉打开后的处理
      console.log('AI抽屉已打开')
    },

    handleDrawerClosed() {
      // 抽屉关闭后的处理
      this.$nextTick(() => {
        // 确保页面恢复正常状态
        document.body.style.overflow = ''
        document.body.classList.remove('el-popup-parent--hidden')

        // 移除所有模态层
        const modals = document.querySelectorAll('.v-modal')
        modals.forEach(modal => {
          modal.remove()
        })

        // 重置z-index
        const drawerElements = document.querySelectorAll('.el-drawer__wrapper')
        drawerElements.forEach(el => {
          if (!el.style.display || el.style.display === 'none') {
            el.remove()
          }
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.ai-button-container {
  position: fixed;
  bottom: 80px;
  right: 30px;
  z-index: 1000;
}

.ai-floating-button {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409EFF 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  cursor: pointer;
  box-shadow: 0 4px 20px rgba(64, 158, 255, 0.4);
  transition: all 0.3s ease;
  position: relative;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 25px rgba(64, 158, 255, 0.6);
  }
  
  &:active {
    transform: translateY(0);
  }
  
  // 脉冲动画
  &.pulse {
    animation: pulse 2s infinite;
  }
  
  // NEW标识
  .ai-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background-color: #f56c6c;
    color: white;
    font-size: 10px;
    padding: 2px 6px;
    border-radius: 10px;
    font-weight: bold;
    animation: bounce 1s infinite;
  }
}

@keyframes pulse {
  0% {
    box-shadow: 0 4px 20px rgba(64, 158, 255, 0.4);
  }
  50% {
          box-shadow: 0 4px 20px rgba(64, 158, 255, 0.8), 0 0 0 10px rgba(64, 158, 255, 0.1);
  }
  100% {
    box-shadow: 0 4px 20px rgba(64, 158, 255, 0.4);
  }
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-3px);
  }
  60% {
    transform: translateY(-1px);
  }
}

// 响应式设计
@media (max-width: 768px) {
  .ai-button-container {
    bottom: 60px;
    right: 20px;
  }
  
  .ai-floating-button {
    width: 50px;
    height: 50px;
    font-size: 20px;
  }
}
</style>
