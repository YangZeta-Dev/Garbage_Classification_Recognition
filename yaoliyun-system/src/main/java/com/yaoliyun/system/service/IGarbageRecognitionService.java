package com.yaoliyun.system.service;

import com.yaoliyun.system.domain.vo.GarbageRecognitionRequest;
import com.yaoliyun.system.domain.vo.GarbageRecognitionResponse;
import com.yaoliyun.system.domain.vo.GarbageSearchRequest;
import com.yaoliyun.system.domain.vo.GarbageSearchResponse;

/**
 * 垃圾识别Service接口
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public interface IGarbageRecognitionService
{
    /**
     * 根据图像识别垃圾分类
     * 
     * @param request 识别请求参数
     * @return 识别结果
     */
    GarbageRecognitionResponse recognizeGarbage(GarbageRecognitionRequest request);

    /**
     * 根据图片base64识别垃圾分类
     * 
     * @param imgBase64 图片base64编码
     * @param mode 识别模式（0严格模式，1模糊模式）
     * @return 识别结果
     */
    GarbageRecognitionResponse recognizeByBase64(String imgBase64, Integer mode);

    /**
     * 根据图片URL识别垃圾分类
     * 
     * @param imgUrl 图片URL地址
     * @param mode 识别模式（0严格模式，1模糊模式）
     * @return 识别结果
     */
    GarbageRecognitionResponse recognizeByUrl(String imgUrl, Integer mode);

    /**
     * 根据物品名称查询垃圾分类
     * 
     * @param request 查询请求参数
     * @return 查询结果
     */
    GarbageSearchResponse searchByName(GarbageSearchRequest request);

    /**
     * 根据物品名称查询垃圾分类
     * 
     * @param word 废弃物名称
     * @param num 返回数量
     * @param mode 查询模式（0模糊查询，1精确查询）
     * @param page 翻页
     * @return 查询结果
     */
    GarbageSearchResponse searchByName(String word, Integer num, Integer mode, Integer page);
}
