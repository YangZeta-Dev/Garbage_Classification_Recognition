import { getDicts } from '@/api/system/dict/data'

// 字典缓存对象
const dictCache = {}

/**
 * 初始化字典缓存
 * @param {string|Array} dictTypes - 字典类型，可以是单个字符串或字符串数组
 */
export async function initDictCache(dictTypes) {
  const types = Array.isArray(dictTypes) ? dictTypes : [dictTypes]
  
  const promises = types.map(async (dictType) => {
    try {
      const response = await getDicts(dictType)
      if (response && response.data) {
        dictCache[dictType] = {}
        response.data.forEach(item => {
          dictCache[dictType][item.dictValue] = item.dictLabel
        })
      }
    } catch (error) {
      console.error(`初始化字典缓存失败 [${dictType}]:`, error)
    }
  })
  
  await Promise.all(promises)
}

/**
 * 直接获取字典标签（同步方法，需要先初始化缓存）
 * @param {string} dictType - 字典类型
 * @param {string} dictValue - 字典值
 * @returns {string} 字典标签
 */
export function getDictLabelSync(dictType, dictValue) {
  if (dictCache[dictType] && dictCache[dictType][dictValue]) {
    return dictCache[dictType][dictValue]
  }
  return dictValue
}

/**
 * 直接获取多个字典标签（同步方法，需要先初始化缓存）
 * @param {string} dictType - 字典类型
 * @param {string} dictValues - 字典值，逗号分割的字符串
 * @returns {Array} 字典标签数组
 */
export function getDictLabelsSync(dictType, dictValues) {
  if (!dictValues) return []
  
  const valueArray = dictValues.split(',').map(value => value.trim())
  return valueArray.map(value => {
    if (dictCache[dictType] && dictCache[dictType][value]) {
      return dictCache[dictType][value]
    }
    return value
  })
}

/**
 * 获取字典缓存状态
 * @param {string} dictType - 字典类型（可选）
 * @returns {Object|boolean} 如果指定dictType则返回该类型是否已缓存，否则返回所有缓存状态
 */
export function getDictCacheStatus(dictType) {
  if (dictType) {
    return !!dictCache[dictType]
  }
  return dictCache
}

/**
 * 清空字典缓存
 * @param {string} dictType - 字典类型（可选），如果不指定则清空所有缓存
 */
export function clearDictCache(dictType) {
  if (dictType) {
    delete dictCache[dictType]
  } else {
    Object.keys(dictCache).forEach(key => {
      delete dictCache[key]
    })
  }
}

/**
 * 根据字典类型和字典值获取字典标签（单个值）
 * @param {string} dictType - 字典类型
 * @param {string} dictValue - 字典值
 * @returns {string} 字典标签
 */
export async function getDictLabel(dictType, dictValue) {
  try {
    const response = await getDicts(dictType)
    if (response && response.data) {
      const dictData = response.data
      // 查找匹配的字典项
      const dictItem = dictData.find(item => item.dictValue === dictValue)
      return dictItem ? dictItem.dictLabel : dictValue
    }
    return dictValue
  } catch (error) {
    console.error('获取字典标签失败:', error)
    return dictValue
  }
}

/**
 * 根据字典类型和字典值获取字典标签（多个值，逗号分割）
 * @param {string} dictType - 字典类型
 * @param {string} dictValues - 字典值，逗号分割的字符串
 * @returns {Array} 字典标签数组
 */
export async function getDictLabels(dictType, dictValues) {
  try {
    if (!dictValues) return []
    
    const response = await getDicts(dictType)
    if (response && response.data) {
      const dictData = response.data
      
      // 将逗号分割的字符串转换为数组
      const valueArray = dictValues.split(',').map(value => value.trim())
      
      // 为每个值查找对应的标签
      const labelArray = valueArray.map(value => {
        const dictItem = dictData.find(item => item.dictValue === value)
        return dictItem ? dictItem.dictLabel : value
      })
      
      // 返回标签数组
      return labelArray
    }
    return dictValues.split(',').map(value => value.trim())
  } catch (error) {
    console.error('获取字典标签失败:', error)
    return dictValues.split(',').map(value => value.trim())
  }
}

/**
 * 根据字典类型获取完整的字典映射对象
 * @param {string} dictType - 字典类型
 * @returns {Object} 字典映射对象 {dictValue: dictLabel}
 */
export async function getDictMap(dictType) {
  try {
    const response = await getDicts(dictType)
    if (response && response.data) {
      const dictData = response.data
      const dictMap = {}
      dictData.forEach(item => {
        dictMap[item.dictValue] = item.dictLabel
      })
      return dictMap
    }
    return {}
  } catch (error) {
    console.error('获取字典映射失败:', error)
    return {}
  }
}
