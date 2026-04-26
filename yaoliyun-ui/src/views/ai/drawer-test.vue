<template>
  <div class="drawer-test-container">
    <div class="test-header">
      <h1>AI抽屉功能测试</h1>
      <p>测试不同屏幕尺寸下的抽屉表现</p>
    </div>
    
    <div class="test-content">
      <el-row :gutter="20">
        <el-col :span="8">
          <el-card class="test-card">
            <div slot="header">
              <span>桌面端测试</span>
            </div>
            <div class="test-info">
              <p><strong>屏幕宽度:</strong> > 1024px</p>
              <p><strong>抽屉尺寸:</strong> 400px 固定宽度</p>
              <p><strong>特点:</strong> 侧边固定宽度，不影响主内容</p>
            </div>
            <el-button type="primary" @click="openAiChat" block>
              测试桌面端抽屉
            </el-button>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card class="test-card">
            <div slot="header">
              <span>平板端测试</span>
            </div>
            <div class="test-info">
              <p><strong>屏幕宽度:</strong> 768px - 1024px</p>
              <p><strong>抽屉尺寸:</strong> 50% 屏幕宽度</p>
              <p><strong>特点:</strong> 半屏显示，平衡内容和聊天</p>
            </div>
            <el-button type="success" @click="simulateTablet" block>
              模拟平板端
            </el-button>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card class="test-card">
            <div slot="header">
              <span>移动端测试</span>
            </div>
            <div class="test-info">
              <p><strong>屏幕宽度:</strong> ≤ 768px</p>
              <p><strong>抽屉尺寸:</strong> 100% 全屏</p>
              <p><strong>特点:</strong> 全屏体验，专注聊天</p>
            </div>
            <el-button type="warning" @click="simulateMobile" block>
              模拟移动端
            </el-button>
          </el-card>
        </el-col>
      </el-row>
      
      <!-- 当前屏幕信息 -->
      <el-card class="screen-info-card">
        <div slot="header">
          <span>当前屏幕信息</span>
        </div>
        <el-row :gutter="20">
          <el-col :span="6">
            <div class="info-item">
              <div class="info-label">屏幕宽度</div>
              <div class="info-value">{{ screenWidth }}px</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="info-item">
              <div class="info-label">屏幕高度</div>
              <div class="info-value">{{ screenHeight }}px</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="info-item">
              <div class="info-label">设备类型</div>
              <div class="info-value">{{ deviceType }}</div>
            </div>
          </el-col>
          <el-col :span="6">
            <div class="info-item">
              <div class="info-label">抽屉尺寸</div>
              <div class="info-value">{{ drawerSize }}</div>
            </div>
          </el-col>
        </el-row>
      </el-card>
      
      <!-- 功能特性说明 -->
      <el-card class="features-card">
        <div slot="header">
          <span>抽屉功能特性</span>
        </div>
        <el-row :gutter="20">
          <el-col :span="12">
            <h4>响应式设计</h4>
            <ul>
              <li>桌面端：固定宽度，不遮挡主内容</li>
              <li>平板端：半屏显示，平衡体验</li>
              <li>移动端：全屏显示，专注聊天</li>
            </ul>
          </el-col>
          <el-col :span="12">
            <h4>交互优化</h4>
            <ul>
              <li>点击遮罩层关闭抽屉</li>
              <li>ESC键快速关闭</li>
              <li>流畅的滑入滑出动画</li>
              <li>防止iOS输入框缩放</li>
            </ul>
          </el-col>
        </el-row>
      </el-card>
    </div>
    
    <!-- AI聊天抽屉 -->
    <ai-chat v-model="showAiChat" />
  </div>
</template>

<script>
import AiChat from '@/components/AiChat'

export default {
  name: 'DrawerTest',
  components: {
    AiChat
  },
  data() {
    return {
      showAiChat: false,
      screenWidth: window.innerWidth,
      screenHeight: window.innerHeight
    }
  },
  computed: {
    deviceType() {
      if (this.screenWidth <= 768) {
        return '移动端'
      } else if (this.screenWidth <= 1024) {
        return '平板端'
      } else {
        return '桌面端'
      }
    },
    drawerSize() {
      if (this.screenWidth <= 768) {
        return '100%'
      } else if (this.screenWidth <= 1024) {
        return '50%'
      } else {
        return '400px'
      }
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  },
  methods: {
    openAiChat() {
      this.showAiChat = true
    },
    
    simulateTablet() {
      this.$message.info('请调整浏览器窗口到 768px-1024px 宽度范围，然后打开抽屉查看效果')
      this.showAiChat = true
    },
    
    simulateMobile() {
      this.$message.info('请调整浏览器窗口到 768px 以下宽度，然后打开抽屉查看效果')
      this.showAiChat = true
    },
    
    handleResize() {
      this.screenWidth = window.innerWidth
      this.screenHeight = window.innerHeight
    }
  }
}
</script>

<style lang="scss" scoped>
.drawer-test-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.test-header {
  text-align: center;
  margin-bottom: 30px;
  
  h1 {
    color: #303133;
    margin-bottom: 10px;
  }
  
  p {
    color: #606266;
    font-size: 16px;
  }
}

.test-content {
  .el-card {
    margin-bottom: 20px;
  }
}

.test-card {
  height: 280px;
  
  .test-info {
    margin-bottom: 20px;
    
    p {
      margin: 8px 0;
      font-size: 14px;
      
      strong {
        color: #409eff;
      }
    }
  }
}

.screen-info-card {
  .info-item {
    text-align: center;
    padding: 10px;
    
    .info-label {
      font-size: 12px;
      color: #909399;
      margin-bottom: 5px;
    }
    
    .info-value {
      font-size: 18px;
      font-weight: bold;
      color: #409eff;
    }
  }
}

.features-card {
  h4 {
    color: #303133;
    margin-bottom: 10px;
  }
  
  ul {
    padding-left: 20px;
    
    li {
      margin: 5px 0;
      color: #606266;
      font-size: 14px;
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .drawer-test-container {
    padding: 10px;
  }
  
  .test-content {
    .el-col {
      margin-bottom: 20px;
    }
  }
  
  .test-card {
    height: auto;
  }
}
</style>
