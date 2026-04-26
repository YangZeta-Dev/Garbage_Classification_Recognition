package com.yaoliyun.web.controller.system;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Base64;
import java.nio.charset.StandardCharsets;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.yaoliyun.common.annotation.Log;
import com.yaoliyun.common.core.controller.BaseController;
import com.yaoliyun.common.core.domain.AjaxResult;
import com.yaoliyun.common.enums.BusinessType;
import com.yaoliyun.system.domain.SysUniappPage;
import com.yaoliyun.system.service.ISysUniappPageService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;
import com.yaoliyun.common.utils.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * UniApp页面管理Controller
 *
 * @author yaoliyun
 * @date 2024-01-15
 */
@RestController
@RequestMapping("/system/uniappPage")
public class SysUniappPageController extends BaseController
{
    private static final Logger log = LoggerFactory.getLogger(SysUniappPageController.class);

    @Autowired
    private ISysUniappPageService sysUniappPageService;

    /**
     * 查询UniApp页面管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysUniappPage sysUniappPage)
    {
        startPage();
        List<SysUniappPage> list = sysUniappPageService.selectSysUniappPageList(sysUniappPage);
        return getDataTable(list);
    }

    /**
     * 导出UniApp页面管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:export')")
    @Log(title = "UniApp页面管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysUniappPage sysUniappPage)
    {
        List<SysUniappPage> list = sysUniappPageService.selectSysUniappPageList(sysUniappPage);
        ExcelUtil<SysUniappPage> util = new ExcelUtil<SysUniappPage>(SysUniappPage.class);
        util.exportExcel(response, list, "UniApp页面管理数据");
    }

    /**
     * 获取UniApp页面管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:query')")
    @GetMapping(value = "/{pageId}")
    public AjaxResult getInfo(@PathVariable("pageId") Long pageId)
    {
        return success(sysUniappPageService.selectSysUniappPageByPageId(pageId));
    }

    /**
     * 新增UniApp页面管理
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:add')")
    @Log(title = "UniApp页面管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysUniappPage sysUniappPage)
    {
        // 验证页面路径
        if (!sysUniappPageService.validatePagePath(sysUniappPage.getPagePath()))
        {
            return error("页面路径格式不正确或包含危险字符");
        }

        // 检查页面路径是否已存在
        if (sysUniappPageService.checkPagePathExists(sysUniappPage.getPagePath()))
        {
            return error("页面路径已存在");
        }

        int result = sysUniappPageService.insertSysUniappPage(sysUniappPage);
        if (result > 0)
        {
            // 更新pages.json
            boolean updateResult = sysUniappPageService.updatePagesJson();
            if (!updateResult)
            {
                log.error("页面信息添加成功但pages.json更新失败");
                return error("页面信息添加成功，但pages.json更新失败，请手动同步配置");
            }
        }
        return toAjax(result);
    }

    /**
     * 修改UniApp页面管理
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @Log(title = "UniApp页面管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysUniappPage sysUniappPage)
    {
        int result = sysUniappPageService.updateSysUniappPage(sysUniappPage);
        if (result > 0)
        {
            // 更新pages.json
            boolean updateResult = sysUniappPageService.updatePagesJson();
            if (!updateResult)
            {
                log.error("页面信息更新成功但pages.json更新失败");
                return error("页面信息更新成功，但pages.json更新失败，请手动同步配置");
            }
        }
        return toAjax(result);
    }

    /**
     * 删除UniApp页面管理
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:remove')")
    @Log(title = "UniApp页面管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{pageIds}")
    public AjaxResult remove(@PathVariable Long[] pageIds)
    {
        int result = sysUniappPageService.deleteSysUniappPageByPageIds(pageIds);
        if (result > 0)
        {
            // 更新pages.json
            boolean updateResult = sysUniappPageService.updatePagesJson();
            if (!updateResult)
            {
                log.error("页面信息删除成功但pages.json更新失败");
                return error("页面信息删除成功，但pages.json更新失败，请手动同步配置");
            }
        }
        return toAjax(result);
    }

    /**
     * 创建页面文件和目录
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:create')")
    @Log(title = "创建UniApp页面", businessType = BusinessType.INSERT)
    @PostMapping("/createPage")
    public AjaxResult createPage(@RequestBody Map<String, String> pageInfo)
    {
        String pagePath = pageInfo.get("pagePath");
        String pageTitle = pageInfo.get("pageTitle");
        String navigationStyle = pageInfo.get("navigationStyle");

        // 验证输入参数
        if (pagePath == null || pagePath.trim().isEmpty())
        {
            return error("页面路径不能为空");
        }
        if (pageTitle == null || pageTitle.trim().isEmpty())
        {
            return error("页面标题不能为空");
        }

        // 构造页面信息JSON
        String pageInfoJson = String.format(
            "{\"pagePath\":\"%s\",\"pageTitle\":\"%s\",\"navigationStyle\":\"%s\"}",
            pagePath.trim(), pageTitle.trim(), navigationStyle != null ? navigationStyle.trim() : "default"
        );

        boolean result = sysUniappPageService.createPageFile(pageInfoJson);
        if (result)
        {
            return success("页面创建成功");
        }
        else
        {
            return error("页面创建失败，请检查日志");
        }
    }

    /**
     * 删除页面文件和目录 (DELETE方式)
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:delete')")
    @Log(title = "删除UniApp页面文件", businessType = BusinessType.DELETE)
    @DeleteMapping("/deletePage/{pagePath}")
    public AjaxResult deletePage(@PathVariable String pagePath)
    {
        try {
            // URL解码
            pagePath = java.net.URLDecoder.decode(pagePath, "UTF-8");

            boolean result = sysUniappPageService.deletePageFile(pagePath);
            if (result)
            {
                return success("页面删除成功");
            }
            else
            {
                return error("页面删除失败，请检查日志");
            }
        } catch (java.io.UnsupportedEncodingException e) {
            log.error("页面路径解码失败: {}", e.getMessage());
            return error("页面路径格式错误");
        }
    }

    /**
     * 删除页面文件和目录 (POST方式 - 避免CORS问题)
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:delete')")
    @Log(title = "删除UniApp页面文件", businessType = BusinessType.DELETE)
    @PostMapping("/deletePageByPost")
    public AjaxResult deletePageByPost(@RequestBody Map<String, String> params)
    {
        String pagePath = params.get("pagePath");
        if (pagePath == null || pagePath.trim().isEmpty())
        {
            return error("页面路径不能为空");
        }

        boolean result = sysUniappPageService.deletePageFile(pagePath.trim());
        if (result)
        {
            return success("页面删除成功");
        }
        else
        {
            return error("页面删除失败，请检查日志");
        }
    }

    /**
     * 同步pages.json到数据库
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:sync')")
    @Log(title = "同步UniApp页面", businessType = BusinessType.UPDATE)
    @PostMapping("/sync")
    public AjaxResult syncPages()
    {
        boolean result = sysUniappPageService.syncPagesFromJson();
        if (result)
        {
            return success("页面同步成功");
        }
        else
        {
            return error("页面同步失败，请检查日志");
        }
    }

    /**
     * 更新pages.json配置
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:update')")
    @Log(title = "更新pages.json", businessType = BusinessType.UPDATE)
    @PostMapping("/updateConfig")
    public AjaxResult updateConfig()
    {
        boolean result = sysUniappPageService.updatePagesJson();
        if (result)
        {
            return success("pages.json更新成功");
        }
        else
        {
            return error("pages.json更新失败，请检查日志");
        }
    }

    /**
     * 备份pages.json文件
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:backup')")
    @Log(title = "备份pages.json", businessType = BusinessType.OTHER)
    @PostMapping("/backup")
    public AjaxResult backup()
    {
        boolean result = sysUniappPageService.backupPagesJson();
        if (result)
        {
            return success("pages.json备份成功");
        }
        else
        {
            return error("pages.json备份失败，请检查日志");
        }
    }

    /**
     * 验证页面路径
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:validate')")
    @PostMapping("/validate")
    public AjaxResult validatePath(@RequestParam String pagePath)
    {
        boolean isValid = sysUniappPageService.validatePagePath(pagePath);
        boolean exists = sysUniappPageService.checkPagePathExists(pagePath);

        AjaxResult result = new AjaxResult();
        result.put("valid", isValid);
        result.put("exists", exists);
        result.put("message",
            !isValid ? "页面路径格式不正确或包含危险字符" :
            exists ? "页面路径已存在" : "页面路径可用");

        return result;
    }

    /**
     * 批量操作页面状态
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @Log(title = "批量更新页面状态", businessType = BusinessType.UPDATE)
    @PostMapping("/batchStatus")
    public AjaxResult batchStatus(@RequestBody Map<String, Object> params)
    {
        Long[] pageIds = (Long[]) params.get("pageIds");
        String status = (String) params.get("status");

        if (pageIds == null || pageIds.length == 0)
        {
            return error("请选择要操作的页面");
        }

        int successCount = 0;
        for (Long pageId : pageIds)
        {
            SysUniappPage page = sysUniappPageService.selectSysUniappPageByPageId(pageId);
            if (page != null)
            {
                page.setStatus(status);
                if (sysUniappPageService.updateSysUniappPage(page) > 0)
                {
                    successCount++;
                }
            }
        }

        if (successCount > 0)
        {
            // 更新pages.json
            boolean updateResult = sysUniappPageService.updatePagesJson();
            if (!updateResult)
            {
                log.error("页面状态更新成功但pages.json更新失败");
                return error(String.format("成功更新 %d 个页面状态，但pages.json更新失败，请手动同步配置", successCount));
            }
            return success(String.format("成功更新 %d 个页面状态", successCount));
        }
        else
        {
            return error("批量更新失败");
        }
    }

    /**
     * 设置页面为底部导航
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @Log(title = "设置页面为底部导航", businessType = BusinessType.UPDATE)
    @PutMapping("/setTabBar")
    public AjaxResult setTabBar(@RequestBody Map<String, Object> params)
    {
        try {
            Long pageId = Long.valueOf(params.get("pageId").toString());
            String isTabbar = (String) params.get("isTabbar");
            String tabbarText = (String) params.get("tabbarText");

            if (pageId == null) {
                return error("页面ID不能为空");
            }

            SysUniappPage page = new SysUniappPage();
            page.setPageId(pageId);
            page.setIsTabbar(isTabbar);
            if (StringUtils.isNotEmpty(tabbarText)) {
                page.setTabbarText(tabbarText);
            }

            int result = sysUniappPageService.updateSysUniappPage(page);
            if (result > 0) {
                // 更新pages.json
                boolean pagesJsonUpdated = sysUniappPageService.updatePagesJson();
                if (!pagesJsonUpdated) {
                    return error("设置底部导航成功，但更新pages.json失败，请检查日志");
                }
                return success("设置底部导航成功");
            } else {
                return error("设置底部导航失败");
            }

        } catch (Exception e) {
            log.error("设置页面为底部导航失败", e);
            return error("设置页面为底部导航失败: " + e.getMessage());
        }
    }

    /**
     * 获取页面代码 (POST方式 - 避免CORS问题)
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:query')")
    @PostMapping("/getPageCode")
    public AjaxResult getPageCode(@RequestBody Map<String, String> params)
    {
        try {
            String pagePath = params.get("pagePath");
            log.info("获取页面代码: {}", pagePath);

            if (StringUtils.isEmpty(pagePath)) {
                return error("页面路径不能为空");
            }

            String code = sysUniappPageService.getPageCode(pagePath);
            if (code != null) {
                log.info("成功获取页面代码，长度: {} 字符，前100字符: {}",
                    code.length(),
                    code.length() > 100 ? code.substring(0, 100) : code);
                return AjaxResult.success("获取页面代码成功", code);
            } else {
                return error("页面文件不存在或读取失败");
            }

        } catch (Exception e) {
            log.error("获取页面代码失败", e);
            return error("获取页面代码失败: " + e.getMessage());
        }
    }

    /**
     * 保存页面代码
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @PostMapping("/code")
    public AjaxResult savePageCode(@RequestBody String requestBody, HttpServletRequest request)
    {
        try {
            log.info("=== 原始请求体调试 ===");
            log.info("原始请求体长度: {}", requestBody.length());
            log.info("原始请求体前500字符: {}", requestBody.length() > 500 ? requestBody.substring(0, 500) : requestBody);
            log.info("原始请求体包含template: {}", requestBody.contains("<template>"));
            log.info("原始请求体包含view: {}", requestBody.contains("<view>"));

            // 手动解析JSON
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> params = objectMapper.readValue(requestBody, Map.class);

            String pagePath = params.get("pagePath");
            String code = params.get("code");

            log.info("=== 解析后参数调试 ===");
            log.info("保存页面代码: {}", pagePath);

            if (StringUtils.isEmpty(pagePath)) {
                return error("页面路径不能为空");
            }

            if (StringUtils.isEmpty(code)) {
                return error("页面代码不能为空");
            }

            // 添加调试信息
            log.info("解析后代码长度: {} 字符", code.length());
            log.info("解析后代码前200字符: {}", code.length() > 200 ? code.substring(0, 200) : code);
            log.info("解析后包含template标签: {}", code.contains("<template>"));
            log.info("解析后包含view标签: {}", code.contains("<view>"));

            boolean result = sysUniappPageService.savePageCode(pagePath, code);
            if (result) {
                return success("保存页面代码成功");
            } else {
                return error("保存页面代码失败");
            }

        } catch (Exception e) {
            log.error("保存页面代码失败", e);
            return error("保存页面代码失败: " + e.getMessage());
        }
    }

    /**
     * 保存页面代码 (Base64编码方式 - 解决HTML标签丢失问题)
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @PostMapping("/codeBase64")
    public AjaxResult savePageCodeBase64(@RequestBody Map<String, String> params)
    {
        try {
            String pagePath = params.get("pagePath");
            String codeBase64 = params.get("code");

            log.info("保存页面代码(Base64): {}", pagePath);

            if (StringUtils.isEmpty(pagePath)) {
                return error("页面路径不能为空");
            }

            if (StringUtils.isEmpty(codeBase64)) {
                return error("页面代码不能为空");
            }

            // 解码Base64
            byte[] decodedBytes = Base64.getDecoder().decode(codeBase64);
            String code = new String(decodedBytes, StandardCharsets.UTF_8);

            // 添加调试信息
            log.info("Base64编码长度: {} 字符", codeBase64.length());
            log.info("解码后代码长度: {} 字符", code.length());
            log.info("解码后代码前200字符: {}", code.length() > 200 ? code.substring(0, 200) : code);
            log.info("解码后包含template标签: {}", code.contains("<template>"));
            log.info("解码后包含view标签: {}", code.contains("<view>"));

            boolean result = sysUniappPageService.savePageCode(pagePath, code);
            if (result) {
                return success("保存页面代码成功");
            } else {
                return error("保存页面代码失败");
            }

        } catch (Exception e) {
            log.error("保存页面代码失败", e);
            return error("保存页面代码失败: " + e.getMessage());
        }
    }

    /**
     * 从备份文件恢复页面代码
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @PostMapping("/restoreFromBackup")
    public AjaxResult restoreFromBackup(@RequestBody Map<String, String> params)
    {
        try {
            String pagePath = params.get("pagePath");
            String backupFileName = params.get("backupFileName");

            log.info("恢复页面代码: {} 从备份: {}", pagePath, backupFileName);

            if (StringUtils.isEmpty(pagePath)) {
                return error("页面路径不能为空");
            }

            if (StringUtils.isEmpty(backupFileName)) {
                return error("备份文件名不能为空");
            }

            boolean result = sysUniappPageService.restoreFromBackup(pagePath, backupFileName);
            if (result) {
                return success("从备份恢复页面代码成功");
            } else {
                return error("从备份恢复页面代码失败");
            }

        } catch (Exception e) {
            log.error("从备份恢复页面代码失败", e);
            return error("从备份恢复页面代码失败: " + e.getMessage());
        }
    }

    /**
     * 获取页面备份文件列表
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:list')")
    @PostMapping("/getPageBackups")
    public AjaxResult getPageBackups(@RequestBody Map<String, String> params)
    {
        try {
            String pagePath = params.get("pagePath");

            if (StringUtils.isEmpty(pagePath)) {
                return error("页面路径不能为空");
            }

            List<String> backupFiles = sysUniappPageService.getPageBackupFiles(pagePath);
            return AjaxResult.success("获取备份列表成功", backupFiles);

        } catch (Exception e) {
            log.error("获取页面备份列表失败", e);
            return error("获取备份列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取pages.json备份文件列表
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:list')")
    @GetMapping("/getPagesJsonBackups")
    public AjaxResult getPagesJsonBackups()
    {
        try {
            List<String> backupFiles = sysUniappPageService.getPagesJsonBackupFiles();
            return AjaxResult.success("获取pages.json备份列表成功", backupFiles);

        } catch (Exception e) {
            log.error("获取pages.json备份列表失败", e);
            return error("获取备份列表失败: " + e.getMessage());
        }
    }

    /**
     * 清理旧备份文件
     */
    @PreAuthorize("@ss.hasPermi('system:uniappPage:edit')")
    @PostMapping("/cleanBackups")
    public AjaxResult cleanBackups(@RequestBody Map<String, Integer> params)
    {
        try {
            Integer days = params.get("days");
            if (days == null || days < 1) {
                days = 7; // 默认保留7天
            }

            boolean result = sysUniappPageService.cleanOldBackups(days);
            if (result) {
                return success("清理备份文件成功");
            } else {
                return error("清理备份文件失败");
            }

        } catch (Exception e) {
            log.error("清理备份文件失败", e);
            return error("清理备份文件失败: " + e.getMessage());
        }
    }
}
