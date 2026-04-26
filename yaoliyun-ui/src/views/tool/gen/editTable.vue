<template>
  <el-card>
    <el-tabs v-model="activeName">
      <el-tab-pane label="基本信息" name="basic">
        <basic-info-form ref="basicInfo" :info="info" />
      </el-tab-pane>
      <el-tab-pane label="字段信息" name="columnInfo">
        <el-table ref="dragTable" :data="columns" row-key="columnId" :max-height="tableHeight">
          <el-table-column label="序号" type="index" min-width="5%" class-name="allowDrag"/>
          <el-table-column label="字段列名" prop="columnName" min-width="10%" :show-overflow-tooltip="true" class-name="allowDrag"/>
          <el-table-column label="字段描述" min-width="10%">
            <template slot-scope="scope">
              <el-input v-model="scope.row.columnComment"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            label="物理类型"
            prop="columnType"
            min-width="10%"
            :show-overflow-tooltip="true"
          />
          <el-table-column label="Java类型" min-width="11%">
            <template slot-scope="scope">
              <el-select v-model="scope.row.javaType">
                <el-option label="Long" value="Long" />
                <el-option label="String" value="String" />
                <el-option label="Integer" value="Integer" />
                <el-option label="Double" value="Double" />
                <el-option label="BigDecimal" value="BigDecimal" />
                <el-option label="Date" value="Date" />
                <el-option label="Boolean" value="Boolean" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="java属性" min-width="10%">
            <template slot-scope="scope">
              <el-input v-model="scope.row.javaField"></el-input>
            </template>
          </el-table-column>

          <el-table-column label="插入" min-width="5%">
            <template slot-scope="scope">
              <el-checkbox true-label="1" false-label="0" v-model="scope.row.isInsert"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="编辑" min-width="5%">
            <template slot-scope="scope">
              <el-checkbox true-label="1" false-label="0" v-model="scope.row.isEdit"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="列表" min-width="5%">
            <template slot-scope="scope">
              <el-checkbox true-label="1" false-label="0" v-model="scope.row.isList"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="查询" min-width="5%">
            <template slot-scope="scope">
              <el-checkbox true-label="1" false-label="0" v-model="scope.row.isQuery"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="查询方式" min-width="10%">
            <template slot-scope="scope">
              <el-select v-model="scope.row.queryType">
                <el-option label="=" value="EQ" />
                <el-option label="!=" value="NE" />
                <el-option label=">" value="GT" />
                <el-option label=">=" value="GTE" />
                <el-option label="<" value="LT" />
                <el-option label="<=" value="LTE" />
                <el-option label="LIKE" value="LIKE" />
                <el-option label="BETWEEN" value="BETWEEN" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="必填" min-width="5%">
            <template slot-scope="scope">
              <el-checkbox true-label="1" false-label="0" v-model="scope.row.isRequired"></el-checkbox>
            </template>
          </el-table-column>
          <el-table-column label="显示类型" min-width="12%">
            <template slot-scope="scope">
              <el-select v-model="scope.row.htmlType">
                <el-option label="文本框" value="input" />
                <el-option label="文本域" value="textarea" />
                <el-option label="下拉框" value="select" />
                <el-option label="单选框" value="radio" />
                <el-option label="复选框" value="checkbox" />
                <el-option label="日期控件" value="datetime" />
                <el-option label="图片上传" value="imageUpload" />
                <el-option label="文件上传" value="fileUpload" />
                <el-option label="富文本控件" value="editor" />
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="字典类型" min-width="12%">
            <template slot-scope="scope">
              <el-select v-model="scope.row.dictType" clearable filterable placeholder="请选择">
                <el-option
                  v-for="dict in dictOptions"
                  :key="dict.dictType"
                  :label="dict.dictName"
                  :value="dict.dictType">
                  <span style="float: left">{{ dict.dictName }}</span>
                  <span style="float: right; color: #8492a6; font-size: 13px">{{ dict.dictType }}</span>
              </el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="外键关联" min-width="10%" align="center">
            <template slot-scope="scope">
              <div style="display: flex; align-items: center; justify-content: center; gap: 8px;">
                <el-tag v-if="scope.row.isForeignKey == '1'" type="success" size="small" effect="dark">
                  <i class="el-icon-link"></i> 外键
                </el-tag>
                <el-tag v-else type="info" size="small" plain>普通</el-tag>
                <el-button 
                  type="text" 
                  size="small" 
                  icon="el-icon-setting"
                  @click="openForeignKeyDialog(scope.row)"
                  style="padding: 0; margin-left: 8px;"
                >
                  配置
                </el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="生成信息" name="genInfo">
        <gen-info-form ref="genInfo" :info="info" :tables="tables" :menus="menus"/>
      </el-tab-pane>
      <el-tab-pane label="外键关系" name="foreignKey">
        <div v-if="foreignKeyColumns.length > 0">
          <el-alert
            title="外键关系配置"
            type="info"
            :closable="false"
            show-icon
            style="margin-bottom: 20px;">
            <div style="line-height: 1.8;">
              <p style="margin: 0 0 8px 0;">✨ <strong>智能识别：</strong>系统会自动检测数据库中的外键约束</p>
              <p style="margin: 0 0 8px 0;">✏️ <strong>手动配置：</strong>您也可以在"字段信息"标签页中手动设置外键关联</p>
              <p style="margin: 0;">🎯 <strong>生成效果：</strong>外键字段将自动生成关联查询和下拉选择框代码</p>
            </div>
          </el-alert>
          
          <el-table :data="foreignKeyColumns" border stripe style="width: 100%">
            <el-table-column label="序号" type="index" width="60" align="center" />
            <el-table-column label="外键字段" width="140" align="center">
              <template slot-scope="scope">
                <div style="display: flex; flex-direction: column; align-items: center;">
                  <el-tag type="primary" size="small">{{ scope.row.columnName }}</el-tag>
                  <span style="font-size: 12px; color: #909399; margin-top: 4px;">
                    {{ scope.row.foreignFieldComment || scope.row.columnComment }}
                  </span>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="关联配置" min-width="300">
              <template slot-scope="scope">
                <div style="display: flex; align-items: center; gap: 8px;">
                  <div style="flex: 1;">
                    <div style="font-size: 13px; color: #606266; margin-bottom: 4px;">
                      <i class="el-icon-s-grid" style="color: #409EFF;"></i>
                      <strong>关联表：</strong>
                      <span style="color: #409EFF;">{{ scope.row.foreignTableName || '未配置' }}</span>
                    </div>
                    <div style="font-size: 12px; color: #909399;">
                      <i class="el-icon-connection"></i>
                      <span>关联字段：{{ scope.row.foreignColumnName || '-' }}</span>
                    </div>
                    <div style="font-size: 12px; color: #67C23A; margin-top: 4px;" v-if="scope.row.foreignDisplayField && scope.row.foreignDisplayFieldName">
                      <i class="el-icon-check"></i>
                      <span>已配置 {{ scope.row.foreignDisplayField.split(',').length }} 个关联字段：</span>
                      <el-tag 
                        v-for="(field, index) in getForeignFieldMappingsForRow(scope.row)" 
                        :key="index" 
                        size="mini" 
                        type="success" 
                        style="margin-left: 4px;"
                      >
                        {{ field.foreignField }} → {{ field.javaFieldName }}
                      </el-tag>
                    </div>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="显示字段配置" min-width="280" align="center">
              <template slot-scope="scope">
                <div v-if="parseForeignFieldConfig(scope.row).length > 0" style="display: flex; flex-direction: column; gap: 6px;">
                  <div 
                    v-for="(field, idx) in parseForeignFieldConfig(scope.row)" 
                    :key="idx"
                    style="padding: 6px; background: #f5f7fa; border-radius: 4px; font-size: 12px;"
                  >
                    <div style="margin-bottom: 4px;">
                      <el-tag size="mini" type="primary">{{ field.javaFieldName }}</el-tag>
                      <span style="color: #606266; margin-left: 4px;">{{ field.fieldComment || field.foreignField }}</span>
                    </div>
                    <div>
                      <el-tag size="mini" :type="field.isList === '1' ? 'success' : 'info'">
                        {{ field.isList === '1' ? '列表✓' : '列表✗' }}
                      </el-tag>
                      <el-tag size="mini" :type="field.isQuery === '1' ? 'warning' : 'info'" style="margin-left: 4px;">
                        {{ field.isQuery === '1' ? '查询✓' : '查询✗' }}
                      </el-tag>
                      <el-tag size="mini" v-if="field.isQuery === '1'" style="margin-left: 4px;">
                        {{ field.queryType }}
                      </el-tag>
                    </div>
                  </div>
                </div>
                <div v-else style="color: #909399; font-size: 12px;">
                  <i class="el-icon-info"></i> 未配置显示字段
                </div>
              </template>
            </el-table-column>
            <el-table-column label="状态" width="90" align="center">
              <template slot-scope="scope">
                <el-tag 
                  :type="scope.row.isForeignKey === '1' ? 'success' : 'info'" 
                  size="small"
                  effect="dark"
                >
                  {{ scope.row.isForeignKey === '1' ? '已启用' : '已禁用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" align="center" fixed="right">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  icon="el-icon-edit"
                  @click="openForeignKeyDialog(scope.row)"
                  plain
                >
                  配置
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <el-empty v-else :image-size="100">
          <template slot="description">
            <p style="margin: 0 0 10px 0; font-size: 14px; color: #606266;">该表暂无外键关联</p>
            <p style="margin: 0; font-size: 13px; color: #909399;">
              💡 提示：您可以在<strong style="color: #409EFF;">「字段信息」</strong>标签页中手动设置外键关联
            </p>
          </template>
        </el-empty>
      </el-tab-pane>
    </el-tabs>
    <el-form label-width="100px">
      <el-form-item style="text-align: center;margin-left:-100px;margin-top:10px;">
        <el-button type="primary" @click="submitForm()">提交</el-button>
        <el-button @click="close()">返回</el-button>
      </el-form-item>
    </el-form>

    <!-- 外键配置弹窗 -->
    <el-dialog 
      title="外键关联配置" 
      :visible.sync="foreignKeyDialogVisible" 
      width="800px"
      :close-on-click-modal="false"
    >
      <el-form :model="currentColumn" label-width="120px" v-if="currentColumn">
        <el-form-item label="字段名称">
          <el-input v-model="currentColumn.columnName" disabled>
            <template slot="prepend">
              <i class="el-icon-document"></i>
            </template>
          </el-input>
        </el-form-item>
        
        <el-form-item label="字段说明">
          <el-input v-model="currentColumn.columnComment" disabled>
            <template slot="prepend">
              <i class="el-icon-info"></i>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item label="启用外键关联">
          <el-switch
            v-model="currentColumn.isForeignKey"
            active-value="1"
            inactive-value="0"
            active-text="启用"
            inactive-text="禁用"
            active-color="#67C23A"
            @change="handleForeignKeyDialogToggle"
          >
          </el-switch>
          <div style="margin-top: 8px; font-size: 12px; color: #909399;">
            <i class="el-icon-info"></i> 启用后，该字段将生成下拉选择框代码
          </div>
        </el-form-item>

        <template v-if="currentColumn.isForeignKey == '1'">
          <el-divider></el-divider>
          
          <el-form-item label="关联表名" required>
            <el-select 
              v-model="currentColumn.foreignTableName" 
              placeholder="请选择关联的表"
              filterable
              clearable
              @change="handleForeignTableChange"
              style="width: 100%"
            >
              <el-option
                v-for="table in tables"
                :key="table.tableName"
                :label="table.tableName + '：' + table.tableComment"
                :value="table.tableName"
              >
                <span style="float: left">{{ table.tableComment }}</span>
                <span style="float: right; color: #8492a6; font-size: 13px">{{ table.tableName }}</span>
              </el-option>
            </el-select>
            <div style="margin-top: 8px; font-size: 12px; color: #909399;">
              <i class="el-icon-info"></i> 从数据库表列表中选择要关联的表
            </div>
          </el-form-item>

          <el-form-item label="关联字段" required>
            <el-select 
              v-model="currentColumn.foreignColumnName" 
              placeholder="请选择关联字段"
              filterable
              clearable
              :disabled="!currentColumn.foreignTableName || !foreignTableColumns.length"
              style="width: 100%"
            >
              <el-option
                v-for="column in foreignTableColumns"
                :key="column.columnName"
                :label="column.columnName + '：' + column.columnComment"
                :value="column.columnName"
              >
                <span style="float: left">{{ column.columnComment }}</span>
                <span style="float: right; color: #8492a6; font-size: 13px">{{ column.columnName }}</span>
              </el-option>
            </el-select>
            <div style="margin-top: 8px; font-size: 12px; color: #909399;">
              <i class="el-icon-info"></i> 当前字段关联到目标表的哪个字段（通常是主键 id）
            </div>
          </el-form-item>

          <el-form-item label="关联字段配置" required>
            <el-button 
              type="primary" 
              plain 
              size="small" 
              @click="openFieldMappingDialog"
              :disabled="!currentColumn.foreignTableName || !foreignTableColumns.length"
              style="width: 100%"
            >
              <i class="el-icon-setting"></i> 配置关联字段映射（已配置 {{ foreignFieldMappings.length }} 个）
            </el-button>
            <div style="margin-top: 8px; font-size: 12px; color: #909399;">
              <i class="el-icon-info"></i> 为每个关联字段设置对应的 Java 属性名
            </div>
            
            <!-- 已配置的字段列表 -->
            <el-table 
              v-if="foreignFieldMappings.length > 0"
              :data="foreignFieldMappings" 
              border 
              size="mini" 
              style="margin-top: 10px;"
            >
              <el-table-column label="关联表字段" prop="foreignField" width="150">
                <template slot-scope="scope">
                  <el-tag size="mini" type="success">{{ scope.row.foreignField }}</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="Java字段名" prop="javaFieldName">
                <template slot-scope="scope">
                  <span style="color: #409EFF; font-family: monospace;">{{ scope.row.javaFieldName }}</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="60" align="center">
                <template slot-scope="scope">
                  <el-button 
                    type="text" 
                    size="mini" 
                    icon="el-icon-delete" 
                    @click="removeForeignFieldMapping(scope.$index)"
                    style="color: #F56C6C;"
                  />
                </template>
              </el-table-column>
            </el-table>
          </el-form-item>

          <el-alert
            type="success"
            :closable="false"
            show-icon
            style="margin-top: 10px;">
            <template slot="title">
              <div style="font-size: 13px; line-height: 1.8;">
                <strong>配置说明：</strong><br/>
                <div style="margin-top: 8px;">
                  📌 <strong>关联字段配置：</strong><br/>
                  字段 <code style="background: #f5f7fa; padding: 2px 6px; border-radius: 3px;">user_id</code> 关联 
                  <code style="background: #f5f7fa; padding: 2px 6px; border-radius: 3px;">sys_user</code> 表<br/>
                  <strong>关联字段映射：</strong><br/>
                  &nbsp;&nbsp;• <code>nick_name</code> → <code>nickName</code> - 用户名称 
                  <el-tag size="mini" type="success">列表✓</el-tag> 
                  <el-tag size="mini" type="warning">查询✓</el-tag><br/>
                  &nbsp;&nbsp;• <code>phonenumber</code> → <code>phonenumber</code> - 手机号码 
                  <el-tag size="mini" type="success">列表✓</el-tag> 
                  <el-tag size="mini" type="info">查询✗</el-tag><br/>
                  <span style="color: #67C23A; font-size: 12px; margin-top: 5px; display: inline-block;">
                    ✓ 每个显示字段可单独配置：字段描述、列表显示、查询条件、查询方式
                  </span>
                </div>
              </div>
            </template>
          </el-alert>
        </template>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="foreignKeyDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveForeignKeyConfig">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 字段映射配置对话框 -->
    <el-dialog 
      title="配置关联字段映射" 
      :visible.sync="fieldMappingDialogVisible" 
      width="1000px"
      :close-on-click-modal="false"
      append-to-body
      top="8vh"
    >
      <div style="max-height: 70vh; overflow-y: auto; padding: 0 10px;">
        <el-alert
          type="info"
          :closable="false"
          style="margin-bottom: 15px;">
          <div slot="title" style="font-size: 13px;">
            <strong>关联表：</strong><el-tag type="success" size="small" style="margin-left: 5px;">{{ currentColumn ? currentColumn.foreignTableName : '' }}</el-tag>
            <span style="margin-left: 15px; color: #909399;">为每个关联字段配置独立的Java属性名</span>
          </div>
        </el-alert>

        <el-form label-width="100px" size="small">
          <el-form-item label="添加字段">
            <el-row :gutter="10">
              <el-col :span="10">
                <el-select 
                  v-model="newMapping.foreignField" 
                  placeholder="选择关联表字段"
                  filterable
                  size="small"
                  style="width: 100%"
                  @change="handleNewMappingFieldChange"
                >
                  <el-option
                    v-for="column in availableForeignColumns"
                    :key="column.columnName"
                    :label="column.columnComment || column.columnName"
                    :value="column.columnName"
                  >
                    <span style="float: left">{{ column.columnComment }}</span>
                    <span style="float: right; color: #8492a6; font-size: 12px">{{ column.columnName }}</span>
                  </el-option>
                </el-select>
              </el-col>
              <el-col :span="10">
                <el-input 
                  v-model="newMapping.javaFieldName" 
                  placeholder="Java字段名"
                  size="small"
                  clearable
                  @input="validateJavaFieldName"
                >
                  <template slot="prepend">
                    <i class="el-icon-edit"></i>
                  </template>
                </el-input>
              </el-col>
              <el-col :span="4">
                <el-button type="primary" icon="el-icon-plus" size="small" @click="addFieldMapping" style="width: 100%">添加</el-button>
              </el-col>
            </el-row>
            <div v-if="fieldNameError" style="color: #F56C6C; font-size: 12px; margin-top: 5px;">
              <i class="el-icon-warning"></i> {{ fieldNameError }}
            </div>
          </el-form-item>

          <el-form-item label="已配置字段" style="margin-bottom: 10px;">
            <el-table :data="foreignFieldMappings" border size="mini" max-height="280" style="width: 100%;">
              <el-table-column label="#" type="index" width="40" align="center" />
              <el-table-column label="关联表字段" prop="foreignField" width="120">
                <template slot-scope="scope">
                  <el-tag size="mini" type="success">{{ scope.row.foreignField }}</el-tag>
                  <div style="font-size: 11px; color: #909399; margin-top: 2px;">
                    {{ getForeignFieldComment(scope.row.foreignField) }}
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="Java字段名" prop="javaFieldName" width="140">
                <template slot-scope="scope">
                  <el-input 
                    v-model="scope.row.javaFieldName" 
                    size="mini"
                    placeholder="驼峰命名"
                    @blur="validateAllFieldNames"
                  />
                </template>
              </el-table-column>
              <el-table-column label="字段描述" width="110">
                <template slot-scope="scope">
                  <el-input 
                    v-model="scope.row.fieldComment" 
                    size="mini"
                    placeholder="中文名称"
                  />
                </template>
              </el-table-column>
              <el-table-column label="列表" width="50" align="center">
                <template slot-scope="scope">
                  <el-checkbox 
                    v-model="scope.row.isList" 
                    true-label="1" 
                    false-label="0"
                  />
                </template>
              </el-table-column>
              <el-table-column label="查询" width="50" align="center">
                <template slot-scope="scope">
                  <el-checkbox 
                    v-model="scope.row.isQuery" 
                    true-label="1" 
                    false-label="0"
                  />
                </template>
              </el-table-column>
              <el-table-column label="查询方式"  align="center">
                <template slot-scope="scope">
                  <el-select 
                    v-model="scope.row.queryType" 
                    size="mini"
                    :disabled="scope.row.isQuery !== '1'"
                  >
                    <el-option label="=" value="EQ" />
                    <el-option label="!=" value="NE" />
                    <el-option label="LIKE" value="LIKE" />
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column label="操作"  align="center" fixed="right">
                <template slot-scope="scope">
                  <el-button 
                    type="text" 
                    size="mini" 
                    icon="el-icon-delete" 
                    @click="removeForeignFieldMapping(scope.$index)"
                    style="color: #F56C6C;"
                  />
                </template>
              </el-table-column>
            </el-table>
            <div v-if="foreignFieldMappings.length === 0" style="text-align: center; padding: 15px; color: #909399; background: #f5f7fa; border-radius: 4px; margin-top: 10px;">
              <i class="el-icon-info"></i> 暂无配置，请添加关联字段
            </div>
          </el-form-item>
        </el-form>
      </div>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="fieldMappingDialogVisible = false" size="small">取 消</el-button>
        <el-button type="primary" @click="saveFieldMappings" size="small" :disabled="foreignFieldMappings.length === 0">
          <i class="el-icon-check"></i> 确 定
        </el-button>
      </div>
    </el-dialog>
  </el-card>
</template>

<script>
import { getGenTable, updateGenTable } from "@/api/tool/gen"
import { optionselect as getDictOptionselect } from "@/api/system/dict/type"
import { listMenu as getMenuTreeselect } from "@/api/system/menu"
import basicInfoForm from "./basicInfoForm"
import genInfoForm from "./genInfoForm"
import Sortable from 'sortablejs'

export default {
  name: "GenEdit",
  components: {
    basicInfoForm,
    genInfoForm
  },
  data() {
    return {
      // 选中选项卡的 name
      activeName: "columnInfo",
      // 表格的高度
      tableHeight: document.documentElement.scrollHeight - 245 + "px",
      // 表信息
      tables: [],
      // 表列信息
      columns: [],
      // 字典信息
      dictOptions: [],
      // 菜单信息
      menus: [],
      // 表详细信息
      info: {},
      // 外键配置弹窗
      foreignKeyDialogVisible: false,
      // 当前配置的字段
      currentColumn: null,
      // 外键关联表的字段列表
      foreignTableColumns: [],
      // 字段映射配置弹窗
      fieldMappingDialogVisible: false,
      // 外键字段映射列表
      foreignFieldMappings: [],
      // 新增映射临时对象
      newMapping: {
        foreignField: '',
        javaFieldName: ''
      },
      // 字段名错误提示
      fieldNameError: ''
    }
  },
  computed: {
    // 可选的外键字段（排除已选择的）
    availableForeignColumns() {
      const selectedFields = this.foreignFieldMappings.map(m => m.foreignField)
      return this.foreignTableColumns.filter(col => !selectedFields.includes(col.columnName))
    },
    // 外键字段列表
    foreignKeyColumns() {
      return this.columns.filter(col => col.isForeignKey === '1')
    }
  },
  created() {
    const tableId = this.$route.params && this.$route.params.tableId
    if (tableId) {
      // 获取表详细信息
      getGenTable(tableId).then(res => {
        this.columns = res.data.rows
        this.info = res.data.info
        this.tables = res.data.tables
        
        // 初始化字段的外键默认值
        this.columns.forEach(column => {
          // 如果 isForeignKey 为 null 或 undefined，设置为 '0'
          if (!column.isForeignKey) {
            column.isForeignKey = '0'
          }
        })
        
        // 设置默认的生成类型为"生成到项目目录"
        if (!this.info.genType) {
          this.info.genType = "2"
        }
      })
      /** 查询字典下拉列表 */
      getDictOptionselect().then(response => {
        this.dictOptions = response.data
      })
      /** 查询菜单下拉列表 */
      getMenuTreeselect().then(response => {
        this.menus = this.handleTree(response.data, "menuId")
      })
    }
  },
  methods: {
    /** 提交按钮 */
    submitForm() {
      const basicForm = this.$refs.basicInfo.$refs.basicInfoForm
      const genForm = this.$refs.genInfo.$refs.genInfoForm
      Promise.all([basicForm, genForm].map(this.getFormPromise)).then(res => {
        const validateResult = res.every(item => !!item)
        if (validateResult) {
          const genTable = Object.assign({}, basicForm.model, genForm.model)
          genTable.columns = this.columns
          genTable.params = {
            treeCode: genTable.treeCode,
            treeName: genTable.treeName,
            treeParentCode: genTable.treeParentCode,
            parentMenuId: genTable.parentMenuId
          }
          updateGenTable(genTable).then(res => {
            this.$modal.msgSuccess(res.msg)
            if (res.code === 200) {
              this.close()
            }
          })
        } else {
          this.$modal.msgError("表单校验未通过，请重新检查提交内容")
        }
      })
    },
    getFormPromise(form) {
      return new Promise(resolve => {
        form.validate(res => {
          resolve(res)
        })
      })
    },
    /** 关闭按钮 */
    close() {
      const obj = { path: "/tool/gen", query: { t: Date.now(), pageNum: this.$route.query.pageNum } }
      this.$tab.closeOpenPage(obj)
    },
    /** 外键关联状态切换 */
    handleForeignKeyToggle(row) {
      if (row.isForeignKey === '1') {
        // 启用外键时，自动设置为下拉框
        row.htmlType = 'select'
        
        // 智能推测关联表名：去掉 _id 后缀
        if (!row.foreignTableName && row.columnName.endsWith('_id')) {
          row.foreignTableName = row.columnName.substring(0, row.columnName.length - 3)
          
          // 尝试从字段注释中提取表名（如果注释格式为：用户ID（关联sys_user）或 关联用户）
          if (row.columnComment) {
            const match = row.columnComment.match(/关联([a-z_]+)/i)
            if (match && match[1]) {
              row.foreignTableName = match[1]
            }
          }
        }
        
        // 默认关联字段为 id
        if (!row.foreignColumnName) {
          row.foreignColumnName = 'id'
        }
        
        // 默认显示字段为 name
        if (!row.foreignDisplayField) {
          row.foreignDisplayField = 'name'
        }
        
        this.$message.success({
          message: `已启用字段 ${row.columnName} 的外键关联，请检查并完善关联信息`,
          duration: 3000
        })
      } else {
        // 禁用外键时，清空外键相关字段（可选）
        // row.foreignTableName = null
        // row.foreignColumnName = null
        // row.foreignDisplayField = null
        this.$message.info(`已禁用字段 ${row.columnName} 的外键关联`)
      }
    },
    /** 配置外键 */
    handleConfigForeignKey(row) {
      this.$prompt(`请输入外键字段 ${row.columnName} 关联表的显示字段名称`, '配置外键显示字段', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputValue: row.foreignDisplayField || 'name',
        inputPlaceholder: '如: name, title, hotel_name 等',
        inputValidator: (value) => {
          if (!value || value.trim() === '') {
            return '显示字段不能为空'
          }
          return true
        }
      }).then(({ value }) => {
        row.foreignDisplayField = value
        this.$message.success('外键显示字段配置成功')
      }).catch(() => {
        this.$message.info('已取消配置')
      })
    },
    /** 打开外键配置弹窗 */
    openForeignKeyDialog(row) {
      // 深拷贝当前行数据，避免直接修改
      this.currentColumn = JSON.parse(JSON.stringify(row))
      
      // 确保字段有默认值
      if (!this.currentColumn.isForeignKey) {
        this.currentColumn.isForeignKey = '0'
      }
      
      // 将 foreignDisplayField 字符串转换为数组（支持多选）
      if (this.currentColumn.foreignDisplayField && this.currentColumn.foreignDisplayField.trim()) {
        this.currentColumn.foreignDisplayFields = this.currentColumn.foreignDisplayField.split(',').map(f => f.trim()).filter(f => f)
      } else {
        this.currentColumn.foreignDisplayFields = []
      }
      
      // 确保 foreignDisplayFields 是一个数组（Vue 响应式）
      this.$set(this.currentColumn, 'foreignDisplayFields', this.currentColumn.foreignDisplayFields || [])
      
      // 如果没有自定义字段名，初始化为默认值
      if (!this.currentColumn.foreignDisplayFieldName) {
        this.currentColumn.foreignDisplayFieldName = ''
      }
      
      // 如果已经选择了关联表，加载该表的字段列表
      if (this.currentColumn.foreignTableName) {
        this.loadForeignTableColumns(this.currentColumn.foreignTableName)
      } else {
        this.foreignTableColumns = []
      }
      
      // 初始化字段映射（用于显示）
      if (this.currentColumn.foreignDisplayFieldConfig) {
        // 优先使用JSON配置
        try {
          this.foreignFieldMappings = JSON.parse(this.currentColumn.foreignDisplayFieldConfig)
        } catch (e) {
          console.error('解析外键配置失败:', e)
          this.foreignFieldMappings = []
        }
      } else if (this.currentColumn.foreignDisplayField && this.currentColumn.foreignDisplayFieldName) {
        // 兼容旧格式
        const displayFields = this.currentColumn.foreignDisplayField.split(',').map(f => f.trim()).filter(f => f)
        const fieldNames = this.currentColumn.foreignDisplayFieldName.split(',').map(f => f.trim()).filter(f => f)
        
        this.foreignFieldMappings = displayFields.map((field, index) => {
          const fieldComment = this.getForeignFieldComment(field)
          return {
            foreignField: field,
            javaFieldName: fieldNames[index] || this.toCamelCase(field),
            fieldComment: fieldComment || '',
            isList: '1',
            isQuery: '0',
            queryType: 'EQ'
          }
        })
      } else {
        this.foreignFieldMappings = []
      }
      
      this.foreignKeyDialogVisible = true
    },
    /** 关联表改变时，加载该表的字段列表 */
    handleForeignTableChange(tableName) {
      if (tableName) {
        this.loadForeignTableColumns(tableName)
        // 清空之前选择的字段
        this.currentColumn.foreignColumnName = ''
        this.foreignFieldMappings = []
      } else {
        this.foreignTableColumns = []
        this.foreignFieldMappings = []
      }
    },
    /** 加载关联表的字段列表 */
    loadForeignTableColumns(tableName) {
      // 从 tables 数组中找到对应的表
      const table = this.tables.find(t => t.tableName === tableName)
      if (table && table.columns) {
        this.foreignTableColumns = table.columns
      } else {
        this.foreignTableColumns = []
      }
    },
    /** 弹窗中的外键开关切换 */
    handleForeignKeyDialogToggle() {
      if (this.currentColumn.isForeignKey === '1') {
        // 启用外键时，自动设置为下拉框
        this.currentColumn.htmlType = 'select'
        
        // 智能推测关联表名：去掉 _id 后缀
        if (!this.currentColumn.foreignTableName && this.currentColumn.columnName.endsWith('_id')) {
          let guessedTableName = this.currentColumn.columnName.substring(0, this.currentColumn.columnName.length - 3)
          
          // 尝试从字段注释中提取表名
          if (this.currentColumn.columnComment) {
            const match = this.currentColumn.columnComment.match(/关联([a-z_]+)/i)
            if (match && match[1]) {
              guessedTableName = match[1]
            }
          }
          
          // 检查推测的表名是否存在于表列表中
          const tableExists = this.tables.some(t => t.tableName === guessedTableName)
          if (tableExists) {
            this.currentColumn.foreignTableName = guessedTableName
            // 加载该表的字段列表
            this.loadForeignTableColumns(guessedTableName)
          }
        }
        
        // 默认关联字段为 id
        if (!this.currentColumn.foreignColumnName) {
          this.currentColumn.foreignColumnName = 'id'
        }
        
        // 默认显示字段为 name（支持多个）
        if (!this.currentColumn.foreignDisplayFields || this.currentColumn.foreignDisplayFields.length === 0) {
          // 智能推测常用的显示字段
          const commonDisplayFields = ['name', 'title', 'nick_name', 'user_name', 'dept_name']
          const availableFields = this.foreignTableColumns
            .filter(col => commonDisplayFields.includes(col.columnName))
            .map(col => col.columnName)
          
          const defaultFields = availableFields.length > 0 ? [availableFields[0]] : ['name']
          this.$set(this.currentColumn, 'foreignDisplayFields', defaultFields)
        }
      }
    },
    /** 保存外键配置 */
    saveForeignKeyConfig() {
      // 验证必填项
      if (this.currentColumn.isForeignKey === '1') {
        if (!this.currentColumn.foreignTableName || !this.currentColumn.foreignTableName.trim()) {
          this.$message.error('请选择关联表名')
          return
        }
        if (!this.currentColumn.foreignColumnName || !this.currentColumn.foreignColumnName.trim()) {
          this.$message.error('请选择关联字段')
          return
        }
        if (!this.foreignFieldMappings || this.foreignFieldMappings.length === 0) {
          this.$message.error('请至少配置一个关联字段')
          return
        }
      }
      
      // 使用字段映射的数据
      const foreignDisplayField = this.foreignFieldMappings.map(m => m.foreignField).join(',')
      const foreignDisplayFieldName = this.foreignFieldMappings.map(m => m.javaFieldName).join(',')
      
      // 找到原始数据并更新
      const index = this.columns.findIndex(col => col.columnId === this.currentColumn.columnId)
      if (index !== -1) {
        console.log('=== 保存外键配置 ===')
        console.log('当前字段:', this.currentColumn.columnName)
        console.log('foreignDisplayFieldConfig:', this.currentColumn.foreignDisplayFieldConfig)
        console.log('foreignFieldMappings:', this.foreignFieldMappings)
        
        // 更新字段
        this.$set(this.columns, index, Object.assign({}, this.columns[index], {
          isForeignKey: this.currentColumn.isForeignKey,
          foreignTableName: this.currentColumn.foreignTableName,
          foreignColumnName: this.currentColumn.foreignColumnName,
          foreignDisplayField: foreignDisplayField,
          foreignDisplayFieldName: foreignDisplayFieldName,
          foreignDisplayFieldConfig: this.currentColumn.foreignDisplayFieldConfig,  // JSON配置
          htmlType: this.currentColumn.htmlType
        }))
        
        console.log('更新后的列数据:', this.columns[index])
      }
      
      this.foreignKeyDialogVisible = false
      this.$message.success('外键配置已保存')
    },
    /** 打开字段映射配置对话框 */
    openFieldMappingDialog() {
      // 初始化字段映射列表
      if (this.currentColumn.foreignDisplayFieldConfig) {
        // 优先使用JSON配置（新格式）
        try {
          this.foreignFieldMappings = JSON.parse(this.currentColumn.foreignDisplayFieldConfig)
        } catch (e) {
          console.error('解析外键配置失败:', e)
          this.foreignFieldMappings = []
        }
      } else if (this.currentColumn.foreignDisplayField && this.currentColumn.foreignDisplayFieldName) {
        // 兼容旧格式：解析逗号分隔的字段
        const displayFields = this.currentColumn.foreignDisplayField.split(',').map(f => f.trim()).filter(f => f)
        const fieldNames = this.currentColumn.foreignDisplayFieldName.split(',').map(f => f.trim()).filter(f => f)
        
        this.foreignFieldMappings = displayFields.map((field, index) => {
          const fieldComment = this.getForeignFieldComment(field)
          return {
            foreignField: field,
            javaFieldName: fieldNames[index] || this.toCamelCase(field),
            fieldComment: fieldComment || '',
            isList: '1',      // 默认显示
            isQuery: '0',     // 默认不查询
            queryType: 'EQ'   // 默认等于
          }
        })
      } else {
        this.foreignFieldMappings = []
      }
      
      // 重置新增映射
      this.newMapping = {
        foreignField: '',
        javaFieldName: ''
      }
      
      // 重置错误提示
      this.fieldNameError = ''
      
      this.fieldMappingDialogVisible = true
    },
    /** 新增字段选择时自动填充Java字段名 */
    handleNewMappingFieldChange(value) {
      if (value) {
        // 自动填充为驼峰命名
        this.newMapping.javaFieldName = this.toCamelCase(value)
        // 验证字段名
        this.validateJavaFieldName()
      }
    },
    /** 验证Java字段名 */
    validateJavaFieldName() {
      this.fieldNameError = ''
      
      if (!this.newMapping.javaFieldName || !this.newMapping.javaFieldName.trim()) {
        return
      }
      
      const fieldName = this.newMapping.javaFieldName.trim()
      
      // 检查是否与原表字段重复
      const existsInTable = this.columns.some(col => col.javaField === fieldName)
      if (existsInTable) {
        this.fieldNameError = `字段名 "${fieldName}" 与原表字段重复，请修改`
        return
      }
      
      // 检查是否与已配置的字段重复
      const existsInMappings = this.foreignFieldMappings.some(m => m.javaFieldName === fieldName)
      if (existsInMappings) {
        this.fieldNameError = `字段名 "${fieldName}" 已被使用，请修改`
        return
      }
      
      // 检查命名规范
      if (!/^[a-z][a-zA-Z0-9]*$/.test(fieldName)) {
        this.fieldNameError = '字段名必须以小写字母开头，只能包含字母和数字'
        return
      }
    },
    /** 验证所有字段名 */
    validateAllFieldNames() {
      // 收集所有字段名
      const allFieldNames = []
      
      // 原表字段
      this.columns.forEach(col => {
        allFieldNames.push(col.javaField)
      })
      
      // 检查已配置的字段中是否有重复
      const configuredNames = this.foreignFieldMappings.map(m => m.javaFieldName.trim())
      const duplicates = configuredNames.filter((name, index) => configuredNames.indexOf(name) !== index)
      
      if (duplicates.length > 0) {
        this.$message.warning(`字段名 "${duplicates[0]}" 重复，请修改`)
        return false
      }
      
      // 检查是否与原表字段重复
      for (const mapping of this.foreignFieldMappings) {
        const fieldName = mapping.javaFieldName.trim()
        if (allFieldNames.includes(fieldName)) {
          this.$message.warning(`字段名 "${fieldName}" 与原表字段重复，请修改`)
          return false
        }
      }
      
      return true
    },
    /** 添加字段映射 */
    addFieldMapping() {
      if (!this.newMapping.foreignField) {
        this.$message.warning('请选择关联表字段')
        return
      }
      if (!this.newMapping.javaFieldName || !this.newMapping.javaFieldName.trim()) {
        this.$message.warning('请输入Java字段名')
        return
      }
      
      // 验证字段名
      if (this.fieldNameError) {
        this.$message.error(this.fieldNameError)
        return
      }
      
      // 检查是否已存在
      const exists = this.foreignFieldMappings.some(m => m.foreignField === this.newMapping.foreignField)
      if (exists) {
        this.$message.warning('该字段已添加')
        return
      }
      
      // 获取字段注释作为默认描述
      const fieldComment = this.getForeignFieldComment(this.newMapping.foreignField)
      
      // 添加到列表（包含显示配置）
      this.foreignFieldMappings.push({
        foreignField: this.newMapping.foreignField,
        javaFieldName: this.newMapping.javaFieldName.trim(),
        fieldComment: fieldComment || '',  // 字段描述
        isList: '1',        // 默认在列表显示
        isQuery: '0',       // 默认不作为查询条件
        queryType: 'EQ'     // 默认等于查询
      })
      
      // 重置
      this.newMapping = {
        foreignField: '',
        javaFieldName: ''
      }
      this.fieldNameError = ''
      
      this.$message.success('添加成功')
    },
    /** 删除字段映射 */
    removeForeignFieldMapping(index) {
      this.foreignFieldMappings.splice(index, 1)
      this.$message.success('删除成功')
    },
    /** 保存字段映射 */
    saveFieldMappings() {
      if (this.foreignFieldMappings.length === 0) {
        this.$message.warning('请至少配置一个关联字段')
        return
      }
      
      // 验证所有字段名不为空
      const emptyField = this.foreignFieldMappings.find(m => !m.javaFieldName || !m.javaFieldName.trim())
      if (emptyField) {
        this.$message.error('请为所有字段配置Java字段名')
        return
      }
      
      // 验证所有字段名
      if (!this.validateAllFieldNames()) {
        return
      }
      
      // Trim 所有字段名和字段描述
      this.foreignFieldMappings.forEach(m => {
        m.javaFieldName = m.javaFieldName.trim()
        if (m.fieldComment) {
          m.fieldComment = m.fieldComment.trim()
        }
        // 确保配置属性存在
        if (!m.isList) m.isList = '1'
        if (!m.isQuery) m.isQuery = '0'
        if (!m.queryType) m.queryType = 'EQ'
      })
      
      // 保存到 currentColumn（新格式：JSON）
      this.currentColumn.foreignDisplayFieldConfig = JSON.stringify(this.foreignFieldMappings)
      
      // 同时保存旧格式（为了向后兼容）
      this.currentColumn.foreignDisplayField = this.foreignFieldMappings.map(m => m.foreignField).join(',')
      this.currentColumn.foreignDisplayFieldName = this.foreignFieldMappings.map(m => m.javaFieldName).join(',')
      
      this.fieldMappingDialogVisible = false
      this.$message.success('配置已保存')
    },
    /** 获取外键字段注释 */
    getForeignFieldComment(fieldName) {
      const column = this.foreignTableColumns.find(col => col.columnName === fieldName)
      return column ? column.columnComment : ''
    },
    /** 转换为驼峰命名 */
    toCamelCase(str) {
      if (!str) return ''
      const parts = str.split('_')
      return parts.map((part, index) => {
        if (index === 0) return part.toLowerCase()
        return part.charAt(0).toUpperCase() + part.slice(1).toLowerCase()
      }).join('')
    },
    /** 获取行的字段映射列表（用于显示） */
    getForeignFieldMappingsForRow(row) {
      if (!row.foreignDisplayField || !row.foreignDisplayFieldName) return []
      
      const displayFields = row.foreignDisplayField.split(',').map(f => f.trim()).filter(f => f)
      const fieldNames = row.foreignDisplayFieldName.split(',').map(f => f.trim()).filter(f => f)
      
      return displayFields.map((field, index) => ({
        foreignField: field,
        javaFieldName: fieldNames[index] || field
      }))
    },
    /** 解析外键显示字段配置（用于外键关系标签页显示） */
    parseForeignFieldConfig(row) {
      // 优先使用JSON配置
      if (row.foreignDisplayFieldConfig) {
        try {
          return JSON.parse(row.foreignDisplayFieldConfig)
        } catch (e) {
          console.error('解析外键配置失败:', e)
        }
      }
      
      // 兼容旧格式
      if (row.foreignDisplayField && row.foreignDisplayFieldName) {
        const displayFields = row.foreignDisplayField.split(',').map(f => f.trim()).filter(f => f)
        const fieldNames = row.foreignDisplayFieldName.split(',').map(f => f.trim()).filter(f => f)
        
        return displayFields.map((field, index) => ({
          foreignField: field,
          javaFieldName: fieldNames[index] || field,
          fieldComment: '',
          isList: '1',   // 旧数据默认显示
          isQuery: '0',  // 旧数据默认不查询
          queryType: 'EQ'
        }))
      }
      
      return []
    }
  },
  mounted() {
    const el = this.$refs.dragTable.$el.querySelectorAll(".el-table__body-wrapper > table > tbody")[0]
    const sortable = Sortable.create(el, {
      handle: ".allowDrag",
      onEnd: evt => {
        const targetRow = this.columns.splice(evt.oldIndex, 1)[0]
        this.columns.splice(evt.newIndex, 0, targetRow)
        for (let index in this.columns) {
          this.columns[index].sort = parseInt(index) + 1
        }
      }
    })
  }
}
</script>
