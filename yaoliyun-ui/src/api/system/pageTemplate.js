import request from '@/utils/request'

// 查询页面模板管理列表
export function listPageTemplate(query) {
  return request({
    url: '/system/pageTemplate/list',
    method: 'get',
    params: query
  })
}

// 查询页面模板管理详细
export function getPageTemplate(templateId) {
  return request({
    url: '/system/pageTemplate/' + templateId,
    method: 'get'
  })
}

// 新增页面模板管理
export function addPageTemplate(data) {
  return request({
    url: '/system/pageTemplate',
    method: 'post',
    data: data
  })
}

// 新增页面模板（包含代码）
export function addPageTemplateWithCode(data) {
  return request({
    url: '/system/pageTemplate/withCode',
    method: 'post',
    data: data
  })
}

// 新增页面模板（自动Base64编码代码）
export function addPageTemplateWithCodeBase64(data) {
  // 如果包含代码，自动进行Base64编码
  if (data.code) {
    try {
      data.code = btoa(unescape(encodeURIComponent(data.code)))
    } catch (e) {
      console.warn('Base64编码失败，使用原始代码:', e)
    }
  }
  
  return request({
    url: '/system/pageTemplate/withCode',
    method: 'post',
    data: data
  })
}

// 修改页面模板管理
export function updatePageTemplate(data) {
  return request({
    url: '/system/pageTemplate',
    method: 'put',
    data: data
  })
}

// 修改页面模板（包含代码，自动Base64编码）
export function updatePageTemplateWithCode(data) {
  // 如果包含代码，自动进行Base64编码
  if (data.templateCode) {
    try {
      const originalCode = data.templateCode
      data.templateCode = btoa(unescape(encodeURIComponent(originalCode)))
      console.log('模板代码Base64编码前长度:', originalCode.length)
      console.log('模板代码Base64编码前包含template:', originalCode.includes('<template>'))
      console.log('模板代码Base64编码后长度:', data.templateCode.length)
    } catch (e) {
      console.warn('模板代码Base64编码失败，使用原始代码:', e)
    }
  }
  
  return request({
    url: '/system/pageTemplate/withCode',
    method: 'put',
    data: data
  })
}

// 删除页面模板管理
export function delPageTemplate(templateId) {
  return request({
    url: '/system/pageTemplate/' + templateId,
    method: 'delete'
  })
}

// 查询热门模板列表
export function getPopularTemplates(limit = 10) {
  return request({
    url: '/system/pageTemplate/popular/' + limit,
    method: 'get'
  })
}

// 根据分类查询模板列表
export function getTemplatesByCategory(category) {
  return request({
    url: '/system/pageTemplate/category/' + category,
    method: 'get'
  })
}

// 根据类型查询模板列表
export function getTemplatesByType(templateType) {
  return request({
    url: '/system/pageTemplate/type/' + templateType,
    method: 'get'
  })
}

// 获取模板统计信息
export function getTemplateStatistics() {
  return request({
    url: '/system/pageTemplate/statistics',
    method: 'get'
  })
}

// 获取模板代码（自动Base64解码）
export function getTemplateCode(templateId) {
  return request({
    url: '/system/pageTemplate/code/' + templateId,
    method: 'get'
  }).then(response => {
    // 自动进行Base64解码
    if (response.code === 200 && response.data) {
      try {
        const decodedCode = atob(response.data)
        response.data = decodedCode
      } catch (e) {
        console.warn('Base64解码失败，返回原始数据:', e)
      }
    }
    return response
  })
}

// 复制模板代码（增加使用次数，自动Base64解码）
export function copyTemplateCode(templateId) {
  return request({
    url: '/system/pageTemplate/copy/' + templateId,
    method: 'post'
  }).then(response => {
    // 自动进行Base64解码
    if (response.code === 200 && response.data) {
      try {
        const decodedCode = atob(response.data)
        response.data = decodedCode
      } catch (e) {
        console.warn('Base64解码失败，返回原始数据:', e)
      }
    }
    return response
  })
}

// 使用模板（仅增加使用次数）
export function useTemplate(templateId) {
  return request({
    url: '/system/pageTemplate/use/' + templateId,
    method: 'post'
  })
} 