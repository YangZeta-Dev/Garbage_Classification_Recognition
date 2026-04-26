import request from '@/utils/request'

// 查询垃圾分类类别列表
export function listCategory(query) {
  return request({
    url: '/system/category/list',
    method: 'get',
    params: query
  })
}

// 查询垃圾分类类别详细
export function getCategory(categoryId) {
  return request({
    url: '/system/category/' + categoryId,
    method: 'get'
  })
}

// 新增垃圾分类类别
export function addCategory(data) {
  return request({
    url: '/system/category',
    method: 'post',
    data: data
  })
}

// 修改垃圾分类类别
export function updateCategory(data) {
  return request({
    url: '/system/category',
    method: 'put',
    data: data
  })
}

// 删除垃圾分类类别
export function delCategory(categoryId) {
  return request({
    url: '/system/category/' + categoryId,
    method: 'delete'
  })
}

// 批量删除垃圾分类类别
export function delCategorys(categoryIds) {
  return request({
    url: '/system/category/' + categoryIds,
    method: 'delete'
  })
}

// 导出垃圾分类类别
export function exportCategory(query) {
  return request({
    url: '/system/category/export',
    method: 'post',
    params: query
  })
}
