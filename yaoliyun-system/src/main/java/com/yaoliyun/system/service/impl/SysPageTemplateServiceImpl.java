package com.yaoliyun.system.service.impl;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.nio.charset.StandardCharsets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.SysPageTemplateMapper;
import com.yaoliyun.system.domain.SysPageTemplate;
import com.yaoliyun.system.service.ISysPageTemplateService;
import com.yaoliyun.common.utils.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 页面模板管理Service业务层处理
 * 
 * @author yaoliyun
 * @date 2025-01-26
 */
@Service
public class SysPageTemplateServiceImpl implements ISysPageTemplateService 
{
    private static final Logger log = LoggerFactory.getLogger(SysPageTemplateServiceImpl.class);
    
    @Autowired
    private SysPageTemplateMapper sysPageTemplateMapper;

    /**
     * 查询页面模板管理
     * 
     * @param templateId 页面模板管理主键
     * @return 页面模板管理
     */
    @Override
    public SysPageTemplate selectSysPageTemplateByTemplateId(Long templateId)
    {
        return sysPageTemplateMapper.selectSysPageTemplateByTemplateId(templateId);
    }

    /**
     * 查询页面模板管理列表
     * 
     * @param sysPageTemplate 页面模板管理
     * @return 页面模板管理
     */
    @Override
    public List<SysPageTemplate> selectSysPageTemplateList(SysPageTemplate sysPageTemplate)
    {
        return sysPageTemplateMapper.selectSysPageTemplateList(sysPageTemplate);
    }

    /**
     * 查询热门模板列表
     * 
     * @param limit 限制数量
     * @return 页面模板管理集合
     */
    @Override
    public List<SysPageTemplate> selectPopularTemplates(int limit)
    {
        return sysPageTemplateMapper.selectPopularTemplates(limit);
    }

    /**
     * 根据分类查询模板列表
     * 
     * @param category 分类
     * @return 页面模板管理集合
     */
    @Override
    public List<SysPageTemplate> selectTemplatesByCategory(String category)
    {
        return sysPageTemplateMapper.selectTemplatesByCategory(category);
    }

    /**
     * 根据类型查询模板列表
     * 
     * @param templateType 模板类型
     * @return 页面模板管理集合
     */
    @Override
    public List<SysPageTemplate> selectTemplatesByType(String templateType)
    {
        return sysPageTemplateMapper.selectTemplatesByType(templateType);
    }

    /**
     * 新增页面模板管理
     * 
     * @param sysPageTemplate 页面模板管理
     * @return 结果
     */
    @Override
    public int insertSysPageTemplate(SysPageTemplate sysPageTemplate)
    {
        sysPageTemplate.setCreateTime(DateUtils.getNowDate());
        return sysPageTemplateMapper.insertSysPageTemplate(sysPageTemplate);
    }

    /**
     * 修改页面模板管理
     * 
     * @param sysPageTemplate 页面模板管理
     * @return 结果
     */
    @Override
    public int updateSysPageTemplate(SysPageTemplate sysPageTemplate)
    {
        sysPageTemplate.setUpdateTime(DateUtils.getNowDate());
        return sysPageTemplateMapper.updateSysPageTemplate(sysPageTemplate);
    }

    /**
     * 批量删除页面模板管理
     * 
     * @param templateIds 需要删除的页面模板管理主键
     * @return 结果
     */
    @Override
    public int deleteSysPageTemplateByTemplateIds(Long[] templateIds)
    {
        return sysPageTemplateMapper.deleteSysPageTemplateByTemplateIds(templateIds);
    }

    /**
     * 删除页面模板管理信息
     * 
     * @param templateId 页面模板管理主键
     * @return 结果
     */
    @Override
    public int deleteSysPageTemplateByTemplateId(Long templateId)
    {
        return sysPageTemplateMapper.deleteSysPageTemplateByTemplateId(templateId);
    }

    /**
     * 获取模板代码内容（直接返回源代码）
     * 
     * @param templateId 模板ID
     * @return 模板代码
     */
    @Override
    public String getTemplateCode(Long templateId)
    {
        try {
            SysPageTemplate template = sysPageTemplateMapper.selectSysPageTemplateByTemplateId(templateId);
            if (template != null && template.getTemplateCode() != null) {
                String code = template.getTemplateCode();
                log.info("获取模板代码成功，模板ID: {}, 代码长度: {}", templateId, code.length());
                return code;
            }
            return null;
        } catch (Exception e) {
            log.error("获取模板代码失败，模板ID: {}, 错误: {}", templateId, e.getMessage(), e);
            return null;
        }
    }

