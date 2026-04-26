<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 统计卡片 -->
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <i class="el-icon-document"></i>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ statistics.totalCount || 0 }}</div>
              <div class="stat-label">总模板数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <i class="el-icon-download"></i>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ statistics.totalDownloads || 0 }}</div>
              <div class="stat-label">总下载数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <i class="el-icon-view"></i>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ popularTemplates.length || 0 }}</div>
              <div class="stat-label">热门模板</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <i class="el-icon-star-on"></i>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ Object.keys(statistics.categoryStats || {}).length }}</div>
              <div class="stat-label">分类数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 分类统计图表 -->
      <el-col :span="12">
        <el-card>
          <div slot="header">
            <span>模板分类统计</span>
          </div>
          <div class="chart-container">
            <div ref="categoryChart" style="height: 300px;"></div>
          </div>
        </el-card>
      </el-col>

      <!-- 类型统计图表 -->
      <el-col :span="12">
        <el-card>
          <div slot="header">
            <span>模板类型统计</span>
          </div>
          <div class="chart-container">
            <div ref="typeChart" style="height: 300px;"></div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 热门模板列表 -->
      <el-col :span="24">
        <el-card>
          <div slot="header">
            <span>热门模板排行</span>
          </div>
          <el-table :data="popularTemplates" style="width: 100%">
            <el-table-column prop="templateName" label="模板名称" width="200">
              <template slot-scope="scope">
                <el-link type="primary" @click="handlePreview(scope.row)">{{ scope.row.templateName }}</el-link>
              </template>
            </el-table-column>
            <el-table-column prop="templateType" label="类型" width="100">
              <template slot-scope="scope">
                <el-tag :type="getTypeTagType(scope.row.templateType)">
                  {{ getTypeLabel(scope.row.templateType) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="category" label="分类" width="100">
              <template slot-scope="scope">
                <el-tag type="info">{{ getCategoryLabel(scope.row.category) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="downloadCount" label="下载次数" width="120" sortable>
              <template slot-scope="scope">
                <span class="download-count">
                  <i class="el-icon-download"></i>
                  {{ scope.row.downloadCount || 0 }}
                </span>
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="创建时间" width="180">
              <template slot-scope="scope">
                {{ parseTime(scope.row.createTime) }}
              </template>
            </el-table-column>
            <el-table-column prop="templateDescription" label="描述" show-overflow-tooltip>
              <template slot-scope="scope">
                {{ scope.row.templateDescription }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150" fixed="right">
              <template slot-scope="scope">
                <el-button type="text" size="mini" @click="handleCopy(scope.row)">复制</el-button>
                <el-button type="text" size="mini" @click="handleUse(scope.row)">使用</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <!-- 代码预览对话框 -->
    <el-dialog title="模板代码预览" :visible.sync="previewOpen" width="80%" append-to-body>
      <div class="code-preview">
        <pre class="code-content">{{ previewCode }}</pre>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="copyCode">复制代码</el-button>
        <el-button @click="previewOpen = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getTemplateStatistics, copyTemplateCode, useTemplate } from "@/api/system/pageTemplate";
import * as echarts from 'echarts';

export default {
  name: "PageTemplateStatistics",
  dicts: ['sys_template_type', 'sys_template_category'],
  data() {
    return {
      // 统计数据
      statistics: {},
      // 热门模板
      popularTemplates: [],
      // 预览相关
      previewOpen: false,
      previewCode: "",
      // 图表实例
      categoryChart: null,
      typeChart: null
    };
  },
  mounted() {
    this.getStatistics();
  },
  beforeDestroy() {
    // 销毁图表实例
    if (this.categoryChart) {
      this.categoryChart.dispose();
    }
    if (this.typeChart) {
      this.typeChart.dispose();
    }
  },
  methods: {
    /** 获取统计数据 */
    getStatistics() {
      getTemplateStatistics().then(response => {
        this.statistics = response.data;
        this.popularTemplates = response.data.popularTemplates || [];
        this.initCharts();
      });
    },
    /** 初始化图表 */
    initCharts() {
      this.$nextTick(() => {
        this.initCategoryChart();
        this.initTypeChart();
      });
    },
    /** 初始化分类统计图表 */
    initCategoryChart() {
      const categoryData = this.statistics.categoryStats || {};
      const chartDom = this.$refs.categoryChart;
      this.categoryChart = echarts.init(chartDom);
      
      const option = {
        title: {
          text: '模板分类分布',
          left: 'center'
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '模板分类',
            type: 'pie',
            radius: '50%',
            data: Object.keys(categoryData).map(key => ({
              name: this.getCategoryLabel(key),
              value: categoryData[key]
            })),
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      };
      
      this.categoryChart.setOption(option);
    },
    /** 初始化类型统计图表 */
    initTypeChart() {
      const typeData = this.statistics.typeStats || {};
      const chartDom = this.$refs.typeChart;
      this.typeChart = echarts.init(chartDom);
      
      const option = {
        title: {
          text: '模板类型分布',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        xAxis: {
          type: 'category',
          data: Object.keys(typeData).map(key => this.getTypeLabel(key))
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: '模板数量',
            type: 'bar',
            data: Object.values(typeData),
            itemStyle: {
              color: function(params) {
                const colors = ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399', '#9C27B0'];
                return colors[params.dataIndex % colors.length];
              }
            }
          }
        ]
      };
      
      this.typeChart.setOption(option);
    },
    /** 预览模板 */
    handlePreview(row) {
      this.previewCode = row.templateCode;
      this.previewOpen = true;
    },
    /** 复制模板代码 */
    handleCopy(row) {
      copyTemplateCode(row.templateId).then(response => {
        this.$modal.msgSuccess("复制成功，代码已复制到剪贴板");
        this.copyToClipboard(response.data);
      });
    },
    /** 使用模板 */
    handleUse(row) {
      useTemplate(row.templateId).then(response => {
        this.$modal.msgSuccess("使用成功");
        this.getStatistics(); // 刷新统计数据
      });
    },
    /** 复制代码 */
    copyCode() {
      this.copyToClipboard(this.previewCode);
      this.$modal.msgSuccess("代码已复制到剪贴板");
    },
    /** 复制到剪贴板 */
    copyToClipboard(text) {
      if (navigator.clipboard) {
        navigator.clipboard.writeText(text).then(() => {
          console.log('复制成功');
        });
      } else {
        // 兼容旧浏览器
        const textArea = document.createElement('textarea');
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
      }
    },
    // 获取类型标签样式
    getTypeTagType(type) {
      const typeMap = {
        'index': 'primary',
        'list': 'success',
        'detail': 'info',
        'form': 'warning',
        'login': 'danger',
        'user': 'purple'
      };
      return typeMap[type] || 'info';
    },
    // 获取类型标签文本 - 使用字典数据
    getTypeLabel(type) {
      const typeDict = this.dict.type.sys_template_type.find(item => item.value === type);
      return typeDict ? typeDict.label : type;
    },
    // 获取分类标签文本 - 使用字典数据
    getCategoryLabel(category) {
      const categoryDict = this.dict.type.sys_template_category.find(item => item.value === category);
      return categoryDict ? categoryDict.label : category;
    }
  }
};
</script>

<style scoped>
.stat-card {
  margin-bottom: 20px;
}

.stat-content {
  display: flex;
  align-items: center;
  padding: 10px;
}

.stat-icon {
  font-size: 48px;
  color: #409EFF;
  margin-right: 20px;
}

.stat-info {
  flex: 1;
}

.stat-number {
  font-size: 32px;
  font-weight: bold;
  color: #333;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-top: 5px;
}

.chart-container {
  padding: 10px;
}

.download-count {
  display: flex;
  align-items: center;
  gap: 5px;
  color: #409EFF;
}

.code-preview {
  max-height: 600px;
  overflow: auto;
}

.code-content {
  background: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  font-family: 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.5;
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style> 