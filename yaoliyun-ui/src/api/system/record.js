import request from '@/utils/request'

// 查询垃圾识别记录列表
export function listRecord(query) {
  return request({
    url: '/system/record/list',
    method: 'get',
    params: query
  })
}

// 查询垃圾识别记录详细
export function getRecord(recordId) {
  return request({
    url: '/system/record/' + recordId,
    method: 'get'
  })
}

// 新增垃圾识别记录
export function addRecord(data) {
  return request({
    url: '/system/record',
    method: 'post',
    data: data
  })
}

// 修改垃圾识别记录
export function updateRecord(data) {
  return request({
    url: '/system/record',
    method: 'put',
    data: data
  })
}

// 删除垃圾识别记录
export function delRecord(recordId) {
  return request({
    url: '/system/record/' + recordId,
    method: 'delete'
  })
}

// 批量删除垃圾识别记录
export function delRecords(recordIds) {
  return request({
    url: '/system/record/' + recordIds,
    method: 'delete'
  })
}

// 导出垃圾识别记录
export function exportRecord(query) {
  return request({
    url: '/system/record/export',
    method: 'post',
    params: query
  })
}

// 查询用户ID选项列表
export function getUserIdOptions() {
  return request({
    url: '/system/record/userId/options',
    method: 'get'
  })
}

// 查询分类ID选项列表
export function getCategoryIdOptions() {
  return request({
    url: '/system/record/categoryId/options',
    method: 'get'
  })
}