    /**
     * 使用模板（增加下载次数）
     * 
     * @param templateId 模板ID
     * @return 结果
     */
    @Override
    public boolean useTemplate(Long templateId)
    {
        try {
            int result = sysPageTemplateMapper.incrementDownloadCount(templateId);
            log.info("模板使用次数增加，模板ID: {}, 结果: {}", templateId, result > 0 ? "成功" : "失败");
            return result > 0;
        } catch (Exception e) {
            log.error("增加模板使用次数失败，模板ID: {}, 错误: {}", templateId, e.getMessage(), e);
            return false;
        }
    }

    /**
     * 复制模板代码
     * 
     * @param templateId 模板ID
     * @return 解码后的模板代码
     */
    @Override
    public String copyTemplateCode(Long templateId)
    {
        // 获取模板代码
        String code = getTemplateCode(templateId);
        if (code != null) {
            // 增加使用次数
            useTemplate(templateId);
        }
        return code;
    }

    /**
     * 获取模板统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Map<String, Object> getTemplateStatistics()
    {
        Map<String, Object> statistics = new HashMap<>();
        
        try {
            // 查询所有模板
            SysPageTemplate queryTemplate = new SysPageTemplate();
            queryTemplate.setStatus("0"); // 只统计正常状态的模板
            List<SysPageTemplate> allTemplates = sysPageTemplateMapper.selectSysPageTemplateList(queryTemplate);
            
            // 总模板数
            statistics.put("totalCount", allTemplates.size());
            
            // 按分类统计
            Map<String, Integer> categoryStats = new HashMap<>();
            Map<String, Integer> typeStats = new HashMap<>();
            int totalDownloads = 0;
            
            for (SysPageTemplate template : allTemplates) {
                // 分类统计
                String category = template.getCategory();
                categoryStats.put(category, categoryStats.getOrDefault(category, 0) + 1);
                
                // 类型统计
                String type = template.getTemplateType();
                typeStats.put(type, typeStats.getOrDefault(type, 0) + 1);
                
                // 下载次数统计
                totalDownloads += template.getDownloadCount() != null ? template.getDownloadCount() : 0;
            }
            
            statistics.put("categoryStats", categoryStats);
            statistics.put("typeStats", typeStats);
            statistics.put("totalDownloads", totalDownloads);
            
            // 热门模板（前5个）
            List<SysPageTemplate> popularTemplates = sysPageTemplateMapper.selectPopularTemplates(5);
            statistics.put("popularTemplates", popularTemplates);
            
            log.info("获取模板统计信息成功，总数: {}, 总下载数: {}", allTemplates.size(), totalDownloads);
            
        } catch (Exception e) {
            log.error("获取模板统计信息失败: {}", e.getMessage(), e);
        }
        
        return statistics;
    }

    /**
     * 保存模板代码（直接存储源代码）
     * 
     * @param sysPageTemplate 页面模板对象
     * @param code 原始代码
     * @return 结果
     */
    @Override
    public int saveTemplateWithCode(SysPageTemplate sysPageTemplate, String code)
    {
        try {
            if (code != null) {
                // 直接存储源代码
                sysPageTemplate.setTemplateCode(code);
                log.info("模板代码保存，代码长度: {}", code.length());
            }
            
            // 设置默认值
            if (sysPageTemplate.getDownloadCount() == null) {
                sysPageTemplate.setDownloadCount(0);
            }
            if (sysPageTemplate.getStatus() == null) {
                sysPageTemplate.setStatus("0");
            }
            if (sysPageTemplate.getSortOrder() == null) {
                sysPageTemplate.setSortOrder(0);
            }
            
            return insertSysPageTemplate(sysPageTemplate);
            
        } catch (Exception e) {
            log.error("保存模板代码失败: {}", e.getMessage(), e);
            return 0;
        }
    }

    /**
     * 更新模板代码（直接存储源代码）
     * 
     * @param sysPageTemplate 页面模板对象
     * @param code 原始代码
     * @return 结果
     */
    @Override
    public int updateTemplateWithCode(SysPageTemplate sysPageTemplate, String code)
    {
        try {
            if (code != null) {
                // 直接存储源代码
                sysPageTemplate.setTemplateCode(code);
                log.info("模板代码更新，代码长度: {}", code.length());
            }
            
            return updateSysPageTemplate(sysPageTemplate);
            
        } catch (Exception e) {
            log.error("更新模板代码失败: {}", e.getMessage(), e);
            return 0;
        }
    }
} 