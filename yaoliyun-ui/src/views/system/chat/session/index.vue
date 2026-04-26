<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户ID" prop="userId">
        <el-input
          v-model="queryParams.userId"
          placeholder="请输入用户ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="联系人" prop="contactName">
        <el-input
          v-model="queryParams.contactName"
          placeholder="请输入联系人名称"
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
          v-hasPermi="['system:chat:add']"
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
          v-hasPermi="['system:chat:edit']"
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
          v-hasPermi="['system:chat:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="sessionList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="会话ID" align="center" prop="id" />
      <el-table-column label="用户ID" align="center" prop="userId" />
      <el-table-column label="联系人ID" align="center" prop="contactId" />
      <el-table-column label="联系人名称" align="center" prop="contactName" />
      <el-table-column label="最后消息" align="center" prop="lastMessage" :show-overflow-tooltip="true" />
      <el-table-column label="最后消息时间" align="center" prop="lastMessageTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.lastMessageTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="未读消息数" align="center" prop="unreadCount">
        <template slot-scope="scope">
          <el-badge :value="scope.row.unreadCount" :hidden="scope.row.unreadCount === 0" class="item">
            <span>{{ scope.row.unreadCount }}</span>
          </el-badge>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleViewMessages(scope.row)"
          >查看消息</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:chat:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:chat:remove']"
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

    <!-- 添加或修改聊天会话对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="联系人ID" prop="contactId">
          <el-input v-model="form.contactId" placeholder="请输入联系人ID" />
        </el-form-item>
        <el-form-item label="联系人名称" prop="contactName">
          <el-input v-model="form.contactName" placeholder="请输入联系人名称" />
        </el-form-item>
        <el-form-item label="最后消息" prop="lastMessage">
          <el-input v-model="form.lastMessage" type="textarea" placeholder="请输入最后消息内容" />
        </el-form-item>
        <el-form-item label="未读消息数" prop="unreadCount">
          <el-input-number v-model="form.unreadCount" :min="0" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看消息对话框 -->
    <el-dialog title="聊天记录" :visible.sync="messagesOpen" width="800px" append-to-body>
      <div class="chat-messages" v-loading="messagesLoading">
        <div v-for="message in chatMessages" :key="message.id" class="message-item">
          <div class="message-header">
            <span class="sender">{{ message.senderName }}</span>
            <span class="time">{{ parseTime(message.timestamp, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            <el-tag :type="getStatusType(message.readStatus)" size="mini">{{ getStatusText(message.readStatus) }}</el-tag>
          </div>
          <div class="message-content">{{ message.message }}</div>
        </div>
        <div v-if="chatMessages.length === 0" class="no-messages">
          暂无聊天记录
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSessions, getSession, delSession, addSession, updateSession } from "@/api/chat";
import { getChatHistory } from "@/api/chat";

export default {
  name: "ChatSession",
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
      // 聊天会话表格数据
      sessionList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userId: null,
        contactName: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        userId: [
          { required: true, message: "用户ID不能为空", trigger: "blur" }
        ],
        contactId: [
          { required: true, message: "联系人ID不能为空", trigger: "blur" }
        ],
        contactName: [
          { required: true, message: "联系人名称不能为空", trigger: "blur" }
        ]
      },
      // 消息对话框
      messagesOpen: false,
      messagesLoading: false,
      chatMessages: []
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询聊天会话列表 */
    getList() {
      this.loading = true;
      listSessions(this.queryParams).then(response => {
        this.sessionList = response.rows;
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
        id: null,
        userId: null,
        contactId: null,
        contactName: null,
        lastMessage: null,
        unreadCount: 0
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
      this.ids = selection.map(item => item.id)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加聊天会话";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getSession(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改聊天会话";
      });
    },
    /** 查看消息操作 */
    handleViewMessages(row) {
      this.messagesOpen = true;
      this.messagesLoading = true;
      getChatHistory(row.userId, row.contactId).then(response => {
        this.chatMessages = response.data;
        this.messagesLoading = false;
      }).catch(() => {
        this.messagesLoading = false;
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateSession(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSession(this.form).then(response => {
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
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除聊天会话编号为"' + ids + '"的数据项？').then(function() {
        return delSession(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    // 获取状态类型
    getStatusType(status) {
      const statusMap = {
        'sent': 'info',
        'delivered': 'warning',
        'read': 'success'
      };
      return statusMap[status] || 'info';
    },
    // 获取状态文本
    getStatusText(status) {
      const statusMap = {
        'sent': '已发送',
        'delivered': '已送达',
        'read': '已读'
      };
      return statusMap[status] || status;
    }
  }
};
</script>

<style scoped>
.chat-messages {
  max-height: 400px;
  overflow-y: auto;
  padding: 10px;
}

.message-item {
  margin-bottom: 15px;
  padding: 10px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
}

.message-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  font-size: 12px;
  color: #909399;
}

.sender {
  font-weight: bold;
  color: #409eff;
}

.message-content {
  color: #303133;
  line-height: 1.5;
}

.no-messages {
  text-align: center;
  color: #909399;
  padding: 20px;
}
</style>
