import request from '@/utils/request'

// 获取系统统计概览数据
export function getSystemOverview() {
  return request({
    url: '/system/index/overview',
    method: 'get'
  })
}

// 获取用户注册趋势数据（最近30天）
export function getUserTrend() {
  return request({
    url: '/system/index/userTrend',
    method: 'get'
  })
}

// 获取在线用户趋势数据（最近24小时）
export function getOnlineTrend() {
  return request({
    url: '/system/index/onlineTrend',
    method: 'get'
  })
}

// 获取系统模块使用统计
export function getModuleUsage() {
  return request({
    url: '/system/index/moduleUsage',
    method: 'get'
  })
}

// 获取垃圾分类统计概览数据
export function getGarbageOverview() {
  return request({
    url: '/system/index/garbageOverview',
    method: 'get'
  })
}

// 获取各分类识别统计
export function getCategoryStats() {
  return request({
    url: '/system/index/categoryStats',
    method: 'get'
  })
}

// 获取识别趋势数据（最近30天）
export function getRecognitionTrend() {
  return request({
    url: '/system/index/recognitionTrend',
    method: 'get'
  })
}