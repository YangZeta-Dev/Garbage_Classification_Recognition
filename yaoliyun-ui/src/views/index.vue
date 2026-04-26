<template>

  <div class="dashboard-container">

    <!-- 页面标题 -->

    <div class="page-header">

      <div class="header-content">

        <h1 class="dashboard-title">

          <i class="el-icon-s-cooperation"></i>

          垃圾分类统计概览

        </h1>

        <p class="dashboard-subtitle">实时监控垃圾分类识别系统运行状态</p>

        <div class="update-time">

          <i class="el-icon-time"></i>

          最后更新：{{ updateTime }}

        </div>

      </div>

    </div>



    <!-- 系统统计概览 -->

    <div class="stats-section">

      <el-row :gutter="24">

        <el-col :xs="12" :sm="6" :md="6" :lg="6" v-for="(item, index) in overviewStats" :key="index">

          <div class="stats-card" @click="handleStatsClick(item)">

            <div class="stats-content">

              <div class="stats-icon-wrapper">

                <div class="stats-icon" :style="{ background: item.color }">

                  <i :class="item.icon"></i>

                </div>

              </div>

              <div class="stats-details">

                <div class="stats-number" :data-value="item.value">{{ item.value }}</div>

                <div class="stats-label">{{ item.label }}</div>

                <div class="stats-trend" v-if="item.trend">

                  <i :class="item.trend > 0 ? 'el-icon-arrow-up' : 'el-icon-arrow-down'"></i>

                  <span>{{ Math.abs(item.trend) }}%</span>

                </div>

              </div>

            </div>

          </div>

        </el-col>

      </el-row>

    </div>



    <!-- 图表区域 -->

    <div class="charts-section">

      <!-- 第一行图表 -->

      <el-row :gutter="24" class="chart-row">

        <el-col :xs="24" :sm="24" :md="12" :lg="12">

          <div class="chart-container">

            <div class="chart-header">

              <div class="chart-title">

                <i class="el-icon-data-analysis"></i>

                <span>识别趋势统计</span>

              </div>

              <div class="chart-subtitle">最近30天垃圾识别数据分析</div>

            </div>

            <div class="chart-content">

              <div ref="userTrendChart" class="chart-canvas"></div>

            </div>

          </div>

        </el-col>


        <el-col :xs="24" :sm="24" :md="12" :lg="12">

          <div class="chart-container">

            <div class="chart-header">

              <div class="chart-title">

                <i class="el-icon-pie-chart"></i>

                <span>分类识别统计</span>

              </div>

              <div class="chart-subtitle">各垃圾类别识别占比</div>

            </div>

            <div class="chart-content">

              <div ref="onlineTrendChart" class="chart-canvas"></div>

            </div>

          </div>

        </el-col>

      </el-row>



      <!-- 第二行图表 -->

      <el-row :gutter="24" class="chart-row">

        <el-col :xs="24" :sm="24" :md="12" :lg="12">

          <div class="chart-container">

            <div class="chart-header">

              <div class="chart-title">

                <i class="el-icon-s-data"></i>

                <span>系统统计数据</span>

              </div>

              <div class="chart-subtitle">垃圾分类系统核心数据统计</div>

            </div>

            <div class="chart-content tech-stack">

              <div class="tech-section">

                <div class="tech-category">

                  <div class="category-header">

                    <i class="el-icon-document"></i>

                    <span>内容统计</span>

                  </div>

                  <div class="tech-tags">

                    <span class="tech-tag backend">知识文章: {{ extraStats.totalArticles || 0 }} 篇</span>

                    <span class="tech-tag backend">测验题目: {{ extraStats.totalQuestions || 0 }} 道</span>

                  </div>

                </div>


                <div class="tech-category">

                  <div class="category-header">

                    <i class="el-icon-user"></i>

                    <span>用户统计</span>

                  </div>

                  <div class="tech-tags">

                    <span class="tech-tag frontend">总用户数: {{ extraStats.totalUsers || 0 }} 人</span>

                    <span class="tech-tag frontend">在线用户: {{ extraStats.onlineUsers || 0 }} 人</span>

                  </div>

                </div>

              </div>

            </div>

          </div>

        </el-col>


        <el-col :xs="24" :sm="24" :md="12" :lg="12">

          <div class="chart-container">

            <div class="chart-header">

              <div class="chart-title">

                <i class="el-icon-s-management"></i>

                <span>功能模块统计</span>

              </div>

              <div class="chart-subtitle">各功能模块的使用情况</div>

            </div>

            <div class="chart-content">

              <div ref="moduleUsageChart" class="chart-canvas"></div>

            </div>

          </div>

        </el-col>

      </el-row>

    </div>




  </div>

