package com.yaoliyun.system.service;

import java.util.List;
import java.util.Map;

/**
 * 系统首页统计服务接口
 * 
 * @author ruoyi
 */
public interface ISysIndexService 
{
    /**
     * 获取系统统计概览数据
     * 
     * @return 概览数据
     */
    Map<String, Object> getSystemOverview();

    /**
     * 获取用户注册趋势数据（最近30天）
     * 
     * @return 注册趋势数据
     */
    Map<String, Object> getUserRegistrationTrend();

    /**
     * 获取在线用户趋势数据（最近24小时）
     * 
     * @return 在线用户趋势数据
     */
    Map<String, Object> getOnlineUserTrend();

    /**
     * 获取系统模块使用统计
     * 
     * @return 模块使用统计
     */
    List<Map<String, Object>> getModuleUsageStats();

    /**
     * 获取垃圾分类统计概览数据
     * 
     * @return 垃圾分类概览数据
     */
    Map<String, Object> getGarbageOverview();

    /**
     * 获取各分类识别统计
     * 
     * @return 分类识别统计
     */
    List<Map<String, Object>> getCategoryRecognitionStats();

    /**
     * 获取识别趋势数据（最近30天）
     * 
     * @return 识别趋势数据
     */
    Map<String, Object> getRecognitionTrend();
} 