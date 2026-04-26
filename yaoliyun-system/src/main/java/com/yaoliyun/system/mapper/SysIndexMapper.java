package com.yaoliyun.system.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

/**
 * 系统首页统计数据Mapper接口
 * 
 * @author ruoyi
 */
public interface SysIndexMapper 
{
    /**
     * 获取总用户数
     * 
     * @return 总用户数
     */
    Long getTotalUserCount();

    /**
     * 获取在线用户数
     * 
     * @return 在线用户数
     */
    Long getOnlineUserCount();

    /**
     * 获取今日新增用户数
     * 
     * @return 今日新增用户数
     */
    Long getTodayNewUserCount();

    /**
     * 获取本月新增用户数
     * 
     * @return 本月新增用户数
     */
    Long getMonthNewUserCount();

    /**
     * 获取系统总访问量
     * 
     * @return 总访问量
     */
    Long getTotalVisitCount();

    /**
     * 获取今日访问量
     * 
     * @return 今日访问量
     */
    Long getTodayVisitCount();

    /**
     * 获取系统运行天数
     * 
     * @return 运行天数
     */
    Long getSystemRunningDays();

    /**
     * 获取总菜单数
     * 
     * @return 总菜单数
     */
    Long getTotalMenuCount();

    /**
     * 根据日期获取用户注册数量
     * 
     * @param date 日期
     * @return 注册数量
     */
    Long getUserRegistrationCountByDate(@Param("date") String date);

    /**
     * 根据小时获取在线用户数量
     * 
     * @param dateTime 时间
     * @return 在线用户数量
     */
    Long getOnlineUserCountByHour(@Param("dateTime") Date dateTime);

    /**
     * 获取系统模块使用统计
     * 
     * @return 模块使用统计
     */
    List<Map<String, Object>> getModuleUsageStats();

    /**
     * 获取垃圾分类类别总数
     * 
     * @return 类别总数
     */
    Long getTotalCategoryCount();

    /**
     * 获取垃圾物品总数
     * 
     * @return 物品总数
     */
    Long getTotalItemCount();

    /**
     * 获取识别记录总数
     * 
     * @return 识别记录总数
     */
    Long getTotalRecognitionCount();

    /**
     * 获取今日识别次数
     * 
     * @return 今日识别次数
     */
    Long getTodayRecognitionCount();

    /**
     * 获取知识文章总数
     * 
     * @return 文章总数
     */
    Long getTotalArticleCount();

    /**
     * 获取测验题目总数
     * 
     * @return 题目总数
     */
    Long getTotalQuestionCount();

    /**
     * 获取各分类识别统计
     * 
     * @return 分类识别统计
     */
    List<Map<String, Object>> getCategoryRecognitionStats();

    /**
     * 获取最近30天识别趋势
     * 
     * @param date 日期
     * @return 识别数量
     */
    Long getRecognitionCountByDate(@Param("date") String date);
}