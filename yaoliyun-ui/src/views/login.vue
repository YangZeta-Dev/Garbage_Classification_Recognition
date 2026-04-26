<template>
  <div class="auth-view-wrapper">
    <div class="visual-showcase-panel">
      <div class="eco-elements">
        <div class="shape shape-green"></div>
        <div class="shape shape-mint"></div>
        <div class="shape shape-yellow"></div>
      </div>

      <div class="brand-hero">
        <div class="logo-box">
          <i class="el-icon-s-cooperation"></i>
        </div>
        <h1 class="hero-title">AI 驱动<br/>绿色未来</h1>
        <p class="hero-desc">社区智能垃圾分类督导系统，让每一次投递都更有价值。</p>

        <div class="feature-cards">
          <div class="glass-card">
            <i class="el-icon-cpu"></i>
            <span>智能图像识别</span>
          </div>
          <div class="glass-card">
            <i class="el-icon-reading"></i>
            <span>海量知识图谱</span>
          </div>
          <div class="glass-card">
            <i class="el-icon-trophy"></i>
            <span>碳积分奖励</span>
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
          <h2>系统登录</h2>
          <p>欢迎回来，请验证您的管理员身份</p>
        </div>

        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="modern-login-form">
          <el-form-item prop="username">
            <div class="form-group">
              <label>账号</label>
              <el-input
                v-model="loginForm.username"
                type="text"
                auto-complete="off"
                placeholder="请输入登录账号"
                class="sleek-input"
              >
                <i slot="prefix" class="el-icon-user"></i>
              </el-input>
            </div>
          </el-form-item>

          <el-form-item prop="password">
            <div class="form-group">
              <label>密码</label>
              <el-input
                v-model="loginForm.password"
                type="password"
                auto-complete="off"
                placeholder="请输入登录密码"
                class="sleek-input"
                @keyup.enter.native="handleLogin"
              >
                <i slot="prefix" class="el-icon-lock"></i>
              </el-input>
            </div>
          </el-form-item>

          <el-form-item prop="code" v-if="captchaEnabled">
            <div class="form-group">
              <label>安全验证</label>
              <div class="captcha-layout">
                <el-input
                  v-model="loginForm.code"
                  auto-complete="off"
                  placeholder="请输入验证码"
                  class="sleek-input code-input"
                  @keyup.enter.native="handleLogin"
                >
                  <i slot="prefix" class="el-icon-key"></i>
                </el-input>
                <div class="img-box" @click="getCode" title="点击刷新">
                  <img :src="codeUrl" alt="验证码" />
                </div>
              </div>
            </div>
          </el-form-item>

          <div class="action-row">
            <el-checkbox v-model="loginForm.rememberMe" class="custom-checkbox">自动登录</el-checkbox>
            <router-link v-if="register" to="/register" class="text-btn">注册新账号</router-link>
          </div>

          <el-button
            :loading="loading"
            class="submit-btn"
            @click.native.prevent="handleLogin"
          >
            <span v-if="!loading">进入系统</span>
            <span v-else>正在验证身份...</span>
          </el-button>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>
// 这里的逻辑与你提供的代码完全一致，没有任何改动
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'

