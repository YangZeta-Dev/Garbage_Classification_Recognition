<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="文章" prop="articleId">
        <el-select v-model="queryParams.articleId" placeholder="请选择文章" clearable filterable>
          <el-option
            v-for="item in articleIdOptions"
            :key="item.article_id"
            :label="item.title"
            :value="item.article_id"
          />
        </el-select>
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
      <el-form-item label="难度" prop="difficulty">
        <el-select v-model="queryParams.difficulty" placeholder="请选择难度" clearable>
          <el-option
            v-for="dict in dict.type.quiz_difficulty"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
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
          v-hasPermi="['system:question:add']"
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
          v-hasPermi="['system:question:edit']"
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
          v-hasPermi="['system:question:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:question:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="questionList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="questionId" />
      <el-table-column label="文章" align="center" prop="title" show-overflow-tooltip />
      <el-table-column label="分类" align="center" prop="categoryName" />
      <el-table-column label="题目" align="center" prop="questionContent" show-overflow-tooltip />
      <el-table-column label="答案" align="center" prop="correctAnswer" />
      <el-table-column label="难度" align="center" prop="difficulty">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.quiz_difficulty" :value="scope.row.difficulty"/>
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
            v-hasPermi="['system:question:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:question:remove']"
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

    <!-- 添加或修改垃圾分类测验题目对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="基本信息" name="basic">
            <el-form-item label="文章" prop="articleId">
              <el-select v-model="form.articleId" placeholder="请选择文章" clearable filterable>
                <el-option
                  v-for="item in articleIdOptions"
                  :key="item.article_id"
                  :label="item.title"
                  :value="item.article_id"
                />
              </el-select>
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
            <el-form-item label="题目" prop="questionContent">
              <el-input v-model="form.questionContent" type="textarea" placeholder="请输入题目" :rows="3" />
            </el-form-item>
            <el-form-item label="难度" prop="difficulty">
              <el-radio-group v-model="form.difficulty">
                <el-radio
                  v-for="dict in dict.type.quiz_difficulty"
                  :key="dict.value"
                  :label="parseInt(dict.value)"
                >{{dict.label}}</el-radio>
              </el-radio-group>
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
          <el-tab-pane label="选项设置" name="options">
            <el-form-item label="选项A" prop="optionA">
              <el-input v-model="form.optionA" placeholder="请输入选项A" />
            </el-form-item>
            <el-form-item label="选项B" prop="optionB">
              <el-input v-model="form.optionB" placeholder="请输入选项B" />
            </el-form-item>
            <el-form-item label="选项C" prop="optionC">
              <el-input v-model="form.optionC" placeholder="请输入选项C" />
            </el-form-item>
            <el-form-item label="选项D" prop="optionD">
              <el-input v-model="form.optionD" placeholder="请输入选项D" />
            </el-form-item>
          </el-tab-pane>
          <el-tab-pane label="答案设置" name="answer">
            <el-form-item label="答案" prop="correctAnswer">
              <el-input v-model="form.correctAnswer" placeholder="请输入答案" />
            </el-form-item>
            <el-form-item label="解析">
              <el-input v-model="form.explanation" type="textarea" placeholder="请输入解析" :rows="3" />
            </el-form-item>
            <el-form-item label="分值" prop="pointsValue">
              <el-input v-model="form.pointsValue" placeholder="请输入分值" />
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
    <el-dialog title="题目详情" :visible.sync="viewOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ID">{{ viewForm.questionId }}</el-descriptions-item>
        <el-descriptions-item label="文章">{{ viewForm.title || '-' }}</el-descriptions-item>
        <el-descriptions-item label="分类">{{ viewForm.categoryName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="难度">
          <dict-tag :options="dict.type.quiz_difficulty" :value="viewForm.difficulty"/>
        </el-descriptions-item>
        <el-descriptions-item label="题目" :span="2">{{ viewForm.questionContent }}</el-descriptions-item>
        <el-descriptions-item label="选项A">{{ viewForm.optionA }}</el-descriptions-item>
        <el-descriptions-item label="选项B">{{ viewForm.optionB }}</el-descriptions-item>
        <el-descriptions-item label="选项C">{{ viewForm.optionC || '-' }}</el-descriptions-item>
        <el-descriptions-item label="选项D">{{ viewForm.optionD || '-' }}</el-descriptions-item>
        <el-descriptions-item label="答案">{{ viewForm.correctAnswer }}</el-descriptions-item>
        <el-descriptions-item label="分值">{{ viewForm.pointsValue }}</el-descriptions-item>
        <el-descriptions-item label="解析" :span="2">{{ viewForm.explanation || '-' }}</el-descriptions-item>
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
import { listQuestion, getQuestion, delQuestion, addQuestion, updateQuestion, getArticleIdOptions, getCategoryIdOptions } from "@/api/system/question"

export default {
  name: "Question",
  dicts: ['quiz_difficulty', 'sys_normal_disable'],
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
      // 垃圾分类测验题目表格数据
      questionList: [],
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
        articleId: null,
        categoryId: null,
        questionContent: null,
        optionA: null,
        optionB: null,
        optionC: null,
        optionD: null,
        correctAnswer: null,
        explanation: null,
        pointsValue: null,
        difficulty: null,
        status: null,
      },
      // 表单参数
      form: {},
      // 关联文章ID选项列表
      articleIdOptions: [],
      // 关联分类ID选项列表
      categoryIdOptions: [],
      // 表单校验
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" }
        ],
        optionA: [
          { required: true, message: "选项A不能为空", trigger: "blur" }
        ],
        optionB: [
          { required: true, message: "选项B不能为空", trigger: "blur" }
        ],
        correctAnswer: [
          { required: true, message: "正确答案不能为空", trigger: "blur" }
        ],
      }
    }
  },
  created() {
    this.getList()
    this.getArticleIdOptions()
    this.getCategoryIdOptions()
  },
  methods: {
    /** 查询垃圾分类测验题目列表 */
    getList() {
      this.loading = true
      listQuestion(this.queryParams).then(response => {
        this.questionList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    /** 查询关联文章ID选项列表 */
    getArticleIdOptions() {
      getArticleIdOptions().then(response => {
        this.articleIdOptions = response.data || []
      }).catch(error => {
        console.error('获取关联文章ID选项失败：', error)
        this.articleIdOptions = []
      })
    },
    /** 查询关联分类ID选项列表 */
    getCategoryIdOptions() {
      getCategoryIdOptions().then(response => {
        this.categoryIdOptions = response.data || []
      }).catch(error => {
        console.error('获取关联分类ID选项失败：', error)
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
        questionId: null,
        articleId: null,
        categoryId: null,
        questionContent: null,
        optionA: null,
        optionB: null,
        optionC: null,
        optionD: null,
        correctAnswer: null,
        explanation: [],
        pointsValue: null,
        difficulty: null,
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
      this.ids = selection.map(item => item.questionId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset()
      this.activeTab = 'basic'
      this.open = true
      this.title = "添加题目"
    },
    /** 详情按钮操作 */
    handleView(row) {
      this.viewForm = row
      this.viewOpen = true
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset()
      const questionId = row.questionId || this.ids
      getQuestion(questionId).then(response => {
        this.form = response.data
        this.form.explanation = this.form.explanation.split(",")
        this.open = true
        this.activeTab = 'basic'
        this.title = "修改题目"
      })
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.explanation = this.form.explanation.join(",")
          if (this.form.questionId != null) {
            updateQuestion(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addQuestion(this.form).then(response => {
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
      const questionIds = row.questionId || this.ids
      this.$modal.confirm('是否确认删除垃圾分类测验题目编号为"' + questionIds + '"的数据项？').then(function() {
        return delQuestion(questionIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/question/export', {
        ...this.queryParams
      }, `question_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
