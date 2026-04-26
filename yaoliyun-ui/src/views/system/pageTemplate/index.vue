<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="模板名称" prop="templateName">
        <el-input
          v-model="queryParams.templateName"
          placeholder="请输入模板名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="模板类型" prop="templateType">
        <el-select v-model="queryParams.templateType" placeholder="请选择模板类型" clearable>
          <el-option
            v-for="dict in dict.type.sys_template_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="分类" prop="category">
        <el-select v-model="queryParams.category" placeholder="请选择分类" clearable>
          <el-option
            v-for="dict in dict.type.sys_template_category"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="正常" value="0" />
          <el-option label="停用" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:pageTemplate:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:pageTemplate:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:pageTemplate:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:pageTemplate:export']"
        >导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-view"
          size="mini"
          @click="handleStatistics"
          v-hasPermi="['system:pageTemplate:statistics']"
        >统计</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 模板卡片展示 -->
    <el-row :gutter="20">
      <el-col :span="6" v-for="item in templateList" :key="item.templateId">
        <el-card class="template-card" shadow="hover">
          <div class="template-preview">
            <image-preview :src="item.previewImage || '/static/default-template.jpg'" :width="300" :height="200" />
            <div class="template-overlay">
              <el-button type="primary" size="small" @click="handlePreview(item)" icon="el-icon-view">预览</el-button>
            </div>
          </div>
          <div class="template-info">
            <h3 class="template-title">{{ item.templateName }}</h3>
            <p class="template-desc">{{ item.templateDescription }}</p>
            <div class="template-meta">
              <el-tag size="mini" :type="getTypeTagType(item.templateType)">
                {{ getTypeLabel(item.templateType) }}
              </el-tag>
              <el-tag size="mini" type="info" v-if="item.category">
                {{ getCategoryLabel(item.category) }}
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
              <el-button type="text" size="mini" @click="handleUpdate(item)" v-hasPermi="['system:pageTemplate:edit']">编辑</el-button>
              <el-button type="text" size="mini" @click="handleUse(item)" v-hasPermi="['system:pageTemplate:use']">使用</el-button>
              <el-button type="text" size="mini" @click="handleDelete(item)" v-hasPermi="['system:pageTemplate:remove']">删除</el-button>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改页面模板管理对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="模板名称" prop="templateName">
              <el-input v-model="form.templateName" placeholder="请输入模板名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="模板类型" prop="templateType">
              <el-select v-model="form.templateType" placeholder="请选择模板类型">
                <el-option
                  v-for="dict in dict.type.sys_template_type"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择分类">
                <el-option
                  v-for="dict in dict.type.sys_template_category"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排序" prop="sortOrder">
              <el-input-number v-model="form.sortOrder" :min="0" :max="999" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="预览图片" prop="previewImage">
          <image-upload v-model="form.previewImage"/>
        </el-form-item>
        <el-form-item label="模板描述" prop="templateDescription">
          <el-input v-model="form.templateDescription" type="textarea" placeholder="请输入模板描述" />
        </el-form-item>
        <el-form-item label="标签" prop="tags">
          <el-input v-model="form.tags" placeholder="请输入标签，多个标签用逗号分隔" />
        </el-form-item>
        <el-form-item label="模板代码" prop="templateCode">
          <el-input
            v-model="form.templateCode"
            type="textarea"
            :rows="15"
            placeholder="请输入模板代码"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

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
import { listPageTemplate, getPageTemplate, delPageTemplate, addPageTemplate, updatePageTemplate, updatePageTemplateWithCode, addPageTemplateWithCodeBase64, copyTemplateCode, useTemplate } from "@/api/system/pageTemplate";
import ImageUpload from "@/components/ImageUpload";
import ImagePreview from "@/components/ImagePreview";

