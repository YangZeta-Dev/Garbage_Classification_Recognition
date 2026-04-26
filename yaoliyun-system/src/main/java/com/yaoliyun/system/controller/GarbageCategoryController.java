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
import com.yaoliyun.system.domain.GarbageCategory;
import com.yaoliyun.system.service.IGarbageCategoryService;
import com.yaoliyun.common.utils.poi.ExcelUtil;
import com.yaoliyun.common.core.page.TableDataInfo;

/**
 * 垃圾分类类别Controller
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/system/category")
public class GarbageCategoryController extends BaseController
{
    @Autowired
    private IGarbageCategoryService garbageCategoryService;

    /**
     * 查询垃圾分类类别列表
     */
    @PreAuthorize("@ss.hasPermi('system:category:list')")
    @GetMapping("/list")
    public TableDataInfo list(GarbageCategory garbageCategory)
    {
        startPage();
        List<GarbageCategory> list = garbageCategoryService.selectGarbageCategoryList(garbageCategory);
        return getDataTable(list);
    }

    /**
     * 导出垃圾分类类别列表
     */
    @PreAuthorize("@ss.hasPermi('system:category:export')")
    @Log(title = "垃圾分类类别", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GarbageCategory garbageCategory)
    {
        List<GarbageCategory> list = garbageCategoryService.selectGarbageCategoryList(garbageCategory);
        ExcelUtil<GarbageCategory> util = new ExcelUtil<GarbageCategory>(GarbageCategory.class);
        util.exportExcel(response, list, "垃圾分类类别数据");
    }

    /**
     * 获取垃圾分类类别详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:category:query')")
    @GetMapping(value = "/{categoryId}")
    public AjaxResult getInfo(@PathVariable("categoryId") Long categoryId)
    {
        return success(garbageCategoryService.selectGarbageCategoryByCategoryId(categoryId));
    }

    /**
     * 新增垃圾分类类别
     */
    @PreAuthorize("@ss.hasPermi('system:category:add')")
    @Log(title = "垃圾分类类别", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GarbageCategory garbageCategory)
    {
        return toAjax(garbageCategoryService.insertGarbageCategory(garbageCategory));
    }

    /**
     * 修改垃圾分类类别
     */
    @PreAuthorize("@ss.hasPermi('system:category:edit')")
    @Log(title = "垃圾分类类别", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GarbageCategory garbageCategory)
    {
        return toAjax(garbageCategoryService.updateGarbageCategory(garbageCategory));
    }

    /**
     * 删除垃圾分类类别
     */
    @PreAuthorize("@ss.hasPermi('system:category:remove')")
    @Log(title = "垃圾分类类别", businessType = BusinessType.DELETE)
	@DeleteMapping("/{categoryIds}")
    public AjaxResult remove(@PathVariable Long[] categoryIds)
    {
        return toAjax(garbageCategoryService.deleteGarbageCategoryByCategoryIds(categoryIds));
    }
}