</template>



<script>

import * as echarts from 'echarts'

import { getGarbageOverview, getRecognitionTrend, getCategoryStats, getModuleUsage } from '@/api/system/index'



export default {

  name: "Index",

  data() {

    return {

// 版本号

      version: "3.9.0",

// 当前时间

      currentTime: '',

// 概览统计数据

      overviewStats: [

        {

          label: '识别总数',

          value: 0,

          icon: 'el-icon-camera',

          color: 'linear-gradient(135deg, #2E7D32 0%, #43A047 100%)',

          trend: null

        },

        {

          label: '今日识别',

          value: 0,

          icon: 'el-icon-data-line',

          color: 'linear-gradient(135deg, #43A047 0%, #66BB6A 100%)',

          trend: null

        },

        {

          label: '垃圾物品',

          value: 0,

          icon: 'el-icon-goods',

          color: 'linear-gradient(135deg, #66BB6A 0%, #81C784 100%)',

          trend: null

        },

        {

          label: '分类类别',

          value: 0,

          icon: 'el-icon-s-grid',

          color: 'linear-gradient(135deg, #81C784 0%, #A5D6A7 100%)',

          trend: null

        }

      ],

// 系统信息

      systemInfo: {

        runningDays: 0

      },

// 额外统计数据

      extraStats: {

        totalArticles: 0,

        totalQuestions: 0,

        totalUsers: 0,

        onlineUsers: 0

      },

// 更新时间

      updateTime: '',

// 图表实例

      userTrendChart: null,

      onlineTrendChart: null,

      moduleUsageChart: null,

// 定时器

      timeTimer: null

    }

  },

  mounted() {

    this.initData()

    this.startTimeUpdate()

// 添加窗口大小改变事件监听

    window.addEventListener('resize', this.handleResize)

  },

  beforeDestroy() {

// 清除定时器

    if (this.timeTimer) {

      clearInterval(this.timeTimer)

    }

// 移除事件监听

    window.removeEventListener('resize', this.handleResize)

// 销毁图表实例

    this.destroyCharts()

  },

  methods: {

// 开始时间更新

    startTimeUpdate() {

      this.updateCurrentTime()

      this.timeTimer = setInterval(() => {

        this.updateCurrentTime()

      }, 1000)

    },


// 更新当前时间

    updateCurrentTime() {

      this.currentTime = new Date().toLocaleString()

    },


// 处理窗口大小改变

    handleResize() {

      this.$nextTick(() => {

        if (this.userTrendChart) this.userTrendChart.resize()

        if (this.onlineTrendChart) this.onlineTrendChart.resize()

        if (this.moduleUsageChart) this.moduleUsageChart.resize()

      })

    },


// 销毁图表

    destroyCharts() {

      if (this.userTrendChart) {

        this.userTrendChart.dispose()

        this.userTrendChart = null

      }

      if (this.onlineTrendChart) {

        this.onlineTrendChart.dispose()

        this.onlineTrendChart = null

      }

      if (this.moduleUsageChart) {

        this.moduleUsageChart.dispose()

        this.moduleUsageChart = null

      }

    },


// 处理统计卡片点击

    handleStatsClick(item) {

      this.$message.info(`点击了${item.label}统计`)

    },


// 初始化数据

    async initData() {

      try {

        await this.loadOverviewData()

        await this.$nextTick()

        await Promise.all([

          this.loadUserTrendChart(),

          this.loadOnlineTrendChart(),

          this.loadModuleUsageChart()

        ])

        this.updateTime = new Date().toLocaleString()

      } catch (error) {

        console.error('加载数据失败:', error)

        this.$message.error('数据加载失败，请稍后重试')

      }

    },


// 加载概览数据

    async loadOverviewData() {

      const { data } = await getGarbageOverview()

      this.overviewStats[0].value = data.totalRecognitions || 0

      this.overviewStats[1].value = data.todayRecognitions || 0

      this.overviewStats[2].value = data.totalItems || 0

      this.overviewStats[3].value = data.totalCategories || 0


// 额外统计数据

      this.extraStats.totalArticles = data.totalArticles || 0

      this.extraStats.totalQuestions = data.totalQuestions || 0

      this.extraStats.totalUsers = data.totalUsers || 0

      this.extraStats.onlineUsers = data.onlineUsers || 0


// 趋势数据

      this.overviewStats[0].trend = 8.5

      this.overviewStats[1].trend = 15.2

      this.overviewStats[2].trend = 3.1

      this.overviewStats[3].trend = 0

    },



// 加载识别趋势图

    async loadUserTrendChart() {

      if (!this.$refs.userTrendChart) return


      const { data } = await getRecognitionTrend()

      this.userTrendChart = echarts.init(this.$refs.userTrendChart)


      const option = {

        tooltip: {

          trigger: 'axis',

          axisPointer: {

            type: 'cross',

            crossStyle: {

              color: '#999'

            }

          },

          backgroundColor: 'rgba(255, 255, 255, 0.95)',

          borderColor: '#4A90E2',

          borderWidth: 1,

          textStyle: {

            color: '#333'

          }

        },

        grid: {

          left: '3%',

          right: '4%',

          bottom: '8%',

          top: '10%',

          containLabel: true

        },

        xAxis: {

          type: 'category',

          data: data.dates,

          axisLabel: {

            formatter: function(value) {

              return value.substring(5)

            },

            color: '#666'

          },

          axisLine: {

            lineStyle: {

              color: '#e0e0e0'

            }

          }

        },

        yAxis: {

          type: 'value',

          minInterval: 1,

          axisLabel: {

            color: '#666'

          },

          axisLine: {

            lineStyle: {

              color: '#e0e0e0'

            }

          },

          splitLine: {

            lineStyle: {

              color: '#f0f0f0'

            }

          }

        },

        series: [{

          data: data.counts,

          type: 'line',

          smooth: true,

          symbol: 'circle',

          symbolSize: 6,

          areaStyle: {

            color: {

              type: 'linear',

              x: 0,

              y: 0,

              x2: 0,

              y2: 1,

              colorStops: [{

                offset: 0, color: 'rgba(46, 125, 50, 0.3)'

              }, {

                offset: 1, color: 'rgba(46, 125, 50, 0.05)'

              }]

            }

          },

          lineStyle: {

            color: '#2E7D32',

            width: 3

          },

          itemStyle: {

            color: '#2E7D32',

            borderColor: '#fff',

            borderWidth: 2

          }

        }]

      }


      this.userTrendChart.setOption(option)

    },



// 加载分类识别统计图

    async loadOnlineTrendChart() {

      if (!this.$refs.onlineTrendChart) return


      const { data } = await getCategoryStats()

      this.onlineTrendChart = echarts.init(this.$refs.onlineTrendChart)


      const colors = ['#2E7D32', '#43A047', '#66BB6A', '#81C784', '#A5D6A7', '#C8E6C9']


      const option = {

        tooltip: {

          trigger: 'item',

          formatter: '{a} <br/>{b}: {c} ({d}%)',

          backgroundColor: 'rgba(255, 255, 255, 0.95)',

          borderColor: '#43A047',

          borderWidth: 1,

          textStyle: {

            color: '#333'

          }

        },

        legend: {

          orient: 'vertical',

          left: 10,

          top: 20,

          data: data.map(item => item.name),

          textStyle: {

            color: '#666'

          }

        },

        series: [{

          name: '识别数量',

          type: 'pie',

          radius: ['45%', '70%'],

          center: ['65%', '50%'],

          avoidLabelOverlap: false,

          label: {

            show: false

          },

          emphasis: {

            label: {

              show: true,

              fontSize: '14',

              fontWeight: 'bold'

            },

            itemStyle: {

              shadowBlur: 10,

              shadowOffsetX: 0,

              shadowColor: 'rgba(0, 0, 0, 0.5)'

            }

          },

          labelLine: {

            show: false

          },

          data: data.map((item, index) => ({

            ...item,

            itemStyle: {

              color: colors[index % colors.length],

              borderRadius: 8,

              borderColor: '#fff',

              borderWidth: 2

            }

          }))

        }]

      }


      this.onlineTrendChart.setOption(option)

    },



// 加载模块使用统计图

    async loadModuleUsageChart() {

      if (!this.$refs.moduleUsageChart) return


      const { data } = await getModuleUsage()

      this.moduleUsageChart = echarts.init(this.$refs.moduleUsageChart)


      const colors = ['#2E7D32', '#43A047', '#66BB6A', '#81C784', '#A5D6A7', '#C8E6C9', '#388E3C', '#4CAF50']


      const option = {

        tooltip: {

          trigger: 'item',

          formatter: '{a} <br/>{b}: {c} ({d}%)',

          backgroundColor: 'rgba(255, 255, 255, 0.95)',

          borderColor: '#ddd',

          borderWidth: 1,

          textStyle: {

            color: '#333'

          }

        },

        legend: {

          orient: 'vertical',

          left: 10,

          top: 20,

          data: data.map(item => item.name),

          textStyle: {

            color: '#666'

          }

        },

        series: [{

          name: '模块使用量',

          type: 'pie',

          radius: ['45%', '70%'],

          center: ['65%', '50%'],

          avoidLabelOverlap: false,

          label: {

            show: false

          },

          emphasis: {

            label: {

              show: true,

              fontSize: '14',

              fontWeight: 'bold'

            },

            itemStyle: {

              shadowBlur: 10,

              shadowOffsetX: 0,

              shadowColor: 'rgba(0, 0, 0, 0.5)'

            }

          },

          labelLine: {

            show: false

          },

          data: data.map((item, index) => ({

            ...item,

            itemStyle: {

              color: colors[index % colors.length],

              borderRadius: 8,

              borderColor: '#fff',

              borderWidth: 2

            }

          }))

        }]

      }


      this.moduleUsageChart.setOption(option)

    }

  }

}

