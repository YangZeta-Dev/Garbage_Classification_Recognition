import request from '@/utils/request'

// 查询垃圾分类测验题目列表
export function listQuestion(query) {
  return request({
    url: '/system/question/list',
    method: 'get',
    params: query
  })
}

// 查询垃圾分类测验题目详细
export function getQuestion(questionId) {
  return request({
    url: '/system/question/' + questionId,
    method: 'get'
  })
}

// 新增垃圾分类测验题目
export function addQuestion(data) {
  return request({
    url: '/system/question',
    method: 'post',
    data: data
  })
}

// 修改垃圾分类测验题目
export function updateQuestion(data) {
  return request({
    url: '/system/question',
    method: 'put',
    data: data
  })
}

// 删除垃圾分类测验题目
export function delQuestion(questionId) {
  return request({
    url: '/system/question/' + questionId,
    method: 'delete'
  })
}

// 批量删除垃圾分类测验题目
export function delQuestions(questionIds) {
  return request({
    url: '/system/question/' + questionIds,
    method: 'delete'
  })
}

// 导出垃圾分类测验题目
export function exportQuestion(query) {
  return request({
    url: '/system/question/export',
    method: 'post',
    params: query
  })
}

// 查询关联文章ID选项列表
export function getArticleIdOptions() {
  return request({
    url: '/system/question/articleId/options',
    method: 'get'
  })
}

// 查询关联分类ID选项列表
export function getCategoryIdOptions() {
  return request({
    url: '/system/question/categoryId/options',
    method: 'get'
  })
}
