<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="表名" prop="tableName">
        <el-input
          v-model="queryParams.tableName"
          placeholder="请输入表名"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
          v-hasPermi="['tool:dbmanage:add']"
        >新建表</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          @click="handleSqlExecute"
          v-hasPermi="['tool:dbmanage:execute']"
        >SQL执行</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-refresh"
          size="mini"
          @click="handleSyncDatabase"
          v-hasPermi="['tool:dbmanage:sync']"
        >同步数据库</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['tool:dbmanage:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="tableList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="表名" align="center" prop="tableName" :show-overflow-tooltip="true" min-width="120">
        <template slot-scope="scope">
          <span class="link-type" @click="handlePreview(scope.row)" style="cursor: pointer; color: #409EFF;">
            {{ scope.row.tableName }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="表注释" align="center" prop="tableComment" :show-overflow-tooltip="true" min-width="120"/>
      <el-table-column label="引擎" align="center" prop="engine" width="80"/>
      <el-table-column label="字符集" align="center" prop="charset" width="100" :show-overflow-tooltip="true"/>
      <el-table-column label="行数" align="center" prop="tableRows" width="80">
        <template slot-scope="scope">
          <span>{{ scope.row.tableRows | numberFormat }}</span>
        </template>
      </el-table-column>
      <el-table-column label="数据大小" align="center" prop="dataLength" width="100">
        <template slot-scope="scope">
          <span>{{ scope.row.dataLength | sizeFormat }}</span>
        </template>
      </el-table-column>
      <el-table-column label="索引大小" align="center" prop="indexLength" width="100">
        <template slot-scope="scope">
          <span>{{ scope.row.indexLength | sizeFormat }}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handlePreview(scope.row)"
            v-hasPermi="['tool:dbmanage:query']"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleEdit(scope.row)"
            v-hasPermi="['tool:dbmanage:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['tool:dbmanage:remove']"
          >删除</el-button>
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

    <!-- 添加表对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="12">
                    <el-form-item label="表名" prop="tableName">
          <el-input v-model="form.tableName" placeholder="请输入表名" :disabled="form.isEdit" />
        </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="表注释" prop="tableComment">
              <el-input v-model="form.tableComment" placeholder="请输入表注释" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="引擎" prop="engine">
              <el-select v-model="form.engine" placeholder="请选择引擎">
                <el-option label="InnoDB" value="InnoDB"></el-option>
                <el-option label="MyISAM" value="MyISAM"></el-option>
                <el-option label="Memory" value="Memory"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="字符集" prop="charset">
              <el-select v-model="form.charset" placeholder="请选择字符集">
                <el-option label="utf8mb4" value="utf8mb4"></el-option>
                <el-option label="utf8" value="utf8"></el-option>
                <el-option label="latin1" value="latin1"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 字段定义 -->
        <el-form-item label="字段信息" v-if="!form.isEdit">
          <el-table :data="form.columns" style="width: 100%">
            <el-table-column label="字段名" width="120">
              <template slot-scope="scope">
                <el-input v-model="scope.row.columnName" placeholder="字段名" size="mini" />
              </template>
            </el-table-column>
            <el-table-column label="类型" width="100">
              <template slot-scope="scope">
                <el-select v-model="scope.row.dataType" placeholder="类型" size="mini">
                  <el-option label="INT" value="INT"></el-option>
                  <el-option label="VARCHAR" value="VARCHAR"></el-option>
                  <el-option label="TEXT" value="TEXT"></el-option>
                  <el-option label="DECIMAL" value="DECIMAL"></el-option>
                  <el-option label="DATETIME" value="DATETIME"></el-option>
                  <el-option label="TIMESTAMP" value="TIMESTAMP"></el-option>
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="长度" width="80">
              <template slot-scope="scope">
                <el-input v-model="scope.row.columnLength" placeholder="长度" size="mini" />
              </template>
            </el-table-column>
            <el-table-column label="允许空" width="80">
              <template slot-scope="scope">
                <el-select v-model="scope.row.isNullable" placeholder="是否为空" size="mini">
                  <el-option label="是" value="YES"></el-option>
                  <el-option label="否" value="NO"></el-option>
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="默认值" width="100">
              <template slot-scope="scope">
                <el-input v-model="scope.row.columnDefault" placeholder="默认值" size="mini" />
              </template>
            </el-table-column>
            <el-table-column label="注释" min-width="120">
              <template slot-scope="scope">
                <el-input v-model="scope.row.columnComment" placeholder="字段注释" size="mini" />
              </template>
            </el-table-column>
            <el-table-column label="主键" width="60">
              <template slot-scope="scope">
                <el-checkbox v-model="scope.row.isPrimaryKey" @change="handlePrimaryKeyChange(scope.row, scope.$index)"></el-checkbox>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="80">
              <template slot-scope="scope">
                <el-button size="mini" type="text" icon="el-icon-delete" @click="removeColumn(scope.$index)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-button style="margin-top: 10px;" size="mini" type="primary" @click="addColumn">添加字段</el-button>
        </el-form-item>

        <!-- 修改模式下的字段信息展示 -->
        <el-form-item label="字段信息" v-if="form.isEdit">
          <el-alert
            title="提示：修改表模式下不能编辑字段结构，如需修改字段请到表详情页面进行操作"
            type="info"
            :closable="false"
            show-icon>
          </el-alert>
          <el-table :data="form.columns" style="width: 100%; margin-top: 10px;">
            <el-table-column label="字段名" prop="columnName" width="120"/>
            <el-table-column label="类型" prop="columnType" width="100"/>
            <el-table-column label="长度" prop="columnLength" width="80"/>
            <el-table-column label="允许空" prop="isNullable" width="80"/>
            <el-table-column label="默认值" prop="columnDefault" width="100"/>
            <el-table-column label="注释" prop="columnComment" min-width="120"/>
            <el-table-column label="主键" width="60">
              <template slot-scope="scope">
                <el-tag v-if="scope.row.columnKey === 'PRI'" type="danger" size="mini">PK</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- SQL执行对话框 -->
    <el-dialog title="SQL执行器" :visible.sync="sqlOpen" width="800px" append-to-body>
      <el-form>
        <el-form-item label="SQL语句">
          <el-input
            v-model="sqlForm.sql"
            type="textarea"
            :rows="10"
            placeholder="请输入SQL语句..."
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="executeSql">执 行</el-button>
        <el-button @click="sqlOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看表详情对话框 -->
    <el-dialog :title="'表详情 - ' + previewTable.tableName" :visible.sync="previewOpen" width="900px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="表名">{{ previewTable.tableName }}</el-descriptions-item>
        <el-descriptions-item label="表注释">{{ previewTable.tableComment }}</el-descriptions-item>
        <el-descriptions-item label="引擎">{{ previewTable.engine }}</el-descriptions-item>
        <el-descriptions-item label="字符集">{{ previewTable.charset }}</el-descriptions-item>
        <el-descriptions-item label="行数">{{ previewTable.tableRows | numberFormat }}</el-descriptions-item>
        <el-descriptions-item label="数据大小">{{ previewTable.dataLength | sizeFormat }}</el-descriptions-item>
        <el-descriptions-item label="索引大小">{{ previewTable.indexLength | sizeFormat }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(previewTable.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</el-descriptions-item>
      </el-descriptions>
      
      <div style="margin-top: 20px;">
        <h4>字段信息</h4>
        <el-table :data="previewTable.columns" style="width: 100%;" max-height="400">
          <el-table-column label="字段名" prop="columnName" width="120"/>
          <el-table-column label="类型" prop="columnType" width="100"/>
          <el-table-column label="允许空" prop="isNullable" width="80">
            <template slot-scope="scope">
              <el-tag :type="scope.row.isNullable === 'YES' ? 'success' : 'danger'" size="mini">
                {{ scope.row.isNullable === 'YES' ? '是' : '否' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="默认值" prop="columnDefault" width="100" :show-overflow-tooltip="true"/>
          <el-table-column label="注释" prop="columnComment" :show-overflow-tooltip="true"/>
          <el-table-column label="主键" width="60">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.columnKey === 'PRI'" type="danger" size="mini">PK</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="额外" prop="extra" width="100" :show-overflow-tooltip="true"/>
        </el-table>
      </div>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="previewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTables, getTableInfo, addTable, updateTable, delTable, exportTable, executeSql, syncDatabase } from "@/api/tool/dbmanage";

export default {
  name: "DbManage",
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
      // 表数据
      tableList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // SQL执行对话框
      sqlOpen: false,
      // 预览对话框
      previewOpen: false,
      // 预览表信息
      previewTable: {
        tableName: '',
        tableComment: '',
        engine: '',
        charset: '',
        tableRows: 0,
        dataLength: 0,
        indexLength: 0,
        createTime: '',
        columns: []
      },
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: null
      },
      // 表单参数
      form: {},
      // SQL表单参数
      sqlForm: {
        sql: ""
      },
      // 表单校验
      rules: {
        tableName: [
          { required: true, message: "表名不能为空", trigger: "blur" },
          { pattern: /^[a-zA-Z_][a-zA-Z0-9_]*$/, message: "表名格式不正确", trigger: "blur" }
        ],
        tableComment: [
          { required: true, message: "表注释不能为空", trigger: "blur" }
        ]
      }
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
    this.getList();
  },
  methods: {
    /** 查询表列表 */
    getList() {
      this.loading = true;
      listTables(this.queryParams).then(response => {
        this.tableList = response.rows;
        this.total = response.total;
        this.loading = false;
      }).catch(() => {
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
        tableName: null,
        tableComment: null,
        engine: "InnoDB",
        charset: "utf8mb4",
        columns: [],
        isEdit: false,
        originalTableName: null
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
      this.ids = selection.map(item => item.tableName)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加数据库表";
      // 默认添加一个ID字段
      this.addColumn();
      this.form.columns[0] = {
        columnName: "id",
        dataType: "BIGINT",
        columnLength: 20,
        isNullable: "NO",
        columnDefault: null,
        columnComment: "主键ID",
        isPrimaryKey: true,
        extra: "auto_increment"
      };
    },
    /** 修改按钮操作 - 跳转到详情页面 */
    handleEdit(row) {
      const tableName = row.tableName || this.ids[0];
      const params = { pageNum: this.queryParams.pageNum, mode: 'edit' };
      this.$tab.openPage("修改表[" + tableName + "]", '/tool/dbmanage-table/' + tableName, params);
    },
    /** 查看按钮操作 - 弹窗预览 */
    handlePreview(row) {
      const tableName = row.tableName;
      this.previewTable = { ...row, columns: [] };
      
      // 获取表的详细信息包括字段
      getTableInfo(tableName).then(response => {
        this.previewTable = {
          ...row,
          columns: response.data.columns || []
        };
        this.previewOpen = true;
      }).catch(() => {
        this.$modal.msgError("获取表详情失败");
      });
    },
    /** 修改表基本信息（原来的修改功能，现在用于表单弹窗） */
    handleUpdate(row) {
      this.reset();
      const tableName = row.tableName || this.ids[0];
      getTableInfo(tableName).then(response => {
        this.form = {
          ...response.data,
          isEdit: true,
          originalTableName: response.data.tableName
        };
        this.form.columns = this.form.columns || [];
        // 处理主键标识
        this.form.columns.forEach(column => {
          column.isPrimaryKey = column.columnKey === 'PRI';
        });
        this.open = true;
        this.title = "修改数据库表";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 处理字段信息
          this.form.columns.forEach(column => {
            if (column.isPrimaryKey) {
              column.columnKey = 'PRI';
            }
            // 处理数据类型长度
            if (column.columnLength && ['VARCHAR', 'CHAR', 'DECIMAL'].includes(column.dataType)) {
              column.columnType = `${column.dataType}(${column.columnLength})`;
            } else {
              column.columnType = column.dataType;
            }
          });

          if (this.form.isEdit) {
            // 修改表只能修改注释，不能修改表结构
            const updateData = {
              tableName: this.form.originalTableName,
              tableComment: this.form.tableComment,
              engine: this.form.engine,
              charset: this.form.charset
            };
            updateTable(updateData).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            // 新增表
            addTable(this.form).then(response => {
              this.$modal.msgSuccess("创建成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const tableNames = row.tableName || this.ids;
      this.$modal.confirm('是否确认删除表名为"' + tableNames + '"的数据项？').then(function() {
        return delTable(tableNames);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('tool/dbmanage/export', {
        ...this.queryParams
      }, `table_${new Date().getTime()}.xlsx`)
    },
    /** SQL执行 */
    handleSqlExecute() {
      this.sqlForm.sql = "";
      this.sqlOpen = true;
    },
    /** 执行SQL */
    executeSql() {
      if (!this.sqlForm.sql.trim()) {
        this.$modal.msgError("请输入SQL语句");
        return;
      }
      executeSql(this.sqlForm.sql).then(response => {
        this.$modal.msgSuccess("SQL执行成功");
        this.sqlOpen = false;
        this.getList();
      });
    },
    /** 同步数据库 */
    handleSyncDatabase() {
      this.$modal.confirm('同步数据库将更新所有表的统计信息，可能需要一定时间，是否继续？').then(() => {
        this.loading = true;
        syncDatabase().then(response => {
          this.$modal.msgSuccess("同步数据库成功");
          this.getList();
        }).catch(() => {
          this.loading = false;
        });
      }).catch(() => {});
    },
    /** 添加字段 */
    addColumn() {
      this.form.columns.push({
        columnName: "",
        dataType: "VARCHAR",
        columnLength: 255,
        isNullable: "YES",
        columnDefault: null,
        columnComment: "",
        isPrimaryKey: false
      });
    },
    /** 删除字段 */
    removeColumn(index) {
      this.form.columns.splice(index, 1);
    },
    /** 主键变更处理 */
    handlePrimaryKeyChange(row, index) {
      if (row.isPrimaryKey) {
        // 如果设置为主键，则其他字段取消主键
        this.form.columns.forEach((column, idx) => {
          if (idx !== index) {
            column.isPrimaryKey = false;
          }
        });
      }
    }
  }
};
</script>
 