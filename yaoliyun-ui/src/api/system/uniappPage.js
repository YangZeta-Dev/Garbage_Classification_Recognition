import request from '@/utils/request'

// 查询UniApp页面管理列表
export function listUniappPage(query) {
  return request({
    url: '/system/uniappPage/list',
    method: 'get',
    params: query
  })
}

// 查询UniApp页面管理详细
export function getUniappPage(pageId) {
  return request({
    url: '/system/uniappPage/' + pageId,
    method: 'get'
  })
}

// 新增UniApp页面管理
export function addUniappPage(data) {
  return request({
    url: '/system/uniappPage',
    method: 'post',
    data: data
  })
}

// 修改UniApp页面管理
export function updateUniappPage(data) {
  return request({
    url: '/system/uniappPage',
    method: 'put',
    data: data
  })
}

// 删除UniApp页面管理
export function delUniappPage(pageId) {
  return request({
    url: '/system/uniappPage/' + pageId,
    method: 'delete'
  })
}

// 创建页面文件和目录
export function createPage(data) {
  return request({
    url: '/system/uniappPage/createPage',
    method: 'post',
    data: data
  })
}

// 删除页面文件和目录 (DELETE方式)
export function deletePage(pagePath) {
  return request({
    url: '/system/uniappPage/deletePage/' + encodeURIComponent(pagePath),
    method: 'delete'
  })
}

// 删除页面文件和目录 (POST方式 - 避免CORS问题)
export function deletePageByPost(pagePath) {
  return request({
    url: '/system/uniappPage/deletePageByPost',
    method: 'post',
    data: { pagePath: pagePath }
  })
}

// 同步pages.json到数据库
export function syncPages() {
  return request({
    url: '/system/uniappPage/sync',
    method: 'post'
  })
}

// 更新pages.json配置
export function updateConfig() {
  return request({
    url: '/system/uniappPage/updateConfig',
    method: 'post'
  })
}

// 备份pages.json文件
export function backup() {
  return request({
    url: '/system/uniappPage/backup',
    method: 'post'
  })
}

// 验证页面路径
export function validatePath(pagePath) {
  return request({
    url: '/system/uniappPage/validate',
    method: 'post',
    params: { pagePath: pagePath }
  })
}

// 批量操作页面状态
export function batchStatus(data) {
  return request({
    url: '/system/uniappPage/batchStatus',
    method: 'post',
    data: data
  })
}

// 设置页面为底部导航
export function setTabBar(pageId, isTabbar, tabbarText) {
  return request({
    url: '/system/uniappPage/setTabBar',
    method: 'put',
    data: { pageId, isTabbar, tabbarText }
  })
}

// 获取页面代码 (POST方式 - 避免CORS问题)
export function getPageCode(pagePath) {
  return request({
    url: '/system/uniappPage/getPageCode',
    method: 'post',
    data: { pagePath: pagePath }
  })
}

// 保存页面代码
export function savePageCode(pagePath, code) {
  return request({
    url: '/system/uniappPage/code',
    method: 'post',
    data: { pagePath, code }
  })
}

// 保存页面代码 (Base64编码方式 - 解决HTML标签丢失问题)
export function savePageCodeBase64(pagePath, code) {
  // 使用Base64编码避免HTML标签被转义
  const codeBase64 = btoa(unescape(encodeURIComponent(code)))
  console.log('前端Base64编码前代码长度:', code.length)
  console.log('前端Base64编码前包含template:', code.includes('<template>'))
  console.log('前端Base64编码后长度:', codeBase64.length)
  
  return request({
    url: '/system/uniappPage/codeBase64',
    method: 'post',
    data: { pagePath, code: codeBase64 }
  })
}

// 从备份恢复页面代码
export function restoreFromBackup(pagePath, backupFileName) {
  return request({
    url: '/system/uniappPage/restoreFromBackup',
    method: 'post',
    data: { pagePath, backupFileName }
  })
}

// 获取页面备份文件列表
export function getPageBackups(pagePath) {
  return request({
    url: '/system/uniappPage/getPageBackups',
    method: 'post',
    data: { pagePath }
  })
}

// 获取pages.json备份文件列表
export function getPagesJsonBackups() {
  return request({
    url: '/system/uniappPage/getPagesJsonBackups',
    method: 'get'
  })
}

// 清理旧备份文件
export function cleanBackups(days = 7) {
  return request({
    url: '/system/uniappPage/cleanBackups',
    method: 'post',
    data: { days }
  })
} 