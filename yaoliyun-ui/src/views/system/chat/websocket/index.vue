<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 在线用户统计 -->
      <el-col :span="6">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>在线用户统计</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="refreshOnlineUsers">刷新</el-button>
          </div>
          <div class="stat-item">
            <div class="stat-number">{{ onlineCount }}</div>
            <div class="stat-label">当前在线用户</div>
          </div>
        </el-card>
      </el-col>

      <!-- WebSocket状态 -->
      <el-col :span="6">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>WebSocket状态</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="testWebSocket">测试</el-button>
          </div>
          <div class="stat-item">
            <el-tag :type="wsStatus === 'normal' ? 'success' : 'danger'">
              {{ wsStatus === 'normal' ? '正常' : '异常' }}
            </el-tag>
            <div class="stat-label">服务状态</div>
          </div>
        </el-card>
      </el-col>

      <!-- 计数状态 -->
      <el-col :span="6">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>计数状态</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="checkStatistics">检查</el-button>
          </div>
          <div class="stat-item">
            <el-tag :type="countStatus.consistent ? 'success' : 'warning'">
              {{ countStatus.consistent ? '正常' : '异常' }}
            </el-tag>
            <div class="stat-label">
              计数器: {{ countStatus.counterValue }} / 实际: {{ countStatus.actualCount }}
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 管理操作 -->
      <el-col :span="6">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>管理操作</span>
          </div>
          <div class="management-actions">
            <el-button type="warning" size="small" @click="fixOnlineCount" :loading="fixing">
              修复计数
            </el-button>
            <el-button type="danger" size="small" @click="resetOnlineCount" :loading="resetting">
              重置计数
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <!-- 消息发送 -->
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>系统消息发送</span>
          </div>
          <el-form :inline="true" size="small">
            <el-form-item label="消息类型">
              <el-select v-model="messageForm.type" placeholder="选择消息类型">
                <el-option label="系统消息" value="system" />
                <el-option label="广播消息" value="broadcast" />
              </el-select>
            </el-form-item>
            <el-form-item label="目标用户" v-if="messageForm.type === 'system'">
              <el-input v-model="messageForm.userId" placeholder="用户ID（空则广播）" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="sendMessage">发送</el-button>
            </el-form-item>
          </el-form>
          <el-input
            v-model="messageForm.message"
            type="textarea"
            :rows="3"
            placeholder="请输入消息内容"
          />
        </el-card>
      </el-col>

      <!-- 聊天消息测试 -->
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>聊天消息测试</span>
          </div>
          <el-form :model="chatTestForm" size="small" label-width="80px">
            <el-form-item label="发送者ID">
              <el-input v-model="chatTestForm.senderId" placeholder="请输入发送者ID" />
            </el-form-item>
            <el-form-item label="发送者名">
              <el-input v-model="chatTestForm.senderName" placeholder="请输入发送者名称" />
            </el-form-item>
            <el-form-item label="接收者ID">
              <el-input v-model="chatTestForm.receiverId" placeholder="请输入接收者ID" />
            </el-form-item>
            <el-form-item label="接收者名">
              <el-input v-model="chatTestForm.receiverName" placeholder="请输入接收者名称" />
            </el-form-item>
            <el-form-item label="消息内容">
              <el-input
                v-model="chatTestForm.message"
                type="textarea"
                :rows="2"
                placeholder="请输入消息内容"
              />
            </el-form-item>
            <el-form-item>
              <el-button type="success" @click="sendChatMessage" :loading="sendingChat">
                发送聊天消息
              </el-button>
              <el-button @click="resetChatForm">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>

    <!-- 在线用户列表 -->
    <el-card class="box-card" style="margin-top: 20px;">
      <div slot="header" class="clearfix">
        <span>在线用户列表</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="refreshOnlineUsers">刷新</el-button>
      </div>
      <el-table :data="onlineUsers" style="width: 100%">
        <el-table-column prop="userId" label="用户ID" />
        <el-table-column label="在线状态" width="120">
          <template slot-scope="scope">
            <el-tag type="success">在线</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button size="mini" @click="sendToUser(scope.row.userId)">发送消息</el-button>
            <el-button size="mini" type="info" @click="checkUserStatus(scope.row.userId)">检查状态</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div v-if="onlineUsers.length === 0" style="text-align: center; padding: 20px; color: #909399;">
        暂无在线用户
      </div>
    </el-card>

    <!-- 发送消息给指定用户对话框 -->
    <el-dialog title="发送消息" :visible.sync="sendDialogVisible" width="500px">
      <el-form :model="sendForm" label-width="80px">
        <el-form-item label="目标用户">
          <el-input v-model="sendForm.userId" disabled />
        </el-form-item>
        <el-form-item label="消息内容">
          <el-input v-model="sendForm.message" type="textarea" :rows="4" placeholder="请输入消息内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="sendDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmSendToUser">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getOnlineUsers, getOnlineUserCount, isUserOnline, sendSystemMessage, broadcastMessage, testWebSocket, testSendChatMessage, fixOnlineCount, resetOnlineCount, getOnlineStatistics } from "@/api/chat";

