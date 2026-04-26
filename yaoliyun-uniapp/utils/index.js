// 常用工具函数

// 图片URL处理 - 根据接口文档，图片按逗号分割需要添加请求前缀
export const processImageUrl = (imageStr, baseUrl = 'http://localhost:8080') => {
  if (!imageStr) return []
  
  // 如果传入的是数组，直接处理数组
  if (Array.isArray(imageStr)) {
    return imageStr.map(img => {
      if (!img) return ''
      const trimmedImg = img.toString().trim()
      if (trimmedImg.startsWith('http')) return trimmedImg
      return baseUrl + trimmedImg
    }).filter(img => img) // 过滤空值
  }
  
  // 如果传入的是字符串
  if (typeof imageStr !== 'string') {
    imageStr = imageStr.toString()
  }
  
  if (imageStr.includes(',')) {
    // 多张图片
    return imageStr.split(',').map(img => {
      const trimmedImg = img.trim()
      if (trimmedImg.startsWith('http')) return trimmedImg
      return baseUrl + trimmedImg
    }).filter(img => img) // 过滤空值
  } else {
    // 单张图片，也返回数组格式以保持一致性
    const trimmedImg = imageStr.trim()
    if (trimmedImg.startsWith('http')) return [trimmedImg]
    return [baseUrl + trimmedImg]
  }
}

// 获取第一张图片
export const getFirstImage = (imageStr) => {
  const images = processImageUrl(imageStr)
    return images[0] || ''
}

// 格式化日期
export const formatDate = (date, format = 'YYYY-MM-DD HH:mm:ss') => {
  if (!date) return ''
  
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  const hours = String(d.getHours()).padStart(2, '0')
  const minutes = String(d.getMinutes()).padStart(2, '0')
  const seconds = String(d.getSeconds()).padStart(2, '0')
  
  return format
    .replace('YYYY', year)
    .replace('MM', month)
    .replace('DD', day)
    .replace('HH', hours)
    .replace('mm', minutes)
    .replace('ss', seconds)
}

// 防抖函数
export const debounce = (func, wait) => {
  let timeout
  return function (...args) {
    clearTimeout(timeout)
    timeout = setTimeout(() => func.apply(this, args), wait)
  }
}

// 节流函数
export const throttle = (func, wait) => {
  let timeout
  return function (...args) {
    if (!timeout) {
      timeout = setTimeout(() => {
        timeout = null
        func.apply(this, args)
      }, wait)
    }
  }
}

// 价格格式化
export const formatPrice = (price) => {
  if (price == null || price === '') return '0.00'
  return Number(price).toFixed(2)
}


// 验证手机号
export const validatePhone = (phone) => {
  const phoneReg = /^1[3-9]\d{9}$/
  return phoneReg.test(phone)
}

// 验证邮箱
export const validateEmail = (email) => {
  const emailReg = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  return emailReg.test(email)
}

// 验证身份证号
export const validateIdCard = (idCard) => {
  const idCardReg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/
  return idCardReg.test(idCard)
}

// 页面跳转封装
export const navigateTo = (url, params = {}) => {
  let urlWithParams = url
  if (Object.keys(params).length > 0) {
    const queryString = Object.keys(params)
      .map(key => `${key}=${encodeURIComponent(params[key])}`)
      .join('&')
    urlWithParams += (url.includes('?') ? '&' : '?') + queryString
  }
  
  uni.navigateTo({
    url: urlWithParams,
    fail: (err) => {
		uni.switchTab({
			url:urlWithParams
		})
      console.error('页面跳转失败:', err)
    }
  })
}

// 显示加载提示
export const showLoading = (title = '加载中...') => {
  uni.showLoading({
    title,
    mask: true
  })
}

// 隐藏加载提示
export const hideLoading = () => {
  uni.hideLoading()
}

// 显示成功提示
export const showSuccess = (title = '操作成功') => {
  uni.showToast({
    title,
    icon: 'success',
    duration: 2000
  })
}

// 显示错误提示
export const showError = (title = '操作失败') => {
  uni.showToast({
    title,
    icon: 'none',
    duration: 2000
  })
}
