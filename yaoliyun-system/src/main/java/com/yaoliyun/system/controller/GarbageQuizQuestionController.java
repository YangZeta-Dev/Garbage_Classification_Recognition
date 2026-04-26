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
import com.yaoliyun.system.domain.GarbageQuizQuestion;
import com.yaoliyun.system.service.IGarbageQuizQuestionService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;

/**
 * 垃圾分类测验题目Controller
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/system/question")
public class GarbageQuizQuestionController extends BaseController
{
    @Autowired
    private IGarbageQuizQuestionService garbageQuizQuestionService;

    /**
     * 查询垃圾分类测验题目列表
     */
    @PreAuthorize("@ss.hasPermi('system:question:list')")
    @GetMapping("/list")
    public TableDataInfo list(GarbageQuizQuestion garbageQuizQuestion)
    {
        startPage();
        List<GarbageQuizQuestion> list = garbageQuizQuestionService.selectGarbageQuizQuestionList(garbageQuizQuestion);
        return getDataTable(list);
    }

    /**
     * 导出垃圾分类测验题目列表
     */
    @PreAuthorize("@ss.hasPermi('system:question:export')")
    @Log(title = "垃圾分类测验题目", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GarbageQuizQuestion garbageQuizQuestion)
    {
        List<GarbageQuizQuestion> list = garbageQuizQuestionService.selectGarbageQuizQuestionList(garbageQuizQuestion);
        ExcelUtil<GarbageQuizQuestion> util = new ExcelUtil<GarbageQuizQuestion>(GarbageQuizQuestion.class);
        util.exportExcel(response, list, "垃圾分类测验题目数据");
    }

    /**
     * 获取垃圾分类测验题目详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:question:query')")
    @GetMapping(value = "/{questionId}")
    public AjaxResult getInfo(@PathVariable("questionId") Long questionId)
    {
        return success(garbageQuizQuestionService.selectGarbageQuizQuestionByQuestionId(questionId));
    }

    /**
     * 新增垃圾分类测验题目
     */
    @PreAuthorize("@ss.hasPermi('system:question:add')")
    @Log(title = "垃圾分类测验题目", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GarbageQuizQuestion garbageQuizQuestion)
    {
        return toAjax(garbageQuizQuestionService.insertGarbageQuizQuestion(garbageQuizQuestion));
    }

    /**
     * 修改垃圾分类测验题目
     */
    @PreAuthorize("@ss.hasPermi('system:question:edit')")
    @Log(title = "垃圾分类测验题目", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GarbageQuizQuestion garbageQuizQuestion)
    {
        return toAjax(garbageQuizQuestionService.updateGarbageQuizQuestion(garbageQuizQuestion));
    }

    /**
     * 删除垃圾分类测验题目
     */
    @PreAuthorize("@ss.hasPermi('system:question:remove')")
    @Log(title = "垃圾分类测验题目", businessType = BusinessType.DELETE)
	@DeleteMapping("/{questionIds}")
    public AjaxResult remove(@PathVariable Long[] questionIds)
    {
        return toAjax(garbageQuizQuestionService.deleteGarbageQuizQuestionByQuestionIds(questionIds));
    }

    /**
     * 获取关联文章ID选项列表（用于下拉框）
     */
    @PreAuthorize("@ss.hasPermi('system:question:query')")
    @GetMapping("/articleId/options")
    public AjaxResult getArticleIdOptions()
    {
        return success(garbageQuizQuestionService.getArticleIdOptions());
    }

    /**
     * 获取关联分类ID选项列表（用于下拉框）
     */
    @PreAuthorize("@ss.hasPermi('system:question:query')")
    @GetMapping("/categoryId/options")
    public AjaxResult getCategoryIdOptions()
    {
        return success(garbageQuizQuestionService.getCategoryIdOptions());
    }
}