</script>



<style scoped lang="scss">

.dashboard-container {

  min-height: calc(100vh - 84px);

  background: linear-gradient(135deg, #E8F5E9 0%, #F1F8E9 100%);

  padding: 24px;


  // 页面标题区域

  .page-header {

    background: white;

    border-radius: 12px;

    padding: 32px;

    margin-bottom: 24px;

    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);

    position: relative;

    overflow: hidden;


    &::before {

      content: '';

      position: absolute;

      top: 0;

      left: 0;

      right: 0;

      height: 4px;

      background: linear-gradient(90deg, #2E7D32 0%, #43A047 50%, #66BB6A 100%);

    }


    .header-content {

      position: relative;

      z-index: 1;

    }


    .dashboard-title {

      margin: 0 0 8px 0;

      font-size: 28px;

      font-weight: 600;

      color: #1f2937;

      display: flex;

      align-items: center;


      i {

        margin-right: 12px;

        color: #2E7D32;

        font-size: 32px;

      }

    }


    .dashboard-subtitle {

      margin: 0 0 16px 0;

      font-size: 16px;

      color: #6b7280;

      line-height: 1.6;

    }


    .update-time {

      display: inline-flex;

      align-items: center;

      padding: 8px 16px;

      background: rgba(46, 125, 50, 0.1);

      border-radius: 20px;

      font-size: 14px;

      color: #2E7D32;


      i {

        margin-right: 6px;

      }

    }

  }


  // 统计概览区域

  .stats-section {

    margin-bottom: 24px;


    .stats-card {

      background: white;

      border-radius: 12px;

      padding: 24px;

      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);

      transition: all 0.3s ease;

      cursor: pointer;

      border: 2px solid transparent;

      height: 120px;


      &:hover {

        transform: translateY(-4px);

        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);

        border-color: rgba(46, 125, 50, 0.3);

      }


      .stats-content {

        display: flex;

        align-items: center;

        height: 100%;


        .stats-icon-wrapper {

          margin-right: 20px;


          .stats-icon {

            width: 64px;

            height: 64px;

            border-radius: 16px;

            display: flex;

            align-items: center;

            justify-content: center;

            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);


            i {

              font-size: 28px;

              color: white;

            }

          }

        }


        .stats-details {

          flex: 1;


          .stats-number {

            font-size: 32px;

            font-weight: 700;

            color: #1f2937;

            line-height: 1;

            margin-bottom: 4px;

          }


          .stats-label {

            font-size: 14px;

            color: #6b7280;

            margin-bottom: 8px;

          }


          .stats-trend {

            display: flex;

            align-items: center;

            font-size: 12px;

            font-weight: 500;


            &:has(.el-icon-arrow-up) {

              color: #10b981;

            }


            &:has(.el-icon-arrow-down) {

              color: #ef4444;

            }


            i {

              margin-right: 4px;

              font-size: 14px;

            }

          }

        }

      }

    }

  }


  // 图表区域

  .charts-section {

    .chart-row {

      margin-bottom: 24px;


      &:last-child {

        margin-bottom: 0;

      }

    }


    .chart-container {

      background: white;

      border-radius: 12px;

      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);

      overflow: hidden;

      height: 420px;

      display: flex;

      flex-direction: column;


      .chart-header {

        padding: 20px 24px 16px;

        background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);

        border-bottom: 1px solid #e2e8f0;


        .chart-title {

          display: flex;

          align-items: center;

          font-size: 18px;

          font-weight: 600;

          color: #1f2937;

          margin-bottom: 4px;


          i {

            margin-right: 10px;

            color: #2E7D32;

            font-size: 20px;

          }

        }


        .chart-subtitle {

          font-size: 14px;

          color: #64748b;

        }

      }


      .chart-content {

        flex: 1;

        padding: 16px;

        display: flex;

        flex-direction: column;


        .chart-canvas {

          flex: 1;

          min-height: 280px;

        }


        // 技术栈特殊样式

        &.tech-stack {

          .tech-section {

            flex: 1;

            display: flex;

            flex-direction: column;

            gap: 24px;


            .tech-category {

              .category-header {

                display: flex;

                align-items: center;

                margin-bottom: 12px;

                font-size: 16px;

                font-weight: 600;

                color: #374151;


                i {

                  margin-right: 8px;

                  color: #4A90E2;

                }

              }


              .tech-tags {

                display: flex;

                flex-wrap: wrap;

                gap: 8px;


                .tech-tag {

                  padding: 6px 12px;

                  border-radius: 20px;

                  font-size: 13px;

                  font-weight: 500;

                  border: 1px solid;

                  transition: all 0.2s ease;


                  &.backend {

                    background: rgba(46, 125, 50, 0.1);

                    color: #2E7D32;

                    border-color: rgba(46, 125, 50, 0.25);


                    &:hover {

                      background: rgba(46, 125, 50, 0.2);

                      transform: translateY(-1px);

                    }

                  }


                  &.frontend {

                    background: rgba(102, 187, 106, 0.15);

                    color: #388E3C;

                    border-color: rgba(102, 187, 106, 0.3);


                    &:hover {

                      background: rgba(102, 187, 106, 0.25);

                      transform: translateY(-1px);

                    }

                  }

                }

              }

            }

          }

        }

      }

    }

  }


  // 系统信息区域

  .system-info-section {

    .info-card {

      background: white;

      border-radius: 12px;

      padding: 24px;

      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);


      .info-header {

        display: flex;

        align-items: center;

        margin-bottom: 20px;

        font-size: 18px;

        font-weight: 600;

        color: #1f2937;


        i {

          margin-right: 10px;

          color: #4A90E2;

          font-size: 20px;

        }

      }


      .info-content {

        display: grid;

        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));

        gap: 16px;


        .info-item {

          display: flex;

          align-items: center;

          padding: 12px 16px;

          background: #f8fafc;

          border-radius: 8px;

          border-left: 4px solid #2E7D32;


          .info-label {

            font-weight: 500;

            color: #374151;

            margin-right: 8px;

          }


          .info-value {

            color: #1f2937;

            font-weight: 600;

          }

        }

      }

    }

  }

}