export default {
  name: "WebSocketManagement",
  data() {
    return {
      onlineCount: 0,
      onlineUsers: [],
      wsStatus: 'normal',
      countStatus: {
        consistent: true,
        counterValue: 0,
        actualCount: 0
      },
      fixing: false,
      resetting: false,
      sendingChat: false,
      messageForm: {
        type: 'system',
        userId: '',
        message: ''
      },
      chatTestForm: {
        senderId: 'user001',
        senderName: '测试发送者',
        receiverId: 'user002',
        receiverName: '测试接收者',
        message: '这是一条测试消息',
        messageType: 'text'
      },
      sendDialogVisible: false,
      sendForm: {
        userId: '',
        message: ''
      }
    };
  },
  created() {
    this.refreshOnlineUsers();
    this.testWebSocket();
    this.checkStatistics();
    // 定时刷新在线用户和统计信息
    this.timer = setInterval(() => {
      this.refreshOnlineUsers();
      this.checkStatistics();
    }, 30000); // 30秒刷新一次
  },
  beforeDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    // 刷新在线用户
    async refreshOnlineUsers() {
      try {
        const [countRes, usersRes] = await Promise.all([
          getOnlineUserCount(),
          getOnlineUsers()
        ]);
        
        this.onlineCount = countRes.data;
        this.onlineUsers = usersRes.data.users.map(userId => ({ userId }));
      } catch (error) {
        console.error('刷新在线用户失败:', error);
      }
    },

    // 测试WebSocket
    async testWebSocket() {
      try {
        const response = await testWebSocket();
        this.wsStatus = 'normal';
        this.$message.success('WebSocket服务正常');
      } catch (error) {
        this.wsStatus = 'error';
        this.$message.error('WebSocket服务异常');
      }
    },

    // 发送消息
    async sendMessage() {
      if (!this.messageForm.message.trim()) {
        this.$message.warning('请输入消息内容');
        return;
      }

      try {
        if (this.messageForm.type === 'system') {
          await sendSystemMessage({
            userId: this.messageForm.userId || null,
            message: this.messageForm.message
          });
        } else if (this.messageForm.type === 'broadcast') {
          await broadcastMessage({
            message: this.messageForm.message,
            messageType: 'text'
          });
        }
        
        this.$message.success('消息发送成功');
        this.messageForm.message = '';
      } catch (error) {
        this.$message.error('消息发送失败: ' + error.message);
      }
    },

    // 发送消息给指定用户
    sendToUser(userId) {
      this.sendForm.userId = userId;
      this.sendForm.message = '';
      this.sendDialogVisible = true;
    },

    // 确认发送给指定用户
    async confirmSendToUser() {
      if (!this.sendForm.message.trim()) {
        this.$message.warning('请输入消息内容');
        return;
      }

      try {
        await sendSystemMessage({
          userId: this.sendForm.userId,
          message: this.sendForm.message
        });
        
        this.$message.success('消息发送成功');
        this.sendDialogVisible = false;
      } catch (error) {
        this.$message.error('消息发送失败: ' + error.message);
      }
    },

    // 检查用户状态
    async checkUserStatus(userId) {
      try {
        const response = await isUserOnline(userId);
        const status = response.data.online ? '在线' : '离线';
        this.$message.info(`用户 ${userId} 当前状态: ${status}`);
      } catch (error) {
        this.$message.error('检查用户状态失败');
      }
    },

    // 检查统计信息
    async checkStatistics() {
      try {
        const response = await getOnlineStatistics();
        if (response.code === 200) {
          const stats = response.data.statistics;
          this.countStatus = {
            consistent: stats.consistent,
            counterValue: stats.counterValue,
            actualCount: stats.actualCount
          };
        }
      } catch (error) {
        console.error('检查统计信息失败:', error);
      }
    },

    // 修复在线人数计数
    async fixOnlineCount() {
      this.fixing = true;
      try {
        const response = await fixOnlineCount();
        if (response.code === 200) {
          this.$message.success('在线人数计数已修复');
          this.refreshOnlineUsers();
          this.checkStatistics();
        } else {
          this.$message.error('修复失败: ' + response.msg);
        }
      } catch (error) {
        this.$message.error('修复失败: ' + error.message);
      } finally {
        this.fixing = false;
      }
    },

    // 重置在线人数计数
    async resetOnlineCount() {
      this.$confirm('确定要重置在线人数计数吗？这将根据实际连接数重新设置计数器。', '确认重置', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        this.resetting = true;
        try {
          const response = await resetOnlineCount();
          if (response.code === 200) {
            this.$message.success('在线人数计数已重置');
            this.refreshOnlineUsers();
            this.checkStatistics();
          } else {
            this.$message.error('重置失败: ' + response.msg);
          }
        } catch (error) {
          this.$message.error('重置失败: ' + error.message);
        } finally {
          this.resetting = false;
        }
      }).catch(() => {
        this.$message.info('已取消重置');
      });
    },

    // 发送聊天消息
    async sendChatMessage() {
      if (!this.chatTestForm.senderId || !this.chatTestForm.receiverId || !this.chatTestForm.message) {
        this.$message.warning('请填写发送者ID、接收者ID和消息内容');
        return;
      }

      this.sendingChat = true;
      try {
        const response = await testSendChatMessage(this.chatTestForm);
        if (response.code === 200) {
          this.$message.success('聊天消息发送成功');

          // 显示返回的消息信息
          if (response.data) {
            this.$notify({
              title: '发送成功',
              message: `消息ID: ${response.data.messageId || '未知'}\n发送时间: ${response.data.timestamp || '未知'}`,
              type: 'success',
              duration: 3000
            });
          }

          // 刷新在线用户和统计信息
          this.refreshOnlineUsers();
          this.checkStatistics();
        } else {
          this.$message.error('发送失败: ' + response.msg);
        }
      } catch (error) {
        this.$message.error('发送失败: ' + (error.response?.data?.msg || error.message));
      } finally {
        this.sendingChat = false;
      }
    },

    // 重置聊天测试表单
    resetChatForm() {
      this.chatTestForm = {
        senderId: 'user001',
        senderName: '测试发送者',
        receiverId: 'user002',
        receiverName: '测试接收者',
        message: '这是一条测试消息',
        messageType: 'text'
      };
    }
  }
};
</script>

<style scoped>
.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 32px;
  font-weight: bold;
  color: #409eff;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #606266;
}

.box-card {
  margin-bottom: 20px;
}

.management-actions {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.management-actions .el-button {
  width: 100%;
}
</style>
