<template>
  <div class="auth-view-wrapper">
    <div class="visual-showcase-panel signup-variant">
      <div class="eco-elements">
        <div class="shape shape-leaf"></div>
        <div class="shape shape-sun"></div>
        <div class="shape shape-water"></div>
      </div>

      <div class="brand-hero">
        <div class="logo-box">
          <i class="el-icon-magic-stick"></i>
        </div>
        <h1 class="hero-title">加入我们<br/>共筑绿水青山</h1>
        <p class="hero-desc">注册专属账户，立即体验 AI 赋能的智能垃圾分类识别功能。</p>

        <div class="feature-cards">
          <div class="glass-card">
            <i class="el-icon-present"></i>
            <span>免费注册使用</span>
          </div>
          <div class="glass-card">
            <i class="el-icon-camera"></i>
            <span>拍照智能识别</span>
          </div>
          <div class="glass-card">
            <i class="el-icon-coin"></i>
            <span>环保积分奖励</span>
          </div>
        </div>
      </div>

      <div class="copyright-text">
        © 2026-2027 社区智能垃圾分类督导系统 All Rights Reserved.
      </div>
    </div>

    <div class="interaction-form-panel">
      <div class="form-container">
        <div class="welcome-header">
          <h2>创建账户</h2>
          <p>填写以下基本信息，开启您的环保之旅</p>
        </div>

        <el-form ref="registerForm" :model="registerForm" :rules="registerRules" class="modern-auth-form">
          <el-form-item prop="username">
            <div class="form-group">
              <label>设定账号</label>
              <el-input
                v-model="registerForm.username"
                type="text"
                auto-complete="off"
                placeholder="请输入2-20位字符的账号"
                class="sleek-input"
              >
                <i slot="prefix" class="el-icon-user"></i>
              </el-input>
            </div>
          </el-form-item>

          <el-form-item prop="password">
            <div class="form-group">
              <label>设定密码</label>
              <el-input
                v-model="registerForm.password"
                type="password"
                auto-complete="off"
                placeholder="请输入5-20位安全密码"
                class="sleek-input"
                @keyup.enter.native="handleRegister"
              >
                <i slot="prefix" class="el-icon-lock"></i>
              </el-input>
            </div>
          </el-form-item>

          <el-form-item prop="confirmPassword">
            <div class="form-group">
              <label>确认密码</label>
              <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                auto-complete="off"
                placeholder="请再次输入密码以确认"
                class="sleek-input"
                @keyup.enter.native="handleRegister"
              >
                <i slot="prefix" class="el-icon-key"></i>
              </el-input>
            </div>
          </el-form-item>

          <el-form-item prop="code" v-if="captchaEnabled">
            <div class="form-group">
              <label>安全验证</label>
              <div class="captcha-layout">
                <el-input
                  v-model="registerForm.code"
                  auto-complete="off"
                  placeholder="输入验证码"
                  class="sleek-input code-input"
                  @keyup.enter.native="handleRegister"
                >
                  <i slot="prefix" class="el-icon-c-scale-to-original"></i>
                </el-input>
                <div class="img-box" @click="getCode" title="点击刷新验证码">
                  <img :src="codeUrl" alt="验证码" />
                </div>
              </div>
            </div>
          </el-form-item>

          <div class="action-row flex-column">
            <div class="agreement-text">
              注册即表示您同意我们的 <a href="javascript:void(0)" class="highlight-link">服务条款</a> 和 <a href="javascript:void(0)" class="highlight-link">隐私政策</a>
            </div>
            <div class="login-redirect">
              <span>已有账户？</span>
              <router-link to="/login" class="text-btn">立即登录</router-link>
            </div>
          </div>

          <el-button
            :loading="loading"
            class="submit-btn"
            @click.native.prevent="handleRegister"
          >
            <span v-if="!loading">立即注册账户</span>
            <span v-else>正在提交注册信息...</span>
          </el-button>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>
// 逻辑部分完全保留，未做任何改动
import { getCodeImg, register } from "@/api/login"

