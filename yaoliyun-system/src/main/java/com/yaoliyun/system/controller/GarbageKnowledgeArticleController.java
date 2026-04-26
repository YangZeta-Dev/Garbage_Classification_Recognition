package com.yaoliyun.system.controller;

import java.util.List;
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
import com.yaoliyun.system.domain.GarbageKnowledgeArticle;
import com.yaoliyun.system.service.IGarbageKnowledgeArticleService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;

/**
 * 垃圾分类知识文章Controller
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/system/article")
public class GarbageKnowledgeArticleController extends BaseController
{
    @Autowired
    private IGarbageKnowledgeArticleService garbageKnowledgeArticleService;

    /**
     * 查询垃圾分类知识文章列表
     */
    @PreAuthorize("@ss.hasPermi('system:article:list')")
    @GetMapping("/list")
    public TableDataInfo list(GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        startPage();
        List<GarbageKnowledgeArticle> list = garbageKnowledgeArticleService.selectGarbageKnowledgeArticleList(garbageKnowledgeArticle);
        return getDataTable(list);
    }

    /**
     * 导出垃圾分类知识文章列表
     */
    @PreAuthorize("@ss.hasPermi('system:article:export')")
    @Log(title = "垃圾分类知识文章", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        List<GarbageKnowledgeArticle> list = garbageKnowledgeArticleService.selectGarbageKnowledgeArticleList(garbageKnowledgeArticle);
        ExcelUtil<GarbageKnowledgeArticle> util = new ExcelUtil<GarbageKnowledgeArticle>(GarbageKnowledgeArticle.class);
        util.exportExcel(response, list, "垃圾分类知识文章数据");
    }

    /**
     * 获取垃圾分类知识文章详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:article:query')")
    @GetMapping(value = "/{articleId}")
    public AjaxResult getInfo(@PathVariable("articleId") Long articleId)
    {
        return success(garbageKnowledgeArticleService.selectGarbageKnowledgeArticleByArticleId(articleId));
    }

    /**
     * 获取垃圾分类知识文章详细信息（前端访问，浏览量+1）
     */
    @GetMapping(value = "/detail/{articleId}")
    public AjaxResult getDetail(@PathVariable("articleId") Long articleId)
    {
        // 浏览量+1
        garbageKnowledgeArticleService.incrementViewCount(articleId);
        return success(garbageKnowledgeArticleService.selectGarbageKnowledgeArticleByArticleId(articleId));
    }

    /**
     * 新增垃圾分类知识文章
     */
    @PreAuthorize("@ss.hasPermi('system:article:add')")
    @Log(title = "垃圾分类知识文章", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        return toAjax(garbageKnowledgeArticleService.insertGarbageKnowledgeArticle(garbageKnowledgeArticle));
    }

    /**
     * 修改垃圾分类知识文章
     */
    @PreAuthorize("@ss.hasPermi('system:article:edit')")
    @Log(title = "垃圾分类知识文章", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GarbageKnowledgeArticle garbageKnowledgeArticle)
    {
        return toAjax(garbageKnowledgeArticleService.updateGarbageKnowledgeArticle(garbageKnowledgeArticle));
    }

    /**
     * 删除垃圾分类知识文章
     */
    @PreAuthorize("@ss.hasPermi('system:article:remove')")
    @Log(title = "垃圾分类知识文章", businessType = BusinessType.DELETE)
	@DeleteMapping("/{articleIds}")
    public AjaxResult remove(@PathVariable Long[] articleIds)
    {
        return toAjax(garbageKnowledgeArticleService.deleteGarbageKnowledgeArticleByArticleIds(articleIds));
    }

    /**
     * 获取关联分类ID选项列表（用于下拉框）
     */
    @PreAuthorize("@ss.hasPermi('system:article:query')")
    @GetMapping("/categoryId/options")
    public AjaxResult getCategoryIdOptions()
    {
        return success(garbageKnowledgeArticleService.getCategoryIdOptions());
    }
}
