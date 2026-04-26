import request from '@/utils/request'

// 根据图像识别垃圾分类（支持base64编码或图片URL）
export function recognizeGarbage(data) {
  return request({
    url: '/system/recognition/recognize',
    method: 'POST',
    data: data
  })
}

// 根据图片base64识别垃圾分类
export function recognizeByBase64(img, mode) {
  return request({
    url: '/system/recognition/recognizeByBase64',
    method: 'POST',
    data: { img, mode }
  })
}

// 根据图片URL识别垃圾分类
export function recognizeByUrl(imgurl, mode) {
  return request({
    url: '/system/recognition/recognizeByUrl',
    method: 'POST',
    data: { imgurl, mode }
  })
}

// 根据物品名称查询垃圾分类（POST方式）
export function searchGarbage(data) {
  return request({
    url: '/system/recognition/search',
    method: 'POST',
    data: data
  })
}

// 根据物品名称查询垃圾分类（GET方式）
export function searchByName(word, num, mode, page) {
  return request({
    url: '/system/recognition/searchByName',
    method: 'GET',
    data: { word, num, mode, page }
  })
}