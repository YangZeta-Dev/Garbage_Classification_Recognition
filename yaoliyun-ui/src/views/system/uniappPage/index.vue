<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="页面路径" prop="pagePath">
        <el-input
          v-model="queryParams.pagePath"
          placeholder="请输入页面路径"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="页面标题" prop="pageTitle">
        <el-input
          v-model="queryParams.pageTitle"
          placeholder="请输入页面标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="页面状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="页面状态" clearable>
          <el-option
            v-for="dict in dict.type.uniapp_page_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
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
          @click="handleCreatePage"
          v-hasPermi="['system:uniappPage:create']"
        >创建页面</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:uniappPage:edit']"
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
          v-hasPermi="['system:uniappPage:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-refresh"
          size="mini"
          @click="handleSync"
          v-hasPermi="['system:uniappPage:sync']"
        >同步页面</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:uniappPage:export']"
        >导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-copy-document"
          size="mini"
          @click="handleBackup"
          v-hasPermi="['system:uniappPage:backup']"
        >备份配置</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-menu"
          size="mini"
          @click="handleTabBarManage"
        >导航管理</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-folder-opened"
          size="mini"
          @click="handleBackupManage"
        >备份管理</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="uniappPageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="页面ID" align="center" prop="pageId" />
      <el-table-column label="页面路径" align="center" prop="pagePath" :show-overflow-tooltip="true" />
      <el-table-column label="页面标题" align="center" prop="pageTitle" />
      <el-table-column label="导航栏样式" align="center" prop="navigationStyle">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.uniapp_navigation_style" :value="scope.row.navigationStyle"/>
        </template>
      </el-table-column>
      <el-table-column label="页面状态" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.uniapp_page_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="底部导航" align="center" prop="isTabbar" width="90">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.uniapp_is_tabbar" :value="scope.row.isTabbar"/>
        </template>
      </el-table-column>
      <el-table-column label="排序" align="center" prop="tabbarOrder" width="70">
        <template slot-scope="scope">
          <span v-if="scope.row.isTabbar === '1'">{{ scope.row.tabbarOrder || '-' }}</span>
          <span v-else style="color: #c0c4cc;">-</span>
        </template>
      </el-table-column>
      <el-table-column label="导航文本" align="center" prop="tabbarText" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.isTabbar === '1'">{{ scope.row.tabbarText || '-' }}</span>
          <span v-else style="color: #c0c4cc;">-</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:uniappPage:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:uniappPage:remove']"
          >删除</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDeleteFile(scope.row)"
            v-hasPermi="['system:uniappPage:delete']"
            style="color: #f56c6c;"
          >删除文件</el-button>
          <el-button
            size="mini"
            type="text"
            :icon="scope.row.isTabbar === '1' ? 'el-icon-star-on' : 'el-icon-star-off'"
            @click="handleSetTabBar(scope.row)"
            v-hasPermi="['system:uniappPage:edit']"
            :style="{ color: scope.row.isTabbar === '1' ? '#409EFF' : '#909399' }"
          >{{ scope.row.isTabbar === '1' ? '导航页' : '设导航' }}</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handlePreviewCode(scope.row)"
            v-hasPermi="['system:uniappPage:query']"
            style="color: #67c23a;"
          >预览代码</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改UniApp页面管理对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="页面路径" prop="pagePath">
          <el-input v-model="form.pagePath" placeholder="请输入页面路径，如：pages/product/list" />
        </el-form-item>
        <el-form-item label="页面标题" prop="pageTitle">
          <el-input v-model="form.pageTitle" placeholder="请输入页面标题" />
        </el-form-item>
        <el-form-item  label="导航栏样式" prop="navigationStyle">
          <el-select v-model="form.navigationStyle" placeholder="请选择导航栏样式">
            <el-option
              v-for="dict in dict.type.uniapp_navigation_style"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="页面状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.uniapp_page_status"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="导航页面" prop="isTabbar">
          <el-radio-group v-model="form.isTabbar">
            <el-radio
              v-for="dict in dict.type.uniapp_is_tabbar"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="导航文本" prop="tabbarText" v-if="form.isTabbar === '1'">
          <el-input v-model="form.tabbarText" placeholder="导航显示文本" />
        </el-form-item>
        <el-form-item label="底部排序" prop="tabbarOrder" v-if="form.isTabbar === '1'">
          <el-row :gutter="10">
            <el-col :span="18">
              <el-input-number
                v-model="form.tabbarOrder"
                placeholder="排序号"
                :min="0"
                :max="99"
                controls-position="right"
                style="width: 100%;"
              />
            </el-col>
            <el-col :span="6">
              <el-button
                type="text"
                icon="el-icon-magic-stick"
                @click="generateTabBarOrder"
                style="color: #409EFF;"
              >智能排序</el-button>
            </el-col>
          </el-row>
          <div style="font-size: 12px; color: #999; margin-top: 5px;">
            数字越小越靠前
          </div>
        </el-form-item>
        <el-form-item label="导航图标" v-if="form.isTabbar === '1'">
          <el-row :gutter="10">
            <el-col :span="18">
              <el-input v-model="form.tabbarIconPath" placeholder="未选中图标路径">
                <template slot="prepend">未选中</template>
              </el-input>
            </el-col>
            <el-col :span="6">
              <el-button
                type="text"
                icon="el-icon-picture"
                @click="autoFillIconPaths"
                style="color: #409EFF;"
              >自动填充</el-button>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="选中图标" prop="tabbarSelectedIcon" v-if="form.isTabbar === '1'">
          <el-input v-model="form.tabbarSelectedIcon" placeholder="选中状态图标路径">
            <template slot="prepend">选中</template>
          </el-input>
        </el-form-item>


        <el-form-item label="页面描述" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入页面描述" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 创建页面对话框 -->
    <el-dialog title="创建UniApp页面" :visible.sync="createPageOpen" width="800px" append-to-body>
      <el-form ref="createPageForm" :model="createPageForm" :rules="createPageRules" label-width="100px">
        <el-form-item label="页面路径" prop="pagePath">
          <el-input
            v-model="createPageForm.pagePath"
            placeholder="请输入页面路径，如：pages/product/list"
            @blur="validatePagePath"
          />
          <div style="font-size: 12px; color: #999; margin-top: 5px;">
            注意：只能包含字母、数字、下划线和斜杠
          </div>
          <div v-if="pathValidation.message" :style="{color: pathValidation.valid ? '#67c23a' : '#f56c6c', fontSize: '12px', marginTop: '5px'}">
            {{ pathValidation.message }}
          </div>
        </el-form-item>
        <el-form-item label="页面标题" prop="pageTitle">
          <el-input v-model="createPageForm.pageTitle" placeholder="请输入页面标题" />
        </el-form-item>
        <el-form-item label="导航栏样式" prop="navigationStyle">
          <el-select v-model="createPageForm.navigationStyle" placeholder="请选择导航栏样式">
            <el-option
              v-for="dict in dict.type.uniapp_navigation_style"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        
        <!-- 模板筛选条件 -->
        <el-form-item label="模板筛选">
          <el-row :gutter="10">
            <el-col :span="8">
              <el-select 
                v-model="templateFilter.category" 
                placeholder="选择分类"
                clearable
                @change="filterTemplates"
                size="small"
              >
                <el-option
                  v-for="dict in dict.type.sys_template_category"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-col>
            <el-col :span="8">
              <el-select 
                v-model="templateFilter.templateType" 
                placeholder="选择类型"
                clearable
                @change="filterTemplates"
                size="small"
              >
                <el-option
                  v-for="dict in dict.type.sys_template_type"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-col>
            <el-col :span="8">
              <el-button 
                type="text" 
                icon="el-icon-refresh" 
                @click="resetTemplateFilter"
                size="small"
              >重置筛选</el-button>
            </el-col>
          </el-row>
        </el-form-item>
        
        <el-form-item label="页面模板" prop="templateId">
          <el-row :gutter="10">
            <el-col :span="18">
              <el-select 
                v-model="createPageForm.templateId" 
                placeholder="请选择页面模板（可选）"
                clearable
                filterable
                @change="handleTemplateChange"
              >
                <el-option
                  v-for="template in filteredTemplateList"
                  :key="template.templateId"
                  :label="`${template.templateName} (${getTemplateTypeLabel(template.templateType)})`"
                  :value="template.templateId"
                >
                  <span style="float: left">{{ template.templateName }}</span>
                  <span style="float: right; color: #8492a6; font-size: 13px">
                    {{ getTemplateCategoryLabel(template.category) }}
                  </span>
                </el-option>
              </el-select>
            </el-col>
            <el-col :span="6">
              <el-button
                type="text"
                icon="el-icon-view"
                @click="handlePreviewTemplate"
                :disabled="!createPageForm.templateId"
                style="color: #409EFF;"
              >预览模板</el-button>
            </el-col>
          </el-row>
          <div style="font-size: 12px; color: #999; margin-top: 5px;">
            选择模板后将使用模板代码创建页面，不选择则创建空白页面
          </div>
        </el-form-item>
        <!-- 选中模板时显示模板信息 -->
        <el-form-item v-if="selectedTemplate" label="模板信息">
          <el-card shadow="hover" style="background: #f8f9fa;">
            <div style="display: flex; align-items: center;">
              <div style="flex: 1;">
                <div style="font-weight: bold; margin-bottom: 5px;">{{ selectedTemplate.templateName }}</div>
                <div style="font-size: 12px; color: #666; margin-bottom: 5px;">{{ selectedTemplate.templateDescription }}</div>
                <div>
                  <el-tag size="mini" :type="getTemplateTypeTagType(selectedTemplate.templateType)">
                    {{ getTemplateTypeLabel(selectedTemplate.templateType) }}
                  </el-tag>
                  <el-tag size="mini" type="info" style="margin-left: 5px;">
                    {{ getTemplateCategoryLabel(selectedTemplate.category) }}
                  </el-tag>
                  <el-tag size="mini" type="success" style="margin-left: 5px;" v-if="selectedTemplate.downloadCount">
                    <i class="el-icon-download"></i> {{ selectedTemplate.downloadCount }}
                  </el-tag>
                </div>
              </div>
              <div style="margin-left: 15px;">
                <image-preview 
                  v-if="selectedTemplate.previewImage"
                  :src="selectedTemplate.previewImage" 
                  :width="80" 
                  :height="60"
                  style="border-radius: 4px;"
                />
              </div>
            </div>
          </el-card>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitCreatePage" :loading="createPageLoading">创建页面</el-button>
        <el-button @click="cancelCreatePage">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 模板预览对话框 -->
    <el-dialog title="模板预览" :visible.sync="templatePreviewOpen" width="80%" append-to-body>
      <div v-if="previewTemplate">
        <div style="margin-bottom: 15px;">
          <h3>{{ previewTemplate.templateName }}</h3>
          <p style="color: #666;">{{ previewTemplate.templateDescription }}</p>
          <div>
            <el-tag :type="getTemplateTypeTagType(previewTemplate.templateType)">
              {{ getTemplateTypeLabel(previewTemplate.templateType) }}
            </el-tag>
            <el-tag type="info" style="margin-left: 5px;">
              {{ getTemplateCategoryLabel(previewTemplate.category) }}
            </el-tag>
          </div>
        </div>

        <el-tabs v-model="previewActiveTab" type="card">
          <el-tab-pane label="代码预览" name="code">
            <pre class="template-code-preview">{{ previewTemplate.templateCode || '暂无代码内容' }}</pre>
          </el-tab-pane>
          <el-tab-pane label="效果预览" name="preview" v-if="previewTemplate.previewImage">
            <div class="template-preview-container">
              <image-preview
                :src="previewTemplate.previewImage"
                :width="600"
                :height="400"
                style="max-width: 100%; height: auto;"
              />
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="handleUseTemplate" v-if="previewTemplate">使用此模板</el-button>
        <el-button @click="templatePreviewOpen = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- TabBar管理对话框 -->
    <el-dialog title="底部导航排序" :visible.sync="tabBarManageOpen" width="600px" append-to-body>
      <div style="margin-bottom: 15px; padding: 10px; background: #f5f7fa; border-radius: 4px;">
        <div style="font-size: 14px; color: #606266; margin-bottom: 5px;">
          <i class="el-icon-info"></i> 使用箭头调整导航项目顺序
        </div>
        <div style="font-size: 12px; color: #909399;">
          排序越靠前越靠左显示
        </div>
      </div>

      <div v-if="tabBarPages.length === 0" style="text-align: center; padding: 40px; color: #909399;">
        <i class="el-icon-info" style="font-size: 48px; margin-bottom: 15px;"></i>
        <div>暂无导航页面</div>
        <div style="font-size: 12px; margin-top: 8px;">请先设置页面为底部导航</div>
      </div>

      <div v-else>
        <div
          v-for="(page, index) in tabBarPages"
          :key="page.pageId"
          style="display: flex; align-items: center; padding: 12px; margin-bottom: 8px; border: 1px solid #e4e7ed; border-radius: 4px; background: white;"
        >
          <div style="flex: 1; display: flex; align-items: center;">
            <div style="width: 30px; text-align: center; font-weight: bold; color: #409EFF;">
              {{ index + 1 }}
            </div>
            <div style="margin-left: 10px; flex: 1;">
              <div style="font-size: 14px; font-weight: 500; margin-bottom: 4px;">
                {{ page.pageTitle }}
              </div>
              <div style="font-size: 12px; color: #909399;">
                {{ page.pagePath }}
              </div>
            </div>
            <div style="margin-left: 10px; text-align: center;">
              <div style="font-size: 12px; color: #606266; margin-bottom: 2px;">{{ page.tabbarText }}</div>
              <div style="display: flex; align-items: center; justify-content: center;">
                <img
                  v-if="page.tabbarIconPath"
                  :src="page.tabbarIconPath"
                  style="width: 16px; height: 16px; margin-right: 4px;"
                  onerror="this.style.display='none'"
                />
                <img
                  v-if="page.tabbarSelectedIcon"
                  :src="page.tabbarSelectedIcon"
                  style="width: 16px; height: 16px;"
                  onerror="this.style.display='none'"
                />
              </div>
            </div>
          </div>
          <div style="margin-left: 15px;">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-arrow-up"
              :disabled="index === 0"
              @click="moveTabBarUp(index)"
              title="上移"
            ></el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-arrow-down"
              :disabled="index === tabBarPages.length - 1"
              @click="moveTabBarDown(index)"
              title="下移"
            ></el-button>
          </div>
        </div>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="saveTabBarOrder" :disabled="tabBarPages.length === 0">保存</el-button>
        <el-button @click="tabBarManageOpen = false">取消</el-button>
      </div>
    </el-dialog>

    <!-- 代码预览编辑对话框 -->
    <el-dialog
      :title="`代码编辑 - ${currentPageTitle} (${currentPagePath})`"
      :visible.sync="codePreviewOpen"
      width="85%"
      append-to-body
      :before-close="closeCodePreview"
      class="code-preview-dialog"
    >
      <div style="margin-bottom: 15px; display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center;">
          <el-tag type="info" size="small">{{ currentPagePath }}.vue</el-tag>
          <el-tag
            v-if="isCodeModified()"
            type="warning"
            size="small"
            style="margin-left: 8px;"
          >已修改</el-tag>
        </div>
        <div>
          <el-button
            type="success"
            size="small"
            icon="el-icon-document-copy"
            @click="showTemplateSelector"
            :disabled="codeLoading"
          >选择模板</el-button>
          <el-button
            type="warning"
            size="small"
            icon="el-icon-refresh-left"
            @click="handleRestoreFromBackup"
            :disabled="codeLoading"
          >从备份恢复</el-button>
          <el-button
            type="info"
            size="small"
            icon="el-icon-refresh"
            @click="resetCode"
            :disabled="!isCodeModified() || codeLoading"
          >重置</el-button>
          <el-button
            type="primary"
            size="small"
            icon="el-icon-check"
            @click="saveCode"
            :loading="codeLoading"
            :disabled="!isCodeModified()"
          >保存</el-button>
        </div>
      </div>

      <div v-loading="codeLoading" element-loading-text="加载中...">
        <el-input
          v-model="pageCode"
          type="textarea"
          :rows="25"
          placeholder="页面代码内容..."
          style="font-family: 'Consolas', 'Monaco', 'Courier New', monospace; font-size: 13px; white-space: pre-wrap;"
          :disabled="codeLoading"
          @input="handleCodeInput"
          resize="vertical"
        />
      </div>

      <!-- 代码统计信息 -->
      <div style="margin-top: 10px; padding: 8px; background: #f8f9fa; border-radius: 4px; font-size: 12px; color: #6c757d;">
        <div style="display: flex; justify-content: space-between;">
          <span>字符数: {{ pageCode.length }}</span>
          <span>行数: {{ getLineCount() }}</span>
          <span v-if="isCodeModified()" style="color: #e6a23c;">
            <i class="el-icon-warning"></i> 已修改
          </span>
        </div>
      </div>

      <div style="margin-top: 15px; padding: 10px; background: #f5f7fa; border-radius: 4px; font-size: 12px; color: #606266;">
        <div style="margin-bottom: 5px;">
          <i class="el-icon-info"></i> 代码编辑说明：
        </div>
        <div style="margin-bottom: 3px;">• 支持直接编辑Vue组件代码，保存前会自动备份原文件</div>
        <div style="margin-bottom: 3px;">• 请确保代码语法正确，错误的代码可能导致页面无法正常运行</div>
        <div style="margin-bottom: 3px;">• 可以选择模板快速替换当前页面代码</div>
        <div>• 建议在开发环境下进行代码编辑和测试</div>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="codePreviewOpen = false">关闭</el-button>
        <el-button
          type="primary"
          @click="saveCode"
          :loading="codeLoading"
          :disabled="!isCodeModified()"
        >保存代码</el-button>
      </div>
    </el-dialog>

    <!-- 模板选择器对话框 -->
    <el-dialog title="选择模板替换代码" :visible.sync="templateSelectorOpen" width="70%" append-to-body>
      <div style="margin-bottom: 15px;">
        <el-alert
          title="注意：选择模板将替换当前页面的所有代码内容"
          type="warning"
          :closable="false"
          show-icon
        />
      </div>
      
      <!-- 模板筛选 -->
      <el-row :gutter="15" style="margin-bottom: 15px;">
        <el-col :span="6">
          <el-select 
            v-model="templateSelectorFilter.category" 
            placeholder="选择分类"
            clearable
            @change="filterSelectorTemplates"
            style="width: 100%;"
          >
            <el-option
              v-for="dict in dict.type.sys_template_category"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-select 
            v-model="templateSelectorFilter.templateType" 
            placeholder="选择类型"
            clearable
            @change="filterSelectorTemplates"
            style="width: 100%;"
          >
            <el-option
              v-for="dict in dict.type.sys_template_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-input
            v-model="templateSelectorFilter.keyword"
            placeholder="搜索模板名称"
            @input="filterSelectorTemplates"
            clearable
          />
        </el-col>
        <el-col :span="6">
          <el-button 
            type="text" 
            icon="el-icon-refresh" 
            @click="resetTemplateSelectorFilter"
          >重置筛选</el-button>
        </el-col>
      </el-row>
      
      <!-- 模板列表 -->
      <div style="max-height: 400px; overflow-y: auto;">
        <el-row :gutter="15">
          <el-col :span="8" v-for="template in filteredSelectorTemplateList" :key="template.templateId">
            <el-card 
              class="template-selector-card" 
              shadow="hover"
              :class="{ 'selected': selectedSelectorTemplate && selectedSelectorTemplate.templateId === template.templateId }"
              @click.native="selectSelectorTemplate(template)"
            >
              <div style="text-align: center;">
                <div style="margin-bottom: 10px;">
                  <image-preview 
                    v-if="template.previewImage"
                    :src="template.previewImage" 
                    :width="120" 
                    :height="80"
                    style="border-radius: 4px;"
                  />
                  <div v-else style="width: 120px; height: 80px; background: #f5f5f5; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #999;">
                    无预览图
                  </div>
                </div>
                <h4 style="margin: 0 0 5px 0; font-size: 14px;">{{ template.templateName }}</h4>
                <p style="margin: 0 0 8px 0; font-size: 12px; color: #666; height: 32px; overflow: hidden;">{{ template.templateDescription || '无描述' }}</p>
                <div>
                  <el-tag size="mini" :type="getTemplateTypeTagType(template.templateType)">
                    {{ getTemplateTypeLabel(template.templateType) }}
                  </el-tag>
                  <el-tag size="mini" type="info" style="margin-left: 5px;">
                    {{ getTemplateCategoryLabel(template.category) }}
                  </el-tag>
                </div>
                <div style="margin-top: 5px; font-size: 12px; color: #999;" v-if="template.downloadCount">
                  <i class="el-icon-download"></i> {{ template.downloadCount }}
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        
        <div v-if="filteredSelectorTemplateList.length === 0" style="text-align: center; padding: 40px; color: #999;">
          <i class="el-icon-info" style="font-size: 48px; margin-bottom: 15px;"></i>
          <div>未找到匹配的模板</div>
          <div style="font-size: 12px; margin-top: 8px;">请调整筛选条件</div>
        </div>
      </div>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="templateSelectorOpen = false">取消</el-button>
        <el-button 
          type="primary" 
          @click="applySelectedTemplate"
          :disabled="!selectedSelectorTemplate"
        >
          应用模板
        </el-button>
      </div>
    </el-dialog>

    <!-- 备份文件列表对话框 -->
    <el-dialog
      title="选择备份文件"
      :visible.sync="backupListVisible"
      width="50%"
      :before-close="closeBackupList"
    >
      <div v-loading="backupLoading">
        <el-alert
          title="选择要恢复的备份文件"
          type="info"
          :closable="false"
          style="margin-bottom: 15px;"
        >
        </el-alert>

        <div v-if="backupFiles.length === 0 && !backupLoading" class="text-center">
          <el-empty description="暂无备份文件"></el-empty>
        </div>

        <el-radio-group v-model="selectedBackup" v-if="backupFiles.length > 0">
          <div style="max-height: 300px; overflow-y: auto;">
            <el-radio
              v-for="backup in backupFiles"
              :key="backup"
              :label="backup"
              style="display: block; margin-bottom: 10px; white-space: normal;"
            >
              <div>
                <strong>{{ backup }}</strong>
                <div style="font-size: 12px; color: #999; margin-top: 2px;">
                  备份时间: {{ formatBackupTime(backup) }}
                </div>
              </div>
            </el-radio>
          </div>
        </el-radio-group>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="closeBackupList">取 消</el-button>
        <el-button
          type="primary"
          @click="confirmRestoreFromBackup"
          :disabled="!selectedBackup"
          :loading="backupLoading"
        >
          恢复备份
        </el-button>
      </div>
    </el-dialog>

    <!-- 备份管理对话框 -->
    <el-dialog
      title="备份管理"
      :visible.sync="backupManageVisible"
      width="60%"
      :before-close="closeBackupManage"
    >
      <div v-loading="backupLoading">
        <!-- 清理功能 -->
        <el-card class="box-card" style="margin-bottom: 20px;">
          <div slot="header" class="clearfix">
            <span>备份清理</span>
          </div>
          <el-form inline>
            <el-form-item label="保留天数:">
              <el-input-number v-model="cleanDays" :min="1" :max="365" size="small"></el-input-number>
            </el-form-item>
            <el-form-item>
              <el-button type="danger" size="small" @click="handleCleanBackups">清理旧备份</el-button>
            </el-form-item>
          </el-form>
          <div style="font-size: 12px; color: #999;">
            将删除 {{ cleanDays }} 天前的所有备份文件（包括页面备份和pages.json备份）
          </div>
        </el-card>

        <!-- pages.json备份列表 -->
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>pages.json 备份历史</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="loadPagesJsonBackups">刷新</el-button>
          </div>

          <div v-if="pagesJsonBackups.length === 0 && !backupLoading" class="text-center">
            <el-empty description="暂无pages.json备份文件"></el-empty>
          </div>

          <el-table :data="pagesJsonBackups" v-if="pagesJsonBackups.length > 0" size="small">
            <el-table-column prop="filename" label="备份文件名" show-overflow-tooltip>
              <template slot-scope="scope">
                {{ scope.row }}
              </template>
            </el-table-column>
            <el-table-column label="备份时间" width="150">
              <template slot-scope="scope">
                {{ formatBackupTime(scope.row) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100">
              <template slot-scope="scope">
                <el-button type="text" size="small" @click="viewBackupInfo(scope.row)">详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="closeBackupManage">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listUniappPage, getUniappPage, delUniappPage, addUniappPage, updateUniappPage } from "@/api/system/uniappPage";
import { createPage, deletePage, deletePageByPost, syncPages, validatePath, backup, setTabBar, getPageCode, savePageCode, savePageCodeBase64, restoreFromBackup, getPageBackups, getPagesJsonBackups, cleanBackups } from "@/api/system/uniappPage";
import { listPageTemplate, getPageTemplate } from "@/api/system/pageTemplate";
import ImagePreview from "@/components/ImagePreview";

export default {
  name: "UniappPage",
  components: {
    ImagePreview
  },
  dicts: ['uniapp_page_status', 'uniapp_navigation_style', 'uniapp_is_tabbar', 'sys_template_type', 'sys_template_category'],
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
      // UniApp页面管理表格数据
      uniappPageList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        pagePath: null,
        pageTitle: null,
        navigationStyle: null,
        status: null,
        isTabbar: null,
        tabbarText: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        pagePath: [
          { required: true, message: "页面路径不能为空", trigger: "blur" }
        ],
        pageTitle: [
          { required: true, message: "页面标题不能为空", trigger: "blur" }
        ],
        tabbarOrder: [
          {
            validator: (rule, value, callback) => {
              if (this.form.isTabbar === '1' && (value === null || value === undefined)) {
                callback(new Error('排序不能为空'));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ],
        tabbarText: [
          {
            validator: (rule, value, callback) => {
              if (this.form.isTabbar === '1' && (!value || value.trim() === '')) {
                callback(new Error('导航文本不能为空'));
              } else if (value && value.length > 4) {
                callback(new Error('文本不能超过4个字符'));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ]
      },
      // 创建页面对话框
      createPageOpen: false,
      createPageLoading: false,
      createPageForm: {
        pagePath: '',
        pageTitle: '',
        navigationStyle: 'default',
        templateId: null
      },
      createPageRules: {
        pagePath: [
          { required: true, message: "页面路径不能为空", trigger: "blur" }
        ],
        pageTitle: [
          { required: true, message: "页面标题不能为空", trigger: "blur" }
        ]
      },
      // 路径验证
      pathValidation: {
        valid: null,
        message: ''
      },
      // TabBar管理对话框
      tabBarManageOpen: false,
      tabBarPages: [],
      // 代码预览编辑对话框
      codePreviewOpen: false,
      codeLoading: false,
      currentPagePath: '',
      currentPageTitle: '',
      pageCode: '',
      originalCode: '',
      // 备份管理相关
      backupListVisible: false,
      backupLoading: false,
      currentBackupPagePath: '',
      backupFiles: [],
      selectedBackup: '',
      // 备份管理对话框
      backupManageVisible: false,
      pagesJsonBackups: [],
      cleanDays: 7,
      // 模板相关
      templateList: [], // 模板列表
      selectedTemplate: null, // 选中的模板
      templatePreviewOpen: false, // 模板预览对话框
      previewTemplate: null, // 预览的模板内容
      previewActiveTab: 'code', // 预览对话框的激活标签
      // 模板筛选
      templateFilter: {
        category: null,
        templateType: null
      },
      filteredTemplateList: [], // 筛选后的模板列表
      // 模板选择器对话框
      templateSelectorOpen: false,
      selectedSelectorTemplate: null,
      templateSelectorFilter: {
        category: null,
        templateType: null,
        keyword: null
      },
      filteredSelectorTemplateList: []
    };
  },
  created() {
    this.getList();
    this.loadTemplateList(); // 加载模板列表
  },
  watch: {
    'form.isTabbar'(newVal, oldVal) {
      if (newVal === '1' && oldVal === '0') {
        // 当设置为TabBar页面时，自动生成排序号和默认文本
        this.generateTabBarOrder();
        if (!this.form.tabbarText && this.form.pageTitle) {
          this.form.tabbarText = this.form.pageTitle.length > 4 ? this.form.pageTitle.substring(0, 4) : this.form.pageTitle;
        }
      }
    },
    // 监听模板筛选条件变化，实时更新filteredTemplateList
    templateFilter: {
      handler() {
        this.filterTemplates();
      },
      deep: true
    },
    // 监听模板选择器筛选条件变化，实时更新filteredSelectorTemplateList
    templateSelectorFilter: {
      handler() {
        this.filterSelectorTemplates();
      },
      deep: true
    }
  },
  methods: {
    /** 查询UniApp页面管理列表 */
    getList() {
      this.loading = true;
      listUniappPage(this.queryParams).then(response => {
        this.uniappPageList = response.rows;
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
        pageId: null,
        pagePath: null,
        pageTitle: null,
        navigationStyle: "default",
        status: "0",
        isTabbar: "0",
        tabbarText: null,
        tabbarOrder: 1,
        tabbarSelectedIcon: null,
        tabbarIconPath: null,
        description: null
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
      this.ids = selection.map(item => item.pageId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加UniApp页面管理";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const pageId = row.pageId || this.ids
      getUniappPage(pageId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改UniApp页面管理";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.pageId != null) {
            updateUniappPage(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addUniappPage(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const pageIds = row.pageId || this.ids;
      this.$modal.confirm('是否确认删除UniApp页面管理编号为"' + pageIds + '"的数据项？').then(function() {
       delUniappPage(pageIds).then(res=>{
         console.log(res)
       })
        return delUniappPage(pageIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/uniappPage/export', {
        ...this.queryParams
      }, `uniappPage_${new Date().getTime()}.xlsx`)
    },
    /** 创建页面按钮操作 */
    handleCreatePage() {
      this.createPageForm = {
        pagePath: '',
        pageTitle: '',
        navigationStyle: 'default',
        templateId: null
      };
      this.pathValidation = { valid: null, message: '' };
      this.selectedTemplate = null; // 清空选中的模板
      this.createPageOpen = true;
    },
    /** 验证页面路径 */
    validatePagePath() {
      if (!this.createPageForm.pagePath) {
        this.pathValidation = { valid: null, message: '' };
        return;
      }

      validatePath(this.createPageForm.pagePath).then(response => {
        this.pathValidation = {
          valid: response.valid && !response.exists,
          message: response.message
        };
      }).catch(() => {
        this.pathValidation = { valid: false, message: '验证失败' };
      });
    },
    /** 提交创建页面 */
    submitCreatePage() {
      this.$refs["createPageForm"].validate(valid => {
        if (valid) {
          if (!this.pathValidation.valid) {
            this.$modal.msgError("页面路径验证失败");
            return;
          }

          this.createPageLoading = true;
          createPage(this.createPageForm).then(response => {
            this.$modal.msgSuccess("页面创建成功");
            this.createPageOpen = false;
            this.getList();
          }).finally(() => {
            this.createPageLoading = false;
          });
        }
      });
    },
    /** 取消创建页面 */
    cancelCreatePage() {
      this.createPageOpen = false;
    },
    /** 删除页面文件操作 */
    handleDeleteFile(row) {
      this.$modal.confirm(`是否确认删除页面文件"${row.pagePath}"？此操作将同时删除文件和数据记录，且不可恢复！`).then(function() {
        // 使用POST方式删除，避免CORS问题
        return deletePageByPost(row.pagePath);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("页面文件删除成功");
      }).catch(() => {});
    },
    /** 同步页面操作 */
    handleSync() {
      this.$modal.confirm('是否确认同步pages.json中的页面到数据库？').then(function() {
        return syncPages();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("页面同步成功");
      }).catch(() => {});
    },
    /** 备份配置操作 */
    handleBackup() {
      backup().then(response => {
        this.$modal.msgSuccess("配置备份成功");
      });
    },
    /** 设置底部导航操作 */
    handleSetTabBar(row) {
      const isCurrentlyTabBar = row.isTabbar === '1';
      const action = isCurrentlyTabBar ? '取消' : '设置';
      const newStatus = isCurrentlyTabBar ? '0' : '1';

      let tabbarText = '';
      if (!isCurrentlyTabBar) {
        // 如果要设置为底部导航，提示输入导航文本
        tabbarText = row.pageTitle; // 默认使用页面标题
        this.$prompt(`请输入底部导航显示文本（默认：${tabbarText}）`, `${action}为底部导航`, {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputValue: tabbarText,
          inputValidator: (value) => {
            if (!value || value.trim() === '') {
              return '导航文本不能为空';
            }
            if (value.length > 4) {
              return '导航文本不能超过4个字符';
            }
            return true;
          }
        }).then(({ value }) => {
          this.updateTabBarStatus(row.pageId, newStatus, value.trim());
        }).catch(() => {});
      } else {
        // 如果是取消底部导航，直接确认
        this.$modal.confirm(`是否确认${action}页面"${row.pageTitle}"的底部导航？`).then(() => {
          this.updateTabBarStatus(row.pageId, newStatus, '');
        }).catch(() => {});
      }
    },
    /** 更新底部导航状态 */
    updateTabBarStatus(pageId, isTabbar, tabbarText) {
      setTabBar(pageId, isTabbar, tabbarText).then(response => {
        this.getList();
        const action = isTabbar === '1' ? '设置' : '取消';
        this.$modal.msgSuccess(`${action}底部导航成功`);
      }).catch(error => {
        console.error('设置底部导航失败:', error);
      });
    },
    /** 验证图标路径是否有效 */
    isValidImagePath(path) {
      if (!path) return false;
      const imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp'];
      return imageExtensions.some(ext => path.toLowerCase().endsWith(ext));
    },
    /** 智能生成排序号 */
    generateTabBarOrder() {
      const tabbarPages = this.uniappPageList.filter(page => page.isTabbar === '1' && page.pageId !== this.form.pageId);
      const existingOrders = tabbarPages.map(page => page.tabbarOrder || 0).sort((a, b) => a - b);

      // 找到第一个可用的排序号
      let suggestedOrder = 1;
      for (let order of existingOrders) {
        if (order === suggestedOrder) {
          suggestedOrder++;
        } else {
          break;
        }
      }

      this.form.tabbarOrder = suggestedOrder;
    },
    /** 自动填充图标路径 */
    autoFillIconPaths() {
      if (!this.form.pagePath) return;

      // 根据页面路径推测图标名称
      const pathParts = this.form.pagePath.split('/');
      const pageName = pathParts[pathParts.length - 2] || pathParts[pathParts.length - 1];

      let iconName = pageName;
      if (iconName === 'index' && pathParts.length > 2) {
        iconName = pathParts[pathParts.length - 2];
      }

      // 设置默认图标路径
      this.form.tabbarIconPath = `/static/icons/${iconName}.png`;
      this.form.tabbarSelectedIcon = `/static/icons/${iconName}-selected.png`;

             this.$modal.msgSuccess('已自动填充图标路径');
     },
     /** TabBar管理 */
     handleTabBarManage() {
       this.tabBarPages = this.uniappPageList
         .filter(page => page.isTabbar === '1')
         .sort((a, b) => (a.tabbarOrder || 0) - (b.tabbarOrder || 0));
       this.tabBarManageOpen = true;
     },
     /** 保存TabBar排序 */
     saveTabBarOrder() {
       // 批量更新TabBar页面的排序
       const promises = this.tabBarPages.map((page, index) => {
         const updatedPage = { ...page, tabbarOrder: index + 1 };
         return updateUniappPage(updatedPage);
       });

               Promise.all(promises).then(() => {
          this.$modal.msgSuccess("排序已保存");
          this.tabBarManageOpen = false;
          this.getList();
        }).catch(() => {
          this.$modal.msgError("保存失败");
        });
     },
     /** 上移TabBar项 */
     moveTabBarUp(index) {
       if (index > 0) {
         const temp = this.tabBarPages[index];
         this.$set(this.tabBarPages, index, this.tabBarPages[index - 1]);
         this.$set(this.tabBarPages, index - 1, temp);
       }
     },
     /** 下移TabBar项 */
     moveTabBarDown(index) {
       if (index < this.tabBarPages.length - 1) {
         const temp = this.tabBarPages[index];
         this.$set(this.tabBarPages, index, this.tabBarPages[index + 1]);
         this.$set(this.tabBarPages, index + 1, temp);
       }
     },
     /** 预览页面代码 */
     handlePreviewCode(row) {
       this.currentPagePath = row.pagePath;
       this.currentPageTitle = row.pageTitle;
       this.codeLoading = true;
       this.codePreviewOpen = true;
       this.pageCode = '';
       this.originalCode = '';

       getPageCode(row.pagePath).then(response => {
         if (response.code === 200) {
           // 确保获取原始文本内容，不进行HTML转义
           const rawCode = response.data || '';
           console.log('获取到的原始代码长度:', rawCode.length);
           console.log('代码前100个字符:', rawCode.substring(0, 100));

           this.pageCode = rawCode;
           this.originalCode = rawCode;
         } else {
           this.$modal.msgError(response.msg || '获取页面代码失败');
           this.codePreviewOpen = false;
         }
       }).catch(error => {
         console.error('获取页面代码失败:', error);
         this.$modal.msgError('获取页面代码失败');
         this.codePreviewOpen = false;
       }).finally(() => {
         this.codeLoading = false;
       });
     },
     /** 保存页面代码 */
     saveCode() {
       // 验证代码
       const validation = this.validateCode();
       if (!validation.valid) {
         this.$modal.confirm(`代码验证失败: ${validation.message}。是否仍要保存？`).then(() => {
           this.performSave();
         }).catch(() => {});
         return;
       }

       this.performSave();
     },
     /** 执行保存操作 */
     performSave() {
       this.codeLoading = true;

       // 显示保存前的代码统计和内容检查
       const beforeStats = `保存前: ${this.originalCode.length} 字符, ${this.originalCode.split('\n').length} 行`;
       const afterStats = `保存后: ${this.pageCode.length} 字符, ${this.pageCode.split('\n').length} 行`;
       console.log(beforeStats);
       console.log(afterStats);
       console.log('准备保存的代码前200个字符:', this.pageCode.substring(0, 200));
       console.log('检查是否包含template标签:', this.pageCode.includes('<template>'));
       console.log('检查是否包含view标签:', this.pageCode.includes('<view>'));
console.log(this.pageCode)
       savePageCodeBase64(this.currentPagePath, this.pageCode).then(response => {
         if (response.code === 200) {
           this.$modal.msgSuccess('保存成功');
           this.originalCode = this.pageCode;

           // 保存成功后重新加载验证
           this.$confirm('保存成功！是否重新加载页面内容以验证保存结果？', '验证保存', {
             confirmButtonText: '重新加载',
             cancelButtonText: '取消',
             type: 'success'
           }).then(() => {
             // 重新加载页面代码进行验证
             this.handlePreviewCode({ pagePath: this.currentPagePath, pageTitle: this.currentPageTitle });
           }).catch(() => {});

         } else {
           this.$modal.msgError(response.msg || '保存失败');
         }
       }).catch(error => {
         console.error('保存页面代码失败:', error);
         this.$modal.msgError('保存失败: ' + (error.message || '网络错误'));
       }).finally(() => {
         this.codeLoading = false;
       });
     },
     /** 重置代码 */
     resetCode() {
       this.pageCode = this.originalCode;
       this.$modal.msgSuccess('已重置为原始代码');
     },
     /** 关闭代码预览 */
     closeCodePreview() {
       if (this.pageCode !== this.originalCode) {
         this.$modal.confirm('代码已修改，是否保存？').then(() => {
           this.saveCode();
         }).catch(() => {
           this.codePreviewOpen = false;
         });
       } else {
         this.codePreviewOpen = false;
       }
     },
     /** 检查代码是否已修改 */
     isCodeModified() {
       return this.pageCode !== this.originalCode;
     },
         /** 从备份恢复 - 显示备份列表 */
    handleRestoreFromBackup() {
      this.currentBackupPagePath = this.currentPagePath;
      this.loadBackupFiles();
    },
    /** 加载备份文件列表 */
    loadBackupFiles() {
      this.backupLoading = true;
      getPageBackups(this.currentBackupPagePath).then(response => {
        if (response.code === 200) {
          this.backupFiles = response.data || [];
          this.backupListVisible = true;
          if (this.backupFiles.length === 0) {
            this.$modal.msgWarning('该页面暂无备份文件');
          }
        } else {
          this.$modal.msgError(response.msg || '获取备份列表失败');
        }
      }).catch(() => {
        this.$modal.msgError('获取备份列表失败');
      }).finally(() => {
        this.backupLoading = false;
      });
    },
    /** 确认从备份恢复 */
    confirmRestoreFromBackup() {
      if (!this.selectedBackup) {
        this.$modal.msgWarning('请选择要恢复的备份文件');
        return;
      }

      this.$confirm('确认从备份文件恢复页面代码？当前内容将被覆盖！', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.backupLoading = true;
        restoreFromBackup(this.currentBackupPagePath, this.selectedBackup).then(response => {
          if (response.code === 200) {
            this.$modal.msgSuccess('从备份恢复成功');
            this.backupListVisible = false;
            this.handlePreviewCode({ pagePath: this.currentPagePath, pageTitle: this.currentPageTitle }); // 重新加载代码
          } else {
            this.$modal.msgError(response.msg || '从备份恢复失败');
          }
        }).catch(() => {
          this.$modal.msgError('从备份恢复失败');
        }).finally(() => {
          this.backupLoading = false;
        });
      }).catch(() => {});
    },
    /** 关闭备份列表 */
    closeBackupList() {
      this.backupListVisible = false;
      this.selectedBackup = '';
      this.backupFiles = [];
    },
    /** 格式化备份时间 */
    formatBackupTime(filename) {
      // 提取时间戳：例如 pages_ai_chat.20250125201734.backup
      const match = filename.match(/\.(\d{14})\./);
      if (match && match[1]) {
        const timestamp = match[1];
        const year = timestamp.substr(0, 4);
        const month = timestamp.substr(4, 2);
        const day = timestamp.substr(6, 2);
        const hour = timestamp.substr(8, 2);
        const minute = timestamp.substr(10, 2);
        const second = timestamp.substr(12, 2);
        return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
      }
      return '未知时间';
    },
    /** 备份管理 */
    handleBackupManage() {
      this.backupManageVisible = true;
      this.loadPagesJsonBackups();
    },
    /** 加载pages.json备份列表 */
    loadPagesJsonBackups() {
      this.backupLoading = true;
      getPagesJsonBackups().then(response => {
        if (response.code === 200) {
          this.pagesJsonBackups = response.data || [];
        } else {
          this.$modal.msgError(response.msg || '获取pages.json备份列表失败');
        }
      }).catch(() => {
        this.$modal.msgError('获取pages.json备份列表失败');
      }).finally(() => {
        this.backupLoading = false;
      });
    },
    /** 清理旧备份 */
    handleCleanBackups() {
      this.$confirm(`确认清理${this.cleanDays}天前的旧备份文件？`, '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.backupLoading = true;
        cleanBackups(this.cleanDays).then(response => {
          if (response.code === 200) {
            this.$modal.msgSuccess('清理备份文件成功');
            this.loadPagesJsonBackups(); // 刷新列表
          } else {
            this.$modal.msgError(response.msg || '清理备份文件失败');
          }
        }).catch(() => {
          this.$modal.msgError('清理备份文件失败');
        }).finally(() => {
          this.backupLoading = false;
        });
      }).catch(() => {});
    },
    /** 关闭备份管理 */
    closeBackupManage() {
      this.backupManageVisible = false;
      this.pagesJsonBackups = [];
    },
    /** 查看备份详情 */
    viewBackupInfo(filename) {
      this.$alert(`备份文件: ${filename}\n备份时间: ${this.formatBackupTime(filename)}\n位置: backups/pages.json/`, '备份详情', {
        confirmButtonText: '确定'
      });
    },
     /** 处理代码输入 */
     handleCodeInput() {
       // 实时检测并保存修改状态
       // 这里可以添加防抖处理，避免过于频繁的检测
     },
     /** 获取代码行数 */
     getLineCount() {
       if (!this.pageCode) return 0;
       return this.pageCode.split('\n').length;
     },
     /** 验证代码基本语法 */
     validateCode() {
       if (!this.pageCode.trim()) {
         return { valid: false, message: '代码不能为空' };
       }

       // 检查基本的Vue文件结构
       const hasTemplate = this.pageCode.includes('<template>');
       const hasScript = this.pageCode.includes('<script>');

       if (!hasTemplate) {
         return { valid: false, message: '缺少 <template> 标签' };
       }

       // 检查标签是否配对
       const tags = ['template', 'script', 'style'];
       for (let tag of tags) {
         const openTags = (this.pageCode.match(new RegExp(`<${tag}[^>]*>`, 'g')) || []).length;
         const closeTags = (this.pageCode.match(new RegExp(`</${tag}>`, 'g')) || []).length;

         if (openTags !== closeTags) {
           return { valid: false, message: `${tag} 标签不匹配` };
         }
       }

       return { valid: true, message: '代码格式正确' };
     },
           /** 加载模板列表 */
      loadTemplateList() {
        // 获取页面模板列表，获取所有可用的模板
        listPageTemplate({
          pageNum: 1,
          pageSize: 100,
          status: '0' // 只获取启用状态的模板
        }).then(response => {
          this.templateList = response.rows || [];
          this.filteredTemplateList = this.templateList; // 初始化筛选列表
          this.filteredSelectorTemplateList = this.templateList; // 初始化选择器筛选列表
        }).catch(() => {
          console.warn('获取模板列表失败，将使用空列表');
          this.templateList = [];
          this.filteredTemplateList = [];
          this.filteredSelectorTemplateList = [];
        });
      },
           /** 预览模板 */
      handlePreviewTemplate() {
        if (!this.createPageForm.templateId) {
          this.$modal.msgWarning('请先选择一个模板');
          return;
        }

        // 获取完整的模板信息（包含代码）
        getPageTemplate(this.createPageForm.templateId).then(response => {
          this.previewTemplate = response.data;
          this.previewActiveTab = 'code';
          this.templatePreviewOpen = true;
        }).catch(() => {
          this.$modal.msgError('获取模板详情失败');
        });
      },
           /** 使用模板 */
      handleUseTemplate() {
        if (!this.previewTemplate) return;

        // 将选中的模板应用到创建表单
        this.createPageForm.templateId = this.previewTemplate.templateId;

        this.templatePreviewOpen = false; // 关闭预览对话框
        this.$modal.msgSuccess('已选择模板，请完善页面信息后创建');
      },
           /** 获取模板类型标签类型 */
      getTemplateTypeTagType(type) {
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
      /** 获取模板类型标签文本 - 使用字典数据 */
      getTemplateTypeLabel(type) {
        const typeDict = this.dict.type.sys_template_type.find(item => item.value === type);
        return typeDict ? typeDict.label : type;
      },
      /** 获取模板类别标签文本 - 使用字典数据 */
      getTemplateCategoryLabel(category) {
        const categoryDict = this.dict.type.sys_template_category.find(item => item.value === category);
        return categoryDict ? categoryDict.label : category;
      },
     /** 模板选择变化 */
     handleTemplateChange(templateId) {
       this.selectedTemplate = this.templateList.find(t => t.templateId === templateId) || null;
     },
     /** 筛选模板 */
     filterTemplates() {
       this.filteredTemplateList = this.templateList.filter(template => {
         const categoryMatch = this.templateFilter.category ? template.category === this.templateFilter.category : true;
         const typeMatch = this.templateFilter.templateType ? template.templateType === this.templateFilter.templateType : true;
         return categoryMatch && typeMatch;
       });
     },
     /** 重置模板筛选 */
     resetTemplateFilter() {
       this.templateFilter = {
         category: null,
         templateType: null
       };
       this.filterTemplates(); // 重新应用筛选
     },
     /** 显示模板选择器 */
     showTemplateSelector() {
       this.templateSelectorOpen = true;
       this.selectedSelectorTemplate = null; // 清空选中的模板
     },
     /** 选择模板 */
     selectSelectorTemplate(template) {
       this.selectedSelectorTemplate = template;
     },
     /** 应用选中的模板 */
     applySelectedTemplate() {
       if (!this.selectedSelectorTemplate) {
         this.$modal.msgWarning('请选择一个模板');
         return;
       }

       this.$confirm(`确定要将当前页面代码替换为模板 "${this.selectedSelectorTemplate.templateName}" 的代码吗？此操作将自动保存到页面文件。`, '警告', {
         confirmButtonText: '确定',
         cancelButtonText: '取消',
         type: 'warning'
       }).then(() => {
         this.codeLoading = true;
         getPageTemplate(this.selectedSelectorTemplate.templateId).then(response => {
           if (response.code === 200) {
             const templateCode = response.data.templateContent || response.data.templateCode;
             this.pageCode = templateCode;
             this.originalCode = templateCode; // 保存原始代码
             
             // 自动保存代码到页面文件
             this.savePageCodeToFile(templateCode);
           } else {
             this.$modal.msgError(response.msg || '应用模板失败');
             this.codeLoading = false;
             this.templateSelectorOpen = false;
           }
         }).catch(() => {
           this.$modal.msgError('应用模板失败');
           this.codeLoading = false;
           this.templateSelectorOpen = false;
         });
       }).catch(() => {});
     },
     
           /** 保存代码到页面文件 */
      savePageCodeToFile(code) {
        if (!this.currentPagePath) {
          this.$modal.msgError('页面路径不能为空');
          this.codeLoading = false;
          this.templateSelectorOpen = false;
          return;
        }

        // 使用与手动保存相同的API方法
        savePageCodeBase64(this.currentPagePath, code || this.pageCode).then(response => {
          if (response.code === 200) {
            this.$modal.msgSuccess('模板已应用并保存到页面文件');
            this.originalCode = code || this.pageCode; // 更新原始代码
            // 刷新页面列表以显示最新状态
            this.getList();
          } else {
            this.$modal.msgError(response.msg || '保存代码失败');
          }
        }).catch(error => {
          console.error('保存代码失败:', error);
          this.$modal.msgError('保存代码失败');
        }).finally(() => {
          this.codeLoading = false;
          this.templateSelectorOpen = false;
        });
      },
     /** 重置模板选择器筛选 */
     resetTemplateSelectorFilter() {
       this.templateSelectorFilter = {
         category: null,
         templateType: null,
         keyword: null
       };
       this.filterSelectorTemplates(); // 重新应用筛选
     },
     /** 筛选模板选择器模板 */
     filterSelectorTemplates() {
       this.filteredSelectorTemplateList = this.templateList.filter(template => {
         const categoryMatch = this.templateSelectorFilter.category ? template.category === this.templateSelectorFilter.category : true;
         const typeMatch = this.templateSelectorFilter.templateType ? template.templateType === this.templateSelectorFilter.templateType : true;
         const keywordMatch = this.templateSelectorFilter.keyword ? template.templateName.includes(this.templateSelectorFilter.keyword) : true;
         return categoryMatch && typeMatch && keywordMatch;
       });
     }
  }
};
</script>

<style scoped>
.code-preview-dialog .el-dialog {
  margin-top: 5vh !important;
}

.code-preview-dialog .el-dialog__body {
  padding: 20px;
}

.code-preview-dialog .el-textarea__inner {
  resize: vertical;
  min-height: 600px;
  line-height: 1.4;
}

.code-preview-dialog .el-tag {
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
}

/* 模板预览样式 */
.template-code-preview {
  background: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 13px;
  line-height: 1.5;
  white-space: pre-wrap;
  word-wrap: break-word;
  max-height: 500px;
  overflow-y: auto;
  border: 1px solid #ddd;
}

.template-preview-container {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  min-height: 400px;
  background: #fff;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 模板选择卡片样式 */
.el-card {
  border-radius: 8px;
  border: 1px solid #e4e7ed;
  transition: all 0.3s;
}

.el-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* 模板选择器卡片样式 */
.template-selector-card {
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 15px;
  border: 2px solid transparent;
}

.template-selector-card:hover {
  border-color: #409EFF;
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.15);
  transform: translateY(-2px);
}

.template-selector-card.selected {
  border-color: #409EFF;
  background-color: #f0f8ff;
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.2);
}

.template-selector-card .el-card__body {
  padding: 15px;
}

/* 模板筛选区域样式 */
.el-form-item__label {
  font-weight: 500;
  color: #606266;
}

/* 模板信息卡片样式 */
.el-card.template-info-card {
  border: 1px solid #e1f3d8;
  background: linear-gradient(135deg, #f8fffe 0%, #f0f8ff 100%);
}

/* 响应式布局优化 */
@media (max-width: 768px) {
  .template-selector-card {
    margin-bottom: 10px;
  }
  
  .el-col {
    margin-bottom: 10px;
  }
}
</style>
