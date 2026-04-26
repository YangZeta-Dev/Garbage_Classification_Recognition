package com.yaoliyun.web.controller.system;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.yaoliyun.common.annotation.Log;
import com.yaoliyun.common.core.controller.BaseController;
import com.yaoliyun.common.core.domain.AjaxResult;
import com.yaoliyun.common.enums.BusinessType;
import com.yaoliyun.system.domain.SysPageTemplate;
import com.yaoliyun.system.service.ISysPageTemplateService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 页面模板管理Controller
 *
 * @author yaoliyun
 * @date 2025-01-26
 */
@RestController
@RequestMapping("/system/pageTemplate")
public class SysPageTemplateController extends BaseController
{
    private static final Logger log = LoggerFactory.getLogger(SysPageTemplateController.class);

    @Autowired
    private ISysPageTemplateService sysPageTemplateService;

    /**
     * 查询页面模板管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysPageTemplate sysPageTemplate)
    {
        startPage();
        List<SysPageTemplate> list = sysPageTemplateService.selectSysPageTemplateList(sysPageTemplate);
        return getDataTable(list);
    }

    /**
     * 查询热门模板列表
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:list')")
    @GetMapping("/popular/{limit}")
    public AjaxResult popularTemplates(@PathVariable("limit") int limit)
    {
        List<SysPageTemplate> list = sysPageTemplateService.selectPopularTemplates(limit);
        return success(list);
    }

    /**
     * 根据分类查询模板列表
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:list')")
    @GetMapping("/category/{category}")
    public AjaxResult templatesByCategory(@PathVariable("category") String category)
    {
        List<SysPageTemplate> list = sysPageTemplateService.selectTemplatesByCategory(category);
        return success(list);
    }

    /**
     * 根据类型查询模板列表
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:list')")
    @GetMapping("/type/{templateType}")
    public AjaxResult templatesByType(@PathVariable("templateType") String templateType)
    {
        List<SysPageTemplate> list = sysPageTemplateService.selectTemplatesByType(templateType);
        return success(list);
    }

    /**
     * 获取模板统计信息
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:list')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics()
    {
        Map<String, Object> statistics = sysPageTemplateService.getTemplateStatistics();
        return AjaxResult.success("获取统计信息成功", statistics);
    }

    /**
     * 导出页面模板管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:export')")
    @Log(title = "页面模板管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysPageTemplate sysPageTemplate)
    {
        List<SysPageTemplate> list = sysPageTemplateService.selectSysPageTemplateList(sysPageTemplate);
        ExcelUtil<SysPageTemplate> util = new ExcelUtil<SysPageTemplate>(SysPageTemplate.class);
        util.exportExcel(response, list, "页面模板管理数据");
    }

    /**
     * 获取页面模板管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:query')")
    @GetMapping(value = "/{templateId}")
    public AjaxResult getInfo(@PathVariable("templateId") Long templateId)
    {
        return success(sysPageTemplateService.selectSysPageTemplateByTemplateId(templateId));
    }

    /**
     * 新增页面模板管理
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:add')")
    @Log(title = "页面模板管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysPageTemplate sysPageTemplate)
    {
        return toAjax(sysPageTemplateService.insertSysPageTemplate(sysPageTemplate));
    }

        /**
     * 新增页面模板（包含代码，支持Base64解码）
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:add')")
    @Log(title = "页面模板管理", businessType = BusinessType.INSERT)
    @PostMapping("/withCode")
    public AjaxResult addWithCode(@RequestBody Map<String, Object> params)
    {
        try {
            SysPageTemplate sysPageTemplate = new SysPageTemplate();
            sysPageTemplate.setTemplateName((String) params.get("templateName"));
            sysPageTemplate.setTemplateType((String) params.get("templateType"));
            sysPageTemplate.setTemplateDescription((String) params.get("templateDescription"));
            sysPageTemplate.setPreviewImage((String) params.get("previewImage"));
            sysPageTemplate.setCategory((String) params.get("category"));
            sysPageTemplate.setTags((String) params.get("tags"));
            sysPageTemplate.setStatus((String) params.get("status"));
            sysPageTemplate.setSortOrder((Integer) params.get("sortOrder"));
            sysPageTemplate.setRemark((String) params.get("remark"));
            sysPageTemplate.setCreateBy(getUsername());
            
            String code = (String) params.get("code");
            
            // 检查是否为Base64编码，如果是则解码
            try {
                if (code != null && code.matches("^[A-Za-z0-9+/]*={0,2}$") && code.length() % 4 == 0) {
                    // 可能是Base64编码，尝试解码
                    byte[] decodedBytes = java.util.Base64.getDecoder().decode(code);
                    String decodedCode = new String(decodedBytes, java.nio.charset.StandardCharsets.UTF_8);
                    if (decodedCode.contains("<template>") || decodedCode.contains("<script>") || decodedCode.contains("<style>")) {
                        code = decodedCode;
                        log.info("检测到Base64编码，已自动解码");
                    }
                }
            } catch (Exception decodeEx) {
                // 解码失败，使用原始代码
                log.debug("Base64解码失败，使用原始代码: {}", decodeEx.getMessage());
            }
            
            int result = sysPageTemplateService.saveTemplateWithCode(sysPageTemplate, code);
            if (result > 0) {
                return success("新增模板成功");
            } else {
                return error("新增模板失败");
            }
        } catch (Exception e) {
            log.error("新增页面模板失败", e);
            return error("新增模板失败: " + e.getMessage());
        }
    }

    /**
     * 修改页面模板管理
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:edit')")
    @Log(title = "页面模板管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysPageTemplate sysPageTemplate)
    {
        return toAjax(sysPageTemplateService.updateSysPageTemplate(sysPageTemplate));
    }

    /**
     * 修改页面模板（包含代码，支持Base64解码）
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:edit')")
    @Log(title = "页面模板管理", businessType = BusinessType.UPDATE)
    @PutMapping("/withCode")
    public AjaxResult editWithCode(@RequestBody Map<String, Object> params)
    {
        try {
            SysPageTemplate sysPageTemplate = new SysPageTemplate();
            sysPageTemplate.setTemplateId(Long.valueOf(params.get("templateId").toString()));
            sysPageTemplate.setTemplateName((String) params.get("templateName"));
            sysPageTemplate.setTemplateType((String) params.get("templateType"));
            sysPageTemplate.setTemplateDescription((String) params.get("templateDescription"));
            sysPageTemplate.setPreviewImage((String) params.get("previewImage"));
            sysPageTemplate.setCategory((String) params.get("category"));
            sysPageTemplate.setTags((String) params.get("tags"));
            sysPageTemplate.setStatus((String) params.get("status"));
            sysPageTemplate.setSortOrder((Integer) params.get("sortOrder"));
            sysPageTemplate.setRemark((String) params.get("remark"));
            sysPageTemplate.setUpdateBy(getUsername());
            
            String code = (String) params.get("templateCode");
            
            // 检查是否为Base64编码，如果是则解码
            try {
                if (code != null && code.matches("^[A-Za-z0-9+/]*={0,2}$") && code.length() % 4 == 0) {
                    // 可能是Base64编码，尝试解码
                    byte[] decodedBytes = java.util.Base64.getDecoder().decode(code);
                    String decodedCode = new String(decodedBytes, java.nio.charset.StandardCharsets.UTF_8);
                    if (decodedCode.contains("<template>") || decodedCode.contains("<script>") || decodedCode.contains("<style>")) {
                        code = decodedCode;
                        log.info("检测到Base64编码，已自动解码");
                    }
                }
            } catch (Exception decodeEx) {
                // 解码失败，使用原始代码
                log.debug("Base64解码失败，使用原始代码: {}", decodeEx.getMessage());
            }
            
            int result = sysPageTemplateService.updateTemplateWithCode(sysPageTemplate, code);
            if (result > 0) {
                return success("修改模板成功");
            } else {
                return error("修改模板失败");
            }
        } catch (Exception e) {
            log.error("修改页面模板失败", e);
            return error("修改模板失败: " + e.getMessage());
        }
    }

    /**
     * 删除页面模板管理
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:remove')")
    @Log(title = "页面模板管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{templateIds}")
    public AjaxResult remove(@PathVariable Long[] templateIds)
    {
        return toAjax(sysPageTemplateService.deleteSysPageTemplateByTemplateIds(templateIds));
    }

    /**
     * 获取模板代码（Base64编码传输）
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:query')")
    @GetMapping("/code/{templateId}")
    public AjaxResult getTemplateCode(@PathVariable("templateId") Long templateId)
    {
        try {
            String code = sysPageTemplateService.getTemplateCode(templateId);
            if (code != null) {
                // Base64编码用于传输，避免HTML标签丢失
                String encodedCode = java.util.Base64.getEncoder().encodeToString(code.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                return AjaxResult.success("获取模板代码成功", encodedCode);
            } else {
                return error("模板不存在或代码为空");
            }
        } catch (Exception e) {
            log.error("获取模板代码失败", e);
            return error("获取模板代码失败: " + e.getMessage());
        }
    }

    /**
     * 复制模板代码（增加使用次数，Base64编码传输）
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:query')")
    @PostMapping("/copy/{templateId}")
    @Log(title = "复制模板代码", businessType = BusinessType.OTHER)
    public AjaxResult copyTemplateCode(@PathVariable("templateId") Long templateId)
    {
        try {
            String code = sysPageTemplateService.copyTemplateCode(templateId);
            if (code != null) {
                // Base64编码用于传输，避免HTML标签丢失
                String encodedCode = java.util.Base64.getEncoder().encodeToString(code.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                return AjaxResult.success("复制模板代码成功", encodedCode);
            } else {
                return error("模板不存在或代码为空");
            }
        } catch (Exception e) {
            log.error("复制模板代码失败", e);
            return error("复制模板代码失败: " + e.getMessage());
        }
    }

    /**
     * 使用模板（仅增加使用次数）
     */
    @PreAuthorize("@ss.hasPermi('system:pageTemplate:query')")
    @PostMapping("/use/{templateId}")
    @Log(title = "使用模板", businessType = BusinessType.OTHER)
    public AjaxResult useTemplate(@PathVariable("templateId") Long templateId)
    {
        try {
            boolean result = sysPageTemplateService.useTemplate(templateId);
            if (result) {
                return success("使用模板成功");
            } else {
                return error("使用模板失败");
            }
        } catch (Exception e) {
            log.error("使用模板失败", e);
            return error("使用模板失败: " + e.getMessage());
        }
    }
}
