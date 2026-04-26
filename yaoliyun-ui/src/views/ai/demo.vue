<template>
  <div class="ai-demo-container">
    <div class="demo-header">
      <h1>AI智能助手演示</h1>
      <p>体验AI聊天功能的各种特性</p>
    </div>
    
    <div class="demo-content">
      <el-row :gutter="20">
        <!-- 功能介绍 -->
        <el-col :span="12">
          <el-card class="feature-card">
            <div slot="header">
              <span>功能特性</span>
            </div>
            <div class="feature-list">
              <div class="feature-item">
                <i class="el-icon-chat-dot-round"></i>
                <span>智能问答对话</span>
              </div>
              <div class="feature-item">
                <i class="el-icon-time"></i>
                <span>实时消息历史</span>
              </div>
              <div class="feature-item">
                <i class="el-icon-mobile-phone"></i>
                <span>响应式抽屉设计</span>
              </div>
              <div class="feature-item">
                <i class="el-icon-magic-stick"></i>
                <span>流畅动画效果</span>
              </div>
              <div class="feature-item">
                <i class="el-icon-menu"></i>
                <span>侧边抽屉布局</span>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <!-- 访问方式 -->
        <el-col :span="12">
          <el-card class="access-card">
            <div slot="header">
              <span>访问方式</span>
            </div>
            <div class="access-methods">
              <div class="access-item">
                <el-button
                  type="primary"
                  icon="el-icon-cpu"
                  @click="openAiChat"
                  size="medium"
                >
                  打开AI抽屉
                </el-button>
                <p>从右侧滑出AI聊天抽屉</p>
              </div>
              <div class="access-item">
                <el-button 
                  type="success" 
                  icon="el-icon-position" 
                  @click="scrollToFloatingButton"
                  size="medium"
                >
                  悬浮AI按钮
                </el-button>
                <p>查看右下角的悬浮按钮</p>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      
      <!-- 示例问题 -->
      <el-card class="example-card">
        <div slot="header">
          <span>示例问题</span>
          <span class="card-subtitle">点击下方问题快速体验AI回答</span>
        </div>
        <div class="example-questions">
          <el-tag 
            v-for="(question, index) in exampleQuestions"
            :key="index"
            class="example-tag"
            @click="askQuestion(question)"
            type="info"
            effect="plain"
          >
            {{ question }}
          </el-tag>
        </div>
      </el-card>
      
      <!-- 使用统计 -->
      <el-card class="stats-card">
        <div slot="header">
          <span>使用统计</span>
        </div>
        <el-row :gutter="20">
          <el-col :span="8">
            <div class="stat-item">
              <div class="stat-number">{{ stats.totalChats }}</div>
              <div class="stat-label">总对话次数</div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="stat-item">
              <div class="stat-number">{{ stats.todayChats }}</div>
              <div class="stat-label">今日对话</div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="stat-item">
              <div class="stat-number">{{ stats.avgResponseTime }}ms</div>
              <div class="stat-label">平均响应时间</div>
            </div>
          </el-col>
        </el-row>
      </el-card>
    </div>
    
    <!-- AI聊天弹窗 -->
    <ai-chat v-model="showAiChat" @message-sent="updateStats" />
  </div>
</template>

<script>
import AiChat from '@/components/AiChat'

export default {
  name: 'AiDemo',
  components: {
    AiChat
  },
  data() {
    return {
      showAiChat: false,
      exampleQuestions: [
        '你好，请介绍一下自己',
        '今天天气怎么样？',
        '如何提高工作效率？',
        '推荐一些学习资源',
        '解释一下人工智能',
        '如何保持健康的生活方式？'
      ],
      stats: {
        totalChats: 0,
        todayChats: 0,
        avgResponseTime: 1200
      }
    }
  },
  mounted() {
    this.loadStats()
  },
  methods: {
    // 打开AI聊天
    openAiChat() {
      this.showAiChat = true
    },
    
    // 滚动到悬浮按钮位置
    scrollToFloatingButton() {
      this.$message.info('请查看页面右下角的悬浮AI按钮')
      // 添加一个临时的高亮效果
      this.highlightFloatingButton()
    },
    
    // 高亮悬浮按钮
    highlightFloatingButton() {
      // 这里可以通过事件总线或其他方式与悬浮按钮通信
      this.$message({
        message: '悬浮AI按钮位于页面右下角，点击即可开始对话',
        type: 'success',
        duration: 3000
      })
    },
    
    // 快速提问
    askQuestion(question) {
      // 这里可以预设问题到AI聊天组件
      this.showAiChat = true
      this.$nextTick(() => {
        // 如果AI聊天组件支持预设问题，可以在这里设置
        this.$message.success(`已选择问题: ${question}`)
      })
    },
    
    // 加载统计数据
    loadStats() {
      // 从localStorage或API加载统计数据
      const savedStats = localStorage.getItem('aiChatStats')
      if (savedStats) {
        this.stats = { ...this.stats, ...JSON.parse(savedStats) }
      }
    },
    
    // 更新统计数据
    updateStats() {
      this.stats.totalChats++
      this.stats.todayChats++
      
      // 保存到localStorage
      localStorage.setItem('aiChatStats', JSON.stringify(this.stats))
    }
  }
}
</script>

<style lang="scss" scoped>
.ai-demo-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.demo-header {
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

.demo-content {
  .el-card {
    margin-bottom: 20px;
  }
}

.feature-card {
  .feature-list {
    .feature-item {
      display: flex;
      align-items: center;
      margin-bottom: 15px;
      
      i {
        font-size: 20px;
        color: #409eff;
        margin-right: 10px;
        width: 24px;
      }
      
      span {
        font-size: 14px;
        color: #606266;
      }
    }
  }
}

.access-card {
  .access-methods {
    .access-item {
      text-align: center;
      margin-bottom: 20px;
      
      .el-button {
        width: 100%;
        margin-bottom: 10px;
      }
      
      p {
        font-size: 12px;
        color: #909399;
        margin: 0;
      }
    }
  }
}

.example-card {
  .card-subtitle {
    float: right;
    font-size: 12px;
    color: #909399;
  }
  
  .example-questions {
    .example-tag {
      margin: 5px 10px 5px 0;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background-color: #409eff;
        color: white;
        transform: translateY(-2px);
      }
    }
  }
}

.stats-card {
  .stat-item {
    text-align: center;
    
    .stat-number {
      font-size: 32px;
      font-weight: bold;
      color: #409eff;
      margin-bottom: 5px;
    }
    
    .stat-label {
      font-size: 14px;
      color: #606266;
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .ai-demo-container {
    padding: 10px;
  }
  
  .demo-content {
    .el-col {
      margin-bottom: 20px;
    }
  }
  
  .example-questions {
    .example-tag {
      display: block;
      margin: 10px 0;
      text-align: center;
    }
  }
}
</style>
