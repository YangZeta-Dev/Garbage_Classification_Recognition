package com.yaoliyun.system.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.SysIndexMapper;
import com.yaoliyun.system.service.ISysIndexService;
import com.yaoliyun.system.service.ISysUserService;
import com.yaoliyun.system.service.ISysUserOnlineService;

/**
 * 系统首页统计服务实现
 * 
 * @author ruoyi
 */
@Service
public class SysIndexServiceImpl implements ISysIndexService 
{
    @Autowired
    private SysIndexMapper sysIndexMapper;

    @Autowired
    private ISysUserService userService;

    @Autowired 
    private ISysUserOnlineService userOnlineService;

    /**
     * 获取系统统计概览数据
     */
    @Override
    public Map<String, Object> getSystemOverview()
    {
        Map<String, Object> data = new HashMap<>();
        
        // 总用户数
        Long totalUsers = sysIndexMapper.getTotalUserCount();
        data.put("totalUsers", totalUsers);
        
        // 在线用户数
        Long onlineUsers = sysIndexMapper.getOnlineUserCount();
        data.put("onlineUsers", onlineUsers);
        
        // 今日新增用户
        Long todayNewUsers = sysIndexMapper.getTodayNewUserCount();
        data.put("todayNewUsers", todayNewUsers);
        
        // 本月新增用户
        Long monthNewUsers = sysIndexMapper.getMonthNewUserCount();
        data.put("monthNewUsers", monthNewUsers);
        
        // 系统总访问量
        Long totalVisits = sysIndexMapper.getTotalVisitCount();
        data.put("totalVisits", totalVisits);
        
        // 今日访问量
        Long todayVisits = sysIndexMapper.getTodayVisitCount();
        data.put("todayVisits", todayVisits);
        
        // 系统运行天数
        Long runningDays = sysIndexMapper.getSystemRunningDays();
        data.put("runningDays", runningDays);
        
        // 总菜单数
        Long totalMenus = sysIndexMapper.getTotalMenuCount();
        data.put("totalMenus", totalMenus);
        
        return data;
    }

    /**
     * 获取用户注册趋势数据（最近30天）
     */
    @Override
    public Map<String, Object> getUserRegistrationTrend()
    {
        Map<String, Object> data = new HashMap<>();
        List<String> dates = new ArrayList<>();
        List<Long> counts = new ArrayList<>();
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        
        // 获取最近30天的数据
        for (int i = 29; i >= 0; i--) {
            calendar.setTime(new Date());
            calendar.add(Calendar.DAY_OF_MONTH, -i);
            String date = sdf.format(calendar.getTime());
            dates.add(date);
            
            Long count = sysIndexMapper.getUserRegistrationCountByDate(date);
            counts.add(count);
        }
        
        data.put("dates", dates);
        data.put("counts", counts);
        return data;
    }

    /**
     * 获取在线用户趋势数据（最近24小时）
     */
    @Override
    public Map<String, Object> getOnlineUserTrend()
    {
        Map<String, Object> data = new HashMap<>();
        List<String> hours = new ArrayList<>();
        List<Long> counts = new ArrayList<>();
        
        SimpleDateFormat sdf = new SimpleDateFormat("HH:00");
        Calendar calendar = Calendar.getInstance();
        
        // 获取最近24小时的数据
        for (int i = 23; i >= 0; i--) {
            calendar.setTime(new Date());
            calendar.add(Calendar.HOUR_OF_DAY, -i);
            String hour = sdf.format(calendar.getTime());
            hours.add(hour);
            
            Long count = sysIndexMapper.getOnlineUserCountByHour(calendar.getTime());
            counts.add(count);
        }
        
        data.put("hours", hours);
        data.put("counts", counts);
        return data;
    }

    /**
     * 获取系统模块使用统计
     */
    @Override
    public List<Map<String, Object>> getModuleUsageStats()
    {
        return sysIndexMapper.getModuleUsageStats();
    }

    /**
     * 获取垃圾分类统计概览数据
     */
    @Override
    public Map<String, Object> getGarbageOverview()
    {
        Map<String, Object> data = new HashMap<>();
        
        // 分类类别总数
        Long totalCategories = sysIndexMapper.getTotalCategoryCount();
        data.put("totalCategories", totalCategories);
        
        // 垃圾物品总数
        Long totalItems = sysIndexMapper.getTotalItemCount();
        data.put("totalItems", totalItems);
        
        // 识别记录总数
        Long totalRecognitions = sysIndexMapper.getTotalRecognitionCount();
        data.put("totalRecognitions", totalRecognitions);
        
        // 今日识别次数
        Long todayRecognitions = sysIndexMapper.getTodayRecognitionCount();
        data.put("todayRecognitions", todayRecognitions);
        
        // 知识文章总数
        Long totalArticles = sysIndexMapper.getTotalArticleCount();
        data.put("totalArticles", totalArticles);
        
        // 测验题目总数
        Long totalQuestions = sysIndexMapper.getTotalQuestionCount();
        data.put("totalQuestions", totalQuestions);
        
        // 总用户数
        Long totalUsers = sysIndexMapper.getTotalUserCount();
        data.put("totalUsers", totalUsers);
        
        // 在线用户数
        Long onlineUsers = sysIndexMapper.getOnlineUserCount();
        data.put("onlineUsers", onlineUsers);
        
        return data;
    }

    /**
     * 获取各分类识别统计
     */
    @Override
    public List<Map<String, Object>> getCategoryRecognitionStats()
    {
        return sysIndexMapper.getCategoryRecognitionStats();
    }

    /**
     * 获取识别趋势数据（最近30天）
     */
    @Override
    public Map<String, Object> getRecognitionTrend()
    {
        Map<String, Object> data = new HashMap<>();
        List<String> dates = new ArrayList<>();
        List<Long> counts = new ArrayList<>();
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        
        // 获取最近30天的数据
        for (int i = 29; i >= 0; i--) {
            calendar.setTime(new Date());
            calendar.add(Calendar.DAY_OF_MONTH, -i);
            String date = sdf.format(calendar.getTime());
            dates.add(date);
            
            Long count = sysIndexMapper.getRecognitionCountByDate(date);
            counts.add(count);
        }
        
        data.put("dates", dates);
        data.put("counts", counts);
        return data;
    }
}