<template>
  <div class="app-container">
    <!-- 面包屑导航 -->
    <el-breadcrumb class="app-breadcrumb" separator="/">
      <el-breadcrumb-item>
        <router-link to="/tool/dbmanage">数据库管理</router-link>
      </el-breadcrumb-item>
      <el-breadcrumb-item>{{ tableName }}</el-breadcrumb-item>
    </el-breadcrumb>

    <!-- 表基本信息 -->
    <el-card class="mb20">
      <div slot="header" class="clearfix">
        <span>表信息</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="refreshTableInfo">刷新</el-button>
      </div>
      <el-descriptions v-if="tableInfo" :column="3" border>
        <el-descriptions-item label="表名">{{ tableInfo.tableName }}</el-descriptions-item>
        <el-descriptions-item label="表注释">{{ tableInfo.tableComment || '无' }}</el-descriptions-item>
        <el-descriptions-item label="引擎">{{ tableInfo.engine }}</el-descriptions-item>
        <el-descriptions-item label="字符集">{{ tableInfo.charset }}</el-descriptions-item>
        <el-descriptions-item label="排序规则">{{ tableInfo.collation }}</el-descriptions-item>
        <el-descriptions-item label="表类型">{{ tableInfo.tableType }}</el-descriptions-item>
        <el-descriptions-item label="行数">{{ tableInfo.tableRows | numberFormat }}</el-descriptions-item>
        <el-descriptions-item label="数据大小">{{ tableInfo.dataLength | sizeFormat }}</el-descriptions-item>
        <el-descriptions-item label="索引大小">{{ tableInfo.indexLength | sizeFormat }}</el-descriptions-item>
        <el-descriptions-item label="自动递增">{{ tableInfo.autoIncrement || '无' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(tableInfo.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ parseTime(tableInfo.updateTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</el-descriptions-item>
      </el-descriptions>
      
      <div style="margin-top: 20px;">
        <el-button type="primary" size="mini" @click="handleAlterTable">修改表</el-button>
        <el-button type="success" size="mini" @click="showCreateSql">查看建表SQL</el-button>
        <el-button type="info" size="mini" @click="handleBackupTable">备份表</el-button>
        <el-button type="warning" size="mini" @click="handleRename">重命名</el-button>
        <el-button type="danger" size="mini" @click="handleDropTable">删除表</el-button>
      </div>
    </el-card>

    <!-- 编辑模式提示和操作按钮 -->
    <el-card v-if="isEditMode" style="margin-top: 20px;">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
          <el-alert 
            title="批量编辑模式" 
            type="info" 
                         description="您可以直接修改表格中的字段信息，修改完成后点击保存所有更改按钮统一提交。" 
            :closable="false" 
            show-icon 
            style="border: none; padding: 0;">
          </el-alert>
        </div>
        <div>
          <el-button type="success" size="small" icon="el-icon-check" @click="saveAllChanges" :disabled="!hasChanges">保存所有更改</el-button>
          <el-button type="info" size="small" icon="el-icon-refresh" @click="resetAllChanges">重置更改</el-button>
        </div>
      </div>
    </el-card>

    <!-- Tab切换 -->
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <!-- 字段管理 -->
      <el-tab-pane label="字段管理" name="columns">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="columnSingle" @click="handleUpdateColumn">修改字段</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="columnMultiple" @click="handleDeleteColumn">删除字段</el-button>
          </el-col>
        </el-row>

        <el-table v-loading="columnLoading" :data="columnList" @selection-change="handleColumnSelectionChange" :row-class-name="getRowClassName">
          <el-table-column type="selection" width="55" align="center" />
          <el-table-column label="序号" type="index" width="50" align="center" />
          <el-table-column label="字段名" prop="columnName" :show-overflow-tooltip="true" min-width="120">
            <template slot-scope="scope">
              <div style="display: flex; align-items: center; gap: 5px;">
                <el-tag v-if="scope.row.columnKey === 'PRI'" type="danger" size="mini">PK</el-tag>
                <el-input 
                  v-if="isEditMode || scope.row.isNewField" 
                  v-model="scope.row.columnName" 
                  size="mini"
                  @input="markAsChanged"
                  style="flex: 1;"
                  placeholder="请输入字段名"
                />
                <span v-else>
                  {{ scope.row.columnName }}
                </span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="数据类型" prop="columnType" min-width="100">
            <template slot-scope="scope">
              <el-select 
                v-if="isEditMode || scope.row.isNewField" 
                v-model="scope.row.dataType" 
                size="mini"
                @change="updateColumnType(scope.row); markAsChanged()"
                placeholder="选择类型"
              >
                <el-option label="TINYINT" value="TINYINT"></el-option>
                <el-option label="SMALLINT" value="SMALLINT"></el-option>
                <el-option label="MEDIUMINT" value="MEDIUMINT"></el-option>
                <el-option label="INT" value="INT"></el-option>
                <el-option label="BIGINT" value="BIGINT"></el-option>
                <el-option label="FLOAT" value="FLOAT"></el-option>
                <el-option label="DOUBLE" value="DOUBLE"></el-option>
                <el-option label="DECIMAL" value="DECIMAL"></el-option>
                <el-option label="CHAR" value="CHAR"></el-option>
                <el-option label="VARCHAR" value="VARCHAR"></el-option>
                <el-option label="TEXT" value="TEXT"></el-option>
                <el-option label="MEDIUMTEXT" value="MEDIUMTEXT"></el-option>
                <el-option label="LONGTEXT" value="LONGTEXT"></el-option>
                <el-option label="DATE" value="DATE"></el-option>
                <el-option label="TIME" value="TIME"></el-option>
                <el-option label="DATETIME" value="DATETIME"></el-option>
                <el-option label="TIMESTAMP" value="TIMESTAMP"></el-option>
                <el-option label="YEAR" value="YEAR"></el-option>
                <el-option label="BLOB" value="BLOB"></el-option>
                <el-option label="LONGBLOB" value="LONGBLOB"></el-option>
                <el-option label="BOOLEAN" value="BOOLEAN"></el-option>
              </el-select>
              <span v-else>
                {{ scope.row.columnType }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="长度" prop="columnLength" width="80" align="center">
            <template slot-scope="scope">
              <el-input 
                v-if="isEditMode || scope.row.isNewField" 
                v-model="scope.row.columnLength" 
                size="mini"
                @input="markAsChanged"
                placeholder="长度"
              />
              <span v-else>
                {{ scope.row.columnLength }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="小数位" prop="columnScale" width="80" align="center">
            <template slot-scope="scope">
              <el-input 
                v-if="isEditMode || scope.row.isNewField" 
                v-model="scope.row.columnScale" 
                size="mini"
                @input="markAsChanged"
                placeholder="小数位"
              />
              <span v-else>
                {{ scope.row.columnScale }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="允许空" prop="isNullable" width="80" align="center">
            <template slot-scope="scope">
              <el-select 
                v-if="isEditMode || scope.row.isNewField" 
                v-model="scope.row.isNullable" 
                size="mini"
                @change="markAsChanged"
                placeholder="选择"
              >
                <el-option label="是" value="YES"></el-option>
                <el-option label="否" value="NO"></el-option>
              </el-select>
              <el-tag v-else :type="scope.row.isNullable === 'YES' ? 'success' : 'danger'" size="mini">
                {{ scope.row.isNullable === 'YES' ? '是' : '否' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="默认值" prop="columnDefault" width="100" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <el-input 
                v-if="isEditMode || scope.row.isNewField" 
                v-model="scope.row.columnDefault" 
                size="mini"
                @input="markAsChanged"
                placeholder="默认值"
              />
              <span v-else>
                {{ scope.row.columnDefault }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="字段注释" prop="columnComment" :show-overflow-tooltip="true" min-width="150">
            <template slot-scope="scope">
              <el-input 
                v-if="isEditMode || scope.row.isNewField" 
                v-model="scope.row.columnComment" 
                size="mini"
                @input="markAsChanged"
                placeholder="字段注释"
              />
              <span v-else>
                {{ scope.row.columnComment }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="额外信息" prop="extra" width="120" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <div v-if="isEditMode || scope.row.isNewField">
                <el-checkbox v-model="scope.row.autoIncrement" @change="handleAutoIncrementChange(scope.row)" size="mini">自增</el-checkbox>
              </div>
              <span v-else>
                {{ scope.row.extra }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="180" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <template v-if="isEditMode || scope.row.isNewField">
                <el-button 
                  v-if="scope.row.isNewField" 
                  size="mini" 
                  type="success" 
                  icon="el-icon-check" 
                  @click="saveNewField(scope.row, scope.$index)"
                >保存</el-button>
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-delete" 
                  @click="handleDeleteColumn(scope.row, scope.$index)"
                >删除</el-button>
              </template>
              <template v-else>
                <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdateColumn(scope.row)">修改</el-button>
                <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDeleteColumn(scope.row)">删除</el-button>
              </template>
            </template>
          </el-table-column>
        </el-table>
        
        <!-- 添加字段行 -->
        <div style="margin-top: 10px; text-align: center;">
          <el-button 
            type="primary" 
            plain 
            icon="el-icon-plus" 
            size="mini" 
            @click="handleAddColumn"
          >添加字段</el-button>
        </div>
      </el-tab-pane>

      <!-- 索引管理 -->
      <el-tab-pane label="索引管理" name="indexes">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAddIndex">添加索引</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="indexMultiple" @click="handleDeleteIndex">删除索引</el-button>
          </el-col>
        </el-row>

        <el-table v-loading="indexLoading" :data="indexList" @selection-change="handleIndexSelectionChange">
          <el-table-column type="selection" width="55" align="center" />
          <el-table-column label="索引名" prop="indexName" :show-overflow-tooltip="true" min-width="120"/>
          <el-table-column label="索引类型" prop="indexType" width="100">
            <template slot-scope="scope">
              <el-tag :type="getIndexTypeColor(scope.row.indexType)" size="mini">{{ scope.row.indexType }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="是否唯一" prop="nonUnique" width="100" align="center">
            <template slot-scope="scope">
              <el-tag :type="scope.row.nonUnique ? 'info' : 'success'" size="mini">
                {{ scope.row.nonUnique ? '否' : '是' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="字段名" prop="columnName" :show-overflow-tooltip="true" min-width="120"/>
          <el-table-column label="排序" prop="collation" width="80" align="center"/>
          <el-table-column label="基数" prop="cardinality" width="100" align="center"/>
          <el-table-column label="索引方法" prop="indexMethod" width="100"/>
          <el-table-column label="注释" prop="indexComment" :show-overflow-tooltip="true" min-width="150"/>
          <el-table-column label="操作" align="center" width="100" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <el-button 
                v-if="scope.row.indexName !== 'PRIMARY'"
                size="mini" 
                type="text" 
                icon="el-icon-delete" 
                @click="handleDeleteIndex(scope.row)"
              >删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>



    <!-- 索引编辑对话框 -->
    <el-dialog :title="indexTitle" :visible.sync="indexOpen" width="500px" append-to-body>
      <el-form ref="indexForm" :model="indexForm" :rules="indexRules" label-width="100px">
        <el-form-item label="索引名" prop="indexName">
          <el-input v-model="indexForm.indexName" placeholder="请输入索引名"/>
        </el-form-item>
        <el-form-item label="索引类型" prop="indexType">
          <el-select v-model="indexForm.indexType" placeholder="请选择索引类型" style="width: 100%;">
            <el-option label="普通索引" value="INDEX"></el-option>
            <el-option label="唯一索引" value="UNIQUE"></el-option>
            <el-option label="全文索引" value="FULLTEXT"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="字段名" prop="columnName">
          <el-select v-model="indexForm.columnName" placeholder="请选择字段" style="width: 100%;">
            <el-option 
              v-for="column in columnList" 
              :key="column.columnName" 
              :label="column.columnName" 
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="索引注释" prop="indexComment">
          <el-input v-model="indexForm.indexComment" placeholder="请输入索引注释"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitIndexForm">确 定</el-button>
        <el-button @click="cancelIndex">取 消</el-button>
      </div>
    </el-dialog>

    <!-- SQL预览对话框 -->
    <el-dialog title="建表SQL" :visible.sync="sqlVisible" width="800px" append-to-body>
      <el-input
        v-model="createSql"
        type="textarea"
        :rows="15"
        readonly
        style="font-family: 'Courier New', monospace;"
      />
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="copySql">复制SQL</el-button>
        <el-button @click="sqlVisible = false">关 闭</el-button>
      </div>
    </el-dialog>

    <!-- 表操作对话框 -->
    <el-dialog :title="tableOperationTitle" :visible.sync="tableOperationVisible" width="500px" append-to-body>
      <el-form ref="tableOperationForm" :model="tableOperationForm" label-width="100px">
        <el-form-item v-if="tableOperation === 'rename'" label="新表名" prop="newTableName">
          <el-input v-model="tableOperationForm.newTableName" placeholder="请输入新表名"/>
        </el-form-item>
        <el-form-item v-if="tableOperation === 'comment'" label="表注释" prop="comment">
          <el-input v-model="tableOperationForm.comment" placeholder="请输入表注释"/>
        </el-form-item>
        <el-form-item v-if="tableOperation === 'engine'" label="存储引擎" prop="engine">
          <el-select v-model="tableOperationForm.engine" placeholder="请选择存储引擎" style="width: 100%;">
            <el-option label="InnoDB" value="InnoDB"></el-option>
            <el-option label="MyISAM" value="MyISAM"></el-option>
            <el-option label="Memory" value="Memory"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitTableOperation">确 定</el-button>
        <el-button @click="cancelTableOperation">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { 
  getTableInfo, 
  getTableColumns, 
  getTableIndexes, 
  getCreateTableSql,
  addTableColumn,
  modifyTableColumn,
  dropTableColumn,
  createIndex,
  dropIndex,
  renameTable,
  alterTableComment,
  alterTableEngine,
  delTable,
  backupTable
} from "@/api/tool/dbmanage";

export default {
  name: "DbTableDetail",
  data() {
    return {
      tableName: this.$route.params.tableName,
      tableInfo: null,
      activeTab: 'columns',
      // 编辑模式相关
      isEditMode: false,
      editingColumn: null,
      editingField: null,
      originalColumnData: null,
      // 批量编辑相关
      hasChanges: false,
      originalColumnList: [],
      
      // 字段相关
      columnLoading: false,
      columnList: [],
      columnIds: [],
      columnSingle: true,
      columnMultiple: true,
      
      // 索引相关
      indexLoading: false,
      indexList: [],
      indexIds: [],
      indexMultiple: true,
      indexOpen: false,
      indexTitle: "",
      indexForm: {},
      indexRules: {
        indexName: [
          { required: true, message: "索引名不能为空", trigger: "blur" },
          { pattern: /^[a-zA-Z_][a-zA-Z0-9_]*$/, message: "索引名格式不正确", trigger: "blur" }
        ],
        indexType: [
          { required: true, message: "索引类型不能为空", trigger: "change" }
        ],
        columnName: [
          { required: true, message: "字段名不能为空", trigger: "change" }
        ]
      },
      
      // SQL预览
      sqlVisible: false,
      createSql: '',
      
      // 表操作
      tableOperationVisible: false,
      tableOperationTitle: '',
      tableOperation: '',
      tableOperationForm: {}
    };
  },
  filters: {
    numberFormat(value) {
      if (!value) return 0;
      return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },
    sizeFormat(value) {
      if (!value) return "0 B";
      const units = ["B", "KB", "MB", "GB", "TB"];
      let size = parseFloat(value);
      let unitIndex = 0;
      
      while (size >= 1024 && unitIndex < units.length - 1) {
        size /= 1024;
        unitIndex++;
      }
      
      return `${size.toFixed(1)} ${units[unitIndex]}`;
    }
  },
  created() {
    // 调试：确保获取到了表名参数
    if (!this.tableName) {
      this.$modal.msgError("未获取到表名参数，请检查URL");
      return;
    }
    // 检查是否为编辑模式
    this.isEditMode = this.$route.query.mode === 'edit';
    this.getTableDetail();
    this.getColumnList();
    this.getIndexList();
  },
  methods: {
    /** 获取表详情 */
    getTableDetail() {
      getTableInfo(this.tableName).then(response => {
        this.tableInfo = response.data;
      });
    },
    
    /** 获取字段列表 */
    getColumnList() {
      this.columnLoading = true;
      getTableColumns(this.tableName).then(response => {
        this.columnList = response.rows;
        // 为每个字段初始化dataType和解析类型详情
        this.columnList.forEach(column => {
          if (!column.dataType && column.columnType) {
            column.dataType = this.getDataTypeFromColumnType(column.columnType);
            this.parseColumnTypeDetails(column);
          }
        });
        
        // 在编辑模式下保存原始数据
        if (this.isEditMode) {
          this.originalColumnList = JSON.parse(JSON.stringify(this.columnList));
          this.hasChanges = false;
        }
        
        this.columnLoading = false;
      });
    },
    
    /** 获取索引列表 */
    getIndexList() {
      this.indexLoading = true;
      getTableIndexes(this.tableName).then(response => {
        // 去重索引，合并同一索引的多个字段
        const indexMap = {};
        response.rows.forEach(index => {
          if (indexMap[index.indexName]) {
            indexMap[index.indexName].columnName += `, ${index.columnName}`;
          } else {
            indexMap[index.indexName] = { ...index };
          }
        });
        this.indexList = Object.values(indexMap);
        this.indexLoading = false;
      });
    },
    
    /** 刷新表信息 */
    refreshTableInfo() {
      this.getTableDetail();
      this.getColumnList();
      this.getIndexList();
    },
    
    /** Tab切换 */
    handleTabClick(tab) {
      if (tab.name === 'columns' && this.columnList.length === 0) {
        this.getColumnList();
      } else if (tab.name === 'indexes' && this.indexList.length === 0) {
        this.getIndexList();
      }
    },
    
    /** 字段选择变更 */
    handleColumnSelectionChange(selection) {
      this.columnIds = selection.map(item => item.columnName);
      this.columnSingle = selection.length !== 1;
      this.columnMultiple = !selection.length;
    },
    
    /** 索引选择变更 */
    handleIndexSelectionChange(selection) {
      this.indexIds = selection.map(item => item.indexName);
      this.indexMultiple = !selection.length;
    },
    
    /** 添加字段 */
    handleAddColumn() {
      const newField = {
        columnName: '',
        dataType: 'VARCHAR',
        columnLength: 255,
        columnScale: null,
        isNullable: 'YES',
        columnDefault: null,
        columnComment: '',
        autoIncrement: false,
        isNewField: true // 标记为新添加的字段
      };
      this.columnList.push(newField);
      this.columnSingle = false; // 取消单选
      this.columnMultiple = true; // 可以多选
      this.markAsChanged(); // 标记为已更改
    },
    
    /** 修改字段 */
    handleUpdateColumn(row) {
      // 修改前先备份
      this.$modal.confirm('修改字段前是否需要备份表数据？建议备份以防数据丢失。').then(() => {
        backupTable(this.tableName).then(() => {
          this.$modal.msgSuccess("备份完成，开始修改字段");
          this.doUpdateColumn(row);
        });
      }).catch(() => {
        // 用户选择不备份，直接修改
        this.doUpdateColumn(row);
      });
    },

    /** 执行修改字段操作 */
    doUpdateColumn(row) {
      this.resetColumnForm();
      const columnName = row.columnName || this.columnIds[0];
      const column = this.columnList.find(c => c.columnName === columnName);
      if (column) {
        this.columnForm = {
          ...column,
          isEdit: true,
          autoIncrement: column.extra && column.extra.includes('auto_increment')
        };
        this.columnOpen = true;
        this.columnTitle = "修改字段";
      }
    },
    
    /** 删除字段 */
    handleDeleteColumn(row, index) {
      // 如果是新添加的字段，直接从列表中移除
      if (row && typeof index !== 'undefined' && row.isNewField) {
        this.columnList.splice(index, 1);
        this.markAsChanged();
        return;
      }
      
      const columnNames = row.columnName ? [row.columnName] : this.columnIds;
      this.$modal.confirm('是否确认删除字段"' + columnNames.join(',') + '"？').then(() => {
        const promises = columnNames.map(name => dropTableColumn(this.tableName, name));
        Promise.all(promises).then(() => {
          this.getColumnList();
          this.$modal.msgSuccess("删除成功");
        });
      });
    },
    
    /** 保存新添加的字段 */
    saveNewField(row, index) {
      // 验证必填字段
      if (!row.columnName) {
        this.$modal.msgError("字段名不能为空");
        return;
      }
      
      if (!row.dataType) {
        this.$modal.msgError("数据类型不能为空");
        return;
      }
      
      // 检查字段名格式
      if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(row.columnName)) {
        this.$modal.msgError("字段名格式不正确");
        return;
      }
      
      // 检查字段名是否重复
      const existingColumn = this.columnList.find((col, idx) => idx !== index && col.columnName === row.columnName);
      if (existingColumn) {
        this.$modal.msgError("字段名已存在");
        return;
      }
      
      // 处理额外属性
      if (row.autoIncrement) {
        row.extra = 'auto_increment';
      } else {
        row.extra = '';
      }
      
      addTableColumn(this.tableName, row).then(response => {
        this.$modal.msgSuccess("新增成功");
        // 移除新字段标记并刷新列表
        row.isNewField = false;
        this.getColumnList();
      }).catch(error => {
        this.$modal.msgError("保存失败：" + (error.response?.data?.msg || error.message));
      });
    },


    
    /** 添加索引 */
    handleAddIndex() {
      this.resetIndexForm();
      this.indexOpen = true;
      this.indexTitle = "添加索引";
    },
    
    /** 删除索引 */
    handleDeleteIndex(row) {
      const indexNames = row.indexName ? [row.indexName] : this.indexIds;
      this.$modal.confirm('是否确认删除索引"' + indexNames.join(',') + '"？').then(() => {
        const promises = indexNames.map(name => dropIndex(this.tableName, name));
        Promise.all(promises).then(() => {
          this.getIndexList();
          this.$modal.msgSuccess("删除成功");
        });
      });
    },
    
    /** 提交索引表单 */
    submitIndexForm() {
      this.$refs["indexForm"].validate(valid => {
        if (valid) {
          createIndex(this.tableName, this.indexForm).then(response => {
            this.$modal.msgSuccess("创建成功");
            this.indexOpen = false;
            this.getIndexList();
          });
        }
      });
    },
    
    /** 取消索引操作 */
    cancelIndex() {
      this.indexOpen = false;
      this.resetIndexForm();
    },
    
    /** 重置索引表单 */
    resetIndexForm() {
      this.indexForm = {
        indexName: '',
        indexType: 'INDEX',
        columnName: '',
        indexComment: ''
      };
      this.resetForm("indexForm");
    },
    
    /** 获取索引类型颜色 */
    getIndexTypeColor(type) {
      switch (type) {
        case 'UNIQUE': return 'success';
        case 'FULLTEXT': return 'warning';
        case 'SPATIAL': return 'info';
        default: return 'primary';
      }
    },
    
    /** 显示建表SQL */
    showCreateSql() {
      getCreateTableSql(this.tableName).then(response => {
        this.createSql = response.data;
        this.sqlVisible = true;
      });
    },
    
    /** 复制SQL */
    copySql() {
      this.$copyText(this.createSql).then(() => {
        this.$modal.msgSuccess("SQL已复制到剪贴板");
      });
    },
    
    /** 修改表 */
    handleAlterTable() {
      this.tableOperation = 'comment';
      this.tableOperationTitle = '修改表注释';
      this.tableOperationForm = {
        comment: this.tableInfo.tableComment || ''
      };
      this.tableOperationVisible = true;
    },
    
    /** 重命名表 */
    handleRename() {
      this.tableOperation = 'rename';
      this.tableOperationTitle = '重命名表';
      this.tableOperationForm = {
        newTableName: ''
      };
      this.tableOperationVisible = true;
    },
    
    /** 备份表 */
    handleBackupTable() {
      this.$modal.confirm('是否确认备份表"' + this.tableName + '"的结构和数据？').then(() => {
        backupTable(this.tableName).then(response => {
          this.$modal.msgSuccess("备份成功，备份文件已保存到sql-log目录");
        });
      });
    },

    /** 删除表 */
    handleDropTable() {
      this.$modal.confirm('删除表前是否需要备份？删除操作不可恢复！').then(() => {
        // 先备份再删除
        backupTable(this.tableName).then(() => {
          this.$modal.msgSuccess("备份完成");
          this.$modal.confirm('确认删除表"' + this.tableName + '"？').then(() => {
            delTable(this.tableName).then(response => {
              this.$modal.msgSuccess("删除成功");
              const obj = { path: "/tool/dbmanage", query: { t: Date.now(), pageNum: this.$route.query.pageNum } };
              this.$tab.closeOpenPage(obj);
            });
          });
        });
      }).catch(() => {
        // 不备份直接删除
        this.$modal.confirm('确认删除表"' + this.tableName + '"？此操作不可恢复！').then(() => {
          delTable(this.tableName).then(response => {
            this.$modal.msgSuccess("删除成功");
            const obj = { path: "/tool/dbmanage", query: { t: Date.now(), pageNum: this.$route.query.pageNum } };
            this.$tab.closeOpenPage(obj);
          });
        });
      });
    },
    
    /** 提交表操作 */
    submitTableOperation() {
      if (this.tableOperation === 'rename') {
        if (!this.tableOperationForm.newTableName) {
          this.$modal.msgError("请输入新表名");
          return;
        }
        renameTable(this.tableName, this.tableOperationForm.newTableName).then(response => {
          this.$modal.msgSuccess("重命名成功");
          this.tableName = this.tableOperationForm.newTableName;
          this.tableOperationVisible = false;
          this.getTableDetail();
        });
      } else if (this.tableOperation === 'comment') {
        alterTableComment(this.tableName, this.tableOperationForm.comment).then(response => {
          this.$modal.msgSuccess("修改成功");
          this.tableOperationVisible = false;
          this.getTableDetail();
        });
      } else if (this.tableOperation === 'engine') {
        alterTableEngine(this.tableName, this.tableOperationForm.engine).then(response => {
          this.$modal.msgSuccess("修改成功");
          this.tableOperationVisible = false;
          this.getTableDetail();
        });
      }
    },
    
    /** 取消表操作 */
    cancelTableOperation() {
      this.tableOperationVisible = false;
      this.tableOperationForm = {};
    },



    /** 更新字段类型时同步更新columnType */
    updateColumnType(row) {
      if (row.columnLength && ['VARCHAR', 'CHAR', 'DECIMAL'].includes(row.dataType)) {
        if (row.columnScale && row.dataType === 'DECIMAL') {
          row.columnType = `${row.dataType}(${row.columnLength},${row.columnScale})`;
        } else {
          row.columnType = `${row.dataType}(${row.columnLength})`;
        }
      } else {
        row.columnType = row.dataType;
      }
      // 更新columnType后也要标记为已更改
      this.markAsChanged();
    },

    /** 从columnType中提取dataType */
    getDataTypeFromColumnType(columnType) {
      if (!columnType) return 'VARCHAR';
      const match = columnType.match(/^(\w+)/);
      return match ? match[1].toUpperCase() : 'VARCHAR';
    },

    /** 解析字段类型的详细信息（长度、小数位） */
    parseColumnTypeDetails(row) {
      if (!row.columnType) return;
      
      // 解析长度 VARCHAR(255) 或 DECIMAL(10,2)
      const lengthMatch = row.columnType.match(/\((\d+)(?:,(\d+))?\)/);
      if (lengthMatch) {
        row.columnLength = lengthMatch[1];
        if (lengthMatch[2]) {
          row.columnScale = lengthMatch[2];
        }
      }
    },

    /** 标记为已更改 */
    markAsChanged() {
      // 实时检查是否真的有变化
      this.hasChanges = this.checkForChanges();
    },

    /** 检查是否有实际变化 */
    checkForChanges() {
      // 检查是否有新添加的字段
      const hasNewFields = this.columnList.some(col => col.isNewField);
      if (hasNewFields) {
        return true;
      }
      
      if (this.originalColumnList.length !== this.columnList.length) {
        return true;
      }
      
      for (let i = 0; i < this.columnList.length; i++) {
        if (this.isColumnChanged(this.columnList[i], this.originalColumnList[i])) {
          return true;
        }
      }
      return false;
    },

    /** 保存所有更改 */
    saveAllChanges() {
      if (!this.hasChanges) {
        this.$modal.msgInfo("没有检测到任何更改");
        return;
      }

      this.$modal.confirm('确认保存所有字段的更改吗？操作前会自动备份表结构。').then(() => {
        // 先备份表
        backupTable(this.tableName).then(() => {
          this.$modal.msgSuccess("备份完成，开始批量更新字段");
          
          // 找出新添加的字段和修改的字段
          const newFields = this.columnList.filter(col => col.isNewField);
          const changedFields = [];
          
          this.columnList.forEach((column, index) => {
            if (!column.isNewField) {
              const original = this.originalColumnList[index];
              if (original && this.isColumnChanged(column, original)) {
                changedFields.push({
                  original: original,
                  current: column
                });
              }
            }
          });

          let allPromises = [];
          let operationCount = 0;

          // 处理新添加的字段
          if (newFields.length > 0) {
            const addPromises = newFields.map(field => {
              // 验证新字段
              if (!field.columnName || !field.dataType) {
                return Promise.reject(new Error(`${field.columnName || '未命名字段'}: 字段名和数据类型不能为空`));
              }
              
              operationCount++;
              return addTableColumn(this.tableName, field);
            });
            allPromises = allPromises.concat(addPromises);
          }

          // 处理修改的字段
          if (changedFields.length > 0) {
            const updatePromises = changedFields.map(field => {
              const modifyData = {
                columnName: field.current.columnName,
                dataType: field.current.dataType || this.getDataTypeFromColumnType(field.current.columnType),
                columnLength: field.current.columnLength,
                columnScale: field.current.columnScale,
                isNullable: field.current.isNullable,
                columnDefault: field.current.columnDefault,
                columnComment: field.current.columnComment
              };

              operationCount++;
              return modifyTableColumn(this.tableName, field.original.columnName, modifyData);
            });
            allPromises = allPromises.concat(updatePromises);
          }

          if (allPromises.length === 0) {
            this.$modal.msgInfo("没有检测到需要保存的更改");
            return;
          }

          // 执行所有操作
          let successCount = 0;
          let errorCount = 0;
          const errors = [];

          const promiseResults = allPromises.map(promise => 
            promise.then(() => {
              successCount++;
            }).catch(error => {
              errorCount++;
              errors.push(error.response?.data?.msg || error.message);
            })
          );

          Promise.all(promiseResults).then(() => {
            if (errorCount === 0) {
              this.$modal.msgSuccess(`批量操作成功！共处理 ${successCount} 个字段`);
              this.hasChanges = false;
              this.getColumnList(); // 刷新列表
            } else {
              this.$modal.msgWarning(`批量操作完成：成功 ${successCount} 个，失败 ${errorCount} 个\n失败详情：\n${errors.join('\n')}`);
              this.getColumnList(); // 刷新列表
            }
          });
        }).catch(() => {
          this.$modal.msgError("备份失败，批量更新操作已取消");
        });
      });
    },

    /** 重置所有更改 */
    resetAllChanges() {
      this.$modal.confirm('确认重置所有更改吗？所有未保存的修改将会丢失。').then(() => {
        // 移除所有新添加的字段
        this.columnList = this.columnList.filter(col => !col.isNewField);
        // 恢复原始数据
        this.columnList = JSON.parse(JSON.stringify(this.originalColumnList));
        this.hasChanges = false;
        this.$modal.msgSuccess("已重置所有更改");
      });
    },

    /** 检查字段是否有更改 */
    isColumnChanged(current, original) {
      return (
        current.columnName !== original.columnName ||
        current.dataType !== original.dataType ||
        current.columnLength !== original.columnLength ||
        current.columnScale !== original.columnScale ||
        current.isNullable !== original.isNullable ||
        current.columnDefault !== original.columnDefault ||
        current.columnComment !== original.columnComment
      );
    },

    /** 处理自动递增属性变化 */
    handleAutoIncrementChange(row) {
      if (row.autoIncrement) {
        row.extra = 'auto_increment';
      } else {
        row.extra = '';
      }
      this.markAsChanged();
    },

    /** 获取行样式类名 */
    getRowClassName({ row, rowIndex }) {
      if (row.isNewField) {
        return 'new-field-row';
      }
      return '';
    }
  }
};
</script>

<style scoped>
.mb20 {
  margin-bottom: 20px;
}

.app-breadcrumb {
  margin-bottom: 20px;
}

.app-breadcrumb .el-breadcrumb__inner a {
  color: #409EFF;
  text-decoration: none;
}

.link-type {
  color: #409EFF;
  text-decoration: none;
}

.link-type:hover {
  color: #66b1ff;
}

/* 新添加字段行的样式 */
.new-field-row {
  background-color: #f0f9ff !important;
  border: 1px solid #409EFF;
}

.new-field-row:hover {
  background-color: #e6f7ff !important;
}
</style> 