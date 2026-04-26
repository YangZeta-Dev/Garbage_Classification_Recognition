<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="表名称" prop="tableName">
        <el-input
          v-model="queryParams.tableName"
          placeholder="请输入表名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="表描述" prop="tableComment">
        <el-input
          v-model="queryParams.tableComment"
          placeholder="请输入表描述"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
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
          icon="el-icon-cpu"
          size="mini"
          :disabled="multiple"
          @click="handleBatchGenTable"
          v-hasPermi="['tool:gen:code']"
        >批量生成</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="openCreateTable"
          v-hasRole="['admin']"
        >创建</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-upload"
          size="mini"
          @click="openImportTable"
          v-hasPermi="['tool:gen:import']"
        >导入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-document"
          size="mini"
          @click="openSqlImport"
          v-hasPermi="['tool:gen:code']"
        >执行SQL</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleEditTable"
          v-hasPermi="['tool:gen:edit']"
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
          v-hasPermi="['tool:gen:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-folder-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDeleteGeneratedFiles"
          v-hasPermi="['tool:gen:remove']"
        >删除生成信息</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table ref="tables" v-loading="loading" :data="tableList" @selection-change="handleSelectionChange" :default-sort="defaultSort" @sort-change="handleSortChange">
      <el-table-column type="selection" align="center" width="55"></el-table-column>
      <el-table-column label="序号" type="index" width="50" align="center">
        <template slot-scope="scope">
          <span>{{(queryParams.pageNum - 1) * queryParams.pageSize + scope.$index + 1}}</span>
        </template>
      </el-table-column>
      <el-table-column label="表名称" align="center" prop="tableName" :show-overflow-tooltip="true" width="120" />
      <el-table-column label="表描述" align="center" prop="tableComment" :show-overflow-tooltip="true" width="120" />
      <el-table-column label="实体" align="center" prop="className" :show-overflow-tooltip="true" width="120" />
      <el-table-column label="特性" align="center" width="100">
        <template slot-scope="scope">
          <el-tooltip content="该表包含外键关联" placement="top" v-if="hasForeignKeys(scope.row)">
            <el-tag type="success" size="mini">
              <i class="el-icon-link"></i> 外键
            </el-tag>
          </el-tooltip>
          <el-tag v-else type="info" size="mini" plain>普通表</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" sortable="custom" :sort-orders="['descending', 'ascending']" width="160" />
      <el-table-column label="更新时间" align="center" prop="updateTime" sortable="custom" :sort-orders="['descending', 'ascending']" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            type="text"
            size="small"
            icon="el-icon-view"
            @click="handlePreview(scope.row)"
            v-hasPermi="['tool:gen:preview']"
          >预览</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-edit"
            @click="handleEditTable(scope.row)"
            v-hasPermi="['tool:gen:edit']"
          >编辑</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['tool:gen:remove']"
          >删除</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-refresh"
            @click="handleSynchDb(scope.row)"
            v-hasPermi="['tool:gen:edit']"
          >同步</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-cpu"
            @click="handleGenTable(scope.row)"
            v-hasPermi="['tool:gen:code']"
          >生成代码</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-folder-delete"
            @click="handleDeleteGeneratedFiles(scope.row)"
            v-hasPermi="['tool:gen:remove']"
            style="color: #E6A23C;"
          >删除生成信息</el-button>
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
    <!-- 预览界面 -->
    <el-dialog :title="preview.title" :visible.sync="preview.open" width="80%" top="5vh" append-to-body class="scrollbar">
      <el-tabs v-model="preview.activeName">
        <el-tab-pane
          v-for="(value, key) in preview.data"
          :label="key.substring(key.lastIndexOf('/')+1,key.indexOf('.vm'))"
          :name="key.substring(key.lastIndexOf('/')+1,key.indexOf('.vm'))"
          :key="key"
        >
          <el-link :underline="false" icon="el-icon-document-copy" v-clipboard:copy="value" v-clipboard:success="clipboardSuccess" style="float:right">复制</el-link>
          <pre><code class="hljs" v-html="highlightedCode(value, key)"></code></pre>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
    <import-table ref="import" @ok="handleQuery" />
    <create-table ref="create" @ok="handleQuery" />

    <!-- SQL文件导入对话框 -->
    <el-dialog title="导入并执行SQL文件" :visible.sync="sqlImport.open" width="600px" append-to-body>
      <div style="margin-bottom: 20px;">
        <div style="padding: 15px; background-color: #fff6f6; border: 1px solid #f56c6c; border-radius: 4px; margin-bottom: 15px;">
          <div style="color: #f56c6c; font-weight: bold; margin-bottom: 8px;">
            <i class="el-icon-warning"></i> 注意事项
          </div>
          <div style="color: #606266; font-size: 13px; line-height: 1.6;">
            <p style="margin: 0 0 8px 0;"><strong>谨慎操作</strong>：SQL执行操作不可逆，请确保SQL语句正确</p>
            <p style="margin: 0 0 8px 0;"><strong>文件格式</strong>：仅支持.sql格式文件</p>
            <p style="margin: 0 0 8px 0;"><strong>语句分隔</strong>：多条SQL请用分号(;)分隔</p>
            <p style="margin: 0;"><strong>备份建议</strong>：执行前请备份重要数据</p>
          </div>
        </div>

        <el-upload
          ref="sqlUpload"
          class="upload-demo"
          drag
          :auto-upload="false"
          :multiple="false"
          :file-list="sqlImport.fileList"
          :on-change="handleSqlFileChange"
          :on-remove="handleSqlFileRemove"
          accept=".sql"
        >
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">将SQL文件拖到此处，或<em>点击上传</em></div>
          <div class="el-upload__tip" slot="tip">只能上传.sql文件，且不超过10MB</div>
        </el-upload>

        <div v-if="sqlImport.fileContent" style="margin-top: 15px;">
          <div style="color: #409eff; font-weight: bold; margin-bottom: 8px;">
            <i class="el-icon-document"></i> SQL预览
          </div>
          <el-input
            type="textarea"
            :rows="8"
            v-model="sqlImport.fileContent"
            placeholder="SQL文件内容将在此显示..."
            readonly
          ></el-input>
        </div>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="sqlImport.open = false">取 消</el-button>
        <el-button
          type="primary"
          @click="executeSqlFile"
          :loading="sqlImport.loading"
          :disabled="!sqlImport.fileList.length"
        >确认执行</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTable, previewTable, delTable, genCodeToProject, synchDb, uploadAndExecuteSql, deleteGeneratedFiles } from "@/api/tool/gen"