export default {
  name: "Register",
  data() {
    const equalToPassword = (rule, value, callback) => {
      if (this.registerForm.password !== value) {
        callback(new Error("两次输入的密码不一致"))
      } else {
        callback()
      }
    }
    return {
      title: "智能垃圾分类识别系统",
      codeUrl: "",
      registerForm: {
        username: "",
        password: "",
        confirmPassword: "",
        code: "",
        uuid: ""
      },
      registerRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" },
          { min: 2, max: 20, message: '用户账号长度必须介于 2 和 20 之间', trigger: 'blur' }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" },
          { min: 5, max: 20, message: "用户密码长度必须介于 5 和 20 之间", trigger: "blur" },
          { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "blur" }
        ],
        confirmPassword: [
          { required: true, trigger: "blur", message: "请再次输入您的密码" },
          { required: true, validator: equalToPassword, trigger: "blur" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true
    }
  },
  created() {
    this.getCode()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl =  res.img
          this.registerForm.uuid = res.uuid
        }
      })
    },
    handleRegister() {
      this.$refs.registerForm.validate(valid => {
        if (valid) {
          this.loading = true
          register(this.registerForm).then(res => {
            const username = this.registerForm.username
            this.$alert("<font color='red'>恭喜你，您的账号 " + username + " 注册成功！</font>", '系统提示', {
              dangerouslyUseHTMLString: true,
              type: 'success'
            }).then(() => {
              this.$router.push("/login")
            }).catch(() => {})
          }).catch(() => {
            this.loading = false
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
/* --- 全局视图框架 (复用登录页底座以保持一致) --- */
.auth-view-wrapper {
  display: flex;
  min-height: 100vh;
  width: 100%;
  background-color: #ffffff;
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
  overflow: hidden;
}

/* --- 左侧视觉区 (注册页变体) --- */
.visual-showcase-panel.signup-variant {
  flex: 1.2;
  position: relative;
  /* 稍微改变一点渐变角度和色值，与登录页有微妙的视觉区分 */
  background: linear-gradient(120deg, #ecfdf5 0%, #d1fae5 100%);
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 8vw;
  overflow: hidden;

  /* 注册页特有背景光影 */
  .eco-elements {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    pointer-events: none;

    .shape {
      position: absolute;
      border-radius: 50%;
      filter: blur(70px);
      opacity: 0.5;
      animation: float-alt 14s infinite alternate ease-in-out;
    }
    .shape-leaf {
      width: 45vw; height: 45vw; background: #6ee7b7;
      bottom: -15vw; left: -10vw;
    }
    .shape-sun {
      width: 35vw; height: 35vw; background: #fde047;
      top: -5vw; right: -5vw; animation-delay: -4s;
    }
    .shape-water {
      width: 20vw; height: 20vw; background: #99f6e4;
      top: 40%; left: 30%; animation-delay: -7s;
    }
  }

  .brand-hero {
    position: relative;
    z-index: 2;
    max-width: 600px;
    animation: fade-in-up 1s ease-out;

    .logo-box {
      width: 72px;
      height: 72px;
      background: #047857; /* 稍微深一点的绿 */
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 2rem;
      box-shadow: 0 20px 40px -10px rgba(4, 120, 87, 0.4);

      i { font-size: 36px; color: #ffffff; }
    }

    .hero-title {
      font-size: 3.5rem;
      font-weight: 800;
      color: #064e3b;
      line-height: 1.2;
      margin: 0 0 1.5rem 0;
      letter-spacing: -1.5px;
    }

    .hero-desc {
      font-size: 1.15rem;
      color: #065f46;
      line-height: 1.6;
      margin-bottom: 3rem;
      opacity: 0.85;
    }

    .feature-cards {
      display: flex;
      gap: 1.2rem;
      flex-wrap: wrap;

      .glass-card {
        background: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.9);
        padding: 0.8rem 1.2rem;
        border-radius: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 15px -3px rgba(0, 0, 0, 0.05);
        transition: transform 0.3s ease;

        &:hover { transform: translateY(-3px); background: rgba(255, 255, 255, 0.9); }
        i { font-size: 18px; color: #047857; }
        span { font-weight: 600; color: #064e3b; font-size: 0.9rem; }
      }
    }
  }

  .copyright-text {
    position: absolute;
    bottom: 2rem;
    left: 8vw;
    z-index: 2;
    color: #065f46;
    font-size: 0.85rem;
    opacity: 0.6;
  }
}

/* --- 右侧表单区 --- */
.interaction-form-panel {
  flex: 0.8;
  min-width: 450px;
  max-width: 600px;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  z-index: 10;
  box-shadow: -20px 0 50px -20px rgba(0, 0, 0, 0.05);

  .form-container {
    width: 100%;
    max-width: 400px;
    padding: 2rem;
    animation: fade-in-left 0.8s ease-out;

    .welcome-header {
      margin-bottom: 2.5rem;

      h2 {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.5rem 0;
      }
      p {
        color: #6b7280;
        font-size: 0.95rem;
        margin: 0;
      }
    }

    /* 统一的表单控件样式 */
    .modern-auth-form {
      .el-form-item { margin-bottom: 20px; border: none; }

      .form-group {
        display: flex;
        flex-direction: column;

        label {
          font-size: 0.9rem;
          font-weight: 600;
          color: #374151;
          margin-bottom: 8px;
        }

        .sleek-input {
          .el-input__inner {
            height: 48px; /* 注册页项较多，高度稍微收敛一点点 */
            background: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding-left: 42px;
            font-size: 0.95rem;
            color: #1f2937;
            transition: all 0.2s ease;

            &:focus {
              background: #ffffff;
              border-color: #10b981;
              box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
            }
          }

          .el-input__prefix {
            left: 14px;
            display: flex;
            align-items: center;
            i { font-size: 16px; color: #9ca3af; }
          }

          &.is-active .el-input__prefix i,
          &:focus-within .el-input__prefix i { color: #10b981; }
        }

        .captcha-layout {
          display: flex;
          gap: 12px;
          .code-input { flex: 1; }
          .img-box {
            width: 120px;
            height: 48px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
            cursor: pointer;
            img { width: 100%; height: 100%; object-fit: fill; }
          }
        }
      }

      .action-row {
        margin-bottom: 1.8rem;
        margin-top: 10px;

        &.flex-column {
          display: flex;
          flex-direction: column;
          gap: 12px;
        }

        .agreement-text {
          font-size: 0.85rem;
          color: #6b7280;
          text-align: center;

          .highlight-link {
            color: #10b981;
            text-decoration: none;
            font-weight: 500;
            &:hover { text-decoration: underline; color: #059669; }
          }
        }

        .login-redirect {
          text-align: center;
          font-size: 0.9rem;
          color: #4b5563;

          .text-btn {
            color: #10b981;
            font-weight: 600;
            text-decoration: none;
            margin-left: 5px;
            transition: color 0.3s ease;
            &:hover { color: #059669; }
          }
        }
      }

      .submit-btn {
        width: 100%;
        height: 52px;
        background: #10b981;
        border: none;
        border-radius: 12px;
        color: white;
        font-size: 1.05rem;
        font-weight: 600;
        letter-spacing: 1px;
        box-shadow: 0 8px 20px -5px rgba(16, 185, 129, 0.4);
        transition: all 0.3s ease;

        &:hover {
          background: #059669;
          transform: translateY(-2px);
          box-shadow: 0 12px 25px -5px rgba(5, 150, 105, 0.4);
        }
        &:active { transform: translateY(0); }
      }
    }
  }
}

/* --- 动画与响应式 --- */
@keyframes float-alt {
  0% { transform: translate(0, 0) scale(1) rotate(0deg); }
  100% { transform: translate(-3vw, 2vw) scale(1.1) rotate(5deg); }
}

@keyframes fade-in-up {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fade-in-left {
  from { opacity: 0; transform: translateX(30px); }
  to { opacity: 1; transform: translateX(0); }
}

@media (max-width: 992px) {
  .auth-view-wrapper { flex-direction: column; }

  .visual-showcase-panel.signup-variant {
    flex: none;
    padding: 3rem 2rem;
    min-height: auto;

    .brand-hero {
      .hero-title { font-size: 2.2rem; }
      .feature-cards { display: none; } /* 移动端隐藏以保证表单显示在首屏 */
    }
  }

  .interaction-form-panel {
    flex: 1;
    min-width: 100%;
    border-radius: 30px 30px 0 0;
    margin-top: -30px;

    .form-container { padding: 2rem 1.5rem; }
  }
}
</style>