// 响应式设计

@media (max-width: 1200px) {

  .dashboard-container {

    .charts-section .chart-container {

      height: 380px;


      .chart-content .chart-canvas {

        min-height: 240px;

      }

    }

  }

}



@media (max-width: 768px) {

  .dashboard-container {

    padding: 16px;


    .page-header {

      padding: 20px;


      .dashboard-title {

        font-size: 24px;


        i {

          font-size: 28px;

        }

      }


      .dashboard-subtitle {

        font-size: 14px;

      }

    }


    .stats-section .stats-card {

      margin-bottom: 16px;

      height: auto;

      min-height: 100px;


      .stats-content {

        .stats-details .stats-number {

          font-size: 24px;

        }

      }

    }


    .charts-section {

      .chart-row {

        margin-bottom: 16px;

      }


      .chart-container {

        height: 350px;


        .chart-content {

          &.tech-stack .tech-section {

            gap: 16px;


            .tech-category .tech-tags .tech-tag {

              font-size: 12px;

              padding: 4px 8px;

            }

          }

        }

      }

    }


    .system-info-section .info-card {

      .info-content {

        grid-template-columns: 1fr;

      }

    }

  }

}



@media (max-width: 480px) {

  .dashboard-container {

    .stats-section .stats-card .stats-content {

      flex-direction: column;

      text-align: center;


      .stats-icon-wrapper {

        margin-right: 0;

        margin-bottom: 12px;

      }

    }

  }

}

</style>
