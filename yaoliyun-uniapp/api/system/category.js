import request from '@/utils/request'

// 查询垃圾分类类别列表
export function listCategory(query) {
  return request({
    url: '/system/category/list',
    method: 'GET',
    data: query
  })
}

// 查询垃圾分类类别详细
export function getCategory(categoryId) {
  return request({
    url: '/system/category/' + categoryId,
    method: 'GET'
  })
}

// 新增垃圾分类类别
export function addCategory(data) {
  return request({
    url: '/system/category',
    method: 'POST',
    data: data
  })
}

// 修改垃圾分类类别
export function updateCategory(data) {
  return request({
    url: '/system/category',
    method: 'PUT',
    data: data
  })
}

// 删除垃圾分类类别
export function delCategory(categoryId) {
  return request({
    url: '/system/category/' + categoryId,
    method: 'DELETE'
  })
}

// 批量删除垃圾分类类别
export function delCategorys(categoryIds) {
  return request({
    url: '/system/category/' + categoryIds,
    method: 'DELETE'
  })
}

// 导出垃圾分类类别
export function exportCategory(query) {
  return request({
    url: '/system/category/export',
    method: 'POST',
    data: query
  })
}
