<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="名称" prop="itemName">
        <el-input
          v-model="queryParams.itemName"
          placeholder="请输入名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option
            v-for="dict in dict.type.sys_normal_disable"
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
          v-hasPermi="['system:item:add']"
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
          v-hasPermi="['system:item:edit']"
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
          v-hasPermi="['system:item:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:item:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="itemList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="itemId" />
      <el-table-column label="分类" align="center" prop="categoryName" />
      <el-table-column label="名称" align="center" prop="itemName" show-overflow-tooltip />
      <el-table-column label="图片" align="center" prop="imageUrl" width="80">
        <template slot-scope="scope">
          <image-preview :src="scope.row.imageUrl" :width="50" :height="50"/>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
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
            v-hasPermi="['system:item:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:item:remove']"
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

    <!-- 添加或修改垃圾物品对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="基本信息" name="basic">
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
            <el-form-item label="名称" prop="itemName">
              <el-input v-model="form.itemName" placeholder="请输入名称" />
            </el-form-item>
            <el-form-item label="拼音" prop="itemNamePinyin">
              <el-input v-model="form.itemNamePinyin" placeholder="请输入拼音" />
            </el-form-item>
            <el-form-item label="图片" prop="imageUrl">
              <image-upload v-model="form.imageUrl"/>
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
          </el-tab-pane>
          <el-tab-pane label="详细信息" name="detail">
            <el-form-item label="建议" prop="disposalSuggestion">
              <el-input v-model="form.disposalSuggestion" type="textarea" placeholder="请输入处理建议" :rows="3" />
            </el-form-item>
            <el-form-item label="贴士">
              <editor v-model="form.environmentalTips" :min-height="192"/>
            </el-form-item>
            <el-form-item label="搜索量" prop="searchCount">
              <el-input v-model="form.searchCount" placeholder="请输入搜索量" />
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
    <el-dialog title="物品详情" :visible.sync="viewOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ID">{{ viewForm.itemId }}</el-descriptions-item>
        <el-descriptions-item label="分类">{{ viewForm.categoryName }}</el-descriptions-item>
        <el-descriptions-item label="名称">{{ viewForm.itemName }}</el-descriptions-item>
        <el-descriptions-item label="拼音">{{ viewForm.itemNamePinyin || '-' }}</el-descriptions-item>
        <el-descriptions-item label="图片" :span="2">
          <image-preview v-if="viewForm.imageUrl" :src="viewForm.imageUrl" :width="100" :height="100"/>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="建议" :span="2">{{ viewForm.disposalSuggestion || '-' }}</el-descriptions-item>
        <el-descriptions-item label="贴士" :span="2">
          <div v-html="viewForm.environmentalTips" style="max-height: 200px; overflow-y: auto;"></div>
        </el-descriptions-item>
        <el-descriptions-item label="搜索量">{{ viewForm.searchCount }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.sys_normal_disable" :value="viewForm.status"/>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listItem, getItem, delItem, addItem, updateItem, getCategoryIdOptions } from "@/api/system/item"

export default {
  name: "Item",
  dicts: ['sys_normal_disable'],
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
      // 垃圾物品表格数据
      itemList: [],
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
        categoryId: null,
        itemName: null,
        itemNamePinyin: null,
        disposalSuggestion: null,
        imageUrl: null,
        environmentalTips: null,
        searchCount: null,
        status: null,
      },
      // 表单参数
      form: {},
      // 所属类别ID（关联垃圾分类类别表）选项列表
      categoryIdOptions: [],
      // 表单校验
      rules: {
        categoryId: [
          { required: true, message: "所属类别ID不能为空", trigger: "change" }
        ],
        itemName: [
          { required: true, message: "物品名称不能为空", trigger: "blur" }
        ],
      }
    }
  },
  created() {
    this.getList()
    this.getCategoryIdOptions()
  },
  methods: {
    /** 查询垃圾物品列表 */
    getList() {
      this.loading = true
      listItem(this.queryParams).then(response => {
        this.itemList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    /** 查询所属类别ID（关联垃圾分类类别表）选项列表 */
    getCategoryIdOptions() {
      getCategoryIdOptions().then(response => {
        this.categoryIdOptions = response.data || []
      }).catch(error => {
        console.error('获取所属类别ID（关联垃圾分类类别表）选项失败：', error)
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
        itemId: null,
        categoryId: null,
        itemName: null,
        itemNamePinyin: null,
        disposalSuggestion: null,
        imageUrl: null,
        environmentalTips: null,
        searchCount: null,
        status: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null
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
      this.ids = selection.map(item => item.itemId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset()
      this.activeTab = 'basic'
      this.open = true
      this.title = "添加物品"
    },
    /** 详情按钮操作 */
    handleView(row) {
      this.viewForm = row
      this.viewOpen = true
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset()
      const itemId = row.itemId || this.ids
      getItem(itemId).then(response => {
        this.form = response.data
        this.open = true
        this.activeTab = 'basic'
        this.title = "修改物品"
      })
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.itemId != null) {
            updateItem(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addItem(this.form).then(response => {
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
      const itemIds = row.itemId || this.ids
      this.$modal.confirm('是否确认删除垃圾物品编号为"' + itemIds + '"的数据项？').then(function() {
        return delItem(itemIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/item/export', {
        ...this.queryParams
      }, `item_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
