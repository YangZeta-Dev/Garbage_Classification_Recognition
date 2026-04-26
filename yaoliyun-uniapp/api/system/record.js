import request from '@/utils/request'

// 查询垃圾识别记录列表
export function listRecord(query) {
  return request({
    url: '/system/record/list',
    method: 'GET',
    data: query
  })
}

// 查询垃圾识别记录详细
export function getRecord(recordId) {
  return request({
    url: '/system/record/' + recordId,
    method: 'GET'
  })
}

// 新增垃圾识别记录
export function addRecord(data) {
  return request({
    url: '/system/record',
    method: 'POST',
    data: data
  })
}

// 修改垃圾识别记录
export function updateRecord(data) {
  return request({
    url: '/system/record',
    method: 'PUT',
    data: data
  })
}

// 删除垃圾识别记录
export function delRecord(recordId) {
  return request({
    url: '/system/record/' + recordId,
    method: 'DELETE'
  })
}

// 批量删除垃圾识别记录
export function delRecords(recordIds) {
  return request({
    url: '/system/record/' + recordIds,
    method: 'DELETE'
  })
}

// 导出垃圾识别记录
export function exportRecord(query) {
  return request({
    url: '/system/record/export',
    method: 'POST',
    data: query
  })
}