export default {
  name: "Login",
  data() {
    return {
      title: "智能垃圾分类识别系统",
      codeUrl: "",
      loginForm: {
        username: "admin",
        password: "admin123",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true,
      register: true,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = res.img
          this.loginForm.uuid = res.uuid
        }
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove("password")
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
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
/* --- 全局视图框架 --- */
.auth-view-wrapper {
  display: flex;
  min-height: 100vh;
  width: 100%;
  background-color: #ffffff;
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
  overflow: hidden;
}

/* --- 左侧视觉区 --- */
.visual-showcase-panel {
  flex: 1.2; /* 占据较大比例 */
  position: relative;
  background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 8vw;
  overflow: hidden;

  /* 极简抽象几何背景 */
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
      filter: blur(60px);
      opacity: 0.5;
      animation: float-slow 12s infinite alternate ease-in-out;
    }
    .shape-green {
      width: 40vw; height: 40vw; background: #86efac;
      top: -10vw; left: -10vw;
    }
    .shape-mint {
      width: 30vw; height: 30vw; background: #6ee7b7;
      bottom: 10vw; right: -5vw; animation-delay: -3s;
    }
    .shape-yellow {
      width: 25vw; height: 25vw; background: #fef08a;
      top: 30%; left: 40%; animation-delay: -6s;
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
      background: #166534;
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 2rem;
      box-shadow: 0 20px 40px -10px rgba(22, 101, 52, 0.4);

      i { font-size: 36px; color: #ffffff; }
    }

    .hero-title {
      font-size: 4rem;
      font-weight: 800;
      color: #064e3b;
      line-height: 1.1;
      margin: 0 0 1.5rem 0;
      letter-spacing: -2px;
    }

    .hero-desc {
      font-size: 1.2rem;
      color: #065f46;
      line-height: 1.6;
      margin-bottom: 3rem;
      opacity: 0.8;
    }

    .feature-cards {
      display: flex;
      gap: 1.5rem;
      flex-wrap: wrap;

      .glass-card {
        background: rgba(255, 255, 255, 0.6);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.8);
        padding: 1rem 1.5rem;
        border-radius: 16px;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        transition: transform 0.3s ease;

        &:hover { transform: translateY(-5px); }
        i { font-size: 20px; color: #059669; }
        span { font-weight: 600; color: #064e3b; font-size: 0.95rem; }
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
      margin-bottom: 3rem;

      h2 {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.5rem 0;
      }
      p {
        color: #6b7280;
        font-size: 1rem;
        margin: 0;
      }
    }

    /* 深度复写 Element UI 样式 */
    .modern-login-form {
      .el-form-item { margin-bottom: 24px; border: none; }

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
            height: 50px;
            background: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding-left: 45px;
            font-size: 1rem;
            color: #1f2937;
            transition: all 0.2s ease;

            &:focus {
              background: #ffffff;
              border-color: #10b981;
              box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
            }
          }

          .el-input__prefix {
            left: 15px;
            display: flex;
            align-items: center;
            i { font-size: 18px; color: #9ca3af; }
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
            height: 50px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
            cursor: pointer;
            img { width: 100%; height: 100%; object-fit: fill; }
          }
        }
      }

      .action-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;

        .custom-checkbox .el-checkbox__inner { border-radius: 4px; }
        .custom-checkbox.is-checked .el-checkbox__inner {
          background-color: #10b981; border-color: #10b981;
        }
        .custom-checkbox.is-checked .el-checkbox__label { color: #111827; }

        .text-btn {
          color: #10b981;
          font-size: 0.9rem;
          font-weight: 600;
          text-decoration: none;
          &:hover { color: #059669; }
        }
      }

      .submit-btn {
        width: 100%;
        height: 54px;
        background: #10b981;
        border: none;
        border-radius: 12px;
        color: white;
        font-size: 1.1rem;
        font-weight: 600;
        letter-spacing: 1px;
        box-shadow: 0 10px 25px -5px rgba(16, 185, 129, 0.4);
        transition: all 0.3s ease;

        &:hover {
          background: #059669;
          transform: translateY(-2px);
          box-shadow: 0 15px 30px -5px rgba(5, 150, 105, 0.4);
        }
        &:active { transform: translateY(0); }
      }
    }
  }
}

/* --- 动画与响应式 --- */
@keyframes float-slow {
  0% { transform: translate(0, 0) scale(1); }
  100% { transform: translate(2vw, -2vw) scale(1.05); }
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

  .visual-showcase-panel {
    flex: none;
    padding: 3rem 2rem;
    min-height: auto;

    .brand-hero {
      .hero-title { font-size: 2.5rem; }
      .feature-cards { display: none; } /* 移动端隐藏卡片省空间 */
    }
  }

  .interaction-form-panel {
    flex: 1;
    min-width: 100%;
    border-radius: 30px 30px 0 0;
    margin-top: -30px; /* 产生重叠层次感 */

    .form-container { padding: 2rem 1.5rem; }
  }
}
</style>