export default {
  name: "PageTemplate",
  dicts: ['sys_template_type', 'sys_template_category', 'sys_normal_disable'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 页面模板管理表格数据
      templateList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        templateName: null,
        templateType: null,
        category: null,
        status: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        templateName: [
          { required: true, message: "模板名称不能为空", trigger: "blur" }
        ],
        templateType: [
          { required: true, message: "模板类型不能为空", trigger: "change" }
        ]
      },
      // 预览相关
      previewOpen: false,
      previewCode: "",
      previewImage: "",
      activeTab: "code"
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询页面模板管理列表 */
    getList() {
      this.loading = true;
      listPageTemplate(this.queryParams).then(response => {
        this.templateList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        templateId: null,
        templateName: null,
        templateType: null,
        templateDescription: null,
        previewImage: null,
        templateCode: null,
        category: null,
        tags: null,
        downloadCount: 0,
        status: "0",
        sortOrder: 0,
        remark: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.templateId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加页面模板管理";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const templateId = row.templateId || this.ids
      getPageTemplate(templateId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改页面模板管理";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 检查是否包含模板代码
          const hasTemplateCode = this.form.templateCode && this.form.templateCode.trim().length > 0;

          if (this.form.templateId != null) {
            // 修改操作
            if (hasTemplateCode) {
              // 包含代码，使用Base64编码方式
              console.log('修改模板，使用Base64编码保存代码');
              console.log('原始代码长度:', this.form.templateCode.length);
              console.log('原始代码包含template:', this.form.templateCode.includes('<template>'));

              updatePageTemplateWithCode(this.form).then(response => {
                this.$modal.msgSuccess("修改成功");
                this.open = false;
                this.getList();
              }).catch(error => {
                console.error('模板代码保存失败:', error);
                this.$modal.msgError('保存失败: ' + (error.message || '网络错误'));
              });
            } else {
              // 不包含代码，使用普通方式
              updatePageTemplate(this.form).then(response => {
                this.$modal.msgSuccess("修改成功");
                this.open = false;
                this.getList();
              });
            }
          } else {
            // 新增操作
            if (hasTemplateCode) {
              // 包含代码，使用Base64编码方式
              console.log('新增模板，使用Base64编码保存代码');
              console.log('原始代码长度:', this.form.templateCode.length);
              console.log('原始代码包含template:', this.form.templateCode.includes('<template>'));

              const templateData = {
                ...this.form,
                code: this.form.templateCode // 使用code字段传递给Base64编码函数
              };

              addPageTemplateWithCodeBase64(templateData).then(response => {
                this.$modal.msgSuccess("新增成功");
                this.open = false;
                this.getList();
              }).catch(error => {
                console.error('模板代码保存失败:', error);
                this.$modal.msgError('保存失败: ' + (error.message || '网络错误'));
              });
            } else {
              // 不包含代码，使用普通方式
              addPageTemplate(this.form).then(response => {
                this.$modal.msgSuccess("新增成功");
                this.open = false;
                this.getList();
              });
            }
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const templateIds = row.templateId || this.ids;
      this.$modal.confirm('是否确认删除页面模板管理编号为"' + templateIds + '"的数据项？').then(function() {
        return delPageTemplate(templateIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/pageTemplate/export', {
        ...this.queryParams
      }, `pageTemplate_${new Date().getTime()}.xlsx`)
    },
    /** 预览按钮操作 */
    handlePreview(row) {
      getPageTemplate(row.templateId).then(response => {
        this.previewCode = response.data.templateCode;
        this.previewImage = response.data.previewImage;
        this.previewOpen = true;
      });
    },
    /** 复制代码按钮操作 */
    handleCopy(row) {
      copyTemplateCode(row.templateId).then(response => {
        this.$modal.msgSuccess("复制成功，代码已复制到剪贴板");
        // 复制到剪贴板
        this.copyToClipboard(response.data);
      });
    },
    /** 使用模板按钮操作 */
    handleUse(row) {
      useTemplate(row.templateId).then(response => {
        this.$modal.msgSuccess("使用成功");
        this.getList();
      });
    },
    /** 统计按钮操作 */
    handleStatistics() {
      this.$router.push('/system/pageTemplate/statistics');
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
    },
    // 复制到剪贴板
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
    // 复制代码
    copyCode() {
      this.copyToClipboard(this.previewCode);
      this.$modal.msgSuccess("代码已复制到剪贴板");
    }
  }
};
</script>

<style scoped>
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

/* 图片预览组件样式 */
.template-preview .image-preview {
  width: 100%;
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
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

.template-meta .el-tag {
  margin-right: 5px;
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
