<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 分类统计卡片 -->
      <el-col :span="6" v-for="(count, category) in categoryStats" :key="category">
        <el-card class="category-card" shadow="hover">
          <div class="category-content">
            <div class="category-icon">
              <i class="el-icon-folder"></i>
            </div>
            <div class="category-info">
              <div class="category-name">{{ getCategoryLabel(category) }}</div>
              <div class="category-count">{{ count }} 个模板</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 分类筛选 -->
      <el-col :span="24">
        <el-card>
          <div slot="header">
            <span>按分类浏览模板</span>
          </div>
          <el-tabs v-model="activeCategory" @tab-click="handleCategoryChange">
            <el-tab-pane 
              v-for="(count, category) in categoryStats" 
              :key="category"
              :label="`${getCategoryLabel(category)} (${count})`"
              :name="category"
            >
              <el-row :gutter="20">
                <el-col :span="6" v-for="item in categoryTemplates" :key="item.templateId">
                  <el-card class="template-card" shadow="hover">
                    <div class="template-preview">
                      <image-preview :src="item.previewImage || '/static/default-template.jpg'" :width="300" :height="200" />
                      <div class="template-overlay">
                        <el-button type="primary" size="small" @click="handlePreview(item)" icon="el-icon-view">预览</el-button>
                        <el-button type="success" size="small" @click="handleCopy(item)" icon="el-icon-document-copy">复制</el-button>
                      </div>
                    </div>
                    <div class="template-info">
                      <h3 class="template-title">{{ item.templateName }}</h3>
                      <p class="template-desc">{{ item.templateDescription }}</p>
                      <div class="template-meta">
                        <el-tag size="mini" :type="getTypeTagType(item.templateType)">
                          {{ getTypeLabel(item.templateType) }}
                        </el-tag>
                      </div>
                      <div class="template-stats">
                        <span class="download-count">
                          <i class="el-icon-download"></i>
                          {{ item.downloadCount || 0 }}
                        </span>
                        <span class="create-time">{{ parseTime(item.createTime, '{y}-{m}-{d}') }}</span>
                      </div>
                      <div class="template-actions">
                        <el-button type="text" size="mini" @click="handleUse(item)">使用</el-button>
                        <el-button type="text" size="mini" @click="handleView(item)">查看</el-button>
                      </div>
                    </div>
                  </el-card>
                </el-col>
              </el-row>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
    </el-row>

    <!-- 代码预览对话框 -->
    <el-dialog title="模板代码预览" :visible.sync="previewOpen" width="80%" append-to-body>
      <div class="code-preview">
        <div class="code-header">
          <el-tabs v-model="activeTab" type="card">
            <el-tab-pane label="代码预览" name="code">
              <pre class="code-content">{{ previewCode }}</pre>
            </el-tab-pane>
            <el-tab-pane label="效果预览" name="preview">
              <div class="preview-container">
                <image-preview 
                  :src="previewImage || '/static/default-template.jpg'" 
                  :width="600" 
                  :height="400"
                  style="max-width: 100%; height: auto;"
                />
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="copyCode">复制代码</el-button>
        <el-button @click="previewOpen = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getTemplateStatistics, getTemplatesByCategory, copyTemplateCode, useTemplate } from "@/api/system/pageTemplate";
import ImagePreview from "@/components/ImagePreview";

export default {
  name: "PageTemplateCategory",
  dicts: ['sys_template_type', 'sys_template_category'],
  data() {
    return {
      // 分类统计
      categoryStats: {},
      // 当前分类
      activeCategory: 'common',
      // 分类模板列表
      categoryTemplates: [],
      // 预览相关
      previewOpen: false,
      previewCode: "",
      previewImage: "",
      activeTab: "code"
    };
  },
  created() {
    this.getStatistics();
  },
  methods: {
    /** 获取统计数据 */
    getStatistics() {
      getTemplateStatistics().then(response => {
        this.categoryStats = response.data.categoryStats || {};
        this.loadCategoryTemplates(this.activeCategory);
      });
    },
    /** 加载分类模板 */
    loadCategoryTemplates(category) {
      getTemplatesByCategory(category).then(response => {
        this.categoryTemplates = response.data || [];
      });
    },
    /** 分类切换 */
    handleCategoryChange(tab) {
      this.loadCategoryTemplates(tab.name);
    },
    /** 预览模板 */
    handlePreview(row) {
      this.previewCode = row.templateCode;
      this.previewImage = row.previewImage;
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
    /** 查看模板 */
    handleView(row) {
      this.$router.push(`/system/pageTemplate/template?id=${row.templateId}`);
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
.category-card {
  margin-bottom: 20px;
  transition: all 0.3s;
}

.category-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.1);
}

.category-content {
  display: flex;
  align-items: center;
  padding: 15px;
}

.category-icon {
  font-size: 36px;
  color: #409EFF;
  margin-right: 15px;
}

.category-info {
  flex: 1;
}

.category-name {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 5px;
}

.category-count {
  font-size: 14px;
  color: #666;
}

.template-card {
  margin-bottom: 20px;
  transition: all 0.3s;
}

.template-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

.template-preview {
  position: relative;
  height: 200px;
  overflow: hidden;
  border-radius: 8px;
}

.preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.template-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  opacity: 0;
  transition: opacity 0.3s;
}

.template-preview:hover .template-overlay {
  opacity: 1;
}

.template-info {
  padding: 15px;
}

.template-title {
  margin: 0 0 10px 0;
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.template-desc {
  margin: 0 0 10px 0;
  font-size: 14px;
  color: #666;
  line-height: 1.4;
  height: 40px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.template-meta {
  margin-bottom: 10px;
}

.template-stats {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  font-size: 12px;
  color: #999;
}

.download-count {
  display: flex;
  align-items: center;
  gap: 5px;
}

.template-actions {
  display: flex;
  justify-content: space-around;
  border-top: 1px solid #eee;
  padding-top: 10px;
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

.preview-container {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  min-height: 400px;
  background: #fff;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style> 