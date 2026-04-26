import request from '@/utils/request'

// 查询垃圾分类测验题目列表
export function listQuestion(query) {
  return request({
    url: '/system/question/list',
    method: 'GET',
    data: query
  })
}

// 查询垃圾分类测验题目详细
export function getQuestion(questionId) {
  return request({
    url: '/system/question/' + questionId,
    method: 'GET'
  })
}

// 新增垃圾分类测验题目
export function addQuestion(data) {
  return request({
    url: '/system/question',
    method: 'POST',
    data: data
  })
}

// 修改垃圾分类测验题目
export function updateQuestion(data) {
  return request({
    url: '/system/question',
    method: 'PUT',
    data: data
  })
}

// 删除垃圾分类测验题目
export function delQuestion(questionId) {
  return request({
    url: '/system/question/' + questionId,
    method: 'DELETE'
  })
}

// 批量删除垃圾分类测验题目
export function delQuestions(questionIds) {
  return request({
    url: '/system/question/' + questionIds,
    method: 'DELETE'
  })
}

// 导出垃圾分类测验题目
export function exportQuestion(query) {
  return request({
    url: '/system/question/export',
    method: 'POST',
    data: query
  })
}
