import request from '@/utils/request'

// 查询垃圾物品列表
export function listItem(query) {
  return request({
    url: '/system/item/list',
    method: 'GET',
    data: query
  })
}

// 查询垃圾物品详细
export function getItem(itemId) {
  return request({
    url: '/system/item/' + itemId,
    method: 'GET'
  })
}

// 新增垃圾物品
export function addItem(data) {
  return request({
    url: '/system/item',
    method: 'POST',
    data: data
  })
}

// 修改垃圾物品
export function updateItem(data) {
  return request({
    url: '/system/item',
    method: 'PUT',
    data: data
  })
}

// 删除垃圾物品
export function delItem(itemId) {
  return request({
    url: '/system/item/' + itemId,
    method: 'DELETE'
  })
}

// 批量删除垃圾物品
export function delItems(itemIds) {
  return request({
    url: '/system/item/' + itemIds,
    method: 'DELETE'
  })
}

// 导出垃圾物品
export function exportItem(query) {
  return request({
    url: '/system/item/export',
    method: 'POST',
    data: query
  })
}
