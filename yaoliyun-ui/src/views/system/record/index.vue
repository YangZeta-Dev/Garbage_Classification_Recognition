<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户" prop="userId">
        <el-select v-model="queryParams.userId" placeholder="请选择用户" clearable filterable>
          <el-option
            v-for="item in userIdOptions"
            :key="item.user_id"
            :label="item.nickName"
            :value="item.user_id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="结果" prop="recognizedName">
        <el-input
          v-model="queryParams.recognizedName"
          placeholder="请输入结果"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="分类" prop="categoryId">
        <el-select v-model="queryParams.categoryId" placeholder="请选择分类" clearable filterable>
          <el-option
            v-for="item in categoryIdOptions"
            :key="item.category_id"
            :label="item.categoryName"
            :value="item.category_id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="来源" prop="recognitionSource">
        <el-select v-model="queryParams.recognitionSource" placeholder="请选择来源" clearable>
          <el-option
            v-for="dict in dict.type.garbage_recognition_source"
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
          @click="handleAdd"
          v-hasPermi="['system:record:add']"
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
          v-hasPermi="['system:record:edit']"
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
          v-hasPermi="['system:record:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:record:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="recordList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="recordId" />
      <el-table-column label="用户" align="center" prop="nickName" />
      <el-table-column label="图片" align="center" prop="imageUrl" width="80">
        <template slot-scope="scope">
          <image-preview :src="scope.row.imageUrl" :width="50" :height="50"/>
        </template>
      </el-table-column>
      <el-table-column label="结果" align="center" prop="recognizedName" show-overflow-tooltip />
      <el-table-column label="分类" align="center" prop="categoryName" />
      <el-table-column label="置信度" align="center" prop="confidenceScore" />
      <el-table-column label="来源" align="center" prop="recognitionSource">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.garbage_recognition_source" :value="scope.row.recognitionSource"/>
        </template>
      </el-table-column>
      <el-table-column label="时间" align="center" prop="recognitionTime" width="100">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.recognitionTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:record:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:record:remove']"
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

    <!-- 添加或修改垃圾识别记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="基本信息" name="basic">
            <el-form-item label="用户" prop="userId">
              <el-select v-model="form.userId" placeholder="请选择用户" clearable filterable>
                <el-option
                  v-for="item in userIdOptions"
                  :key="item.user_id"
                  :label="item.nickName"
                  :value="item.user_id"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="原图" prop="imageUrl">
              <image-upload v-model="form.imageUrl"/>
            </el-form-item>
            <el-form-item label="缩略图" prop="thumbnailUrl">
              <image-upload v-model="form.thumbnailUrl"/>
            </el-form-item>
            <el-form-item label="来源" prop="recognitionSource">
              <el-select v-model="form.recognitionSource" placeholder="请选择来源">
                <el-option
                  v-for="dict in dict.type.garbage_recognition_source"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="时间" prop="recognitionTime">
              <el-date-picker clearable
                v-model="form.recognitionTime"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="请选择时间">
              </el-date-picker>
            </el-form-item>
          </el-tab-pane>
          <el-tab-pane label="识别信息" name="recognition">
            <el-form-item label="结果" prop="recognizedName">
              <el-input v-model="form.recognizedName" placeholder="请输入结果" />
            </el-form-item>
            <el-form-item label="物品ID" prop="recognizedItemId">
              <el-input v-model="form.recognizedItemId" placeholder="请输入物品ID" />
            </el-form-item>
            <el-form-item label="分类" prop="categoryId">
              <el-select v-model="form.categoryId" placeholder="请选择分类" clearable filterable>
                <el-option
                  v-for="item in categoryIdOptions"
                  :key="item.category_id"
                  :label="item.categoryName"
                  :value="item.category_id"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="置信度" prop="confidenceScore">
              <el-input v-model="form.confidenceScore" placeholder="请输入置信度" />
            </el-form-item>
            <el-form-item label="积分" prop="pointsEarned">
              <el-input v-model="form.pointsEarned" placeholder="请输入积分" />
            </el-form-item>
          </el-tab-pane>
        </el-tabs>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog title="记录详情" :visible.sync="viewOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ID">{{ viewForm.recordId }}</el-descriptions-item>
        <el-descriptions-item label="用户">{{ viewForm.nickName }}</el-descriptions-item>
        <el-descriptions-item label="原图" :span="2">
          <image-preview v-if="viewForm.imageUrl" :src="viewForm.imageUrl" :width="150" :height="150"/>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="缩略图">
          <image-preview v-if="viewForm.thumbnailUrl" :src="viewForm.thumbnailUrl" :width="80" :height="80"/>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="物品ID">{{ viewForm.recognizedItemId || '-' }}</el-descriptions-item>
        <el-descriptions-item label="结果">{{ viewForm.recognizedName }}</el-descriptions-item>
        <el-descriptions-item label="分类">{{ viewForm.categoryName }}</el-descriptions-item>
        <el-descriptions-item label="置信度">{{ viewForm.confidenceScore }}</el-descriptions-item>
        <el-descriptions-item label="积分">{{ viewForm.pointsEarned || 0 }}</el-descriptions-item>
        <el-descriptions-item label="来源">
          <dict-tag :options="dict.type.garbage_recognition_source" :value="viewForm.recognitionSource"/>
        </el-descriptions-item>
        <el-descriptions-item label="时间">{{ parseTime(viewForm.recognitionTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listRecord, getRecord, delRecord, addRecord, updateRecord, getUserIdOptions, getCategoryIdOptions } from "@/api/system/record"

export default {
  name: "Record",
  dicts: ['garbage_recognition_source'],
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
      // 垃圾识别记录表格数据
      recordList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示详情弹出层
      viewOpen: false,
      // 详情表单
      viewForm: {},
      // 当前激活的tab
      activeTab: 'basic',
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userId: null,
        imageUrl: null,
        thumbnailUrl: null,
        recognizedItemId: null,
        recognizedName: null,
        categoryId: null,
        confidenceScore: null,
        pointsEarned: null,
        recognitionSource: null,
        recognitionTime: null,
      },
      // 表单参数
      form: {},
      // 用户ID选项列表
      userIdOptions: [],
      // 分类ID选项列表
      categoryIdOptions: [],
      // 表单校验
      rules: {
        userId: [
          { required: true, message: "用户ID不能为空", trigger: "change" }
        ],
      }
    }
  },
  created() {
    this.getList()
    this.getUserIdOptions()
    this.getCategoryIdOptions()
  },
  methods: {
    /** 查询垃圾识别记录列表 */
    getList() {
      this.loading = true
      listRecord(this.queryParams).then(response => {
        this.recordList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    /** 查询用户ID选项列表 */
    getUserIdOptions() {
      getUserIdOptions().then(response => {
        this.userIdOptions = response.data || []
      }).catch(error => {
        console.error('获取用户ID选项失败：', error)
        this.userIdOptions = []
      })
    },
    /** 查询分类ID选项列表 */
    getCategoryIdOptions() {
      getCategoryIdOptions().then(response => {
        this.categoryIdOptions = response.data || []
      }).catch(error => {
        console.error('获取分类ID选项失败：', error)
        this.categoryIdOptions = []
      })
    },
    // 取消按钮
    cancel() {
      this.open = false
      this.reset()
    },
    // 表单重置
    reset() {
      this.form = {
        recordId: null,
        userId: null,
        imageUrl: null,
        thumbnailUrl: null,
        recognizedItemId: null,
        recognizedName: null,
        categoryId: null,
        confidenceScore: null,
        pointsEarned: null,
        recognitionSource: null,
        recognitionTime: null,
        delFlag: null,
        createTime: null
      }
      this.resetForm("form")
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.recordId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset()
      this.activeTab = 'basic'
      this.open = true
      this.title = "添加记录"
    },
    /** 详情按钮操作 */
    handleView(row) {
      this.viewForm = row
      this.viewOpen = true
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset()
      const recordId = row.recordId || this.ids
      getRecord(recordId).then(response => {
        this.form = response.data
        this.open = true
        this.activeTab = 'basic'
        this.title = "修改记录"
      })
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.recordId != null) {
            updateRecord(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addRecord(this.form).then(response => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const recordIds = row.recordId || this.ids
      this.$modal.confirm('是否确认删除垃圾识别记录编号为"' + recordIds + '"的数据项？').then(function() {
        return delRecord(recordIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/record/export', {
        ...this.queryParams
      }, `record_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