import importTable from "./importTable"
import createTable from "./createTable"
import hljs from "highlight.js/lib/highlight"
import "highlight.js/styles/github-gist.css"
hljs.registerLanguage("java", require("highlight.js/lib/languages/java"))
hljs.registerLanguage("xml", require("highlight.js/lib/languages/xml"))
hljs.registerLanguage("html", require("highlight.js/lib/languages/xml"))
hljs.registerLanguage("vue", require("highlight.js/lib/languages/xml"))
hljs.registerLanguage("javascript", require("highlight.js/lib/languages/javascript"))
hljs.registerLanguage("sql", require("highlight.js/lib/languages/sql"))

export default {
  name: "Gen",
  components: { importTable, createTable },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 唯一标识符
      uniqueId: "",
      // 选中数组
      ids: [],
      // 选中表数组
      tableNames: [],
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
      // 日期范围
      dateRange: "",
      // 默认排序
      defaultSort: { prop: "createTime", order: "descending" },
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: undefined,
        tableComment: undefined
      },
      // 预览参数
      preview: {
        open: false,
        title: "代码预览",
        data: {},
        activeName: "domain.java"
      },
      // SQL导入参数
      sqlImport: {
        open: false,
        loading: false,
        fileList: [],
        fileContent: ""
      }
    }
  },
  created() {
    this.queryParams.orderByColumn = this.defaultSort.prop
    this.queryParams.isAsc = this.defaultSort.order
    this.getList()
  },
  activated() {
    const time = this.$route.query.t
    if (time != null && time != this.uniqueId) {
      this.uniqueId = time
      this.queryParams.pageNum = Number(this.$route.query.pageNum)
      this.getList()
    }
  },
  methods: {
    /** 查询表集合 */
    getList() {
      this.loading = true
      listTable(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.tableList = response.rows
          this.total = response.total
          this.loading = false
        }
      )
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 生成代码操作 */
    handleGenTable(row) {
      if (!row.tableName) {
        this.$modal.msgError("请选择要生成的数据")
        return
      }
      genCodeToProject(row.tableName).then(response => {
        this.$modal.msgSuccess("✅ 代码生成成功！已自动放置到项目目录并执行SQL脚本")
      }).catch(error => {
        this.$modal.msgError("生成失败：" + (error.response?.data?.msg || error.message))
      })
    },
    /** 同步数据库操作 */
    handleSynchDb(row) {
      const tableName = row.tableName
      this.$modal.confirm('确认要强制同步"' + tableName + '"表结构吗？').then(function() {
        return synchDb(tableName)
      }).then(() => {
        this.$modal.msgSuccess("同步成功")
      }).catch(() => {})
    },
    /** 打开导入表弹窗 */
    openImportTable() {
      this.$refs.import.show()
    },
    /** 打开创建表弹窗 */
    openCreateTable() {
      this.$refs.create.show()
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.queryParams.pageNum = 1
      this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
    },
    /** 预览按钮 */
    handlePreview(row) {
      previewTable(row.tableId).then(response => {
        this.preview.data = response.data
        this.preview.open = true
        this.preview.activeName = "domain.java"
      })
    },
    /** 高亮显示 */
    highlightedCode(code, key) {
      const vmName = key.substring(key.lastIndexOf("/") + 1, key.indexOf(".vm"))
      var language = vmName.substring(vmName.indexOf(".") + 1, vmName.length)
      const result = hljs.highlight(language, code || "", true)
      return result.value || '&nbsp;'
    },
    /** 复制代码成功 */
    clipboardSuccess() {
      this.$modal.msgSuccess("复制成功")
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.tableId)
      this.tableNames = selection.map(item => item.tableName)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    /** 排序触发事件 */
    handleSortChange(column, prop, order) {
      this.queryParams.orderByColumn = column.prop
      this.queryParams.isAsc = column.order
      this.getList()
    },
    /** 修改按钮操作 */
    handleEditTable(row) {
      const tableId = row.tableId || this.ids[0]
      const tableName = row.tableName || this.tableNames[0]
      const params = { pageNum: this.queryParams.pageNum }
      this.$tab.openPage("修改[" + tableName + "]生成配置", '/tool/gen-edit/index/' + tableId, params)
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const tableIds = row.tableId || this.ids
      this.$modal.confirm('是否确认删除表编号为"' + tableIds + '"的数据项？').then(function() {
        return delTable(tableIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },

    /** 批量生成代码操作 */
    handleBatchGenTable() {
      const tableNames = this.tableNames
      if (tableNames.length === 0) {
        this.$modal.msgError("请选择要生成的数据")
        return
      }

      this.$modal.confirm(`确认要批量生成 ${tableNames.length} 个表的代码到项目目录吗？`).then(() => {
        let successCount = 0
        let errorCount = 0
        const errors = []

        // 串行处理每个表，避免并发冲突
        const processTable = async (index) => {
          if (index >= tableNames.length) {
            // 所有表处理完成
            if (errorCount === 0) {
              this.$modal.msgSuccess(`🎉 批量生成成功！共生成 ${successCount} 个表的代码`)
            } else {
              this.$modal.msgWarning(`批量生成完成：成功 ${successCount} 个，失败 ${errorCount} 个\n失败详情：\n${errors.join('\n')}`)
            }
            return
          }

          const tableName = tableNames[index]
          try {
            await genCodeToProject(tableName)
            successCount++
            this.$message.success(`${tableName} 生成成功`)
          } catch (error) {
            errorCount++
            const errorMsg = error.response?.data?.msg || error.message
            errors.push(`${tableName}: ${errorMsg}`)
            this.$message.error(`${tableName} 生成失败`)
          }

          // 处理下一个表
          setTimeout(() => processTable(index + 1), 500) // 间隔500ms避免频繁请求
        }

        processTable(0)
      }).catch(() => {})
    },

    /** 打开SQL导入对话框 */
    openSqlImport() {
      this.sqlImport.open = true
      this.sqlImport.fileList = []
      this.sqlImport.fileContent = ""
      this.$nextTick(() => {
        this.$refs.sqlUpload.clearFiles()
      })
    },

    /** 文件列表变化 */
    handleSqlFileChange(file, fileList) {
      this.sqlImport.fileList = fileList
      if (fileList.length > 0) {
        const reader = new FileReader()
        reader.onload = (event) => {
          this.sqlImport.fileContent = event.target.result
        }
        reader.readAsText(file.raw)
      } else {
        this.sqlImport.fileContent = ""
      }
    },

    /** 文件列表移除 */
    handleSqlFileRemove(file, fileList) {
      this.sqlImport.fileList = fileList
      this.sqlImport.fileContent = ""
    },

    /** 执行SQL文件 */
    executeSqlFile() {
      this.sqlImport.loading = true
      const file = this.sqlImport.fileList[0]
      if (!file) {
        this.$modal.msgError("请选择要执行的SQL文件")
        this.sqlImport.loading = false
        return
      }

      if (file.raw.size > 10 * 1024 * 1024) { // 10MB
        this.$modal.msgError("SQL文件大小不能超过10MB")
        this.sqlImport.loading = false
        return
      }

      if (!file.raw.name.endsWith('.sql')) {
        this.$modal.msgError("请选择.sql格式的SQL文件")
        this.sqlImport.loading = false
        return
      }

      this.$modal.confirm('确认要执行此SQL文件吗？').then(() => {
        return uploadAndExecuteSql(file.raw)
      }).then(response => {
        this.$modal.msgSuccess("SQL文件执行成功！")
        this.sqlImport.open = false
        this.sqlImport.loading = false
        this.getList() // 刷新列表
      }).catch(error => {
        this.$modal.msgError("SQL文件执行失败：" + (error.response?.data?.msg || error.message))
        this.sqlImport.loading = false
      })
    },

    /** 判断表是否包含外键 */
    hasForeignKeys(row) {
      // 这里可以通过表的属性判断是否有外键
      // 由于后端返回的数据可能不包含columns，我们暂时通过表名包含特定关键字来判断
      // 实际使用中，后端应该返回外键数量或标识
      return false // 默认先返回false，后续可以优化
    },

    /** 删除生成信息操作 */
    handleDeleteGeneratedFiles(row) {
      // 判断是单个删除还是批量删除
      if (row && row.tableName) {
        // 单个删除
        const tableName = row.tableName
        this.$modal.confirm(`确认要删除表 "${tableName}" 的所有生成代码文件和菜单信息吗？此操作不可逆！`).then(() => {
          deleteGeneratedFiles(tableName).then(() => {
            this.$modal.msgSuccess("删除生成信息成功")
          }).catch(error => {
            this.$modal.msgError("删除失败：" + (error.response?.data?.msg || error.message))
          })
        }).catch(() => {})
      } else {
        // 批量删除
        const tableNames = this.tableNames
        if (tableNames.length === 0) {
          this.$modal.msgError("请选择要删除生成信息的数据")
          return
        }

        this.$modal.confirm(`确认要删除 ${tableNames.length} 个表的所有生成代码文件和菜单信息吗？此操作不可逆！`).then(() => {
          let successCount = 0
          let errorCount = 0
          const errors = []

          // 串行处理每个表，避免并发冲突
          const processTable = async (index) => {
            if (index >= tableNames.length) {
              // 所有表处理完成
              if (errorCount === 0) {
                this.$modal.msgSuccess(`🎉 删除生成信息成功！共处理 ${successCount} 个表`)
              } else {
                this.$modal.msgWarning(`删除完成：成功 ${successCount} 个，失败 ${errorCount} 个\n失败详情：\n${errors.join('\n')}`)
              }
              return
            }

            const tableName = tableNames[index]
            try {
              await deleteGeneratedFiles(tableName)
              successCount++
              this.$message.success(`${tableName} 生成信息删除成功`)
            } catch (error) {
              errorCount++
              const errorMsg = error.response?.data?.msg || error.message
              errors.push(`${tableName}: ${errorMsg}`)
              this.$message.error(`${tableName} 生成信息删除失败`)
            }

            // 处理下一个表
            setTimeout(() => processTable(index + 1), 300) // 间隔300ms避免频繁请求
          }

          processTable(0)
        }).catch(() => {})
      }
    }
  }
}
</script>
